import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import os

# 1. Setup folders
input_folder = 'raw-data'
output_folder = 'processed-data'
plots_folder = 'plots'  # New folder for visuals

for folder in [output_folder, plots_folder]:
    if not os.path.exists(folder):
        os.makedirs(folder)

# 2. Process all files
for filename in os.listdir(input_folder):
    if filename.endswith(".csv") and "annotations" not in filename.lower():
        file_path = os.path.join(input_folder, filename)

        df = pd.read_csv(file_path)
        raw_signal = df.iloc[:, 1]

        if pd.api.types.is_numeric_dtype(raw_signal):
            raw_signal = raw_signal.values

            # Normalize and scale
            min_val, max_val = np.min(raw_signal), np.max(raw_signal)
            scaled_signal = ((raw_signal - min_val) / (max_val - min_val) * 4095).astype(int)

            # Save hex
            hex_filename = filename.replace('.csv', '.hex')
            with open(os.path.join(output_folder, hex_filename), 'w') as f:
                for val in scaled_signal:
                    f.write(f"{val:03x}\n")

            # 3. Save plot
            plt.figure(figsize=(10, 4))
            plt.plot(scaled_signal[:1000], color='crimson', linewidth=1)
            plt.title(f"Processed ECG: {filename} (12-bit Digital)")
            plt.ylabel("Digital Value (0-4095)")
            plt.xlabel("Sample Index")
            plt.grid(True, alpha=0.3)

            # Save the plot to the specific plots folder
            plot_filename = filename.replace('.csv', '.png')
            plt.savefig(os.path.join(plots_folder, plot_filename))
            plt.close()  # Closes the plot so it doesn't eat up RAM

            print(f"SUCCESS: {filename} -> Hex and Plot created.")

print("\nCHECK THE 'plots' FOLDER TO SEE ALL VISUALS!")