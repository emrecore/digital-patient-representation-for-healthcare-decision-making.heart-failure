# Digital Patient Representation for Healthcare Decision-Making: Heart Failure

## Overview

This project presents a structured statistical analysis of digital clinical records from patients with heart failure using **R**.

It combines two connected objectives:

1. **Clinical statistical analysis**  
   Examine demographic characteristics, clinical measurements, mortality patterns, and statistical associations within the available patient data.

2. **Digital patient representation analysis**  
   Examine how statistical conclusions depend on the amount and structure of patient information available to the analytical model.

The broader methodological question is:

> **How adequately can patients be represented through available digital health data, and how reliable are statistical conclusions and potential healthcare decisions when they are based on this representation?**

The dataset contains records from **299 patients with heart failure**, including demographic characteristics, comorbidities, laboratory measurements, cardiac function, follow-up duration, and a recorded mortality outcome.

The project therefore treats the dataset not simply as a table of variables, but as a **partial digital representation of real patients**.

The core analytical logic is:

```text
Real Patient
    ↓
Digital Patient Representation
    ↓
Data Quality
    ↓
Statistical Analysis
    ↓
Statistical Evidence
    ↓
Representation Sensitivity
    ↓
Reliability Assessment
    ↓
Potential Decision Implications
    ↓
Clinical and Methodological Limits
```

The project is **exploratory and explanatory**.

It does not:

- establish causal relationships
- provide clinical treatment recommendations
- define clinical decision thresholds
- evaluate real healthcare-management interventions
- represent a clinically validated prediction system

---

# Research Perspective

A statistical model does not analyze the complete real-world patient.

It analyzes the information that has been digitally recorded about that patient.

Conceptually:

```text
Real Patient
    ≠
Digital Patient Representation
```

A real patient may be characterized by clinical, physiological, behavioral, therapeutic, social, and contextual information that extends far beyond the variables available in one dataset.

The analytical process can therefore be represented as:

```text
P(real)
    ↓
P(digital)
    ↓
Statistical Model
    ↓
Statistical Evidence
    ↓
Potential Decision Support
```

This project distinguishes between two related but different concepts:

> **Statistical reliability**  
> Whether a statistical result is methodologically supported and sufficiently stable within the available data.

and:

> **Clinical validity**  
> Whether the available patient information and resulting evidence are sufficient and appropriate for interpretation in the real clinical context.

A model may be statistically coherent while clinically relevant patient information remains unavailable.

Therefore:

```text
Statistical reliability
        ≠
Clinical validity
```

---

# Research Questions

The project addresses five connected groups of questions.

## 1. Patient Representation

- Which dimensions of the patient are digitally represented?
- How are these dimensions encoded?
- Which potentially relevant patient dimensions are absent?
- At what level of granularity is the available information represented?

## 2. Statistical Description

- What are the main demographic and clinical characteristics of the observed patient population?
- How frequently did a recorded death event occur?
- How are important clinical measurements distributed?

## 3. Statistical Associations

- Which characteristics differ between patients with and without a recorded death event?
- Which variables show statistically supported mortality associations?
- Which associations remain after adjustment for other available baseline characteristics?
- How consistent are findings across different statistical approaches?

## 4. Representation Sensitivity

- How dependent are statistical conclusions on the amount of patient information available?
- How do model outputs change when the digital patient representation becomes less informative?
- What happens when continuous information is simplified?
- How sensitive are patient-level model estimates to information reduction?

## 5. Decision and Clinical Interpretation

- What type of healthcare decision support could potentially use this information?
- Which conclusions remain too uncertain for real-world decisions?
- Which limitations result from missing patient information?
- Where does statistical interpretation end and additional clinical expertise become necessary?

---

# Dataset

The project uses the **Heart Failure Clinical Records** dataset from the UCI Machine Learning Repository.

The dataset contains:

- **299 patients**
- **12 explanatory variables**
- **1 binary mortality outcome**
- **no documented missing values in the original dataset**

Each row represents one patient.

The primary outcome is:

```text
DEATH_EVENT
```

indicating whether a death event was recorded during follow-up.

The dataset is associated with:

> Chicco, D. & Jurman, G.  
> *Machine learning can predict survival of patients with heart failure from serum creatinine and ejection fraction alone.*  
> BMC Medical Informatics and Decision Making, 2020.

UCI Dataset DOI:

