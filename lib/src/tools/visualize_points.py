#!/usr/bin/env python3
"""
visualize_points.py

Visualizes JSON points from PointsInfo.json overlaid on the SVG letter shape.
This helps verify if the points match the letter shape before generating dotted paths.

Usage:
  python3 visualize_points.py <PointsInfo.json> <SVG_path_string> [viewSize]

Example:
  python3 visualize_points.py a_PointsInfo.json "M 390 1012 Q 270 1012..." 1000

Dependencies: matplotlib, svgpathtools (optional for better SVG parsing)
Install: pip3 install matplotlib
"""

import sys
import json
import os
import re
from typing import List, Tuple, Optional

try:
    import matplotlib.pyplot as plt
    import matplotlib.patches as patches
    from matplotlib.patches import PathPatch
    from matplotlib.path import Path as MPLPath
except ImportError:
    print("Error: matplotlib is required. Install with: pip3 install matplotlib")
    sys.exit(1)

def parse_point(point_str: str) -> Tuple[float, float]:
    """Parse a point string like '0.5,0.3' to (x, y) tuple."""
    try:
        x, y = point_str.split(',')
        return float(x.strip()), float(y.strip())
    except Exception as e:
        print(f"Error parsing point '{point_str}': {e}")
        return None, None

def parse_svg_path(svg_path: str) -> List[Tuple[str, List[float]]]:
    """
    Parse SVG path string into commands.
    Returns list of (command, coordinates) tuples.
    """
    # Pattern to match SVG commands and their coordinates
    pattern = r'([MmLlHhVvCcSsQqTtAaZz])\s*([-\d.eE, ]+)?'
    matches = re.findall(pattern, svg_path)
    
    commands = []
    for cmd, coords in matches:
        if not coords or cmd.upper() == 'Z':
            commands.append((cmd.upper(), []))
            continue
        
        # Parse coordinates
        coords_clean = coords.replace(',', ' ')
        nums = []
        for num_str in coords_clean.split():
            try:
                nums.append(float(num_str))
            except ValueError:
                continue
        
        commands.append((cmd.upper(), nums))
    
    return commands

def svg_to_matplotlib_path(svg_path: str, view_size: float = 1000.0) -> MPLPath:
    """
    Convert SVG path to matplotlib Path.
    Handles M, L, Q, C, H, V, Z commands.
    For curves (Q, C), samples points along the curve for accurate bounds.
    """
    commands = parse_svg_path(svg_path)
    
    vertices = []
    codes = []
    current_x = 0
    current_y = 0
    start_x = 0
    start_y = 0
    
    def sample_quadratic_bezier(x0, y0, x1, y1, x2, y2, num_samples=10):
        """Sample points along a quadratic bezier curve."""
        points = []
        for i in range(num_samples + 1):
            t = i / num_samples
            x = (1-t)**2 * x0 + 2*(1-t)*t * x1 + t**2 * x2
            y = (1-t)**2 * y0 + 2*(1-t)*t * y1 + t**2 * y2
            points.append((x, y))
        return points
    
    for cmd, coords in commands:
        if cmd == 'M':
            # Move to
            if len(coords) >= 2:
                current_x = coords[0]
                current_y = coords[1]
                start_x = current_x
                start_y = current_y
                vertices.append((current_x, current_y))
                codes.append(MPLPath.MOVETO)
        elif cmd == 'L':
            # Line to
            if len(coords) >= 2:
                current_x = coords[0]
                current_y = coords[1]
                vertices.append((current_x, current_y))
                codes.append(MPLPath.LINETO)
        elif cmd == 'Q':
            # Quadratic bezier: Q x1,y1 x,y
            if len(coords) >= 4:
                x1, y1 = coords[0], coords[1]
                x2, y2 = coords[2], coords[3]
                # Sample the curve
                curve_points = sample_quadratic_bezier(current_x, current_y, x1, y1, x2, y2)
                for pt in curve_points[1:]:  # Skip first point (already added)
                    vertices.append(pt)
                    codes.append(MPLPath.LINETO)
                current_x = x2
                current_y = y2
        elif cmd == 'C':
            # Cubic bezier: C x1,y1 x2,y2 x,y
            if len(coords) >= 6:
                x1, y1 = coords[0], coords[1]
                x2, y2 = coords[2], coords[3]
                x3, y3 = coords[4], coords[5]
                # Sample cubic bezier (simplified - use more samples for accuracy)
                num_samples = 20
                for i in range(1, num_samples + 1):
                    t = i / num_samples
                    x = (1-t)**3 * current_x + 3*(1-t)**2*t * x1 + 3*(1-t)*t**2 * x2 + t**3 * x3
                    y = (1-t)**3 * current_y + 3*(1-t)**2*t * y1 + 3*(1-t)*t**2 * y2 + t**3 * y3
                    vertices.append((x, y))
                    codes.append(MPLPath.LINETO)
                current_x = x3
                current_y = y3
        elif cmd == 'H':
            # Horizontal line
            if len(coords) >= 1:
                current_x = coords[0]
                vertices.append((current_x, current_y))
                codes.append(MPLPath.LINETO)
        elif cmd == 'V':
            # Vertical line
            if len(coords) >= 1:
                current_y = coords[0]
                vertices.append((current_x, current_y))
                codes.append(MPLPath.LINETO)
        elif cmd == 'Z':
            # Close path
            if vertices:
                codes.append(MPLPath.CLOSEPOLY)
                vertices.append((start_x, start_y))  # Close to first point
                current_x = start_x
                current_y = start_y
    
    if not vertices:
        return None
    
    return MPLPath(vertices, codes)

