#!/usr/bin/env python3
"""
extract_telugu.py

Usage:
  # Use a local TTF file
  python3 tools/extract_telugu.py /path/to/NotoSansTelugu-Regular.ttf

  # Or pass a URL to download (fallback)
  python3 tools/extract_telugu.py https://example.com/NotoSansTelugu-Regular.ttf

If no argument is given, the script will try a known Google Fonts URL.
The script prints the SVG path string (d="...") and writes a_extracted.svg.

Dependencies: fonttools, requests
Install: python3 -m pip install --user fonttools requests
"""
import sys
import io
import os
import re
import glob
import requests
from fontTools.ttLib import TTFont
from fontTools.pens.svgPathPen import SVGPathPen

def find_local_telugu_font():
    """Search common locations for Telugu fonts."""
    possible_paths = [
        # macOS system fonts
        "/System/Library/Fonts/*Telugu*.ttf",
        "/Library/Fonts/*Telugu*.ttf",
        os.path.expanduser("~/Library/Fonts/*Telugu*.ttf"),
        # Common Linux paths
        "/usr/share/fonts/**/*Telugu*.ttf",
        "/usr/local/share/fonts/**/*Telugu*.ttf",
        # Windows paths
        "C:/Windows/Fonts/*Telugu*.ttf",
    ]
    
    for pattern in possible_paths:
        try:
            matches = glob.glob(pattern, recursive=True)
            if matches:
                print(f"Found local Telugu font: {matches[0]}")
                return matches[0]
        except Exception as e:
            print(f"Error checking {pattern}: {e}")
    
    return None

DEFAULT_FONT_URL = "https://cdn.jsdelivr.net/gh/notofonts/notofonts.github.io/fonts/NotoSansTelugu/hinted/ttf/NotoSansTelugu-Regular.ttf"
OUT_SVG = "a_extracted.svg"
CODEPOINT = 0x0C05  # U+0C05 = అ
# Alternative codepoints to try if main one fails
ALTERNATIVE_CODEPOINTS = [0x0C05, 0x0C06, 0x0C07]  # Different potential mappings for అ


def read_local_file(path):
    with open(path, "rb") as f:
        return f.read()


def download_font(url):
    print("Downloading font from:", url)
    r = requests.get(url, allow_redirects=True, timeout=30)
    r.raise_for_status()
    data = r.content
    print("Downloaded bytes:", len(data))
    
    # Save the downloaded font for inspection
    with open("downloaded_font.ttf", "wb") as f:
        f.write(data)
    print("Saved font to: downloaded_font.ttf")
    
    return data


def inspect_header(data):
    head = data[:64]
    printable = head.decode("latin-1", errors="replace")
    print("File header (first 64 bytes):", printable)
    
    # Check for HTML content
    if printable.lstrip().startswith("<"):
        print("Warning: file looks like HTML (downloaded a webpage instead of raw TTF).")
        return False
        
    # Check for valid TTF/OTF magic numbers
    if not (data.startswith(b'\x00\x01\x00\x00') or  # TTF
            data.startswith(b'OTTO') or              # OTF
            data.startswith(b'true') or              # TTF (older)
            data.startswith(b'typ1')):               # Other valid font
        print("Warning: File does not start with valid font magic number")
        return False
        
    return True


