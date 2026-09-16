# Patient Representation

## Concept

This project treats the dataset as a **digital representation of real patients**.

A statistical model does not analyze the complete patient directly. It analyzes the patient information that has been recorded and made available in digital form.

Therefore:

**Real Patient ≠ Digital Patient Representation**

The quality of statistical evidence depends not only on the statistical method, but also on:

- which patient characteristics are available
- how those characteristics are encoded
- how much information is omitted
- how much information is simplified

---

## Represented Patient Dimensions

The dataset contains selected information from several patient-health domains.

| Patient Dimension | Representation | Available Information |
|---|---|---|
| Demographics | Partial | Age, sex |
| Cardiac function | Partial | Ejection fraction |
| Renal status | Partial | Serum creatinine |
| Hematological information | Partial | Anaemia, platelets |
| Biochemical information | Partial | Serum sodium, creatinine phosphokinase, serum creatinine |
| Comorbidities | Partial | Anaemia, diabetes, hypertension |
| Behavioral risk factors | Very limited | Smoking status |
| Mortality outcome | Available | Recorded death event |
| Follow-up information | Available | Follow-up duration |
| Detailed disease severity | Limited | Selected clinical measurements only |
| Medication | Not represented | None |
| Treatment interventions | Not represented | None |
| Symptoms | Not represented | None |
| Functional status | Not represented | None |
| Longitudinal clinical development | Not represented | None |
| Patient-reported outcomes | Not represented | None |
| Socioeconomic context | Not represented | None |
| Healthcare resource use | Not represented | None |
| Management decisions | Not represented | None |

This map defines the informational boundary of the analysis.

---

## Technical Completeness vs Patient Representation

A dataset can contain no missing values and still represent only part of the real patient.

Therefore:

**Technical completeness ≠ Complete patient representation**

The absence of missing values only means that recorded variables are populated. It does not mean that all clinically relevant patient dimensions are available.

The adequacy of a representation also depends on the intended analytical or decision context.

---

## Representation Layers

The representation sensitivity analysis defines four nested baseline patient representations.

### Layer 1 — Basic Demographic Representation

- `age`
- `sex`

### Layer 2 — Demographics, Comorbidities and Risk Factors

Layer 1 plus:

- `anaemia`
- `diabetes`
- `high_blood_pressure`
- `smoking`

### Layer 3 — Expanded Clinical Representation

Layer 2 plus:

- `ejection_fraction`
- `serum_creatinine`
- `serum_sodium`

### Layer 4 — Full Available Baseline Representation

Layer 3 plus:

- `creatinine_phosphokinase`
- `platelets`

The layers are nested:

**Layer 1 ⊂ Layer 2 ⊂ Layer 3 ⊂ Layer 4**

Layer 4 contains all **available baseline variables** used by the project.

It should not be interpreted as a complete representation of the real patient.

---

## Why Representation Layers Matter

The four layers allow the project to hold the patient population constant while changing the amount of patient information available to the model.

This creates the analytical structure:

**Same Patients + Different Available Information → Different Statistical Models**

The project then examines whether representation changes affect:

- model fit
- regression coefficients
- odds ratios
- patient-level probabilities
- illustrative classifications

This evaluates **representation sensitivity**.

---

## Information Granularity

Patient representation depends not only on which variables are available, but also on how precisely they are represented.

The project demonstrates this by comparing:

- continuous ejection fraction
- median-based binary ejection fraction

The median is used only as a methodological cutoff.

It is not a clinical threshold.

This experiment evaluates whether reducing the granularity of patient information changes statistical model output.

---

## Follow-Up Information

The variable `time` records follow-up duration.

It is not included in the representation layers because it describes the observation process rather than baseline patient information.

For the same reason, `time` is not used as an ordinary baseline predictor in the logistic regression models.

---

## Interpretation

Representation sensitivity does not determine whether one representation is clinically sufficient.

Instead, it asks whether statistical results remain stable when the available representation changes.

A statistically stable result may still be based on incomplete clinical information.

Therefore:

**Statistical reliability ≠ Clinical validity**

Clinical validity requires additional clinical evidence, domain expertise, and information beyond the statistical behavior observed in this dataset.

---

## Role in the Project

The patient-representation framework connects the project's main analytical stages:

**Real Patient → Digital Representation → Statistical Model → Statistical Evidence → Representation Sensitivity → Reliability Assessment**

The central principle is:

> **A statistical model does not analyze the patient directly. It analyzes the available digital representation of the patient.**