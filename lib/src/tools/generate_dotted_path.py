#!/usr/bin/env python3
"""
generate_dotted_path.py

Generates stroke-by-stroke dotted SVG paths from PointsInfo.json file.

Usage:
  # From JSON file
  python3 generate_dotted_path.py path/to/PointsInfo.json [viewSize]

  # From manual input (interactive)
  python3 generate_dotted_path.py --interactive

  # With custom view size (default: 1000)
  python3 generate_dotted_path.py path/to/PointsInfo.json 1000

The script reads stroke points from PointsInfo.json and converts them to SVG path format
where each stroke becomes a separate path segment (starting with M command).

Output format matches the dotted path format used in telugu_shape_paths.dart
"""

import sys
import json
import os
from typing import List, Tuple

def parse_point(point_str: str) -> Tuple[float, float]:
    """Parse a point string like '0.5,0.3' to (x, y) tuple."""
    try:
        x, y = point_str.split(',')
        return float(x.strip()), float(y.strip())
    except Exception as e:
        print(f"Error parsing point '{point_str}': {e}")
        return None, None

def points_to_svg_path(points: List[str], view_size: float = 1000.0) -> str:
    """
    Convert a list of normalized points (0.0-1.0) to SVG path string.
    
    Args:
        points: List of point strings like ['0.5,0.3', '0.6,0.4', ...]
        view_size: Size of the view (default 1000, matching font extraction)
    
    Returns:
        SVG path string like 'M 500,300 L 600,400 ...'
    """
    if not points:
        return ""
    
    path_commands = []
    
    for i, point_str in enumerate(points):
        x_norm, y_norm = parse_point(point_str)
        if x_norm is None or y_norm is None:
            continue
        
        # Convert normalized coordinates (0.0-1.0) to actual coordinates
        x = x_norm * view_size
        y = y_norm * view_size
        
        if i == 0:
            # First point: Move to
            path_commands.append(f"M {x:.1f} {y:.1f}")
        else:
            # Subsequent points: Line to
            path_commands.append(f"L {x:.1f} {y:.1f}")
    
    return ' '.join(path_commands)

def points_to_svg_path_smooth(points: List[str], view_size: float = 1000.0, use_curves: bool = True) -> str:
    """
    Convert points to SVG path with smooth curves (quadratic bezier).
    
    Args:
        points: List of point strings
        view_size: Size of the view
        use_curves: If True, use Q (quadratic) curves, else use L (lines)
    
    Returns:
        SVG path string
    """
    if not points:
        return ""
    
    if len(points) < 2:
        x_norm, y_norm = parse_point(points[0])
        x = x_norm * view_size
        y = y_norm * view_size
        return f"M {x:.1f} {y:.1f}"
    
    path_commands = []
    
    for i, point_str in enumerate(points):
        x_norm, y_norm = parse_point(point_str)
        if x_norm is None or y_norm is None:
            continue
        
        x = x_norm * view_size
        y = y_norm * view_size
        
        if i == 0:
            path_commands.append(f"M {x:.1f} {y:.1f}")
        elif use_curves and i > 0:
            # Use quadratic bezier for smooth curves
            # Control point is midpoint between previous and current
            prev_x_norm, prev_y_norm = parse_point(points[i-1])
            if prev_x_norm is not None:
                prev_x = prev_x_norm * view_size
                prev_y = prev_y_norm * view_size
                # Control point
                ctrl_x = (prev_x + x) / 2
                ctrl_y = (prev_y + y) / 2
                path_commands.append(f"Q {ctrl_x:.1f} {ctrl_y:.1f} {x:.1f} {y:.1f}")
            else:
                path_commands.append(f"L {x:.1f} {y:.1f}")
        else:
            path_commands.append(f"L {x:.1f} {y:.1f}")
    
    return ' '.join(path_commands)

