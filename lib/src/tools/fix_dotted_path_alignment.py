#!/usr/bin/env python3
"""
fix_dotted_path_alignment.py

Fixes dotted path alignment by ensuring it uses the same coordinate space
and bounds as the letter path.

The issue: JSON points are normalized for 300x300, but when converted to
dotted path with view_size=1000, the bounds don't match the letter path,
causing misalignment in Flutter.

Solution: Convert JSON points back to the original SVG coordinate space
by reverse-transforming them, then generate the dotted path.
"""

import sys
import json
import re
from typing import List, Tuple

def parse_svg_path(svg_path: str) -> dict:
    """Get bounds of SVG path."""
    coords = []
    for match in re.findall(r'([-]?\d+\.?\d*)', svg_path):
        try:
            coords.append(float(match))
        except:
            pass
    
    x_coords = [coords[i] for i in range(0, len(coords), 2) if i < len(coords)]
    y_coords = [coords[i+1] for i in range(0, len(coords)-1, 2) if i+1 < len(coords)]
    
    return {
        'left': min(x_coords),
        'top': min(y_coords),
        'width': max(x_coords) - min(x_coords),
        'height': max(y_coords) - min(y_coords)
    }

def calculate_flutter_transform(svg_bounds: dict, view_size: float) -> dict:
    """Calculate Flutter's transformation."""
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

def reverse_transform_point(normalized_x: float, normalized_y: float, 
                            transform: dict, view_size: float) -> Tuple[float, float]:
    """
    Reverse Flutter transformation: from normalized (0-1) back to SVG coordinates (0-1000).
    
    This reverses the transformation that was applied when generating JSON points.
    """
    # Convert normalized to Flutter space
    flutter_x = normalized_x * view_size
    flutter_y = normalized_y * view_size
    
    # Reverse transform: from Flutter space back to SVG space
    svg_x = (flutter_x - transform['translate_x']) / transform['scale']
    svg_y = (flutter_y - transform['translate_y']) / transform['scale']
    
    return svg_x, svg_y

def convert_json_to_svg_coords(json_path: str, letter_svg_path: str, 
                                view_size: float = 300.0) -> List[List[Tuple[float, float]]]:
    """
    Convert JSON points (normalized for viewSize) back to SVG coordinates.
    
    This ensures the dotted path is in the same coordinate space as the letter path.
    """
    # Load JSON
    with open(json_path, 'r', encoding='utf-8') as f:
        json_data = json.load(f)
    
    # Get letter path bounds
    letter_bounds = parse_svg_path(letter_svg_path)
    
    # Calculate Flutter transformation (that was used to generate JSON)
    transform = calculate_flutter_transform(letter_bounds, view_size)
    
    print(f"Letter path bounds: {letter_bounds}")
    print(f"Flutter transform: scale={transform['scale']:.4f}, "
          f"translate=({transform['translate_x']:.2f}, {transform['translate_y']:.2f})")
    print()
    
    # Convert each stroke's points
    svg_strokes = []
    for stroke in json_data.get('strokes', []):
        points = stroke.get('points', [])
        svg_points = []
        
        for point_str in points:
            try:
                x_norm, y_norm = map(float, point_str.split(','))
                svg_x, svg_y = reverse_transform_point(x_norm, y_norm, transform, view_size)
                svg_points.append((svg_x, svg_y))
            except:
                continue
        
        if svg_points:
            svg_strokes.append(svg_points)
            print(f"Converted stroke: {len(svg_points)} points")
            print(f"  First point: normalized ({x_norm:.4f}, {y_norm:.4f}) -> SVG ({svg_x:.1f}, {svg_y:.1f})")
    
    return svg_strokes

def generate_dotted_path_from_svg_coords(svg_strokes: List[List[Tuple[float, float]]], 
                                         use_curves: bool = True) -> str:
    """Generate dotted path from SVG coordinates."""
    path_segments = []
    
    for stroke in svg_strokes:
        if not stroke:
            continue
        
        commands = []
        for i, (x, y) in enumerate(stroke):
            if i == 0:
                commands.append(f"M {x:.1f} {y:.1f}")
            elif use_curves and i > 0:
                # Use quadratic bezier for smooth curves
                if i == 1:
                    # First curve point - use previous point as control
                    prev_x, prev_y = stroke[i-1]
                    commands.append(f"Q {prev_x:.1f} {prev_y:.1f} {x:.1f} {y:.1f}")
                else:
                    # Use midpoint as control point
                    prev_x, prev_y = stroke[i-1]
                    mid_x = (prev_x + x) / 2
                    mid_y = (prev_y + y) / 2
                    commands.append(f"Q {mid_x:.1f} {mid_y:.1f} {x:.1f} {y:.1f}")
            else:
                commands.append(f"L {x:.1f} {y:.1f}")
        
        if commands:
            path_segments.append(' '.join(commands))
    
    return '\n           '.join(path_segments)

def main():
    if len(sys.argv) < 3:
        print("Usage:")
        print("  python3 fix_dotted_path_alignment.py <PointsInfo.json> <letter_svg_path> [viewSize]")
        print()
        print("Example:")
        print('  python3 fix_dotted_path_alignment.py a_PointsInfo.json "M 390 1012 Q..." 300')
        sys.exit(1)
    
    json_path = sys.argv[1]
    letter_svg_path = sys.argv[2]
    view_size = float(sys.argv[3]) if len(sys.argv) > 3 else 300.0
    
    print("=" * 60)
    print("Fixing Dotted Path Alignment")
    print("=" * 60)
    print()
    print("Converting JSON points (normalized for 300x300) back to SVG coordinates...")
    print()
    
    # Convert JSON to SVG coordinates
    svg_strokes = convert_json_to_svg_coords(json_path, letter_svg_path, view_size)
    
    if not svg_strokes:
        print("Error: No strokes converted")
        sys.exit(1)
    
    print()
    print("=" * 60)
    print("Generated Dotted Path (in SVG coordinate space):")
    print("=" * 60)
    
    # Generate dotted path
    dotted_path = generate_dotted_path_from_svg_coords(svg_strokes, use_curves=True)
    
    print()
    print("  static const aDotted = '''" + dotted_path + "''';")
    print()
    print("=" * 60)
    print("This dotted path is now in the same coordinate space as the letter path,")
    print("so both will be transformed the same way by Flutter and will align correctly.")
    print("=" * 60)

if __name__ == '__main__':
    main()

