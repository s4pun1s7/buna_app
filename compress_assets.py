import os
from PIL import Image

# Set the root directory for assets
ASSETS_DIR = 'assets'

# File extensions to compress
IMAGE_EXTENSIONS = ['.png', '.jpg', '.jpeg']

# Compression quality (for JPEG)
JPEG_QUALITY = 85  # You can adjust this

# PNG optimization
PNG_OPTIMIZE = True


def compress_image(file_path):
    ext = os.path.splitext(file_path)[1].lower()
    try:
        with Image.open(file_path) as img:
            if ext in ['.jpg', '.jpeg']:
                img.save(file_path, 'JPEG', quality=JPEG_QUALITY, optimize=True)
            elif ext == '.png':
                img.save(file_path, 'PNG', optimize=PNG_OPTIMIZE)
            print(f"Compressed: {file_path}")
    except Exception as e:
        print(f"Failed to compress {file_path}: {e}")


def compress_assets():
    for root, _, files in os.walk(ASSETS_DIR):
        for file in files:
            ext = os.path.splitext(file)[1].lower()
            if ext in IMAGE_EXTENSIONS:
                file_path = os.path.join(root, file)
                compress_image(file_path)


if __name__ == '__main__':
    compress_assets() 