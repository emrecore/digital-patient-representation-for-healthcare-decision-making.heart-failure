# Dataset Description

## Dataset

This project uses the:

**Heart Failure Clinical Records**

dataset distributed through the **UCI Machine Learning Repository**.

The repository contains the dataset locally as:

```text
data/heart_failure_clinical_records_dataset.csv
```

The analytical file contains:

* **299 patient records**
* **11 baseline patient characteristics**
* **1 follow-up-duration variable**
* **1 binary recorded death-event outcome**
* **13 columns in total**
* **no documented missing values in the UCI version**

Each row represents one patient record.

---

# Data Provenance

The dataset should be understood through three related but distinct sources.

## 1. Original Clinical Cohort

The underlying patient cohort was described by:

**Ahmad T, Munir A, Bhatti SH, Aftab M, Raza MA.
Survival analysis of heart failure patients: A case study.
PLoS One. 2017;12(7):e0181001.**

The original study included **299 patients with heart failure** treated at the Institute of Cardiology and Allied Hospital in Faisalabad, Pakistan.

The reported cohort characteristics included:

* 105 women
* 194 men
* age above 40 years
* left-ventricular systolic dysfunction
* New York Heart Association functional class III or IV

Patients were observed during a follow-up period ranging from approximately:

```text
4–285 days
```

with an average reported follow-up of approximately:

```text
130 days
```

The original study analyzed the data as a **time-to-event problem** and used survival-analysis methods including Cox regression and Kaplan-Meier analysis.

This point is important for the interpretation of the current project.

---

## 2. Subsequent Analytical Publication

The dataset was later analyzed by:

**Chicco D, Jurman G.
Machine learning can predict survival of patients with heart failure from serum creatinine and ejection fraction alone.
BMC Medical Informatics and Decision Making. 2020;20:16.**

This publication provides an additional description of the dataset and is identified by the UCI Machine Learning Repository as the dataset's introductory paper.

The later publication contains the same 299-patient dataset and describes the 13 recorded variables used in the publicly distributed file.

---

## 3. UCI Machine Learning Repository

The current project uses the version distributed by the:

**UCI Machine Learning Repository**

Dataset DOI:

```text
10.24432/C5Z89R
```

UCI identifies the dataset as a multivariate health-and-medicine dataset and reports:

```text
Instances: 299
Features: 12
Missing values: No
```

In UCI terminology, the 12 features include the available predictor and follow-up information, while `DEATH_EVENT` is identified as the target.

For the purposes of this project, the 13 file columns are separated conceptually into:

```text
11 baseline patient characteristics
+
1 observation variable
+
1 outcome variable
```

This separation is more appropriate for the analytical design of the current project than treating all 12 non-target columns as equivalent predictors.

---

# Dataset Structure

The raw CSV contains the following columns:

```text
age
anaemia
creatinine_phosphokinase
diabetes
ejection_fraction
high_blood_pressure
platelets
serum_creatinine
serum_sodium
sex
smoking
time
DEATH_EVENT
```

The project deliberately separates these variables into three analytical categories.

---

# 1. Baseline Patient Characteristics

The baseline variables describe information available about the patient rather than observation duration or outcome.

## Numerical Baseline Variables

| Variable                   | Unit             | Project Interpretation               |
| -------------------------- | ---------------- | ------------------------------------ |
| `age`                      | years            | Patient age                          |
| `creatinine_phosphokinase` | mcg/L            | Blood creatinine-phosphokinase level |
| `ejection_fraction`        | %                | Left-ventricular ejection fraction   |
| `platelets`                | kiloplatelets/mL | Blood platelet concentration         |
| `serum_creatinine`         | mg/dL            | Serum creatinine                     |
| `serum_sodium`             | mEq/L            | Serum sodium                         |

These variables are configured as numeric values in the analytical workflow.

The project retains their available numerical granularity rather than reproducing every categorization used in earlier publications.

---

## Categorical Baseline Variables

| Variable              | Source Coding | Project Labels |
| --------------------- | ------------- | -------------- |
| `anaemia`             | 0 / 1         | No / Yes       |
| `diabetes`            | 0 / 1         | No / Yes       |
| `high_blood_pressure` | 0 / 1         | No / Yes       |
| `sex`                 | 0 / 1         | Female / Male  |
| `smoking`             | 0 / 1         | No / Yes       |

The categorical source coding is validated before factor conversion in:

```text
01_data_import_and_setup.R
```

The configured factor levels are then independently checked during the technical data-quality audit in:

```text
02_patient_representation_and_data_quality.R
```

---

# 2. Observation Information

