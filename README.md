# Digital Patient Representation for Healthcare Decision-Making: Heart Failure

## Overview

This project presents a structured statistical analysis of digital clinical records from patients with heart failure using **R**.

It combines two connected objectives:

1. **Clinical statistical analysis**  
   Examine demographic characteristics, clinical measurements, mortality patterns, and statistical associations within the available patient data.

2. **Digital patient representation analysis**  
   Examine how statistical results change when the amount or structure of patient information available to the model changes.

The broader methodological question is:

> **How adequately can patients be represented through available digital health data, and how reliable are statistical conclusions and potential healthcare decisions when they are based on this representation?**

The dataset contains records from **299 patients with heart failure**, including demographic characteristics, comorbidities, laboratory measurements, cardiac function, follow-up duration, and a recorded mortality outcome.

The dataset is therefore treated as a **partial digital representation of real patients**, not as a complete description of their clinical state.

The analytical framework is:

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

The project is exploratory and explanatory.

It does not:

- establish causal relationships
- provide treatment recommendations
- define validated clinical thresholds
- evaluate real healthcare-management interventions
- provide externally validated mortality predictions
- represent a clinically validated prediction system

---

# Research Perspective

A statistical model does not analyze the complete real-world patient.

It analyzes the information that has been digitally recorded about that patient.

```text
Real Patient
    ≠
Digital Patient Representation
```

A real patient may contain substantially more clinical, physiological, therapeutic, behavioral, social, and contextual information than any individual dataset can capture.

The analytical process can therefore be conceptualized as:

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

The project distinguishes between:

> **Statistical reliability**  
> Whether a statistical result is methodologically supported and sufficiently stable within the available data.

and:

> **Clinical validity**  
> Whether the available information and resulting statistical evidence are sufficient and appropriate for interpretation in the real clinical context.

Therefore:

```text
Statistical reliability
        ≠
Clinical validity
```

A statistical model may perform coherently within the available dataset while clinically relevant patient information remains unavailable.

---

# Research Questions

The project addresses five connected areas.

## 1. Patient Representation

- Which dimensions of the patient are digitally represented?
- How are these dimensions encoded?
- Which potentially relevant patient dimensions are absent?
- At what level of granularity is patient information represented?

## 2. Statistical Description

- What are the main demographic and clinical characteristics of the observed population?
- How frequently did a recorded death event occur?
- How are the numerical and categorical patient characteristics distributed?

## 3. Statistical Associations

- Which characteristics differ between patients with and without a recorded death event?
- Which differences are statistically supported?
- Which characteristics are associated with mortality in logistic regression?
- Which associations remain after adjustment for the other available baseline characteristics?

## 4. Representation Sensitivity

- How do statistical models change when less patient information is available?
- How stable are regression coefficients across increasingly informative representations?
- How sensitive are patient-level model probabilities to information reduction?
- What happens when continuous patient information is simplified?

## 5. Decision and Clinical Interpretation

- What type of decision support could potentially use this form of evidence?
- Which conclusions remain unsupported by the available data?
- Which limitations arise from incomplete patient representation?
- Where does statistical interpretation end and additional clinical evidence become necessary?

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

During data setup, binary variables are converted into labelled factors where appropriate.

---

# Digital Patient Representation

## Representation Map

The dataset represents selected patient-information dimensions.

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

This map defines the informational boundary of the project.

A technically complete dataset can still omit entire dimensions of the real patient.

```text
Technical completeness
        ≠
Complete patient representation
```

---

# Representation Layers

Four nested baseline patient representations are defined for the representation sensitivity analysis.

## Layer 1 — Basic Demographic Representation

```text
age
sex
```

## Layer 2 — Demographics, Comorbidities and Risk Factors

```text
age
sex
anaemia
diabetes
high_blood_pressure
smoking
```

## Layer 3 — Expanded Clinical Representation

Layer 3 additionally includes:

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

The layers are nested:

```text
Layer 1 ⊂ Layer 2 ⊂ Layer 3 ⊂ Layer 4
```

Layer 4 represents the **full available baseline representation**.

It does not represent the complete real-world patient.

---

# Analysis Workflow

The scripts are intentionally sequential.

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

Each stage has a distinct responsibility:

