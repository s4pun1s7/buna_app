import os
import sys
from PIL import Image

# Set the root directory for assets
ASSETS_DIR = 'assets'

# File extensions to compress
IMAGE_EXTENSIONS = ['.png', '.jpg', '.jpeg']

# Compression settings
JPEG_QUALITY = 82  # Optimized for quality vs size
PNG_OPTIMIZE = True
WEBP_QUALITY = 85  # WebP generally provides better compression than JPEG

# Size thresholds for optimization (in bytes)
LARGE_IMAGE_THRESHOLD = 500 * 1024  # 500KB
HUGE_IMAGE_THRESHOLD = 1024 * 1024  # 1MB

# Maximum dimensions for different use cases
MAX_HERO_DIMENSIONS = (1920, 1080)  # Hero/background images
MAX_CONTENT_DIMENSIONS = (800, 600)  # Content images
MAX_ICON_DIMENSIONS = (512, 512)    # Icons and logos

def get_image_info(file_path):
    """Get image dimensions and file size"""
    try:
        with Image.open(file_path) as img:
            size = os.path.getsize(file_path)
            return img.size, size
    except Exception as e:
        print(f"Error reading {file_path}: {e}")
        return None, None

def should_convert_to_webp(file_path, file_size):
    """Determine if image should be converted to WebP for better compression"""
    # Convert large images to WebP for better compression
    if file_size > LARGE_IMAGE_THRESHOLD:
        return True
    
    # Convert hero/background images to WebP
    filename = os.path.basename(file_path).lower()
    if any(keyword in filename for keyword in ['story', 'background', 'hero', 'banner']):
        return True
        
    return False

def resize_if_needed(img, file_path):
    """Resize image if it's too large for its use case"""
    filename = os.path.basename(file_path).lower()
    width, height = img.size
    
    # Determine appropriate max dimensions based on filename
    if any(keyword in filename for keyword in ['story', 'background', 'hero']):
        max_dims = MAX_HERO_DIMENSIONS
    elif any(keyword in filename for keyword in ['icon', 'logo', 'buna']):
        max_dims = MAX_ICON_DIMENSIONS
    else:
        max_dims = MAX_CONTENT_DIMENSIONS
    
    # Check if resizing is needed
    if width > max_dims[0] or height > max_dims[1]:
        # Calculate new dimensions maintaining aspect ratio
        ratio = min(max_dims[0] / width, max_dims[1] / height)
        new_size = (int(width * ratio), int(height * ratio))
        print(f"Resizing {file_path} from {img.size} to {new_size}")
        return img.resize(new_size, Image.Resampling.LANCZOS)
    
    return img

def compress_image(file_path):
    """Compress a single image with optimal settings"""
    ext = os.path.splitext(file_path)[1].lower()
    original_size = os.path.getsize(file_path)
    
    try:
        with Image.open(file_path) as img:
            # Resize if needed
            img = resize_if_needed(img, file_path)
            
            # Convert RGBA to RGB for JPEG if needed
            if ext in ['.jpg', '.jpeg'] and img.mode in ('RGBA', 'LA'):
                background = Image.new('RGB', img.size, (255, 255, 255))
                background.paste(img, mask=img.split()[-1] if img.mode == 'RGBA' else None)
                img = background
            
            # Try to create WebP version for large images
            if should_convert_to_webp(file_path, original_size):
                try:
                    webp_path = os.path.splitext(file_path)[0] + '.webp'
                    img.save(webp_path, 'WebP', quality=WEBP_QUALITY, optimize=True)
                    webp_size = os.path.getsize(webp_path)
                    
                    # Keep WebP only if it's significantly smaller
                    if webp_size < original_size * 0.8:
                        print(f"Created WebP: {webp_path} ({original_size//1024}KB → {webp_size//1024}KB)")
                    else:
                        os.remove(webp_path)
                        print(f"WebP not beneficial for {file_path}, keeping original format")
                except Exception as e:
                    print(f"WebP creation failed for {file_path}: {e}")
            
            # Optimize original format
            if ext in ['.jpg', '.jpeg']:
                img.save(file_path, 'JPEG', quality=JPEG_QUALITY, optimize=True, progressive=True)
            elif ext == '.png':
                if original_size > HUGE_IMAGE_THRESHOLD:
                    # For very large PNGs, consider converting to progressive JPEG
                    jpeg_path = os.path.splitext(file_path)[0] + '_optimized.jpg'
                    if img.mode in ('RGBA', 'LA'):
                        background = Image.new('RGB', img.size, (255, 255, 255))
                        background.paste(img, mask=img.split()[-1] if img.mode == 'RGBA' else None)
                        img = background
                    img.save(jpeg_path, 'JPEG', quality=JPEG_QUALITY, optimize=True, progressive=True)
                    jpeg_size = os.path.getsize(jpeg_path)
                    
                    if jpeg_size < original_size * 0.6:  # If JPEG is significantly smaller
                        print(f"Large PNG converted to JPEG: {jpeg_path} ({original_size//1024}KB → {jpeg_size//1024}KB)")
                    else:
                        os.remove(jpeg_path)
                        # Standard PNG optimization
                        img.save(file_path, 'PNG', optimize=True, compress_level=9)
                else:
                    # Standard PNG optimization
                    img.save(file_path, 'PNG', optimize=True, compress_level=9)
            
            compressed_size = os.path.getsize(file_path)
            compression_ratio = (1 - compressed_size / original_size) * 100
            print(f"Compressed: {file_path} ({original_size//1024}KB → {compressed_size//1024}KB, {compression_ratio:.1f}% reduction)")
            
    except Exception as e:
        print(f"Failed to compress {file_path}: {e}")

def compress_assets():
    """Main function to compress all assets"""
    total_original_size = 0
    total_compressed_size = 0
    processed_files = 0
    
    print("🚀 Starting asset optimization...")
    print(f"Processing directory: {ASSETS_DIR}")
    
    for root, _, files in os.walk(ASSETS_DIR):
        for file in files:
            ext = os.path.splitext(file)[1].lower()
            if ext in IMAGE_EXTENSIONS:
                file_path = os.path.join(root, file)
                
                # Get original size
                original_size = os.path.getsize(file_path)
                total_original_size += original_size
                
                # Compress the image
                compress_image(file_path)
                
                # Get compressed size
                compressed_size = os.path.getsize(file_path)
                total_compressed_size += compressed_size
                
                processed_files += 1
    
    # Print summary
    if processed_files > 0:
        total_reduction = (1 - total_compressed_size / total_original_size) * 100
        print(f"\n✅ Optimization complete!")
        print(f"📊 Summary:")
        print(f"   Files processed: {processed_files}")
        print(f"   Original size: {total_original_size // 1024}KB")
        print(f"   Compressed size: {total_compressed_size // 1024}KB")
        print(f"   Total reduction: {total_reduction:.1f}%")
        print(f"   Space saved: {(total_original_size - total_compressed_size) // 1024}KB")
    else:
        print("No image files found to process.")

if __name__ == '__main__':
    compress_assets() 