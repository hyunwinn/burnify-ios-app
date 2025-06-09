# Initial Plan : Personalised Fat-burn Tracker

## Project Overview
The aim of this project is to build a wearable device that helps users stay in their optimal heart rate zone for fat burning (commonly referred to as "Zone 2"). Unlike the most commonly known method that estimates Zone 2 as 60-70% of maximum heart rate, this project focuses on adapting to individual differences through real-time physiological feedback.

---

## Motivation
While many fitness devices offer basic heart rate tracking, they often fail to adapt to individual differences in cardiovascular fitness. This project was inspired by the goal of creating an intelligent tool that adapts to the user and offers more personalised and efficient guidance for fat loss.

---

## Personalisation
- Zone 2 is typically estimated as 60–70% of one's maximum heart rate — with the latter often calculated using the overly simplistic formula of (220 - age), which fails to account for individual differences in fitness, genetics, or physiology. Indeed, a one-size-fits-all model is insufficient for identifying the most effective fat-burning zone for every individual.
- By tracking real-world performance, we aim to **estimate a personal "Fatmax" point** — the heart rate at which fat oxidation is maximised.

---

## Fatmax Estimation
Accurate Fatmax measurement requires gas exchange analysis, where oxygen consumption (VO₂) and carbon dioxide production (VCO₂) are measured during exercise. However, such methods are expensive, lab-restricted, and impractical for most users.

Instead, this project estimates Fatmax based on:

---

### 1. **Calorie Burn Estimation (Heart Rate Based)**
This formula estimates energy expenditure (in kcal/min) using age, weight, gender, and heart rate:
**Keytel *et al.* (2005)**
*Prediction of energy expenditure from heart rate monitoring during submaximal exercise*.
_European Journal of Applied Physiology, 95(5-6), pp. 518-524._

#### Male:
Calories/min = ((-55.0969 + (0.6309 x HR) + (0.1988 x weight[kg]) + 0.2017 x age)) / 4.184

#### Female:
Calories/min = ((-20.4022 + (0.4472 × HR) - (0.1263 × weight[kg]) + (0.074 × age)) / 4.184)

---

### 2. **Fatigue Estimation (via Heart Rate Recovery, HRR)**
After a steady-state run at a specific heart rate, we record:

- **End HR** at the moment exercise stops
- **HR after 1 minute of rest**

Then calculate:
HRR = End HR - HR after 1 minute of rest

#### HRR to Fatigue Level

| **HRR** | **Fatigue Estimate**       | **Fatigue Level** |
|----------------------|----------------------------|--------------------------------------|
| ≥ 25 bpm             | Excellent recovery         | 1                                    |
| 18–24 bpm            | Good / Moderate fatigue    | 2                                    |
| 12–17 bpm            | Average / Suboptimal       | 3                                    |
| < 12 bpm             | Poor recovery / High fatigue | 4                                 |

_Source: Cole *et al.* (1999), NEJM, 341(18), pp. 1351–1357._

---

### 3. **Efficiency Calculation**
For each steady-state run (e.g. 5 mins at constant HR):
Efficiency = Calories Burned / Fatigue Level

---

By repeating steady-state runs at different heart rates and ultimately measuring efficiencies at each heart rates, we can estimate the heart rate range that offers the highest energy efficiency with the least fatigue - an individiual's **personalised Fatmax zone**.

---

## Core Features
- [ ] User input: age, gender, height, weight, etc.
- [ ] Real-time heart rate tracking via MAX30102 sensor
- [ ] HRR measurement post exercise
- [ ] Fatmax estimation & alerting
- [ ] Fatmax refinement over time through data accumulation
- [ ] Visual feedback via GUI (Raspberry Pi)

---

## Tech Stack
| Component         | Description                     |
|------------------|---------------------------------|
| Raspberry Pi      | Hardware platform               |
| MAX30102          | Heart rate sensor      |
| Python            | Main development language       |
| GitHub            | Version control & collaboration |
| AI/ML     | For smart Fatmax prediction     |

---

## Future Plans

### 1. **Validation via Laboratoy Comparison**
Compare estimated Fatmax (Calories Burned / Fatigue Level) with values obtained from lab-based gas exchage analysis.

- Goal: Evaluate the accuracy and reliabilty of our method.
- If the estimated Fatmax is consistently close to lab results, it could serve as a low-cost and practical alternative for the general public.

### 2. **User Study: Traditional vs Personalised Guidance**
Compare personalised Fatmax guidance with conventional Zone 2 models and commercial wearables (such as Apple Watch).

**Participants**:
Recruit test users with **diverse fitness levels** (e.g. sedentary, recreational, athletic) to ensure generalisability across different cardiovascular fitness.

**Evaluation metrics**:
- Estimated fat burned (via body composition analyzer such as InBody)
- User feedback

> Goal: Test whether our approach leads to more efficient fat loss compared to standard methods.