def load_points_from_json(json_path: str) -> List[List[Tuple[float, float]]]:
    """Load points from PointsInfo.json file."""
    try:
        with open(json_path, 'r', encoding='utf-8') as f:
            data = json.load(f)
    except Exception as e:
        print(f"Error reading JSON file: {e}")
        return []
    
    strokes = []
    if 'strokes' in data:
        strokes = data['strokes']
    elif isinstance(data, list):
        strokes = data
    else:
        print("Error: JSON format not recognized")
        return []
    
    all_strokes = []
    for i, stroke in enumerate(strokes):
        if isinstance(stroke, dict) and 'points' in stroke:
            points = stroke['points']
        elif isinstance(stroke, list):
            points = stroke
        else:
            continue
        
        stroke_points = []
        for point_str in points:
            x, y = parse_point(point_str)
            if x is not None and y is not None:
                stroke_points.append((x, y))
        
        if stroke_points:
            all_strokes.append(stroke_points)
    
    return all_strokes

def apply_flutter_transformation(path_bounds, view_size):
    """
    Apply Flutter's exact transformation logic.
    Matches _applyTransformation in tracing_cubit.dart
    """
    original_width = path_bounds['width']
    original_height = path_bounds['height']
    original_left = path_bounds['left']
    original_top = path_bounds['top']
    
    # Calculate scale (uniform, preserving aspect ratio)
    scale_x = view_size / original_width
    scale_y = view_size / original_height
    scale = min(scale_x, scale_y)
    
    # Calculate translation to center
    translate_x = (view_size - original_width * scale) / 2 - original_left * scale
    translate_y = (view_size - original_height * scale) / 2 - original_top * scale
    
    return {
        'scale': scale,
        'translate_x': translate_x,
        'translate_y': translate_y
    }

def transform_point_to_flutter_space(x, y, transform):
    """Transform a point using Flutter's transformation."""
    # Scale first, then translate (matches Flutter's Matrix4)
    flutter_x = x * transform['scale'] + transform['translate_x']
    flutter_y = y * transform['scale'] + transform['translate_y']
    return flutter_x, flutter_y

def transform_point_from_flutter_space(flutter_x, flutter_y, transform):
    """Reverse transform: from Flutter space back to SVG space."""
    svg_x = (flutter_x - transform['translate_x']) / transform['scale']
    svg_y = (flutter_y - transform['translate_y']) / transform['scale']
    return svg_x, svg_y

