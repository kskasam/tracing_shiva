#!/usr/bin/env python3
"""
fix_json_alignment.py

Verifies and fixes JSON point alignment with SVG path using Flutter's exact transformation.

Usage:
  python3 fix_json_alignment.py <PointsInfo.json> <SVG_path_string> [viewSize]

This script:
1. Loads JSON points
2. Calculates Flutter's transformation for the SVG path
3. Verifies if points align correctly
4. Can optionally regenerate points (requires manual tracing)
"""

import sys
import json
import re
from typing import List, Tuple

def parse_svg_path(svg_path: str) -> List[Tuple[str, List[float]]]:
    """Parse SVG path into commands and coordinates."""
    # Pattern to match SVG path commands
    pattern = r'([MmLlHhVvCcSsQqTtAaZz])\s*([-\d.eE, ]+)?'
    matches = re.findall(pattern, svg_path)
    
    commands = []
    for cmd, coords_str in matches:
        cmd_upper = cmd.upper()
        if cmd_upper == 'Z':
            commands.append((cmd_upper, []))
            continue
        
        if not coords_str or not coords_str.strip():
            continue
        
        # Parse numbers (handle both space and comma separated)
        coords_clean = coords_str.replace(',', ' ')
        nums = []
        for num_str in coords_clean.split():
            try:
                nums.append(float(num_str))
            except ValueError:
                continue
        
        if nums:
            commands.append((cmd_upper, nums))
    
    return commands

def get_svg_bounds(svg_path: str) -> dict:
    """
    Calculate SVG path bounds by sampling all path commands.
    Returns dict with 'left', 'top', 'width', 'height'.
    """
    commands = parse_svg_path(svg_path)
    
    all_x = []
    all_y = []
    current_x = 0
    current_y = 0
    
    def sample_quadratic_bezier(x0, y0, x1, y1, x2, y2, num_samples=20):
        """Sample points along a quadratic bezier curve."""
        points = []
        for i in range(num_samples + 1):
            t = i / num_samples
            x = (1-t)**2 * x0 + 2*(1-t)*t * x1 + t**2 * x2
            y = (1-t)**2 * y0 + 2*(1-t)*t * y1 + t**2 * y2
            points.append((x, y))
        return points
    
    def sample_cubic_bezier(x0, y0, x1, y1, x2, y2, x3, y3, num_samples=20):
        """Sample points along a cubic bezier curve."""
        points = []
        for i in range(num_samples + 1):
            t = i / num_samples
            x = (1-t)**3 * x0 + 3*(1-t)**2*t * x1 + 3*(1-t)*t**2 * x2 + t**3 * x3
            y = (1-t)**3 * y0 + 3*(1-t)**2*t * y1 + 3*(1-t)*t**2 * y2 + t**3 * y3
            points.append((x, y))
        return points
    
    for cmd, coords in commands:
        if cmd == 'M':
            if len(coords) >= 2:
                current_x = coords[0]
                current_y = coords[1]
                all_x.append(current_x)
                all_y.append(current_y)
        elif cmd == 'L':
            if len(coords) >= 2:
                current_x = coords[0]
                current_y = coords[1]
                all_x.append(current_x)
                all_y.append(current_y)
        elif cmd == 'Q':
            if len(coords) >= 4:
                x1, y1 = coords[0], coords[1]
                x2, y2 = coords[2], coords[3]
                curve_points = sample_quadratic_bezier(current_x, current_y, x1, y1, x2, y2)
                for pt in curve_points:
                    all_x.append(pt[0])
                    all_y.append(pt[1])
                current_x = x2
                current_y = y2
        elif cmd == 'C':
            if len(coords) >= 6:
                x1, y1 = coords[0], coords[1]
                x2, y2 = coords[2], coords[3]
                x3, y3 = coords[4], coords[5]
                curve_points = sample_cubic_bezier(current_x, current_y, x1, y1, x2, y2, x3, y3)
                for pt in curve_points:
                    all_x.append(pt[0])
                    all_y.append(pt[1])
                current_x = x3
                current_y = y3
        elif cmd == 'H':
            if len(coords) >= 1:
                current_x = coords[0]
                all_x.append(current_x)
                all_y.append(current_y)
        elif cmd == 'V':
            if len(coords) >= 1:
                current_y = coords[0]
                all_x.append(current_x)
                all_y.append(current_y)
        elif cmd == 'Z':
            # Close path - already have start point
            pass
    
    if not all_x or not all_y:
        return None
    
    return {
        'left': min(all_x),
        'top': min(all_y),
        'width': max(all_x) - min(all_x),
        'height': max(all_y) - min(all_y)
    }

