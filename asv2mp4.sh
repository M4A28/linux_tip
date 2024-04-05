#!/bin/bash

# Check if FFmpeg is installed
if ! command -v ffmpeg &> /dev/null; then
    echo "FFmpeg is not installed. Please install FFmpeg before running this script."
    exit 1
fi

# Check if input directory is provided
if [ $# -eq 0 ]; then
    echo "Usage: $0 input_directory"
    exit 1
fi

input_dir="$1"

# Check if input directory exists
if [ ! -d "$input_dir" ]; then
    echo "Input directory '$input_dir' not found."
    exit 1
fi

# Create output directory if it doesn't exist
output_dir="$input_dir/converted"
mkdir -p "$output_dir"

# Loop through ASF files in the input directory
for file in "$input_dir"/*.asf; do
    if [ -f "$file" ]; then
        filename=$(basename "$file")
        filename_no_ext="${filename%.*}"
        output_file="$output_dir/$filename_no_ext.mp4"

        # Convert ASF to MP4 using FFmpeg
        ffmpeg -i "$file" -c:v libx264 -crf 23 -c:a aac -b:a 128k -loglevel error  "$output_file"

        echo "Converted: $filename -> $output_file"
    fi
done

echo "Conversion completed."