The dataset contains:

```text
time
```

Unit:

```text
days
```

`time` represents the patient's observed follow-up duration.

It is **not treated as a baseline patient characteristic** in this project.

This distinction is important because follow-up duration describes how long the patient was observed rather than a stable characteristic of the patient at baseline.

Accordingly, `time` is:

* described separately
* visualized separately
* excluded from the baseline representation layers
* excluded from baseline correlation analysis
* excluded from baseline logistic-regression predictors
* excluded from the primary baseline hypothesis-testing family

Its presence is nevertheless methodologically important because it reveals the underlying **time-to-event structure** of the dataset.

---

# 3. Recorded Death-Event Outcome

The binary outcome is:

```text
DEATH_EVENT
```

Source coding:

```text
0 = no recorded death event
1 = death event recorded
```

The analytical workflow configures these values as:

```text
No recorded death event
Death event recorded
```

The variable indicates whether a death event was recorded during the patient's available follow-up period.

It is therefore an **outcome variable**, not a baseline patient-representation dimension.

---

# Outcome Distribution

The dataset contains:

```text
203 patients with no recorded death event
96 patients with a recorded death event
```

Corresponding to approximately:

```text
67.9% no recorded death event
32.1% recorded death event
```

This proportion describes the observed dataset.

It should **not** be interpreted as:

* a general heart-failure mortality rate
* a fixed-horizon mortality probability
* an individual patient's mortality risk
* a population-level survival estimate

The patients were observed for different lengths of time.

---

# Follow-Up and Time-to-Event Structure

The original cohort has an underlying survival structure:

```text
Patient
   ↓
Observed for a variable period of time
   ↓
Death event or no recorded death event
```

Two patients classified as:

```text
No recorded death event
```

may therefore have been observed for substantially different lengths of time.

For example:

```text
Patient A
No recorded death event after short follow-up

Patient B
No recorded death event after long follow-up
```

These observations are not equivalent from a survival-analysis perspective.

The original clinical study appropriately used time-to-event methods.

---

## Current Project Approach

The current project deliberately uses logistic regression as an **illustrative binary-outcome framework** for investigating representation sensitivity.

The logistic models answer:

> **Was a death event recorded during the observed follow-up period?**

They do not directly answer:

> **What is the patient's probability of death within a standardized time horizon?**

or:

> **What is the patient's survival function over time?**

Consequently, the model-generated fitted probabilities are treated as:

```text
in-sample fitted probabilities of the recorded binary outcome
```

rather than validated mortality-risk or survival probabilities.

Survival-analysis methods such as:

* Kaplan-Meier estimation
* log-rank testing
* Cox proportional-hazards regression

remain outside the current v1.0 workflow.

---

# Original Study Versus Current Project

The current analytical treatment of the dataset is intentionally not identical to the original 2017 analysis.

The original study focused on survival analysis and transformed or categorized some variables for its own modeling strategy.

The current project instead preserves the publicly available UCI variables in forms suited to its methodological purpose.

For example:

* ejection fraction is retained as a numerical variable
* serum creatinine is retained as a numerical variable
* platelet count is retained as a numerical variable

The project then performs its own explicitly documented simplification experiment for ejection fraction in:

```text
09_representation_sensitivity_analysis.R
```

This distinction is important.

The current project does not attempt to reproduce the statistical model from the original clinical publication.

It uses the same underlying dataset for a different analytical question:

> **How sensitive are statistical outputs to changes in the amount or granularity of digitally represented patient information?**

---

# Missing Data

The UCI repository reports:

```text
Missing values: No
```

The project independently audits missingness after import.

Importantly:

> **No missing values within the defined variables does not imply that the dataset contains all potentially relevant patient information.**

A variable may be completely populated while entire patient-information domains remain absent from the dataset.

For example, the dataset does not contain structured information on several areas such as:

* detailed symptoms
* functional status
* detailed medications
* treatment history
* patient-reported outcomes
* socioeconomic context
* longitudinal clinical trajectories

This distinction between:

```text
technical completeness
```

and:

```text
patient representation
```

is central to the project.

---

# Digital Patient Representation

The 11 baseline variables define the maximum baseline patient information directly available to the statistical models in this repository.

They therefore form the project's:

> **full available baseline representation**

This phrase has a specific meaning.

It means:

> all baseline variables available in this dataset.

It does **not** mean:

* complete representation of the real patient
* clinically sufficient representation
* optimal representation
* ground truth
* validated representation quality

The broader qualitative patient-representation assessment is documented in:

```text
docs/patient_representation.md
```

and implemented analytically in:

