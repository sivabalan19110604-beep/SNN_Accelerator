import csv
import os

# Create sample BCI feature data: 4 channels (f0, f1, f2, f3) representing brain activity
data = [
    {"f0": 200, "f1": 10,  "f2": 10,  "f3": 10},  # Pattern for FORWARD
    {"f0": 10,  "f1": 200, "f2": 10,  "f3": 10},  # Pattern for LEFT
    {"f0": 10,  "f1": 10,  "f2": 200, "f3": 10},  # Pattern for RIGHT
    {"f0": 5,   "f1": 5,   "f2": 5,   "f3": 5}    # Pattern for STOP
]

output_path = r"C:\SNN_Accelerator\data\bci_features_sample.csv"

with open(output_path, "w", newline="") as f:
    writer = csv.DictWriter(f, fieldnames=["f0", "f1", "f2", "f3"])
    writer.writeheader()
    writer.writerows(data)

print("Dataset successfully created at:", output_path)