def transform_path(path_d, em):
    """Transform the path to fix the orientation.
    
    Font coordinates typically have Y-axis inverted (Y increases downward).
    SVG coordinates have Y-axis normal (Y increases upward).
    So we need to flip Y: y_new = em - y_old
    """
    # Pattern to match all SVG path commands and their coordinates
    # Matches: M, L, H, V, C, S, Q, T, A, Z (and lowercase versions)
    pattern = r'([MmLlHhVvCcSsQqTtAaZz])\s*([-\d.eE, ]+)?'
    commands = re.findall(pattern, path_d)
    
    if not commands:
        print("Warning: No commands found in path, returning original")
        return path_d
    
    transformed = []
    
    for cmd, coords in commands:
        cmd_upper = cmd.upper()
        
        # Z command has no coordinates
        if cmd_upper == 'Z':
            transformed.append('Z')
            continue
        
        if not coords or not coords.strip():
            transformed.append(cmd)
            continue
        
        # Parse all numbers from coordinates
        # Handle both space and comma separated values
        coords_clean = coords.replace(',', ' ')
        nums = []
        for num_str in coords_clean.split():
            try:
                nums.append(float(num_str))
            except ValueError:
                continue
        
        if not nums:
            transformed.append(cmd)
            continue
        
        # Transform coordinates based on command type
        transformed_nums = []
        
        if cmd_upper == 'H':  # Horizontal line - only X coordinate
            for x in nums:
                transformed_nums.append(x)  # X stays the same
        elif cmd_upper == 'V':  # Vertical line - only Y coordinate
            for y in nums:
                new_y = em - y  # Flip Y
                transformed_nums.append(new_y)
        elif cmd_upper == 'A':  # Arc - 7 parameters: rx, ry, x-axis-rotation, large-arc-flag, sweep-flag, x, y
            # For arcs, we need to flip the last two (x, y) and possibly adjust flags
            i = 0
            while i < len(nums):
                if i + 6 < len(nums):  # Full arc command
                    rx, ry, x_rot, large_arc, sweep, x, y = nums[i:i+7]
                    # Flip Y and potentially swap sweep flag
                    new_y = em - y
                    transformed_nums.extend([rx, ry, x_rot, large_arc, 1 - sweep, x, new_y])
                    i += 7
                else:
                    # Incomplete arc, just copy remaining
                    transformed_nums.extend(nums[i:])
                    break
        else:
            # For M, L, C, S, Q, T - all have X,Y pairs (or more for curves)
            # Transform each X,Y pair: X stays same, Y is flipped
            i = 0
            if cmd_upper in ['C', 'S']:  # Cubic bezier - 6 numbers (x1,y1 x2,y2 x,y)
                while i + 5 < len(nums):
                    x1, y1, x2, y2, x, y = nums[i:i+6]
                    transformed_nums.extend([x1, em - y1, x2, em - y2, x, em - y])
                    i += 6
            elif cmd_upper in ['Q', 'T']:  # Quadratic bezier - 4 numbers (x1,y1 x,y)
                while i + 3 < len(nums):
                    x1, y1, x, y = nums[i:i+4]
                    transformed_nums.extend([x1, em - y1, x, em - y])
                    i += 4
            else:  # M, L - 2 numbers (x, y)
                while i + 1 < len(nums):
                    x, y = nums[i], nums[i+1]
                    transformed_nums.append(x)
                    transformed_nums.append(em - y)  # Flip Y
                    i += 2
            
            # Add any remaining numbers (shouldn't happen, but handle gracefully)
            if i < len(nums):
                transformed_nums.extend(nums[i:])
        
        # Format numbers back to string
        coord_str = ' '.join([f"{n:.1f}" if n != int(n) else f"{int(n)}" for n in transformed_nums])
        transformed.append(f"{cmd} {coord_str}")
    
    return ' '.join(transformed)