```text
10.24432/C5Z89R
```

License:

```text
Creative Commons Attribution 4.0 International
CC BY 4.0
```

---

# Variable Dictionary

| Variable | Type | Unit / Coding | Description |
|---|---|---|---|
| `age` | Numeric | years | Age of the patient |
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

Binary variables are converted into labelled factors during data preparation where appropriate.

---

# Digital Patient Representation

## Representation Map

The dataset represents selected dimensions of the patient.

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
| Medication | Not represented | No detailed medication information |
| Treatment interventions | Not represented | No detailed treatment information |
| Symptoms | Not represented | No structured symptom information |
| Functional status | Not represented | No detailed functional assessment |
| Longitudinal clinical development | Not represented | No repeated measurement trajectories |
| Patient-reported outcomes | Not represented | No quality-of-life or symptom-reported outcomes |
| Socioeconomic context | Not represented | No socioeconomic characteristics |
| Healthcare resource use | Not represented | No staffing, cost, capacity, or utilization variables |
| Management decisions | Not represented | No observed management interventions |

The purpose of this map is not to classify the dataset as inadequate.

Instead, it makes the informational boundaries of the statistical analysis explicit.

A dataset may be technically complete while still omitting entire patient-information dimensions.

Therefore:

```text
Technical completeness
        ≠
Complete patient representation
```

---

# Representation Layers

The project defines four nested baseline patient representations.

These layers are used later in the representation sensitivity analysis.

## Layer 1 — Basic Demographic Representation

```text
age
sex
```

---

## Layer 2 — Demographics, Comorbidities and Risk Factors

```text
age
sex
anaemia
diabetes
high_blood_pressure
smoking
```

---

## Layer 3 — Expanded Clinical Representation

Layer 3 adds selected cardiac, renal, and biochemical information:

```text
ejection_fraction
serum_creatinine
serum_sodium
```

Complete Layer 3:

```text
age
sex
anaemia
diabetes
high_blood_pressure
smoking
ejection_fraction
serum_creatinine
serum_sodium
```

---

## Layer 4 — Full Available Baseline Representation

Layer 4 additionally includes:

```text
creatinine_phosphokinase
platelets
```

Complete Layer 4:

```text
age
sex
anaemia
diabetes
high_blood_pressure
smoking
ejection_fraction
serum_creatinine
serum_sodium
creatinine_phosphokinase
platelets
```

Layer 4 therefore represents the **full available baseline representation** used in the project.

Importantly:

```text
Full available representation
        ≠
Complete real-world patient
```

---

# Analysis Workflow

The scripts are intentionally sequential.

Each script has one primary analytical responsibility.

```text
01  Data Import and Setup
        ↓
02  Patient Representation and Data Quality
        ↓
03  Descriptive Statistics
        ↓
04  Data Visualization
        ↓
05  Descriptive Outcome Group Comparisons
        ↓
06  Formal Hypothesis Testing
        ↓
07  Exploratory Correlation Analysis
        ↓
08  Logistic Regression Analysis
        ↓
09  Representation Sensitivity Analysis
        ↓
10  Final Clinical and Decision Insights
```

The separation is deliberate.

Later analytical stages should not be performed prematurely in earlier scripts.

For example:

```text
03 describes
05 compares descriptively
06 tests formally
07 explores correlation
08 models mortality associations
09 changes the patient representation
10 integrates the evidence
```

---

# Statistical Workflow

## Data Quality

The project evaluates:

- expected variables
- variable classes
- missing values
- duplicate observations
- categorical coding
- non-finite values
- logically impossible numerical values
- constant variables
- unusual observations
- potential statistical outliers

Extreme observations are not automatically removed.

In clinical datasets, unusual measurements may represent genuine patients rather than data-entry errors.

---

## Descriptive Statistics

Continuous variables are summarized using:

- mean
- standard deviation
- median
- quartiles
- interquartile range
- minimum
- maximum

Categorical variables are summarized using:

- frequencies
- proportions
- percentages

---

## Data Visualization

`ggplot2` is used to explore:

- distributions
- skewness
- extreme values
- categorical composition
- mortality-group patterns
- selected continuous-variable relationships

Visual analysis complements rather than replaces statistical inference.

---

## Outcome Group Comparisons

Patients are compared according to:

```text
No death event
```

versus:

```text
Death event
```

Baseline variables and follow-up duration are treated separately.

