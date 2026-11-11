# SNN Accelerator

Spiking-neural-network-style command decoder for a BCI-controlled car: reads four 8-bit
brain-feature channels and emits a 2-bit drive command (FORWARD / LEFT / RIGHT / STOP).
Includes the Verilog RTL, a self-checking testbench that logs every command, and Python
tooling to generate stimulus and replay the commands to an Arduino Uno.

## Repository layout

```
SNN_Accelerator/
├── rtl/snn_top.v                 # Top-level decoder (4 features -> 2-bit command)
├── tb/tb_snn_top.v               # Testbench: 100 MHz clock, writes results/commands.csv
├── scripts/generate_dataset.py   # Creates the sample feature CSV
├── scripts/serial_bridge.py      # Replays commands to Arduino over serial
├── data/bci_features_sample.csv  # Sample 4-channel feature stimulus
├── results/commands.csv          # Simulation output: time + command code
└── SNN_Accelerator/              # Vivado project (SNN_Accelerator.xpr)
```

Vivado build artifacts (`.cache`, `.hw`, `.runs`, `.sim`, `.ip_user_files`, logs,
waveforms) and Python virtualenvs are gitignored — only sources and the `.xpr` are tracked.

## Command encoding

| `command_code` | Command | Condition (threshold = 100) |
|----------------|---------|------------------------------|
| `00`           | FORWARD | `f0 > 100` |
| `01`           | LEFT    | `f1 > 100` |
| `10`           | RIGHT   | `f2 > 100` |
| `11`           | STOP    | none of the above (also the reset default) |

## Simulation flow (Vivado)

1. Open `SNN_Accelerator/SNN_Accelerator.xpr` in Vivado.
2. Run behavioral simulation of the `tb_snn_top` testbench.
3. The bench drives FORWARD, LEFT, RIGHT and STOP stimulus and writes
   `results/commands.csv` (`Time_ns,Command_Code`), printing
   `[SUCCESS] Simulation finished!` when done.

> **Note:** the testbench and scripts use absolute paths (`C:\SNN_Accelerator\...`).
> Adjust them if your checkout lives elsewhere.

## Serial bridge (Arduino)

`scripts/serial_bridge.py` reads `results/commands.csv` and replays each command to an
Arduino Uno (`COM6` @ 9600 baud), mapping `00/01/10/11` to `F/L/R/S` and sending a final
safety `S`:

```powershell
pip install pyserial
python scripts/serial_bridge.py
```

Close the Arduino IDE Serial Monitor first, otherwise the port cannot be opened.

## Dataset generator

```powershell
python scripts/generate_dataset.py
```

Writes `data/bci_features_sample.csv` with one feature vector per command pattern.
