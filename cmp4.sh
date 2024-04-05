#!/bin/bash

# Check if FFmpeg is installed
if ! command -v ffmpeg &> /dev/null; then
    echo "FFmpeg is not installed. Please install FFmpeg before running this script."
    exit 1
fi

# Check if input is provided
if [ $# -eq 0 ]; then
    echo "Usage: $0 input_directory_or_file"
    exit 1
fi

input="$1"

# Check if input is a directory or a file
if [ -d "$input" ]; then
    input_type="directory"
elif [ -f "$input" ]; then
    input_type="file"
else
    echo "Input '$input' not found."
    exit 1
fi

# Create output directory if it doesn't exist (for directory input)
if [ "$input_type" = "directory" ]; then
    output_dir="$input/compressed"
    mkdir -p "$output_dir"
fi

# Compress MP4 files based on input type
if [ "$input_type" = "directory" ]; then
    # Loop through MP4 files in the input directory
    for file in "$input"/*.mp4; do
        if [ -f "$file" ]; then
            filename=$(basename "$file")
            output_file="$output_dir/$filename"

            # Compress MP4 using FFmpeg and set log level to error
            ffmpeg -i "$file" -c:v libx264 -crf 28 -preset slow -c:a aac -b:a 128k -loglevel error "$output_file"

            echo "Compressed: $filename -> $output_file"
        fi
    done
elif [ "$input_type" = "file" ]; then
    # Compress single MP4 file
    filename=$(basename "$input")
    output_file="${input%.*}_compressed.mp4"

    # Compress MP4 using FFmpeg and set log level to error
    ffmpeg -i "$input" -c:v libx264 -crf 28 -preset slow -c:a aac -b:a 128k -loglevel error "$output_file"

    echo "Compressed: $filename -> $output_file"
fi

echo "Compression completed."