The descriptive group-comparison stage does not perform formal hypothesis testing.

---

## Hypothesis Testing

Depending on variable structure and distribution, the project uses:

- Welch two-sample t-tests
- Wilcoxon rank-sum tests
- Pearson chi-squared tests
- Fisher's exact tests

Categorical association magnitude may additionally be described using:

```text
Cramér's V
```

---

## Multiple-Testing Adjustment

The project applies the **Benjamini-Hochberg procedure** to the primary family of mortality-group hypothesis tests.

Both values are retained:

```text
Raw p-value
Adjusted p-value
```

The adjusted results provide the primary group-level inferential evidence.

---

## Correlation Analysis

Continuous baseline characteristics are evaluated using:

```text
Spearman rank correlation
```

The analysis is primarily exploratory.

Correlation p-values are not used as the central inferential evidence of the project.

Correlation does not establish causality.

---

## Logistic Regression

Because `DEATH_EVENT` is binary, mortality associations are evaluated using logistic regression.

The project includes:

```text
Univariable logistic regression
```

and:

```text
Multivariable logistic regression
```

Results include:

- regression coefficients
- odds ratios
- 95% confidence intervals
- p-values

The multivariable model uses all available baseline patient characteristics.

`time` is not treated as a baseline predictor because it represents follow-up duration.

---

## Regression Diagnostics

The multivariable regression stage additionally considers:

- model convergence
- model sample size
- event count
- AIC
- residual deviance
- log-likelihood
- McFadden pseudo-R²
- in-sample Brier score
- Cook's distance
- leverage
- standardized deviance residuals

Diagnostic flags are used for inspection only.

They are not automatic patient-exclusion rules.

---

# Representation Sensitivity Analysis

The central methodological extension of the project evaluates how model outputs change when the digital patient representation changes.

The underlying patients remain the same.

Only the information available to the model changes.

Conceptually:

```text
Same Patients
        +
Different Digital Representation
        ↓
Different Statistical Model
        ↓
Potentially Different Statistical Evidence
```

The four representation layers are compared using measures such as:

- AIC
- residual deviance
- McFadden pseudo-R²
- Brier score
- likelihood-ratio comparisons
- coefficient stability
- patient-level predicted probabilities

The purpose is not to identify a universally optimal model.

Instead, the analysis evaluates **information dependence**.

---

# Patient-Level Probability Sensitivity

For the same patient, predicted probabilities from reduced representations can be compared with the full available baseline representation.

Conceptually:

```text
Reduced Representation
        ↓
Probability A
```

versus:

```text
Full Available Representation
        ↓
Probability B
```

The difference reflects how strongly the analytical output depends on the information available about that patient.

These probabilities are:

- in-sample model outputs
- not externally validated
- not clinical mortality-risk estimates
- not intended for treatment decisions

---

# Illustrative Reclassification

An illustrative threshold of:

```text
0.50
```

is used to examine whether reduced patient information can change a binary analytical model output.

The resulting categories are methodological only.

The threshold is not:

- a clinical cutoff
- a treatment threshold
- a triage threshold
- a validated risk threshold

Its purpose is to demonstrate:

```text
Same Patient
    +
Different Available Information
    ↓
Potentially Different Analytical Classification
```

---

# Information Loss Through Dichotomization

The project also examines what happens when a continuous clinical measurement is simplified.

Ejection fraction is used as the methodological example.

The comparison is:

```text
Continuous ejection fraction
```

versus:

```text
Median-based binary representation
```

The median cutoff is used only as an analytical demonstration.

It is not interpreted as a clinical ejection-fraction threshold.

The experiment examines whether reducing informational granularity changes:

- model fit
- patient-level probabilities
- analytical classifications

This illustrates a broader principle:

> **Operational simplification may reduce statistical information.**

---

# Outcome Representation

The primary mortality outcome is represented as:

```text
DEATH_EVENT
```

The dataset also contains:

```text
time
```

representing follow-up duration.

Together, these variables create a time-to-event structure.

The current primary analysis uses logistic regression and therefore evaluates:

> Was a death event recorded?

It does not explicitly model:

> When did the event occur?

A dedicated future survival-analysis extension could use methods such as:

- Kaplan-Meier estimation
- log-rank testing
- Cox proportional hazards regression

Survival analysis is not part of the current primary workflow.

---

# Key Findings

## Mortality Outcome

Among the 299 patients:

```text
203 had no recorded death event
96 experienced a recorded death event
```

The observed mortality proportion was approximately:

```text
32.1%
```

This describes the analyzed sample and should not be interpreted as a general population mortality estimate.

---

## Mortality Group Differences

After Benjamini-Hochberg adjustment, the clearest mortality-group differences were observed for:

- age
- ejection fraction
- serum creatinine
- serum sodium

---

## Age

Higher age was associated with higher mortality odds.

The adjusted odds ratio was approximately:

```text
OR = 1.06 per additional year
```

---

## Ejection Fraction

Higher ejection fraction was associated with lower mortality odds.

The adjusted odds ratio was approximately:

```text
OR = 0.93 per one-percentage-point increase
```

---

## Serum Creatinine

Higher serum creatinine was associated with higher mortality odds.

The adjusted odds ratio was approximately:

```text
OR = 1.94 per 1 mg/dL increase
```

---

## Serum Sodium

Lower serum sodium was associated with mortality in unadjusted analyses and showed a mortality-group difference after multiple-testing adjustment.

The association weakened after multivariable adjustment.

---

## Creatinine Phosphokinase

Creatinine phosphokinase reached statistical significance in the multivariable model.

Its per-unit odds ratio is close to `1.00`, making measurement scale important for interpretation.

---

# Main Statistical Pattern

Across several analytical stages, three patient characteristics showed particularly consistent statistical evidence:

| Patient Dimension | Digital Variable | Observed Pattern |
|---|---|---|
| Demographic vulnerability | Age | Higher age associated with higher mortality odds |
| Cardiac function | Ejection fraction | Lower ejection fraction associated with higher mortality odds |
| Renal status | Serum creatinine | Higher serum creatinine associated with higher mortality odds |

This consistency strengthens the internal statistical evidence within the dataset.

It does not imply:

- causality
- clinical sufficiency
- treatment relevance
- a ranking of clinical importance

---

# Decision Context

The project does not evaluate real healthcare-management decisions.

The dataset contains no direct variables describing:

- staffing allocation
- hospital capacity decisions
- treatment allocation
- resource-allocation strategies
- management interventions
- quality-improvement interventions

Instead, the analysis examines a prerequisite for data-driven decision support:

> **How reliable is the patient information on which a potential decision would be based?**

Possible future decision contexts include:

- population characterization
- healthcare demand estimation
- risk-oriented service planning
- capacity planning
- quality monitoring
- resource planning
- patient segmentation
- data-driven healthcare management

The current project does not prescribe decisions in these areas.

---

# Clinical Boundary

Statistical methods can evaluate:

- distributions
- differences
- associations
- uncertainty
- model fit
- representation sensitivity
- information loss
- consistency across methods

Statistical analysis alone cannot determine:

- which treatment should be selected
- whether a patient requires a specific intervention
- whether a statistical difference is clinically important
- whether an omitted variable is medically essential
- whether a management decision is medically appropriate
- whether a particular threshold should trigger clinical action

These questions require additional clinical evidence and expertise.

---

# Interpretation Principles

The project follows several consistent principles.

### 1. Association is not causation.

The dataset is observational.

### 2. Statistical significance is not clinical importance.

Effect magnitude, uncertainty, measurement scale, and context matter.

### 3. The dataset represents the patient; it is not the patient.

Unrecorded information remains unavailable to the statistical model.

### 4. Adjusted and unadjusted associations answer different questions.

Changes after adjustment are analytical findings rather than contradictions.

### 5. Measurement scale matters.

Odds ratios must be interpreted relative to the predictor unit.

### 6. Extreme observations are not automatically errors.

Clinically unusual values may represent real patients.

### 7. Information loss can matter.

Removing or simplifying patient information may change statistical output.

### 8. Statistical reliability is not clinical validity.

A statistically stable model may still be clinically incomplete.

---

# Limitations

Important limitations include:

- relatively small sample size (`n = 299`)
- observational study design
- possible unmeasured confounding
- incomplete representation of the real patient
- unavailable detailed medication information
- unavailable detailed treatment information
- unavailable structured symptom information
- unavailable patient-reported outcomes
- limited disease-severity information
- limited longitudinal clinical information
- unavailable socioeconomic context
- unavailable healthcare resource-use variables
- unavailable management interventions
- different follow-up durations
- binary mortality modeling does not explicitly model event timing
- no external model validation
- no causal inference
- no validated clinical prediction system
- no direct evaluation of real healthcare-management decisions