```text
01 prepares
02 audits
03 describes
04 visualizes
05 compares descriptively
06 tests formally
07 explores correlation structure
08 models mortality associations
09 modifies patient representation
10 integrates the evidence
```

Later analytical stages are intentionally not performed prematurely in earlier scripts.

---

# Statistical Workflow

## Data Import and Setup

The setup stage:

- imports the dataset
- performs an initial structural inspection
- defines reusable variable groups
- converts numerical variables
- converts binary variables into labelled factors
- defines the follow-up and outcome variables

These definitions are reused throughout later scripts.

---

## Patient Representation and Data Quality

The dedicated audit stage evaluates:

- expected dataset structure
- variable classes
- categorical factor levels
- missing values
- duplicate rows
- non-finite numerical values
- basic logical validity
- constant variables
- potential numerical outliers
- represented patient-information dimensions
- representation gaps

Potential outliers are identified using the conventional:

```text
1.5 × IQR rule
```

They are flagged for inspection and are not automatically removed.

The representation audit is separate from technical data quality.

---

## Descriptive Statistics

The complete observed population is summarized before outcome-group inference.

Continuous variables are described using:

- number of available observations
- mean
- standard deviation
- median
- first quartile
- third quartile
- interquartile range
- minimum
- maximum

Categorical variables are described using:

- frequencies
- proportions
- percentages

Recorded mortality is also summarized descriptively.

---

## Data Visualization

`ggplot2` is used to visualize:

- numerical distributions through histograms
- numerical distributions through boxplots
- categorical distributions through bar charts
- baseline numerical characteristics by mortality outcome

The visualization stage is descriptive only.

It does not perform formal statistical testing.

Relationships between pairs of continuous baseline variables are examined separately in the correlation-analysis stage.

---

# Outcome Group Comparisons

Patients are compared descriptively according to:

```text
No death event
```

versus:

```text
Death event
```

For baseline numerical variables, the project summarizes each outcome group using:

- mean
- standard deviation
- median
- quartiles
- IQR
- minimum
- maximum

Mean and median differences are calculated as:

```text
Death event - No death event
```

These raw differences are interpreted only within each variable.

They are not ranked across variables with different measurement units.

Categorical baseline characteristics are summarized using counts and within-outcome-group percentages.

Follow-up duration is described separately because it represents observation time rather than baseline patient information.

No formal hypothesis testing occurs at this stage.

---

# Hypothesis Testing

Formal mortality-group inference is performed only after the descriptive comparison stage.

The project uses:

- Welch two-sample t-tests
- Wilcoxon rank-sum tests
- Pearson chi-squared tests
- Fisher's exact tests

In the current implementation:

```text
age
serum_sodium
```

are compared using Welch two-sample t-tests.

The remaining continuous baseline variables are evaluated using Wilcoxon rank-sum tests.

For categorical variables, Fisher's exact test is used when expected cell counts are too small for the chi-squared approximation.

Categorical association magnitude is additionally summarized using:

```text
Cramér's V
```

---

# Multiple-Testing Adjustment

All primary baseline mortality-group tests are treated as one multiple-testing family.

The project applies the **Benjamini-Hochberg procedure**.

For each test, the workflow retains:

```text
Raw p-value
BH-adjusted p-value
```

The BH-adjusted results provide the primary group-level inferential evidence.

Statistical decisions are made using unrounded numerical values.

Formatting and rounding occur only afterward.

---

# Correlation Analysis

The project evaluates pairwise relationships among continuous **baseline** patient characteristics using:

```text
Spearman rank correlation
```

Follow-up duration is excluded because it represents the observation process rather than baseline patient information.

For every pair, the analysis retains:

- complete-pair sample size
- Spearman's rho
- absolute correlation magnitude
- exploratory p-value

Correlations are ranked using the **unrounded absolute Spearman coefficient**.

The three strongest observed pairwise correlations are visualized automatically using scatterplots with LOESS smoothers.

The correlation analysis is exploratory.

Its p-values are not used as the project's primary inferential evidence.

Correlation magnitude is not interpreted as clinical importance or causality.

---

# Logistic Regression

Mortality associations are evaluated using binary logistic regression.