def generate_dotted_path_from_json(json_path: str, view_size: float = 1000.0, use_curves: bool = True) -> str:
    """
    Generate dotted path from PointsInfo.json file.
    
    Each stroke in the JSON becomes a separate path segment (starting with M).
    This creates stroke-by-stroke guide lines like English letters.
    """
    try:
        with open(json_path, 'r', encoding='utf-8') as f:
            data = json.load(f)
    except Exception as e:
        print(f"Error reading JSON file: {e}")
        return ""
    
    # Handle different JSON formats
    strokes = []
    if 'strokes' in data:
        strokes = data['strokes']
    elif isinstance(data, list):
        strokes = data
    else:
        print("Error: JSON format not recognized. Expected 'strokes' array or array of strokes.")
        return ""
    
    if not strokes:
        print("Warning: No strokes found in JSON file")
        return ""
    
    print(f"Found {len(strokes)} stroke(s) in JSON file")
    
    # Generate path segments for each stroke
    path_segments = []
    for i, stroke in enumerate(strokes):
        if isinstance(stroke, dict) and 'points' in stroke:
            points = stroke['points']
        elif isinstance(stroke, list):
            points = stroke
        else:
            print(f"Warning: Stroke {i+1} format not recognized, skipping")
            continue
        
        if not points:
            print(f"Warning: Stroke {i+1} has no points, skipping")
            continue
        
        print(f"  Stroke {i+1}: {len(points)} points")
        
        # Convert points to SVG path
        if use_curves:
            stroke_path = points_to_svg_path_smooth(points, view_size, use_curves=True)
        else:
            stroke_path = points_to_svg_path(points, view_size)
        
        if stroke_path:
            path_segments.append(stroke_path)
    
    if not path_segments:
        print("Error: No valid path segments generated")
        return ""
    
    # Join all segments with newlines and proper spacing
    # Each stroke starts with M (creates separate path segments)
    return '\n           '.join(path_segments)

def format_for_dart(path_string: str) -> str:
    """Format the path string for Dart code (with proper indentation)."""
    lines = path_string.split('\n')
    formatted = []
    for i, line in enumerate(lines):
        if i == 0:
            formatted.append(f"  static const aDotted = '''{line.strip()}")
        else:
            formatted.append(f"           {line.strip()}")
    formatted.append("''';")
    return '\n'.join(formatted)

def interactive_mode():
    """Interactive mode: manually input stroke points."""
    print("Interactive Dotted Path Generator")
    print("=" * 50)
    print("Enter stroke points in format: x,y (normalized 0.0-1.0)")
    print("Press Enter on empty line to finish a stroke")
    print("Type 'done' to finish all strokes")
    print()
    
    view_size = input("Enter view size (default 1000): ").strip()
    view_size = float(view_size) if view_size else 1000.0
    
    all_strokes = []
    stroke_num = 1
    
    while True:
        print(f"\nStroke {stroke_num}:")
        points = []
        while True:
            point_input = input("  Point (x,y) or Enter to finish stroke: ").strip()
            if not point_input:
                break
            if point_input.lower() == 'done':
                break
            points.append(point_input)
        
        if point_input.lower() == 'done':
            break
        
        if points:
            all_strokes.append(points)
            stroke_num += 1
        else:
            break
    
    # Generate paths
    path_segments = []
    for points in all_strokes:
        stroke_path = points_to_svg_path(points, view_size)
        if stroke_path:
            path_segments.append(stroke_path)
    
    result = '\n           '.join(path_segments)
    print("\n" + "=" * 50)
    print("Generated Dotted Path:")
    print("=" * 50)
    print(format_for_dart(result))
    return result

def main():
    if len(sys.argv) > 1 and sys.argv[1] == '--interactive':
        interactive_mode()
        return
    
    if len(sys.argv) < 2:
        print("Usage:")
        print("  python3 generate_dotted_path.py <PointsInfo.json> [viewSize] [--lines]")
        print("  python3 generate_dotted_path.py --interactive")
        print()
        print("Options:")
        print("  --lines    Use straight lines (L) instead of curves (Q)")
        print()
        print("Example:")
        print("  python3 generate_dotted_path.py a_PointsInfo.json 1000")
        sys.exit(1)
    
    json_path = sys.argv[1]
    view_size = 1000.0
    use_curves = True
    
    # Parse arguments
    for arg in sys.argv[2:]:
        if arg == '--lines':
            use_curves = False
        else:
            try:
                view_size = float(arg)
            except ValueError:
                print(f"Warning: Ignoring invalid argument: {arg}")
    
    if not os.path.exists(json_path):
        print(f"Error: File not found: {json_path}")
        sys.exit(1)
    
    print(f"Generating dotted path from: {json_path}")
    print(f"View size: {view_size}")
    print(f"Using: {'Curves (Q)' if use_curves else 'Lines (L)'}")
    print()
    
    dotted_path = generate_dotted_path_from_json(json_path, view_size, use_curves)
    
    if not dotted_path:
        print("Error: Could not generate dotted path")
        sys.exit(1)
    
    print()
    print("=" * 50)
    print("Generated Dotted Path (Dart format):")
    print("=" * 50)
    print(format_for_dart(dotted_path))
    print()
    print("=" * 50)
    print("Raw Path (for verification):")
    print("=" * 50)
    print(dotted_path)
    print()
    print("=" * 50)
    print("Note: Each stroke should be a separate path segment")
    print("      (each starting with M command)")
    print("=" * 50)

if __name__ == "__main__":
    main()