These limitations are part of the central research problem rather than merely technical caveats.

---

# Repository Structure

```text
heart-failure-clinical-statistical-analysis-with-R/
│
├── README.md
│
├── data/
│   └── heart_failure_clinical_records_dataset.csv
│
├── R/
│   ├── 01_data_import_and_setup.R
│   ├── 02_patient_representation_and_data_quality.R
│   ├── 03_descriptive_statistics.R
│   ├── 04_data_visualization.R
│   ├── 05_outcome_group_comparisons.R
│   ├── 06_hypothesis_testing.R
│   ├── 07_correlation_analysis.R
│   ├── 08_regression_analysis.R
│   ├── 09_representation_sensitivity_analysis.R
│   └── 10_final_clinical_and_decision_insights.R
│
└── docs/
    ├── healthcare_context.md
    ├── dataset_description.md
    ├── patient_representation.md
    ├── statistical_methods.md
    ├── decision_context.md
    └── insights_summary.md
```

---

# File Responsibilities

## `01_data_import_and_setup.R`

Responsible only for:

- importing the dataset
- initial structural inspection
- variable-type configuration
- factor labels
- definition of reusable variable groups

It prepares the analytical environment.

It does not perform data-quality analysis or statistical inference.

---

## `02_patient_representation_and_data_quality.R`

Responsible for:

- mapping available patient-information dimensions
- identifying representation gaps
- checking missing values
- checking duplicates
- validating variable classes
- validating categorical coding
- checking non-finite and logically invalid values
- identifying potential statistical outliers

This is the dedicated data-quality and representation-audit stage.

---

## `03_descriptive_statistics.R`

Responsible for:

- numerical descriptive statistics
- categorical frequencies
- proportions
- overall patient-population summaries

It does not compare mortality groups inferentially.

---

## `04_data_visualization.R`

Responsible for:

- distribution visualizations
- categorical visualizations
- selected mortality-group visualizations

It does not perform hypothesis testing.

---

## `05_outcome_group_comparisons.R`

Responsible for:

- descriptive comparison of baseline characteristics by mortality outcome
- categorical group summaries
- separate description of follow-up duration

It does not perform formal hypothesis tests.

---

## `06_hypothesis_testing.R`

Responsible for:

- formal mortality-group hypothesis tests
- appropriate continuous-variable tests
- categorical association tests
- categorical effect-size estimation
- Benjamini-Hochberg adjustment

This is the primary group-level inferential stage.

---

## `07_correlation_analysis.R`

Responsible for:

- exploratory Spearman correlation analysis
- correlation ranking
- selected relationship visualizations

It does not model mortality.

---

## `08_regression_analysis.R`

Responsible for:

- univariable logistic regression
- multivariable logistic regression
- odds ratios
- confidence intervals
- model-fit summaries
- basic influence diagnostics

This stage evaluates mortality associations conditional on the available baseline representation.

---

## `09_representation_sensitivity_analysis.R`

Responsible for:

- fitting the four patient-representation models
- comparing increasingly information-rich representations
- evaluating model-fit changes
- evaluating coefficient stability
- evaluating patient-level probability sensitivity
- illustrative reclassification
- information-loss analysis through dichotomization

This is the dedicated representation-sensitivity stage.

---

## `10_final_clinical_and_decision_insights.R`

Responsible for:

- integrating results from the previous analytical stages
- comparing evidence across methods
- summarizing representation sensitivity
- defining decision relevance
- defining clinical and methodological boundaries
- producing the final analytical synthesis

This is the only script responsible for the complete project-level interpretation.

---

# Documentation

The `docs/` directory contains deeper methodological and contextual material.

## `healthcare_context.md`

Explains the clinical meaning of the disease, variables, and outcome.

## `dataset_description.md`

Documents dataset provenance, structure, coding, and analytical characteristics.

## `patient_representation.md`

Explains which patient dimensions are digitally represented, how they are represented, and which important dimensions remain unavailable.

## `statistical_methods.md`

Documents the statistical methods, assumptions, interpretation principles, and methodological limitations.

## `decision_context.md`

Explains how statistical evidence may relate to healthcare decision support while separating statistical evidence from actual decision validity.

## `insights_summary.md`

Provides the extended final interpretation of the statistical findings, representation limitations, and broader research implications.

