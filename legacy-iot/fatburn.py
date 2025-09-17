def estimate_calorie(hr, weight, age, gender):
    # Estimate caloric expenditure using Keytel formula
    if gender == True: # gender is male
        return ((-55.0969 + (0.6309 * hr) + (0.1988 * weight) + (0.2017 * age)) / 4.184)
    else: # gender is female
        ((-20.4022 + (0.4472 * hr) - (0.1263 * weight) + (0.074 * age)) / 4.184)
        
def get_hrr(end_hr, one_min_hr):
    # Calculate heart rate recovery
    return end_hr - one_min_hr

def get_fatigue_level(hrr):
    # Return fatigue level score (1 to 4) based on HRR
    if hrr >= 25:
        return 1
    elif 18 <= hrr < 25:
        return 2
    elif 12 <= hrr < 18:
        return 3
    else:
        return 4
    
def get_efficiency(calories, fatigue_level):
    # Calculate efficiency as calories burned per fatigue unit
    return calories / fatigue_level