# How to Fix JSON Alignment for Telugu Letter Tracing

## Problem
The JSON points in `a_PointsInfo.json` are not aligned with the SVG letter shape in the Flutter app.

## Solution
Regenerate the JSON points using the HTML tool, which uses Flutter's exact transformation.

## Steps

1. **Open the HTML tool:**
   ```bash
   open lib/src/tools/telugu_stroke_editor_centerline.html
   ```
   Or open it in your browser manually.

2. **Copy the SVG path:**
   - Open `lib/src/phontics_constants/telugu_shape_paths.dart`
   - Copy the `aShape` constant value (the entire path string)

3. **Paste into HTML tool:**
   - Paste the SVG path into the "SVG Path" textarea
   - Click "Load SVG Path"
   - You should see the letter shape displayed

4. **Trace the letter:**
   - Click along the centerline of each stroke
   - The tool will automatically find the centerline point inside the stroke borders
   - Red dots = edge points, Green dots = centerline points
   - Adjust "Centerline Offset" slider if needed

5. **Generate JSON:**
   - Click "Generate JSON" button
   - Copy the generated JSON
   - Replace the content of `lib/assets/phontics_assets_points/telugu_phontics/a_PointsInfo.json`

6. **Verify alignment:**
   ```bash
   python3 lib/src/tools/fix_json_alignment.py lib/assets/phontics_assets_points/telugu_phontics/a_PointsInfo.json "<SVG_PATH>" 300
   ```

## Why This Works
The HTML tool uses Flutter's exact transformation logic:
- viewSize = 300x300 (matches Flutter)
- Same scale and translate calculation as Flutter
- Generates normalized points (0.0-1.0) that align perfectly

## Current Issue
The current JSON points don't match the letter shape. They need to be regenerated using the HTML tool.
