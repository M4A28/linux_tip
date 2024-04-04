from sklearn.cluster import KMeans
import numpy as np
import argparse
import csv
from termcolor import colored
import json 
from PIL import Image
import traceback

import matplotlib.pyplot as plt


def brightness(color):
    # Calculate brightness of a color using the formula:
    # sqrt(0.299*R^2 + 0.587*G^2 + 0.114*B^2)
    return np.sqrt(0.299*(color[0]**2) + 0.587*(color[1]**2) + 0.114*(color[2]**2))
    
    

def extract_colors(image_path, num_colors):
    image = Image.open(image_path)
    image = image.resize((150, 150))  # reduce size to speed up processing
    image_np = np.array(image)
    flattened = image_np.reshape(-1, 3)
    
    kmeans = KMeans(n_clusters=num_colors)
    labels = kmeans.fit_predict(flattened)
    
    colors = kmeans.cluster_centers_
    return colors

def rgb_to_hex(rgb):
    return '#{:02x}{:02x}{:02x}'.format(int(rgb[0]), int(rgb[1]), int(rgb[2]))


def plot_colors(colors, filename):
    fig, ax = plt.subplots(1, 1, figsize=(12, 7.2), dpi=100)
    plt.axis('off')
    colors_array = np.array(colors).astype(int)  # convert list to numpy array
    plt.imshow([colors_array], aspect='auto')

    hex_colors = [rgb_to_hex(color) for color in colors]
    x_positions = np.linspace(start=0, stop=1, num=len(hex_colors), endpoint=False)
    for hex_color, pos in zip(hex_colors, x_positions):
        plt.text(pos, 0.5, hex_color, color='white' if np.mean(colors) < 128 else 'black', 
                 horizontalalignment='left', verticalalignment='top', 
                 transform=ax.transAxes, rotation='vertical', fontsize=30)

    extent = ax.get_window_extent().transformed(fig.dpi_scale_trans.inverted())
    plt.savefig(filename, bbox_inches=extent)



def save_colors_to_file(colors, txt_filename, json_filename):
    hex_colors = [rgb_to_hex(color) for color in colors]

    with open(txt_filename+".txt", 'w') as f:
        for color in hex_colors:
            f.write(color + '\n')

    with open(json_filename+".json", 'w') as f:
        json.dump(hex_colors, f)


def main():
    parser = argparse.ArgumentParser(description='Extract dominant colors from an image.')
    parser.add_argument('-p', type=str, nargs='+', help='The path to the image file.')
    parser.add_argument('-n', type=int, default=5, help='The number of colors to extract.')
    parser.add_argument('-o', type=str, default='colors_palte', help='The path to  output file.')

    args = parser.parse_args()

    for image_path in args.p:
        try:
            colors = extract_colors(image_path, args.n)
            colors_sortes = sorted(colors, key=brightness)
            txt_filename = f'{image_path}_colors.txt'
            json_filename = f'{image_path}_colors.json'
            # save_colors_to_file(colors, txt_filename, json_filename)
            plot_filename = f'{image_path}_color_palette.png'
            plot_colors(colors_sortes, plot_filename)
            print(f"Color palette saved as '{plot_filename}'")
            # print(f"Colors saved as '{txt_filename}' and '{json_filename}'")
        except Exception:
            print(colored(f"Image {image_path} color not extracted", 'red'))
            traceback.print_exc()
            pass


if __name__ == '__main__':
    main()