```text
02_patient_representation_and_data_quality.R
```

---

# Representation Layers

The representation-sensitivity analysis constructs four nested representations from the available baseline variables.

```text
Layer 1
Basic demographic representation

        ↓

Layer 2
+ selected comorbidities and risk factors

        ↓

Layer 3
+ selected clinical measurements

        ↓

Layer 4
Full available baseline representation
```

The underlying patients are held constant across these comparisons.

The layers therefore modify:

> **the information supplied to the model**

rather than intentionally modifying:

> **the analytical patient population**

These layers are project-defined analytical constructions.

They are not validated clinical representation levels.

---

# Information Simplification

The project also distinguishes between:

```text
information being absent
```

and:

```text
information being available but simplified
```

This is examined using ejection fraction.

The same underlying measurement is represented as:

```text
continuous ejection fraction
```

and:

```text
median-based binary ejection fraction
```

The median cutoff is arbitrary and non-clinical.

This experiment is not intended to establish a clinically meaningful ejection-fraction threshold.

Its purpose is to evaluate whether reducing the granularity of an available patient characteristic changes statistical output.

---

# Data Quality Versus Dataset Scope

Technical data-quality assessment includes questions such as:

* Are expected variables present?
* Are source codes valid?
* Are data types correct?
* Are values missing?
* Are exact duplicate records present?
* Are numerical values finite?
* Are basic logical constraints violated?
* Are variables constant?
* Are potential numerical outliers present?

These checks evaluate the dataset **as recorded**.

They do not establish whether the available variables are sufficient for a particular clinical or healthcare-management question.

This project therefore treats:

```text
Technical Data Quality
```

and:

```text
Patient Representation
```

as related but distinct analytical concepts.

---

# Dataset Limitations

Important dataset-level limitations include:

* relatively small sample size
* observational clinical data
* single historical cohort
* limited number of recorded patient characteristics
* variable follow-up duration
* no detailed medication information
* no detailed treatment information
* no structured symptom measurements
* no structured functional-status measurement in the distributed analytical file
* no patient-reported outcomes
* no socioeconomic information
* no detailed healthcare-utilization information
* no repeated clinical measurements
* no comprehensive longitudinal patient trajectory
* no unique patient identifier in the distributed analytical file
* no external validation dataset within this repository

These limitations do not make the dataset unsuitable for the methodological purpose of the project.

They define the boundaries within which the results should be interpreted.

---

# Reproducibility and Source Preservation

The workflow preserves two separate objects after import:

```text
heart_failure_raw
```

and:

```text
heart_failure
```

`heart_failure_raw` preserves the imported source data unchanged.

`heart_failure` is the configured analytical copy used in subsequent scripts.

This design allows the project to distinguish between:

```text
source data
```

and:

```text
analytical representation
```

and enables later data-quality checks to identify whether configuration has unintentionally altered properties such as missingness.

---

# Dataset Licensing

The UCI Machine Learning Repository distributes the Heart Failure Clinical Records dataset under:

```text
Creative Commons Attribution 4.0 International
CC BY 4.0
```

The license permits sharing and adaptation of the dataset, including for research and analytical use, provided appropriate attribution is given.

The dataset license applies independently from the license governing the project's own analytical code.

---

# Recommended Dataset Citation

**Heart Failure Clinical Records [Dataset].**
UCI Machine Learning Repository. 2020.
doi: **10.24432/C5Z89R**

---

# References

1. Ahmad T, Munir A, Bhatti SH, Aftab M, Raza MA. Survival analysis of heart failure patients: A case study. *PLoS One.* 2017;12(7):e0181001. doi:10.1371/journal.pone.0181001.

2. Chicco D, Jurman G. Machine learning can predict survival of patients with heart failure from serum creatinine and ejection fraction alone. *BMC Medical Informatics and Decision Making.* 2020;20:16. doi:10.1186/s12911-020-1023-5.

3. Heart Failure Clinical Records [Dataset]. UCI Machine Learning Repository. 2020. doi:10.24432/C5Z89R.

---

# Interpretation Summary

The dataset provides a technically complete but informationally bounded digital representation of 299 patients with heart failure.

For the current project, its structure is understood as:

```text
11 baseline patient characteristics
        +
1 follow-up-duration variable
        +
1 recorded binary outcome
```

The available baseline characteristics define what the statistical models can directly use.

Other patient information remains outside the analytical representation.

The dataset should therefore be interpreted not as a complete digital copy of the patient, but as:

> **a specific, limited digital representation from which statistical evidence can be generated and whose influence on model output can be studied.**
