# Healthcare Context

## Heart Failure

Heart failure is a complex clinical syndrome in which structural or functional cardiac abnormalities impair the heart's ability to support the body's physiological needs.

The clinical presentation of heart failure is heterogeneous. Patients may differ substantially in:

* cardiac function
* symptom burden
* functional capacity
* comorbidities
* renal function
* laboratory measurements
* treatment exposure
* disease severity
* social and behavioral characteristics

For this reason, no small set of routinely collected variables can be assumed to provide a complete representation of the real-world patient.

This project analyzes records from **299 patients with heart failure**.

The dataset is therefore treated as a **partial digital representation of the observed patients**, not as a complete description of their clinical state.

---

# Clinical Information Available in the Dataset

The dataset contains selected baseline characteristics that are clinically interpretable in the context of heart failure.

These variables provide useful patient information, but each represents only one component of a substantially broader clinical picture.

## Demographic Information

The dataset contains:

* age
* sex

Age can be relevant to disease burden, comorbidity patterns, physiological reserve, and prognosis.

Sex may also be associated with differences in heart-failure phenotype, comorbidities, treatment patterns, and outcomes.

Neither variable provides a complete description of the patient's demographic or social context.

---

## Cardiac Function

The dataset contains:

* ejection fraction

Left-ventricular ejection fraction is an important measure of cardiac systolic function and is widely used in the clinical characterization and classification of heart failure.

However, ejection fraction alone does not describe the complete cardiac phenotype.

The dataset does not provide detailed information on:

* cardiac structure
* ventricular dimensions
* valvular disease
* right-ventricular function
* congestion
* cardiac rhythm
* electrocardiographic findings
* repeated cardiac measurements over time

The project therefore treats ejection fraction as one available component of cardiac representation rather than as a complete measure of cardiac disease severity.

---

## Renal and Biochemical Information

The dataset contains:

* serum creatinine
* serum sodium
* creatinine phosphokinase

Renal function and serum electrolytes are clinically relevant in the evaluation and management of patients with heart failure.

Serum creatinine provides limited information related to renal function, while serum sodium provides information about electrolyte status.

Creatinine phosphokinase is included as an available laboratory measurement in the source dataset but is not treated in this project as a comprehensive or heart-failure-specific measure of disease status.

These measurements represent selected laboratory information only.

The dataset does not contain a comprehensive biochemical profile or repeated laboratory trajectories.

---

## Hematological Information

The dataset contains:

* anaemia status
* platelet count

Anaemia can be clinically relevant in patients with heart failure and may coexist with other comorbid conditions.

Platelet count provides additional hematological information.

These variables do not constitute a complete hematological assessment.

---

## Comorbidities and Risk Factors

The dataset contains indicators for:

* diabetes
* high blood pressure
* smoking

These characteristics provide information about selected cardiovascular risk factors and comorbidities.

However, the dataset does not provide a complete comorbidity history.

Other potentially relevant diseases and conditions are not systematically represented.

---

# Information Not Represented

Several clinically meaningful patient-information domains are absent from the analytical dataset.

Examples include:

* detailed symptom burden
* functional status
* New York Heart Association functional class as an analytical variable
* medication use
* medication dose and treatment intensity
* detailed treatment history
* device therapy
* hospitalization history
* detailed healthcare utilization
* patient-reported outcomes
* quality of life
* socioeconomic context
* social support
* adherence
* frailty
* cognitive status
* detailed vital signs
* natriuretic peptides such as BNP or NT-proBNP
* repeated clinical measurements over time

The absence of these variables does **not** mean that each would be required for every statistical or healthcare question.

Their importance depends on the intended analytical context.

The central point is narrower:

> **Information that was never digitally represented cannot directly contribute to the statistical model.**

For this reason, technical completeness within the available variables should not be confused with completeness of the patient representation.

---

# Outcome and Follow-Up

The binary outcome is:

```text
DEATH_EVENT
```

It indicates whether a death event was recorded during the patient's observed follow-up period.

The dataset also contains:

```text
time
```

which represents follow-up duration in days.

These variables are treated separately from baseline patient characteristics.

* `DEATH_EVENT` is an **outcome**
* `time` is **observation information**

Neither is treated as a baseline patient-representation dimension.

---

## Variable Follow-Up

Patients were observed for different lengths of time.

This creates an underlying **time-to-event structure**.

A patient with no recorded death event after a relatively short observation period is not analytically equivalent to a patient who remains without a recorded death event after a much longer observation period.

The original clinical study therefore used survival-analysis methods, including Kaplan-Meier and Cox-regression approaches.

The current project deliberately uses logistic regression as an **illustrative binary-outcome framework** for studying representation sensitivity.

Accordingly, the models evaluate:

> **whether a death event was recorded during the available observed follow-up**

rather than:

> **the probability of death within a standardized clinical time horizon**

The fitted probabilities generated by the logistic models must therefore not be interpreted as validated fixed-horizon mortality risks or survival probabilities.

---

# Clinical Context and Digital Patient Representation

The clinical context is important because healthcare datasets necessarily reduce complex patients to selected recorded variables.

In this project:

```text
Real-World Patient
        ↓
Selected Recorded Information
        ↓
Digital Patient Representation
        ↓
Statistical Model
```

The analytical model has access only to the information represented in the dataset.

It cannot directly observe:

* unrecorded symptoms
* unrecorded treatments
* unrecorded functional limitations
* unrecorded social context
* unrecorded longitudinal changes

This does not make the dataset unusable.

It defines the **informational boundary within which the statistical analysis should be interpreted**.

---

# Interpretation Boundary

The clinical context supports interpretation of the available variables, but this project does not attempt to determine:

* the complete clinical state of each patient
* optimal treatment
* treatment effectiveness
* individual treatment benefit
* validated clinical risk
* clinical decision validity
* healthcare-management decision validity

The statistical analyses are therefore interpreted as analyses of the **available digital patient representation**.

The project asks how statistical output changes when that representation changes.

It does not claim that the available representation is clinically complete or that a more information-rich representation is automatically clinically superior.

---

# References

1. Heidenreich PA, Bozkurt B, Aguilar D, et al. 2022 AHA/ACC/HFSA Guideline for the Management of Heart Failure. *Circulation.* 2022;145:e895-e1032. doi:10.1161/CIR.0000000000001063.

2. McDonagh TA, Metra M, Adamo M, et al. 2023 Focused Update of the 2021 ESC Guidelines for the diagnosis and treatment of acute and chronic heart failure. *European Heart Journal.* 2023.

3. Ahmad T, Munir A, Bhatti SH, Aftab M, Raza MA. Survival analysis of heart failure patients: A case study. *PLoS One.* 2017;12(7):e0181001. doi:10.1371/journal.pone.0181001.
