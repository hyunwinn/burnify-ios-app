import time
import random

def calculate_zone2_heart_rate(age):
    # Calculate maximum heart rate and Zone 2 range (60-70% of max HR)
    max_hr = 220 - age
    zone2_lower = int(max_hr * 0.6)
    zone2_upper = int(max_hr * 0.7)
    return zone2_lower, zone2_upper

def simulate_heart_rate(zone2_lower, zone2_upper):
    # Simulate heart rate with some variation around Zone 2
    return random.randint(zone2_lower - 10, zone2_upper + 10)

def main():
    # Prompt user to enter their age with validation
    while True:
        try:
            age = int(input("Please enter your age (1-120): "))
            if age <= 0 or age > 120:
                print("Invalid input. Age must be between 1 and 120.")
                continue
            break
        except ValueError:
            print("Invalid input. Please enter a valid integer.")

    # Calculate Zone 2 heart rate range
    zone2_lower, zone2_upper = calculate_zone2_heart_rate(age)
    print("\nUser Age:", age)
    print(f"Calculated Zone 2 Heart Rate Range: {zone2_lower} - {zone2_upper} bpm\n")
    print("Beginning heart rate monitoring simulation...")
    print("Press Ctrl+C at any time to terminate the program.\n")

    try:
        while True:
            hr = simulate_heart_rate(zone2_lower, zone2_upper)

            if zone2_lower <= hr <= zone2_upper:
                status = "Within Zone 2: Optimal fat-burning range."
            elif hr < zone2_lower:
                status = "Below Zone 2: Please increase your intensity."
            else:
                status = "Above Zone 2: Please decrease your intensity."

            print(f"Current Heart Rate: {hr} bpm --> {status}")
            time.sleep(2)

    except KeyboardInterrupt:
        print("\nMonitoring session terminated. Thank you for using the Zone 2 Fat-Burn Tracker.")

if __name__ == "__main__":
    main()
