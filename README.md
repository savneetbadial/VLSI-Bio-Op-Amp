# ECG Signal Processing & Hardware-Compatible ML Pipeline

## Overview
[cite_start]This repository contains the Python-based signal processing and machine learning pipeline developed to support an Integrated Circuit (IC) design for biomedical signal monitoring[cite: 6, 17]. [cite_start]The software acts as a "Golden Model," providing the functional reference for the SystemVerilog detection logic and the telescopic cascode amplifier[cite: 7, 21].

### The Role of Python in the Design Flow:
1. [cite_start]**Clinical Data Ingestion:** Loads raw ECG data from the MIT-BIH Arrhythmia Database.
2. **DSP Pipeline:** Implements a 4th-order Butterworth bandpass filter (0.5Hz–45Hz) to remove baseline wander and EMG noise.
3. **ML Classification:** Executes a 1D-CNN with **96.11% accuracy** and **97.22% recall** for arrhythmia detection.
4. [cite_start]**Hardware stimulus Generation:** Normalizes signals to a 12-bit unsigned range (0–4095) and exports them to `.hex` files for Xilinx Vivado testbenches[cite: 27, 28, 96].

---

## 🛠 Project Architecture

### 1. DSP & Normalization
To bridge the gap between microvolt-level biopotentials and digital hardware, the script performs the following:
* [cite_start]**Filtering:** Uses `scipy.signal` to isolate cardiac-specific frequencies.
* [cite_start]**Scaling:** Maps raw data into a 12-bit integer range to emulate a medical-grade ADC.
* **Centering:** Establishes a stable 0-line to prevent DC drift in the hardware detector.

### 2. 1D-CNN Model Structure
The classifier is a lean 6-layer architecture designed for embedded constraints:
* **Total Parameters:** 39,425
* **Memory Footprint:** ~154 KB (Optimized for FPGA BRAM usage)
* **Optimization:** Utilizes a $10^{-4}$ learning rate and Dropout (0.3) for stability during the 30-epoch training cycle.

---

## 🚀 Usage

### Dependencies
```bash
pip install numpy pandas scipy tensorflow scikit-learn