The regression stage uses all available baseline patient characteristics:

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
```

Follow-up duration is excluded because it is not a baseline patient characteristic.

---

## Univariable Regression

Each baseline characteristic is first evaluated separately.

The analysis reports:

- regression coefficient
- standard error
- odds ratio
- approximate 95% confidence interval
- p-value

These estimates represent unadjusted associations.

---

## Multivariable Regression

A full logistic regression model includes all available baseline patient characteristics simultaneously.

The analysis reports:

- adjusted regression coefficients
- standard errors
- adjusted odds ratios
- approximate 95% confidence intervals
- p-values

Adjusted associations remain conditional only on the variables represented in the dataset.

They do not establish causal effects.

---

# Regression Model Evaluation

The multivariable regression stage additionally evaluates:

- model convergence
- model sample size
- recorded death-event count
- null deviance
- residual deviance
- AIC
- log-likelihood
- McFadden pseudo-R²
- in-sample Brier score

These measures describe model behavior within the analyzed data.

They do not constitute external validation.

---

# Influence Diagnostics

Basic observation-level diagnostics include:

- Cook's distance
- leverage
- standardized deviance residuals

Descriptive screening thresholds are used to flag observations for inspection.

Diagnostic flags do not automatically identify invalid patients and are not used as automatic exclusion criteria.

---

# Representation Sensitivity Analysis

The central methodological extension evaluates how model outputs change when the digital representation of the same patient population changes.

A common complete-case sample is used across all four representation models.

This prevents representation comparisons from being confounded by different analytical samples.

Conceptually:

```text
Same Patients
        +
Different Available Information
        ↓
Different Statistical Model
        ↓
Potentially Different Statistical Evidence
```

---

## Representation Model Comparison

One logistic model is fitted for each representation layer.

The models are compared using:

- AIC
- residual deviance
- McFadden pseudo-R²
- in-sample Brier score

These measures describe in-sample behavior only.

---

## Sequential Information Addition

Nested likelihood-ratio tests compare:

```text
Layer 1 → Layer 2
Layer 2 → Layer 3
Layer 3 → Layer 4
```

The tests examine whether adding new patient-information domains improves statistical model fit.

They do not establish clinical necessity.

---

## Coefficient Stability

Regression coefficients and odds ratios are compared across the representation models.

Terms appearing in multiple models are summarized according to their observed coefficient and odds-ratio ranges.

This evaluates whether estimated associations change as additional patient information becomes available.

---

# Patient-Level Probability Sensitivity

Each representation model generates an in-sample probability for the same patients.

Reduced representations are compared with Layer 4 using:

- mean absolute probability difference
- root mean squared probability difference
- maximum absolute probability difference
- Spearman correlation of predicted probabilities

This evaluates how sensitive patient-level model output is to information reduction.

These probabilities are:

- in-sample
- not externally validated
- not clinical mortality-risk estimates
- not intended for treatment decisions

---

# Illustrative Reclassification

The project uses an illustrative probability threshold of:

```text
0.50
```

to examine whether changes in patient representation can alter a binary analytical classification.

Reduced representation models are compared with Layer 4.

The analysis reports:

- number of reclassified patients
- percentage of reclassified patients

The threshold has no clinical interpretation.

It is not:

- a treatment threshold
- a triage threshold
- a validated mortality threshold
- a management decision rule

Its purpose is methodological.

---

# Information Loss Through Dichotomization

The project additionally evaluates what happens when a continuous clinical variable is simplified.

Ejection fraction is compared in two forms:

```text
Continuous ejection fraction
```

versus:

```text
Median-based binary representation
```

The sample median is used only as a neutral methodological cutoff.

It is not a clinical threshold.

The continuous and dichotomized models are compared using:

- model-fit measures
- patient-level probability differences
- illustrative reclassification

This evaluates whether reducing informational granularity changes model output.

---

# Outcome Representation

The primary mortality outcome is:

```text
DEATH_EVENT
```

The dataset also contains:

```text
time
```

representing follow-up duration.

Together, mortality status and follow-up duration create a time-to-event structure.

The current project deliberately uses logistic regression to evaluate:

> Was a death event recorded?

It does not explicitly model:

> When did the event occur?

Survival-analysis methods such as:

- Kaplan-Meier estimation
- log-rank testing
- Cox proportional hazards regression

are therefore potential future extensions, not part of the current analytical workflow.

---

# Final Integration

The final script does not fit additional statistical models.

Instead, it integrates outputs generated during the previous analytical stages.

It summarizes:

- patient and mortality characteristics
- digital patient representation
- BH-adjusted group-level findings
- univariable regression evidence
- adjusted regression evidence
- cross-method consistency
- strongest exploratory correlations
- regression model behavior
- representation-model comparisons
- sequential representation additions
- patient-level probability sensitivity
- illustrative reclassification
- dichotomization effects
- supported and unsupported conclusions
- potential decision contexts
- clinical and methodological boundaries

The final synthesis therefore separates:

```text
What the data contain
        ↓
