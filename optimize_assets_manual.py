#!/usr/bin/env python3
"""
Manual Asset Optimization Script for Buna Festival App
This script provides optimization recommendations and basic file operations.
"""

import os
import shutil

def analyze_assets():
    """Analyze current asset sizes and provide optimization recommendations"""
    assets_dir = 'assets'
    total_size = 0
    large_files = []
    
    print("🔍 Asset Analysis Report")
    print("=" * 50)
    
    for root, dirs, files in os.walk(assets_dir):
        for file in files:
            if file.lower().endswith(('.png', '.jpg', '.jpeg')):
                file_path = os.path.join(root, file)
                size = os.path.getsize(file_path)
                total_size += size
                
                size_mb = size / (1024 * 1024)
                print(f"📁 {file}: {size_mb:.2f}MB")
                
                if size > 500 * 1024:  # > 500KB
                    large_files.append((file, size_mb))
    
    print(f"\n📊 Total asset size: {total_size / (1024 * 1024):.2f}MB")
    
    if large_files:
        print(f"\n⚠️  Large files requiring optimization:")
        for file, size in large_files:
            print(f"   • {file}: {size:.2f}MB")
            
            # Provide specific recommendations
            if 'story' in file.lower() or 'background' in file.lower():
                print(f"     Recommendation: Convert to WebP or progressive JPEG, resize to max 1920x1080")
            elif 'icon' in file.lower() or 'logo' in file.lower():
                print(f"     Recommendation: Optimize PNG compression, resize to max 512x512")
            else:
                print(f"     Recommendation: Compress and resize to appropriate dimensions")
    
    print(f"\n🎯 Optimization Recommendations:")
    print(f"   • Total potential savings: ~60-70% (estimated 2-3MB reduction)")
    print(f"   • Use WebP format for photos (BUNA3_BlueStory.png, BUNA3_PinkStory.png)")
    print(f"   • Resize large images to appropriate dimensions for mobile")
    print(f"   • Use progressive JPEG for large photos")
    print(f"   • Optimize PNG compression for logos/icons")
    
    return total_size, large_files

def create_optimized_asset_config():
    """Create configuration for optimized asset loading"""
    config = """
# Asset Optimization Configuration
# Use this guide to manually optimize assets using external tools

## Large Images (>1MB) - Convert to WebP or Progressive JPEG
BUNA3_BlueStory.png -> BUNA3_BlueStory.webp (recommended max: 1920x1080)
BUNA3_PinkStory.png -> BUNA3_PinkStory.webp (recommended max: 1920x1080)

## Medium Images (100KB-1MB) - Optimize compression
8.jpeg -> Optimize with 80-85% quality

## Small Images (<100KB) - Optimize PNG compression
buna_black.png -> Optimize PNG compression
buna_blue.png -> Optimize PNG compression  
buna_pink.png -> Optimize PNG compression

## Tools for manual optimization:
1. Online: TinyPNG, Squoosh.app, Kraken.io
2. CLI: imagemagick, cwebp, pngquant
3. GUI: GIMP, Photoshop, XnConvert

## Example commands (if tools available):
# Convert to WebP:
cwebp -q 85 BUNA3_BlueStory.png -o BUNA3_BlueStory.webp

# Optimize PNG:
pngquant --quality=75-90 --output buna_black_optimized.png buna_black.png

# Progressive JPEG:
convert BUNA3_BlueStory.png -quality 82 -interlace Plane BUNA3_BlueStory.jpg
"""
    
    with open('ASSET_OPTIMIZATION_GUIDE.txt', 'w') as f:
        f.write(config)
    
    print("📝 Created ASSET_OPTIMIZATION_GUIDE.txt")

def estimate_optimized_sizes():
    """Estimate sizes after optimization"""
    optimizations = {
        'BUNA3_BlueStory.png': {
            'current': 2.5,  # MB
            'optimized_webp': 0.8,  # Estimated 70% reduction
            'optimized_jpg': 1.2,   # Estimated 50% reduction
        },
        'BUNA3_PinkStory.png': {
            'current': 2.2,  # MB
            'optimized_webp': 0.7,  # Estimated 70% reduction
            'optimized_jpg': 1.1,   # Estimated 50% reduction
        },
        'buna_black.png': {
            'current': 0.1,  # MB
            'optimized': 0.06,  # Estimated 40% reduction
        },
        'buna_blue.png': {
            'current': 0.03,  # MB
            'optimized': 0.02,  # Estimated 30% reduction
        },
        'buna_pink.png': {
            'current': 0.04,  # MB
            'optimized': 0.025,  # Estimated 35% reduction
        },
        '8.jpeg': {
            'current': 0.09,  # MB
            'optimized': 0.07,  # Estimated 20% reduction
        }
    }
    
    current_total = sum(opt['current'] for opt in optimizations.values())
    webp_total = (
        optimizations['BUNA3_BlueStory.png']['optimized_webp'] +
        optimizations['BUNA3_PinkStory.png']['optimized_webp'] +
        sum(opt.get('optimized', opt['current']) for key, opt in optimizations.items() 
            if not key.startswith('BUNA3_'))
    )
    
    print(f"\n📈 Optimization Impact Estimates:")
    print(f"   Current total: {current_total:.2f}MB")
    print(f"   With WebP conversion: {webp_total:.2f}MB")
    print(f"   Estimated savings: {current_total - webp_total:.2f}MB ({((current_total - webp_total) / current_total * 100):.1f}%)")
    
    return current_total, webp_total

if __name__ == '__main__':
    print("🚀 Buna Festival Asset Optimization Analysis")
    print("=" * 50)
    
    # Analyze current assets
    total_size, large_files = analyze_assets()
    
    # Create optimization guide
    create_optimized_asset_config()
    
    # Show estimated improvements
    estimate_optimized_sizes()
    
    print(f"\n✅ Analysis complete!")
    print(f"📋 Next steps:")
    print(f"   1. Review ASSET_OPTIMIZATION_GUIDE.txt")
    print(f"   2. Use online tools or CLI to optimize images")
    print(f"   3. Test the app with optimized assets")
    print(f"   4. Monitor performance improvements")