---

# Running the Analysis

Run the scripts sequentially from the repository root:

```text
01_data_import_and_setup.R
02_patient_representation_and_data_quality.R
03_descriptive_statistics.R
04_data_visualization.R
05_outcome_group_comparisons.R
06_hypothesis_testing.R
07_correlation_analysis.R
08_regression_analysis.R
09_representation_sensitivity_analysis.R
10_final_clinical_and_decision_insights.R
```

The dataset is imported using:

```text
data/heart_failure_clinical_records_dataset.csv
```

The visualization stages require:

```r
library(ggplot2)
```

Later scripts may use objects created by earlier scripts.

The workflow is therefore designed to be executed sequentially in one R session.

---

# Reusable Analytical Blueprint

The repository is intended to serve as a reusable framework for future analyses of digital patient data.

The dataset, disease, outcome, and statistical methods may change.

The underlying research logic remains:

```text
1. Define the patient population

2. Identify what is digitally represented

3. Identify important representation gaps

4. Validate technical data quality

5. Describe the patient population

6. Explore distributions and relationships

7. Compare relevant outcome groups

8. Test statistical associations

9. Build an appropriate multivariable model

10. Modify the patient representation

11. Evaluate representation sensitivity

12. Assess statistical reliability

13. Define potential decision implications

14. Define clinical and methodological limits
```

The reusable component is therefore not one specific statistical model.

It is the research logic:

```text
Patient
    ↓
Digital Representation
    ↓
Statistics
    ↓
Reliability
    ↓
Decision Implications
    ↓
Clinical Limits
```

---

# R Skills Demonstrated

The project demonstrates practical experience with:

- data import
- data-type configuration
- factor handling
- data-quality assessment
- missing-value checks
- duplicate checks
- plausibility checks
- descriptive statistics
- grouped summaries
- `ggplot2`
- Welch t-tests
- Wilcoxon rank-sum tests
- chi-squared tests
- Fisher's exact tests
- Cramér's V
- Benjamini-Hochberg adjustment
- Spearman correlation
- univariable logistic regression
- multivariable logistic regression
- odds-ratio interpretation
- confidence intervals
- model diagnostics
- model comparison
- representation sensitivity analysis
- patient-level probability comparison
- information-loss analysis
- healthcare-data interpretation

---

# Learning Approach and AI Usage

This project was intentionally developed as a hands-on learning environment for:

- R
- statistical analysis
- healthcare data
- analytical reasoning
- scientific interpretation

The R code, analytical workflow, project structure, and final statistical decisions were primarily developed and implemented by me.

AI was used as a **learning, review, and quality-improvement tool**.

Its role included:

- reviewing code
- reviewing statistical reasoning
- identifying potential weaknesses
- explaining alternative approaches
- suggesting alternative R implementations
- challenging interpretations
- improving code clarity
- improving documentation

Suggestions were evaluated before implementation.

The objective was not to automate the project, but to use AI as an interactive learning environment while retaining responsibility for the final analytical decisions and interpretation.

---

# Final Interpretation

The conventional statistical analysis identifies recurring mortality-related patterns involving:

```text
Higher age
Lower ejection fraction
Higher serum creatinine
```

Serum sodium also showed mortality-related evidence in unadjusted and group-level analyses, although the relationship weakened after multivariable adjustment.

These findings demonstrate how structured statistical analysis can identify interpretable patterns within digital clinical records.

The broader conclusion of the project extends beyond these individual associations.

Every statistical result is conditional on the digital representation from which it was generated.

The available dataset contains meaningful information about:

- demographics
- selected comorbidities
- cardiac function
- renal status
- laboratory measurements
- smoking
- follow-up
- mortality

but it does not contain a complete representation of the patient.

The central methodological principle is therefore:

> **A statistical model does not analyze the patient directly. It analyzes the available digital representation of the patient.**

Increasing statistical sophistication cannot automatically recover relevant patient information that was never recorded.

The reliability of data-driven healthcare conclusions therefore depends on:

```text
What was measured
How it was represented
What was omitted
How much information was simplified
How stable the resulting evidence remains
Which decision the evidence is intended to support
```

This leads to the broader research question underlying the project:

> **How clinically adequate must digital patient representations be for statistical models to provide reliable support for healthcare management and decision-making?**

The heart failure analysis represents the first implementation of this analytical framework.