What the statistics support
        ↓
How representation affects the evidence
        ↓
What may be relevant for decision support
        ↓
What the project cannot establish
```

The final script expects the complete sequential analytical pipeline to have been executed beforehand.

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

This describes the analyzed sample and follow-up structure.

It is not a general population mortality estimate.

---

## Mortality Group Evidence

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

Lower serum sodium showed mortality-related evidence in group-level and unadjusted analyses.

The association weakened after multivariable adjustment.

---

## Creatinine Phosphokinase

Creatinine phosphokinase reached nominal statistical significance in the full multivariable logistic regression model.

Its per-unit odds ratio remains close to `1.00`, making measurement scale important for interpretation.

---

# Cross-Method Interpretation

The final synthesis compares three mortality-related analytical stages:

```text
BH-adjusted group testing
Univariable logistic regression
Multivariable logistic regression
```

A variable may therefore be described according to whether statistical support appears in:

- all three stages
- two stages
- one stage
- none of these stages

This represents **internal consistency across methods**.

It is not:

- a ranking of clinical importance
- causal evidence
- a treatment recommendation

---

# Decision Context

The dataset contains no directly observed:

- hospital staffing decisions
- capacity-allocation decisions
- healthcare resource-allocation interventions
- treatment-allocation strategies
- management interventions
- quality-improvement interventions

The project therefore does not evaluate actual healthcare-management decisions.

Instead, it examines a prerequisite for data-driven decision support:

> **How strongly does statistical evidence depend on the digital patient information from which it was generated?**

Potential future decision contexts include:

- population characterization
- risk-oriented service planning
- healthcare demand estimation
- capacity planning
- quality monitoring
- resource planning
- patient segmentation

These are potential applications only.

They are not evaluated or recommended by the current project.

---

# Clinical Boundary

The project can evaluate:

- observed distributions
- descriptive group differences
- formal statistical group differences
- associations
- uncertainty
- model fit
- correlation structure
- representation sensitivity
- information loss
- internal consistency across analytical methods

The project cannot determine:

- causal effects
- treatment appropriateness
- individualized treatment recommendations
- validated clinical thresholds
- whether a particular patient requires intervention
- whether an omitted variable is medically essential for every decision
- whether a healthcare-management decision is clinically appropriate
- whether model outputs improve patient outcomes

These questions require additional clinical evidence, study designs, patient information, and domain expertise.

---

# Interpretation Principles

The project follows several principles.

### 1. Association is not causation.

The dataset is observational.

### 2. Statistical significance is not clinical importance.

Effect magnitude, uncertainty, measurement scale, and context matter.

### 3. Digital data represent the patient; they are not the patient.

Unrecorded patient information cannot directly enter the model.

### 4. Adjusted and unadjusted associations answer different questions.

Changes after adjustment are analytical findings rather than contradictions.

### 5. Measurement scale matters.

Odds ratios must be interpreted relative to the unit of the predictor.

### 6. Extreme observations are not automatically errors.

Clinically unusual measurements may represent real patients.

### 7. Information loss can affect statistical output.

Removing or simplifying patient information may alter model behavior.

### 8. Statistical reliability and clinical validity are different.

A statistically coherent model may still be clinically incomplete.

### 9. In-sample model behavior is not external validation.

Model-fit statistics and probabilities are interpreted accordingly.

---

# Limitations

Important limitations include:

- relatively small sample size (`n = 299`)
- observational study design
- possible unmeasured confounding
- incomplete digital representation of the real patient
- unavailable detailed medication information
- unavailable detailed treatment information
- unavailable structured symptom information
- unavailable patient-reported outcomes
- limited disease-severity information
- limited longitudinal clinical information
- unavailable socioeconomic context
- unavailable healthcare resource-use information
- unavailable management interventions
- different follow-up durations
- binary mortality modeling does not explicitly model event timing
- continuous regression terms are not comprehensively modeled for nonlinearity
- no cross-validation or bootstrap validation
- no external validation
- no causal inference
- no validated clinical prediction system
- no direct evaluation of real healthcare-management decisions

These limitations define the scope of interpretation.

---

# Repository Structure

```text
digital-patient-representation-heart-failure/
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