def visualize(json_path: str, svg_path: str, view_size: float = 1000.0, output_file: str = None):
    """Create visualization of JSON points overlaid on SVG path.
    
    Both SVG and JSON points are shown in Flutter's transformed coordinate space
    (0 to view_size), which is how they appear in the app.
    """
    
    print(f"Loading points from: {json_path}")
    strokes = load_points_from_json(json_path)
    
    if not strokes:
        print("Error: No strokes found in JSON")
        return
    
    print(f"Found {len(strokes)} stroke(s)")
    for i, stroke in enumerate(strokes):
        print(f"  Stroke {i+1}: {len(stroke)} points")
    
    # Parse SVG path to get bounds
    print(f"\nParsing SVG path...")
    mpl_path = svg_to_matplotlib_path(svg_path, view_size)
    if not mpl_path:
        print("Error: Could not parse SVG path")
        return
    
    # Get SVG path bounds (in original SVG coordinate space)
    # Use all vertices to calculate accurate bounds
    all_x = [v[0] for v in mpl_path.vertices]
    all_y = [v[1] for v in mpl_path.vertices]
    
    svg_bounds_dict = {
        'left': min(all_x),
        'top': min(all_y),  # In SVG, Y increases downward, so "top" is minimum Y
        'width': max(all_x) - min(all_x),
        'height': max(all_y) - min(all_y)
    }
    
    print(f"SVG bounds (calculated from vertices): {svg_bounds_dict}")
    print(f"  X range: {min(all_x):.1f} to {max(all_x):.1f}")
    print(f"  Y range: {min(all_y):.1f} to {max(all_y):.1f}")
    
    # Calculate Flutter transformation
    flutter_transform = apply_flutter_transformation(svg_bounds_dict, view_size)
    print(f"Flutter transform: scale={flutter_transform['scale']:.4f}, "
          f"translate=({flutter_transform['translate_x']:.2f}, {flutter_transform['translate_y']:.2f})")
    
    # Create figure - showing Flutter's coordinate space (0 to view_size)
    fig, ax = plt.subplots(1, 1, figsize=(12, 12))
    ax.set_aspect('equal')
    # Note: We're showing in Flutter space, not SVG space, so no Y inversion needed
    
    # Transform SVG path vertices to Flutter space
    transformed_vertices = []
    for vertex in mpl_path.vertices:
        fx, fy = transform_point_to_flutter_space(vertex[0], vertex[1], flutter_transform)
        transformed_vertices.append([fx, fy])
    
    # Create transformed path
    transformed_path = MPLPath(transformed_vertices, mpl_path.codes)
    
    # Draw transformed SVG path
    patch = PathPatch(transformed_path, facecolor='lightblue', edgecolor='blue', 
                    linewidth=2, alpha=0.3, label='Letter Shape (Transformed)')
    ax.add_patch(patch)
    print("SVG path drawn in Flutter coordinate space")
    
    # Draw JSON points (already in Flutter space after normalization * viewSize)
    colors = ['red', 'green', 'orange', 'purple', 'brown']
    for i, stroke in enumerate(strokes):
        color = colors[i % len(colors)]
        
        # JSON points are normalized (0.0-1.0), convert to Flutter space
        # This matches Flutter: Offset(coords[0] * viewSize.width, coords[1] * viewSize.height)
        x_coords = [p[0] * view_size for p in stroke]
        y_coords = [p[1] * view_size for p in stroke]
        
        # Draw points
        ax.scatter(x_coords, y_coords, c=color, s=50, alpha=0.7, 
                  label=f'Stroke {i+1} ({len(stroke)} points)', zorder=5)
        
        # Draw lines connecting points
        ax.plot(x_coords, y_coords, color=color, linewidth=2, alpha=0.5, 
               linestyle='--', zorder=4)
        
        # Annotate first and last points
        if len(stroke) > 0:
            first_x, first_y = x_coords[0], y_coords[0]
            ax.annotate(f'S{i+1} Start', (first_x, first_y), 
                       xytext=(10, 10), textcoords='offset points',
                       bbox=dict(boxstyle='round,pad=0.3', facecolor=color, alpha=0.7),
                       fontsize=8, zorder=6)
            
            if len(stroke) > 1:
                last_x, last_y = x_coords[-1], y_coords[-1]
                ax.annotate(f'S{i+1} End', (last_x, last_y),
                           xytext=(10, -10), textcoords='offset points',
                           bbox=dict(boxstyle='round,pad=0.3', facecolor=color, alpha=0.7),
                           fontsize=8, zorder=6)
    
    # Set axis limits to Flutter coordinate space
    ax.set_xlim(0, view_size)
    ax.set_ylim(0, view_size)  # Not inverted - Flutter space
    ax.set_xlabel('X coordinate (Flutter space)')
    ax.set_ylabel('Y coordinate (Flutter space)')
    ax.set_title(f'JSON Points vs Letter Shape (Both in Flutter Coordinate Space)\n{os.path.basename(json_path)}')
    ax.grid(True, alpha=0.3)
    ax.legend(loc='upper right')
    
    # Add info text
    info_text = f"View Size: {view_size}x{view_size}\n"
    info_text += f"Total Strokes: {len(strokes)}\n"
    info_text += f"Total Points: {sum(len(s) for s in strokes)}\n"
    info_text += f"Transform Scale: {flutter_transform['scale']:.4f}"
    ax.text(0.02, 0.98, info_text, transform=ax.transAxes,
           verticalalignment='top', bbox=dict(boxstyle='round', facecolor='wheat', alpha=0.8),
           fontsize=10, family='monospace')
    
    plt.tight_layout()
    
    # Use non-interactive backend to avoid GUI blocking
    import matplotlib
    matplotlib.use('Agg')  # Use non-interactive backend
    
    if output_file:
        plt.savefig(output_file, dpi=150, bbox_inches='tight')
        print(f"\nVisualization saved to: {output_file}")
    else:
        plt.savefig('points_visualization.png', dpi=150, bbox_inches='tight')
        print(f"\nVisualization saved to: points_visualization.png")
    
    print("\nVisualization complete! Check the saved PNG file.")
    print("Note: Both SVG and JSON points are shown in Flutter's coordinate space (0 to view_size)")
    plt.close()

def main():
    if len(sys.argv) < 3:
        print("Usage:")
        print("  python3 visualize_points.py <PointsInfo.json> <SVG_path_string> [viewSize] [output.png]")
        print()
        print("Example:")
        print('  python3 visualize_points.py a_PointsInfo.json "M 390 1012 Q 270 1012..." 1000')
        print()
        print("Note: SVG path should be in quotes if it contains spaces")
        sys.exit(1)
    
    json_path = sys.argv[1]
    svg_path = sys.argv[2]
    view_size = float(sys.argv[3]) if len(sys.argv) > 3 else 1000.0
    output_file = sys.argv[4] if len(sys.argv) > 4 else None
    
    if not os.path.exists(json_path):
        print(f"Error: File not found: {json_path}")
        sys.exit(1)
    
    visualize(json_path, svg_path, view_size, output_file)

if __name__ == "__main__":
    main()

