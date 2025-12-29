from PIL import Image
import sys

# Simple script to replace near-white pixels with transparency and upscale
# Usage: python remove_bg.py input.png output.png [threshold] [scale_factor]

def remove_white_background(infile, outfile, thresh=240, scale=2):
    im = Image.open(infile).convert('RGBA')
    datas = im.getdata()
    newData = []
    for item in datas:
        r, g, b, a = item
        if r >= thresh and g >= thresh and b >= thresh:
            # make transparent
            newData.append((255, 255, 255, 0))
        else:
            newData.append((r, g, b, a))
    im.putdata(newData)
    
    # Upscale using high-quality resampling
    if scale > 1:
        new_width = im.width * scale
        new_height = im.height * scale
        im = im.resize((new_width, new_height), Image.Resampling.LANCZOS)
    
    im.save(outfile, 'PNG')

if __name__ == '__main__':
    if len(sys.argv) < 3:
        print('Usage: remove_bg.py input.png output.png [threshold] [scale_factor]')
        sys.exit(1)
    infile = sys.argv[1]
    outfile = sys.argv[2]
    thresh = int(sys.argv[3]) if len(sys.argv) > 3 else 240
    scale = int(sys.argv[4]) if len(sys.argv) > 4 else 2
    remove_white_background(infile, outfile, thresh, scale)
    print(f'Wrote {outfile} (upscaled {scale}x)')