Responsible for:

- dataset import
- initial structural inspection
- reusable variable groups
- numerical-variable configuration
- factor configuration
- outcome configuration

It prepares the shared analytical environment.

---

## `02_patient_representation_and_data_quality.R`

Responsible for:

- validating expected dataset structure
- validating variable classes
- validating categorical factor levels
- mapping patient-information dimensions
- identifying representation gaps
- checking missing values
- checking duplicate observations
- checking non-finite numerical values
- checking basic logical validity
- checking constant variables
- identifying potential IQR-based outliers

This is the dedicated representation and data-quality audit.

---

## `03_descriptive_statistics.R`

Responsible for:

- overall numerical summaries
- overall categorical summaries
- mortality-frequency summary

It describes the complete observed patient population.

---

## `04_data_visualization.R`

Responsible for:

- numerical histograms
- numerical boxplots
- categorical bar charts
- baseline numerical boxplots by mortality outcome

It is a descriptive visualization stage only.

---

## `05_outcome_group_comparisons.R`

Responsible for:

- descriptive mortality-group summaries
- numerical baseline comparisons
- descriptive mean and median differences
- categorical mortality-group summaries
- separate follow-up-duration summaries

It performs no formal hypothesis testing.

---

## `06_hypothesis_testing.R`

Responsible for:

- Welch two-sample t-tests
- Wilcoxon rank-sum tests
- Pearson chi-squared tests
- Fisher's exact tests
- Cramér's V
- Benjamini-Hochberg adjustment

This is the primary group-level inferential stage.

---

## `07_correlation_analysis.R`

Responsible for:

- pairwise Spearman correlations among continuous baseline variables
- ranking correlations by absolute magnitude
- correlation-matrix visualization
- visualization of the three strongest observed relationships

It is exploratory and does not model mortality.

---

## `08_regression_analysis.R`

Responsible for:

- univariable logistic regression
- full multivariable logistic regression
- odds ratios
- confidence intervals
- nominal regression significance
- model-fit summaries
- basic influence diagnostics

It evaluates mortality associations conditional on the available baseline representation.

---

## `09_representation_sensitivity_analysis.R`

Responsible for:

- four nested patient-representation models
- common-sample representation comparison
- model-fit comparison
- sequential likelihood-ratio tests
- coefficient stability
- patient-level probability sensitivity
- illustrative reclassification
- dichotomization of ejection fraction
- model and probability comparison after information simplification

This is the dedicated representation-sensitivity stage.

---

## `10_final_clinical_and_decision_insights.R`

Responsible for:

- integrating previously generated results
- summarizing BH-adjusted group evidence
- summarizing regression evidence
- comparing statistical support across methods
- summarizing exploratory correlations
- summarizing model behavior
- summarizing representation sensitivity
- defining supported and unsupported conclusions
- defining potential decision contexts
- defining clinical and methodological boundaries
- producing the final project-level synthesis

It does not fit new statistical models.

It expects the full sequential pipeline to have been executed.

---

# Documentation

The `docs/` directory contains extended supporting material.

## `healthcare_context.md`

Explains the clinical background of heart failure, the analyzed patient characteristics, and the recorded mortality outcome.

## `dataset_description.md`

Documents dataset provenance, structure, coding, and analytical characteristics.

## `patient_representation.md`

Explains which patient-information dimensions are represented digitally, how they are represented, and which dimensions remain unavailable.

## `statistical_methods.md`

Documents the statistical methods, assumptions, interpretation principles, and methodological limitations.

## `decision_context.md`

