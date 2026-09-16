# Dataset Description

## Overview

This project uses the **Heart Failure Clinical Records** dataset from the UCI Machine Learning Repository.

The dataset contains clinical records from **299 patients with heart failure**, with **12 explanatory variables and one binary mortality outcome**. Each row represents one patient.

The available information includes demographics, comorbidities, cardiac function, laboratory measurements, smoking status, follow-up duration, and mortality outcome.

The dataset is treated as a **partial digital representation of real patients**, not as a complete description of their clinical condition.

---

## Source

The dataset is associated with:

> Chicco, D. & Jurman, G.  
> *Machine learning can predict survival of patients with heart failure from serum creatinine and ejection fraction alone.*  
> BMC Medical Informatics and Decision Making, 2020.

**UCI Dataset DOI:** `10.24432/C5Z89R`  
**License:** Creative Commons Attribution 4.0 International (CC BY 4.0)

The dataset used in this repository is stored at:

`data/heart_failure_clinical_records_dataset.csv`

---

## Variable Dictionary

| Variable | Type | Unit / Coding | Description |
|---|---|---|---|
| `age` | Numeric | years | Patient age |
| `anaemia` | Binary | 0 = No, 1 = Yes | Presence of anaemia |
| `creatinine_phosphokinase` | Numeric | mcg/L | Creatinine phosphokinase level |
| `diabetes` | Binary | 0 = No, 1 = Yes | Presence of diabetes |
| `ejection_fraction` | Numeric | % | Percentage of blood leaving the left ventricle during contraction |
| `high_blood_pressure` | Binary | 0 = No, 1 = Yes | Presence of hypertension |
| `platelets` | Numeric | kiloplatelets/mL | Platelet concentration |
| `serum_creatinine` | Numeric | mg/dL | Serum creatinine concentration |
| `serum_sodium` | Numeric | mEq/L | Serum sodium concentration |
| `sex` | Binary | 0 = Female, 1 = Male | Biological sex recorded in the dataset |
| `smoking` | Binary | 0 = No, 1 = Yes | Recorded smoking status |
| `time` | Numeric | days | Follow-up duration |
| `DEATH_EVENT` | Binary outcome | 0 = No death event, 1 = Death event | Recorded mortality during follow-up |

---

## Analytical Variable Groups

The project separates baseline patient information from follow-up information and the mortality outcome.

### Baseline Numerical Variables

- `age`
- `creatinine_phosphokinase`
- `ejection_fraction`
- `platelets`
- `serum_creatinine`
- `serum_sodium`

### Baseline Categorical Variables

- `anaemia`
- `diabetes`
- `high_blood_pressure`
- `smoking`
- `sex`

### Follow-Up Variable

- `time`

### Outcome Variable

- `DEATH_EVENT`

The full available baseline representation therefore contains **11 variables**.

These groups are defined centrally in `01_data_import_and_setup.R` and reused throughout the analytical pipeline.

---

## Variable Configuration

During data setup:

- numerical variables are converted to numeric format
- `anaemia`, `diabetes`, `high_blood_pressure`, and `smoking` are converted to `No` / `Yes` factors
- `sex` is converted to `Female` / `Male`
- `DEATH_EVENT` is converted to `No death event` / `Death event`

This creates consistent variable definitions for all later analyses.

---

## Mortality Outcome

The primary outcome is `DEATH_EVENT`.

The dataset contains:

- **203 patients with no recorded death event**
- **96 patients with a recorded death event**

The observed mortality proportion is approximately **32.1%**.

This describes the analyzed sample and should not be interpreted as a population-level mortality estimate.

---

## Follow-Up Information

The variable `time` records follow-up duration in days.

Because it represents the observation process rather than baseline patient information, it is:

- summarized separately in outcome-group descriptions
- excluded from baseline logistic regression models
- excluded from the representation layers
- excluded from baseline correlation analysis

The combination of `DEATH_EVENT` and `time` creates a time-to-event structure.

The current project analyzes whether a death event was recorded rather than explicitly modeling event timing. Survival analysis is therefore a possible future extension.

---

## Data Quality

The original dataset contains no documented missing values.

The project nevertheless performs an independent technical audit including:

- expected-variable checks
- variable-class validation
- categorical factor-level validation
- missing-value assessment
- duplicate detection
- non-finite-value checks
- basic logical-validity checks
- constant-variable checks
- IQR-based potential-outlier detection

Potential outliers are flagged for inspection and are not automatically removed.

---

## Digital Patient Representation

The dataset represents selected patient-health dimensions, including:

- demographics
- cardiac function
- renal and biochemical status
- hematological information
- selected comorbidities
- smoking status
- mortality
- follow-up duration

Important dimensions are not represented in detail, including:

- medication
- treatment interventions
- symptoms
- functional status
- longitudinal clinical development
- patient-reported outcomes
- socioeconomic context
- healthcare resource use
- management decisions

Therefore, **technical completeness does not imply complete patient representation**.

The dataset provides the empirical basis for examining how statistical evidence changes when the amount or granularity of available patient information changes.