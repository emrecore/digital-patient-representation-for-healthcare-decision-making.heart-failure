# Dataset Description

## Overview

This project uses the **Heart Failure Clinical Records** dataset from the UCI Machine Learning Repository.

The dataset contains clinical records of **299 patients with heart failure** who were observed during a follow-up period.

Each row represents one patient.

The dataset contains:

* **299 observations**
* **12 explanatory variables**
* **1 binary outcome variable**
* no missing values in the original dataset

The primary outcome variable is `DEATH_EVENT`, indicating whether the patient died during the recorded follow-up period.

---

## Dataset Source

The dataset is publicly available through the **UCI Machine Learning Repository**.

It is associated with the study:

> Chicco, D. & Jurman, G.
> *Machine learning can predict survival of patients with heart failure from serum creatinine and ejection fraction alone.*
> BMC Medical Informatics and Decision Making, 2020.

UCI Dataset DOI:

`10.24432/C5Z89R`

The dataset is distributed under the **Creative Commons Attribution 4.0 International (CC BY 4.0)** license.

---

## Data Structure

The raw dataset is stored as a CSV file:

```text
heart_failure_clinical_records_dataset.csv
```

Each observation corresponds to a single patient, while columns contain demographic characteristics, comorbidities, laboratory measurements, cardiac measurements, follow-up duration, and mortality status.

The analytical dataset contains the following variables.

---

## Variable Dictionary

| Variable                   | Type           | Unit / Coding          | Description                                                            |
| -------------------------- | -------------- | ---------------------- | ---------------------------------------------------------------------- |
| `age`                      | Numeric        | years                  | Age of the patient                                                     |
| `anaemia`                  | Binary         | 0 = No, 1 = Yes        | Indicates whether the patient had anaemia                              |
| `creatinine_phosphokinase` | Numeric        | mcg/L                  | Level of creatinine phosphokinase enzyme in the blood                  |
| `diabetes`                 | Binary         | 0 = No, 1 = Yes        | Indicates whether the patient had diabetes                             |
| `ejection_fraction`        | Numeric        | %                      | Percentage of blood leaving the left ventricle during each contraction |
| `high_blood_pressure`      | Binary         | 0 = No, 1 = Yes        | Indicates whether the patient had hypertension                         |
| `platelets`                | Numeric        | kiloplatelets/mL       | Platelet concentration in the blood                                    |
| `serum_creatinine`         | Numeric        | mg/dL                  | Serum creatinine concentration                                         |
| `serum_sodium`             | Numeric        | mEq/L                  | Serum sodium concentration                                             |
| `sex`                      | Binary         | 0 = Female, 1 = Male   | Biological sex recorded in the dataset                                 |
| `smoking`                  | Binary         | 0 = No, 1 = Yes        | Indicates whether the patient smoked                                   |
| `time`                     | Numeric        | days                   | Duration of follow-up                                                  |
| `DEATH_EVENT`              | Binary outcome | 0 = Survived, 1 = Died | Indicates whether the patient died during follow-up                    |

---

## Variable Groups

For analytical purposes, the variables can be grouped into several domains.

### Demographic Variables

* `age`
* `sex`

These variables describe basic patient characteristics.

---

### Comorbidities and Risk Factors

* `anaemia`
* `diabetes`
* `high_blood_pressure`
* `smoking`

These variables are represented as binary indicators.

---

### Cardiac Measurement

* `ejection_fraction`

Ejection fraction provides information about systolic cardiac function.

---

### Laboratory Measurements

* `creatinine_phosphokinase`
* `platelets`
* `serum_creatinine`
* `serum_sodium`

These variables represent biochemical or hematological measurements collected from the patients.

---

### Follow-Up Variable

* `time`

The variable `time` represents the number of days for which a patient was followed.

It is important to distinguish this variable from a conventional baseline predictor because it contains information about the observation period itself.

For this reason, its interpretation requires particular caution in analyses involving mortality.

---

### Outcome Variable

* `DEATH_EVENT`

`DEATH_EVENT` is the primary outcome variable used in the project.

The coding is:

```text
0 = patient survived during follow-up
1 = patient died during follow-up
```

The outcome therefore refers specifically to mortality observed during the available follow-up period.

---

## Variable Types in R

During preprocessing, variables are converted into suitable R data types.

Continuous and numerical variables are stored as numeric values:

```text
age
creatinine_phosphokinase
ejection_fraction
platelets
serum_creatinine
serum_sodium
time
```

Binary categorical variables are converted to factors:

```text
anaemia
diabetes
high_blood_pressure
sex
smoking
DEATH_EVENT
```

Using factors for categorical variables improves interpretability during descriptive analyses, visualizations, statistical testing, and regression modeling.

---

## Data Quality

The original UCI dataset contains no documented missing values.

Nevertheless, the analysis does not assume that publicly available data are automatically analysis-ready.

The project therefore performs explicit data quality checks, including:

* verification of missing values
* identification of duplicate observations
* validation of variable classes
* inspection of unexpected values
* assessment of numerical distributions
* detection of potential outliers
* verification of binary variable coding

These checks are implemented before inferential statistical analyses are performed.

---

## Distributional Characteristics

Several variables in the dataset have substantially different statistical distributions.

Variables such as:

* `creatinine_phosphokinase`
* `platelets`
* `serum_creatinine`

may contain skewed distributions or extreme observations.

Other variables, such as:

* `age`
* `ejection_fraction`
* `serum_sodium`

can be evaluated using conventional descriptive measures while still requiring inspection of their empirical distributions.

For this reason, the project uses both graphical and numerical methods when assessing continuous variables.

Depending on the variable and analytical question, summaries include:

* mean
* median
* standard deviation
* interquartile range
* minimum and maximum
* quantiles

This distribution-aware approach also informs the choice between parametric and non-parametric statistical tests later in the analysis.

---

## Analytical Role of the Dataset

The dataset is used to demonstrate a complete statistical workflow in R, including:

1. data import and preparation
2. data quality assessment
3. descriptive statistics
4. clinical data visualization
5. mortality group comparisons
6. hypothesis testing
7. correlation analysis
8. regression analysis
9. interpretation of clinically relevant associations

The objective is not to build a production-ready medical prediction system.

Instead, the dataset serves as a compact real-world healthcare dataset for demonstrating statistical reasoning, reproducible analysis, and careful interpretation of clinical data.

---

## Important Considerations

The dataset should be interpreted within its original clinical context.

It contains a relatively small sample of patients with established heart failure and therefore does not represent the general population.

In addition, variables available in the dataset represent only a subset of the information that would normally be considered in comprehensive clinical research.

Potentially relevant information such as detailed medication history, treatment interventions, broader laboratory panels, longitudinal measurements, socioeconomic factors, and additional cardiovascular characteristics is not included.

The dataset is therefore well suited for exploratory statistical analysis and methodological demonstration, but conclusions should remain limited to the information contained in the available records.