Explains how the statistical evidence may relate to healthcare decision support while separating statistical evidence from actual decision validity.

## `insights_summary.md`

Provides an extended synthesis of the statistical findings, representation limitations, and broader implications.

---

# Running the Analysis

The project is designed to be executed sequentially from the repository root in **one R session**:

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

The dataset is imported from:

```text
data/heart_failure_clinical_records_dataset.csv
```

Visualization stages require:

```r
library(ggplot2)
```

Earlier scripts intentionally create reusable objects consumed by later stages.

For this reason, later scripts should not normally be executed in isolation.

---

# Reusable Analytical Blueprint

The repository is intended to provide a reusable structure for future digital-patient-data projects.

The disease, variables, outcome, and specific statistical methods may change.

The analytical logic remains:

```text
1. Import and configure the data

2. Define what aspects of the patient are digitally represented

3. Identify representation gaps

4. Evaluate technical data quality

5. Describe the observed population

6. Visualize the data

7. Compare relevant outcome groups descriptively

8. Perform formal statistical inference

9. Explore relationships among patient characteristics

10. Model the outcome using available patient information

11. Modify the digital patient representation

12. Evaluate representation sensitivity

13. Assess statistical reliability

14. Define potential decision relevance

15. Define clinical and methodological boundaries
```

The reusable component is not one particular regression model.

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

- CSV data import
- reusable variable grouping
- numerical type conversion
- factor handling
- structural data validation
- missing-value assessment
- duplicate detection
- plausibility checks
- IQR-based outlier detection
- descriptive statistics
- grouped summaries
- `ggplot2`
- functional plot generation
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
- AIC
- log-likelihood
- McFadden pseudo-R²
- Brier score
- Cook's distance
- leverage
- standardized deviance residuals
- nested likelihood-ratio testing
- model comparison
- coefficient-stability analysis
- patient-level probability comparison
- illustrative reclassification
- information-loss analysis
- statistical and healthcare-data interpretation

---

# Learning Approach and AI Usage

This project was developed as a hands-on learning environment for:

- R
- statistical analysis
- healthcare data
- analytical reasoning
- scientific interpretation

The R code, analytical workflow, project structure, and final analytical decisions were primarily developed and implemented by me.

AI was used as a **learning, review, and quality-improvement tool**.

Its role included:

- reviewing code
- reviewing statistical reasoning
- identifying potential weaknesses
- explaining alternative methods
- suggesting alternative R implementations
- challenging interpretations
- improving code clarity
- improving documentation

Suggestions were evaluated before implementation.

The objective was not to automate the project, but to use AI as an interactive learning environment while retaining responsibility for the final implementation and interpretation.

---

# Final Interpretation

The conventional statistical analysis identifies recurring mortality-related evidence involving:

```text
Higher age
Lower ejection fraction
Higher serum creatinine
```

Serum sodium also shows mortality-related evidence at the group and unadjusted levels, although its association weakens after multivariable adjustment.

These findings demonstrate how structured statistical analysis can identify interpretable patterns within digital clinical records.

The broader methodological conclusion extends beyond individual mortality associations.

Every statistical result is conditional on the patient information from which it was generated.

The dataset contains meaningful information about:

- demographics
- selected comorbidities
- cardiac function
- renal status
- laboratory measurements
- smoking
- follow-up
- mortality

but it does not contain a complete representation of the real patient.

The central principle of the project is therefore:

> **A statistical model does not analyze the patient directly. It analyzes the available digital representation of the patient.**

The representation sensitivity analysis operationalizes this principle by holding the patient population constant while changing the amount or granularity of information supplied to the model.

The resulting model behavior can therefore be examined in terms of:

```text
Model fit
Coefficient stability
Patient-level probabilities
Illustrative classifications
Information loss
```

Increasing statistical sophistication cannot automatically recover patient information that was never recorded.

The reliability of data-driven healthcare evidence therefore depends on:

```text
What was measured
How it was represented
What was omitted
How much information was simplified
How stable the resulting evidence remains
Which decision the evidence is intended to support
```

This leads to the broader research perspective:

> **How clinically adequate must digital patient representations be for statistical models to provide reliable support for healthcare management and decision-making?**

The heart failure analysis represents the first implementation of this analytical framework.