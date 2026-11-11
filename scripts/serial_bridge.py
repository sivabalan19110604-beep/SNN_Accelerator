import serial
import time
import csv
import os

COM_PORT = 'COM6'
BAUD_RATE = 9600

def run_serial_bridge():
    csv_path = r"C:\SNN_Accelerator\results\commands.csv"
    
    if not os.path.exists(csv_path):
        print(f"[ERROR] Commands log not found at: {csv_path}")
        print("Please run your Vivado simulation first to generate results/commands.csv.")
        return

    try:
        # Connect to Arduino Uno on COM6
        ser = serial.Serial(COM_PORT, BAUD_RATE, timeout=1)
        time.sleep(2)  # Wait for Arduino auto-reset on connection
        print(f"[SUCCESS] Connected to Arduino Uno on {COM_PORT} @ {BAUD_RATE} baud.")

        with open(csv_path, "r") as f:
            reader = csv.DictReader(f)
            for row in reader:
                code = row["Command_Code"].strip()
                
                # Map binary Vivado codes to motor letters
                cmd_char = 'S'
                if code == '00': cmd_char = 'F'
                elif code == '01': cmd_char = 'L'
                elif code == '10': cmd_char = 'R'
                elif code == '11': cmd_char = 'S'

                print(f"Transmitting Command: {cmd_char} (Code: {code})")
                ser.write(cmd_char.encode('utf-8'))
                time.sleep(0.8) # Delay so you can see motor actions clearly

        # Final safety stop command
        ser.write(b'S')
        ser.close()
        print("[COMPLETED] Command replay finished. Arduino halted safely.")

    except serial.SerialException as e:
        print(f"[ERROR] Could not open {COM_PORT}. Make sure Arduino IDE Serial Monitor is CLOSED.")
        print(f"Details: {e}")

if __name__ == "__main__":
    run_serial_bridge()