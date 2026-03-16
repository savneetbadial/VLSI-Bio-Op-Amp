import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import os

# --- 1. Load the Data ---
# We use the relative path since your CSV is inside the 'raw-data' folder
file_path = 'raw-data/100_ekg.csv'

if not os.path.exists(file_path):
    print(f"ERROR: Could not find '{file_path}'. Check your sidebar!")
else:
    df = pd.read_csv(file_path)

    # Print the first few lines to the console so you can verify the columns
    print("Preview of the data:")
    print(df.head())

    # Assuming the ECG voltage is in the second column (Index 1)
    # If it is the first column, change the 1 to a 0
    raw_signal = df.iloc[:, 1].values

    # --- 2. Normalize and Scale ---
    # ECG signals are tiny (mV). We scale them to a 12-bit integer (0 to 4095)
    # This prepares the data for a digital system (like your SystemVerilog model)
    min_val = np.min(raw_signal)
    max_val = np.max(raw_signal)

    # Avoid division by zero if the signal is flat
    if max_val - min_val == 0:
        scaled_signal = np.zeros_like(raw_signal)
    else:
        scaled_signal = ((raw_signal - min_val) / (max_val - min_val) * 4095).astype(int)

    # --- 3. Export to Hex for SystemVerilog ---
    # This creates the file that $readmemh will use in Vivado
    with open('ecg_data.hex', 'w') as f:
        for val in scaled_signal:
            # Writes as 3-digit hex values (e.g., 1A2)
            f.write(f"{val:03x}\n")

    print("\nSUCCESS: 'ecg_data.hex' has been created.")

    # --- 4. Visualize the Result ---
    # This helps you verify that the signal still looks like an ECG
    plt.figure(figsize=(10, 4))
    plt.plot(scaled_signal[:1000])  # Plot the first 1000 samples
    plt.title("Scaled ECG Signal (12-bit Digital Representation)")
    plt.xlabel("Sample Index")
    plt.ylabel("Digital Value (0-4095)")
    plt.grid(True)
    plt.show()