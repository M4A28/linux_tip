import os
import argparse
import asyncio
import time
from termcolor import colored
import aiofiles
from concurrent.futures import ThreadPoolExecutor

async def organize_files_by_category(source_folder, destination_folder=None):
    start_time = time.time()

    if not destination_folder:
        # If destination_folder is not provided or empty, create subfolders based on file extension
        destination_folder = os.getcwd()

    os.makedirs(destination_folder, exist_ok=True)

    category_counters = {}
    total_files_moved = 0
    total_size_moved = 0

    async def move_file(filename, category):
        nonlocal total_files_moved, total_size_moved
        file_path = os.path.join(source_folder, filename)

        if os.path.isfile(file_path):
            fil_ext = file_path.rsplit(".", 1)
            ext = ""
            if len(fil_ext) < 2:
                ext = ""
            else:
                ext = fil_ext[1]
            destination_path = os.path.join(destination_folder, os.path.join(category, ext))

            try:
                # Create directory if it doesn't exist
                os.makedirs(destination_path, exist_ok=True)

                # Sanitize and move file asynchronously
                new_filename = sanitize_filename(filename)
                destination_file_path = os.path.join(destination_path, new_filename)

                with ThreadPoolExecutor() as executor:
                    await asyncio.get_event_loop().run_in_executor(executor, lambda: os.rename(file_path, destination_file_path))

                print(f"Moved: {colored(filename,'blue')} to {destination_path} as {colored(new_filename, 'green')}")

                # Update category counters
                category_counters[category] = category_counters.get(category, 0) + 1

                # Update total files moved and size
                total_files_moved += 1
                total_size_moved += os.path.getsize(destination_file_path)

            except Exception as e:
                print(colored(f"Error moving {filename}: {str(e)}", 'red'))

    tasks = [move_file(filename, get_file_category(filename)) for filename in os.listdir(source_folder)]
    await asyncio.gather(*tasks)

    end_time = time.time()
    execution_time = end_time - start_time
    print("=============================")
    print(f"{colored('Report:', 'blue')}")
    print(f"Execution Time: {colored('{:.2f}'.format(execution_time), 'green')} seconds")
    print("Category Counters:")
    for category, count in category_counters.items():
        print(f"{category}: {colored(count, 'green')} files")
    print(f"Total Files Moved: {colored(total_files_moved, 'green')}")
    print(f"Total Size Moved: {colored(format_size(total_size_moved), 'green')}")
    print("=============================")

def is_supported_file(filename):
    supported_extensions = {".jpg", ".jpeg", ".png", ".gif", ".bmp", ".tiff", ".webp",
                            ".mp3", ".wav", ".ogg", ".flac", ".aac",".mp4", ".avi",".txt",
                            ".mkv", ".mov", ".wmv", ".pdf","zip", ".rar", ".7z",
                            ".exe", ".deb", ".iso", ".webm", ".m4a", ".svg",
                            ".ods", ".odf", ".odt", ".doc", ".docx", ".xls",
                            ".xlsm", ".ppt", ".pptx", ".bz2", ".xz", ".tar", ".gz"}
    return any(filename.lower().endswith(ext) for ext in supported_extensions)

def get_file_category(filename):
    image_extensions = {".jpg", ".jpeg", ".png", ".gif", ".bmp", ".tiff", ".webp", ".svg"}
    sound_extensions = {".mp3", ".wav", ".ogg", ".flac", ".aac", ".m4a"}
    document_extensions = {".pdf", ".zip", ".rar", ".7z", ".exe", ".deb", ".iso", ".txt", ".bz2", ".xz", ".tar", ".gz"}
    office_extensions = {".ods", ".odf", ".odt", ".doc", ".docx", ".xls", ".xlsm", ".ppt", ".pptx"}
    video_extensions = {".mp4", ".avi", ".mkv", ".mov", ".wmv", ".webm"}
    
    

    if any(filename.lower().endswith(ext) for ext in image_extensions):
        return "Pictures"
    elif any(filename.lower().endswith(ext) for ext in sound_extensions):
        return "Music"
    elif any(filename.lower().endswith(ext) for ext in document_extensions):
        return "Documents"
    elif any(filename.lower().endswith(ext) for ext in office_extensions):
        return "Documents/Office"
    elif any(filename.lower().endswith(ext) for ext in video_extensions):
        return "Videos"
    else:
        return "Other"

def sanitize_filename(filename):
    # Remove specific characters (except underscores) and replace hyphens with underscores
    allowed_characters = set('.-_')
    return ''.join(char if char.isalnum() or char in allowed_characters else '_' for char in filename)

def format_size(size_in_bytes):
    # Convert bytes to human-readable format
    for unit in ['B', 'KB', 'MB', 'GB']:
        if size_in_bytes < 1024.0:
            return f"{size_in_bytes:.2f} {unit}"
        size_in_bytes /= 1024.0

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Organize files by category")
    parser.add_argument("source_folder", help="Path to the source folder containing files")
    parser.add_argument("--destination_folder", help="Path to the destination folder for organizing files")

    args = parser.parse_args()

    asyncio.run(organize_files_by_category(args.source_folder, args.destination_folder))
    print(colored("Script executed successfully.", 'green'))

