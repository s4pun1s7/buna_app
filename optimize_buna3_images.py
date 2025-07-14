from PIL import Image
import os

# Source files
files = [
    'assets/BUNA3_BlueStory.png',
    'assets/BUNA3_PinkStory.png'
]

# Output sizes (width, height)
sizes = [
    (1200, 1200),  # Large for web
    (600, 600),    # Medium for mobile
    (300, 300)     # Thumbnail
]

for file in files:
    img = Image.open(file)
    base, ext = os.path.splitext(file)
    for w, h in sizes:
        img_resized = img.copy()
        img_resized.thumbnail((w, h))
        out_path = f"{base}_{w}x{h}.webp"
        img_resized.save(out_path, 'WEBP', quality=85)
        print(f"Saved {out_path}")