def extract_glyph_path(font_bytes, codepoint):
    try:
        f = TTFont(io.BytesIO(font_bytes))
    except Exception as e:
        print("Error: TTFont could not load font:", e)
        return None, None

    print("\nAvailable tables in font:", f.keys())
    
    # Try different cmap formats
    cmap = None
    best_cmap = f.getBestCmap()
    all_cmaps = []
    
    # First try Unicode platform (3) with Telugu encoding
    for subtable in f['cmap'].tables:
        if subtable.platformID == 3:  # Unicode platform
            print(f"\nChecking cmap table - Platform: {subtable.platformID}, Encoding: {subtable.platEncID}")
            current_cmap = subtable.cmap
            all_cmaps.append(current_cmap)
            
            # Look specifically for Telugu characters
            telugu = [k for k in current_cmap.keys() if 0x0C00 <= k <= 0x0C7F]
            if telugu:
                print("Found Telugu range! Sample codepoints:", [hex(k) for k in sorted(telugu)[:10]])
                print(f"Checking for అ (U+0C05): {hex(codepoint) if codepoint in current_cmap else 'Not found'}")
                if codepoint in current_cmap:
                    cmap = current_cmap
                    break
    
    if not cmap:
        cmap = best_cmap  # Fall back to best cmap if no Telugu-specific one found

    # Try all possible codepoints in all cmaps
    for try_codepoint in ALTERNATIVE_CODEPOINTS:
        if try_codepoint in cmap:
            print(f"\nFound glyph for U+{try_codepoint:04X} in best cmap")
            codepoint = try_codepoint
            break
            
        print(f"\nGlyph for U+{try_codepoint:04X} not found in best cmap.")
        print("Checking other cmaps...")
        
        found = False
        for alt_cmap in all_cmaps:
            if try_codepoint in alt_cmap:
                print(f"Found glyph in alternative cmap!")
                cmap = alt_cmap
                codepoint = try_codepoint
                found = True
                break
        if found:
            break
    else:
        print(f"Could not find Telugu letter అ in any cmap. Tried codepoints: {[hex(cp) for cp in ALTERNATIVE_CODEPOINTS]}")
        return None, None

    if codepoint not in cmap:
        print(f"Error: Codepoint U+{codepoint:04X} not found in any cmap")
        return None, None

    glyph_name = cmap[codepoint]
    print(f"\nFound glyph name: {glyph_name}")
    
    glyphSet = f.getGlyphSet()
    print(f"Available glyphs: {sorted(list(glyphSet.keys()))[:10]}")
    
    if glyph_name not in glyphSet:
        print(f"Error: Glyph '{glyph_name}' not found in glyph set!")
        return None, None
        
    glyph = glyphSet[glyph_name]
    
    # Get the 'glyf' table for more detailed glyph info
    glyf_table = f['glyf'][glyph_name]
    print(f"\nGlyph details from 'glyf' table:")
    print(f"- Number of contours: {glyf_table.numberOfContours}")
    print(f"- X Min/Max: {glyf_table.xMin}/{glyf_table.xMax}")
    print(f"- Y Min/Max: {glyf_table.yMin}/{glyf_table.yMax}")
    if hasattr(glyf_table, 'coordinates'):
        print(f"- Number of coordinates: {len(glyf_table.coordinates)}")
    
    pen = SVGPathPen(glyphSet)
    glyph.draw(pen)
    d = pen.getCommands()
    
    if not d or d.strip() == 'M 0 0 Z':
        print("\nWarning: Empty or invalid path generated!")
        print("Attempting to extract coordinates directly...")
        
        if hasattr(glyf_table, 'coordinates'):
            coords = glyf_table.coordinates
            # Convert coordinates to SVG path
            d = f"M {coords[0][0]} {coords[0][1]}"
            for x, y in coords[1:]:
                d += f" L {x} {y}"
            d += " Z"
    
    print(f"\nRaw path commands: {d}")
    
    em = f['head'].unitsPerEm if 'head' in f else 1000
    print(f"Units per em: {em}")
    
    # Transform the path to fix orientation
    d = transform_path(d, em)
    print(f"\nTransformed path commands: {d}")
    
    svg = f'''<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 {em} {em}">
  <path d="{d}" fill="black"/>
</svg>'''
    return d, svg


def main():
    arg = sys.argv[1] if len(sys.argv) > 1 else None
    font_bytes = None

    # If an argument is provided and it's a local file, use it
    if arg:
        if os.path.isfile(arg):
            print(f"Using local font file: {arg}")
            try:
                font_bytes = read_local_file(arg)
            except Exception as e:
                print("Failed to read local file:", e)
                sys.exit(2)
        else:
            # Treat arg as URL
            try:
                font_bytes = download_font(arg)
            except Exception as e:
                print("Download failed:", e)
                sys.exit(2)
    else:
        # No arg: try the default URL
        try:
            font_bytes = download_font(DEFAULT_FONT_URL)
        except Exception as e:
            print("Download failed:", e)
            print("Try passing a local TTF path as the first argument.")
            sys.exit(2)

    ok = inspect_header(font_bytes)
    if not ok:
        print("Downloaded file looks invalid. If you passed a local file, double-check its path. If using URL, try downloading manually via browser.")

    d, svg = extract_glyph_path(font_bytes, CODEPOINT)
    if not d:
        print("Failed to extract glyph path.")
        sys.exit(3)

    print("\n--- SVG PATH (d=) ---\n")
    print(d)
    with open(OUT_SVG, "w", encoding="utf-8") as f:
        f.write(svg)
    print(f"\nWrote {OUT_SVG} in current directory. Open it to verify visually.")


if __name__ == "__main__":
    main()