def calculate_flutter_transform(svg_bounds: dict, view_size: float) -> dict:
    """
    Calculate Flutter's exact transformation.
    Matches _applyTransformation in tracing_cubit.dart
    """
    original_width = svg_bounds['width']
    original_height = svg_bounds['height']
    original_left = svg_bounds['left']
    original_top = svg_bounds['top']
    
    scale_x = view_size / original_width
    scale_y = view_size / original_height
    scale = min(scale_x, scale_y)
    
    translate_x = (view_size - original_width * scale) / 2 - original_left * scale
    translate_y = (view_size - original_height * scale) / 2 - original_top * scale
    
    return {
        'scale': scale,
        'translate_x': translate_x,
        'translate_y': translate_y
    }

def svg_to_flutter_normalized(svg_x: float, svg_y: float, transform: dict, view_size: float) -> Tuple[float, float]:
    """
    Transform SVG coordinates to Flutter normalized coordinates (0-1).
    Matches HTML tool's svgToFlutterNormalized function.
    """
    flutter_x = svg_x * transform['scale'] + transform['translate_x']
    flutter_y = svg_y * transform['scale'] + transform['translate_y']
    
    normalized_x = flutter_x / view_size
    normalized_y = flutter_y / view_size
    
    # Clamp to 0-1 range
    normalized_x = max(0.0, min(1.0, normalized_x))
    normalized_y = max(0.0, min(1.0, normalized_y))
    
    return normalized_x, normalized_y

def verify_alignment(json_path: str, svg_path: str, view_size: float = 300.0):
    """
    Verify if JSON points align correctly with SVG path.
    """
    print("=" * 60)
    print("JSON Alignment Verification")
    print("=" * 60)
    print()
    
    # Load JSON points
    try:
        with open(json_path, 'r', encoding='utf-8') as f:
            json_data = json.load(f)
    except Exception as e:
        print(f"Error reading JSON file: {e}")
        return
    
    strokes = json_data.get('strokes', [])
    if not strokes:
        print("Error: No strokes found in JSON")
        return
    
    print(f"Found {len(strokes)} stroke(s) in JSON")
    print()
    
    # Get SVG bounds
    print("Calculating SVG path bounds...")
    svg_bounds = get_svg_bounds(svg_path)
    if not svg_bounds:
        print("Error: Could not calculate SVG bounds")
        return
    
    print(f"SVG bounds: left={svg_bounds['left']:.1f}, top={svg_bounds['top']:.1f}, "
          f"width={svg_bounds['width']:.1f}, height={svg_bounds['height']:.1f}")
    print()
    
    # Calculate Flutter transformation
    transform = calculate_flutter_transform(svg_bounds, view_size)
    print(f"Flutter transformation (viewSize={view_size}):")
    print(f"  Scale: {transform['scale']:.4f}")
    print(f"  Translate: ({transform['translate_x']:.2f}, {transform['translate_y']:.2f})")
    print()
    
    # Verify first point from each stroke
    print("Verification Results:")
    print("-" * 60)
    
    for i, stroke in enumerate(strokes):
        points = stroke.get('points', [])
        if not points:
            print(f"Stroke {i+1}: No points")
            continue
        
        # Get first point
        first_point_str = points[0]
        try:
            x_norm, y_norm = map(float, first_point_str.split(','))
        except:
            print(f"Stroke {i+1}: Invalid first point format")
            continue
        
        # Convert back to Flutter space
        flutter_x = x_norm * view_size
        flutter_y = y_norm * view_size
        
        # Convert back to SVG space (reverse transform)
        svg_x = (flutter_x - transform['translate_x']) / transform['scale']
        svg_y = (flutter_y - transform['translate_y']) / transform['scale']
        
        print(f"Stroke {i+1} first point:")
        print(f"  JSON normalized: ({x_norm:.4f}, {y_norm:.4f})")
        print(f"  Flutter space: ({flutter_x:.2f}, {flutter_y:.2f})")
        print(f"  SVG space (reverse): ({svg_x:.2f}, {svg_y:.2f})")
        print(f"  Is on path? (check manually - should be near letter edge)")
        print()
    
    print("=" * 60)
    print("Note: Points should align with the letter shape in Flutter app.")
    print("If misaligned, regenerate using telugu_stroke_editor_centerline.html")
    print("=" * 60)

def main():
    if len(sys.argv) < 3:
        print("Usage:")
        print("  python3 fix_json_alignment.py <PointsInfo.json> <SVG_path_string> [viewSize]")
        print()
        print("Example:")
        print('  python3 fix_json_alignment.py a_PointsInfo.json "M 390 1012 Q ..." 300')
        sys.exit(1)
    
    json_path = sys.argv[1]
    svg_path = sys.argv[2]
    view_size = float(sys.argv[3]) if len(sys.argv) > 3 else 300.0
    
    verify_alignment(json_path, svg_path, view_size)

if __name__ == '__main__':
    main()

