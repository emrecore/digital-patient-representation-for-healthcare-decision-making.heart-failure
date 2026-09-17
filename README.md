# Representation Sensitivity Analysis in Heart Failure with R

## Overview

This project investigates how statistical results derived from healthcare data depend not only on the statistical method used, but also on **how the patient is digitally represented in the available data**.

Using the **Heart Failure Clinical Records** dataset and R, the project combines conventional statistical analysis with a dedicated **representation sensitivity analysis**.

The central methodological idea is:

> **Statistical models do not analyze the real patient directly. They analyze the patient information that has been digitally captured and made available to the model.**

The project therefore asks:

> **How sensitive are statistical model outputs to changes in the amount and granularity of patient information available to the model?**

The analysis uses records from **299 patients with heart failure** and evaluates the same underlying patient sample under different analytically defined representations.

The project is exploratory, methodological, and educational. It is not intended to produce a clinically validated prediction system.

---

## Project Context

This repository is an **independent student-led analytical project** developed as part of my ongoing training in:

* R
* statistics
* healthcare analytics
* digital patient representation
* analytical reasoning
* scientific interpretation

It is intended as a reproducible learning and research-oriented portfolio project.

The repository should **not** be interpreted as:

* a peer-reviewed clinical study
* a validated mortality-prediction model
* a clinical decision-support system
* a treatment recommendation
* evidence of causal effects
* an evaluation of actual healthcare-management decisions

Methodological decisions, assumptions, limitations, and interpretation boundaries are documented explicitly throughout the repository.

---

# Research Perspective

A patient contains more information than any individual healthcare dataset can represent.

Clinical, physiological, therapeutic, behavioral, functional, social, and contextual characteristics may all contribute to the real patient state.

A statistical model, however, can only use information that has entered the digital representation.

```text
Patient Reality
      ↓
Digital Patient Representation
      ↓
Statistical Model
      ↓
Statistical Output
      ↓
Statistical Evidence
      ↓
Potential Decision Support
```

The digital representation is therefore an analytical boundary.

Information that is absent from the dataset cannot directly enter the model.

Information that is simplified may enter the model with reduced granularity.

For this reason:

```text
Technically complete data
          ≠
Complete patient representation
```

and:

```text
Statistically coherent output
          ≠
Clinically sufficient evidence
```

The project does not attempt to create a complete digital copy of a patient.

Instead, it examines how analytical conclusions may depend on **which patient information is available and how that information is represented**.

---

# Core Concepts

## Technical Data Quality

Technical data quality concerns the information that is already present in the dataset.

Examples include:

* expected variables
* valid data types
* valid categorical coding
* missing values
* exact duplicate rows
* non-finite numerical values
* logically implausible values
* constant variables
* potential numerical outliers

A dataset may perform well on these checks while still containing only a limited representation of the patient.

---

## Patient Representation

Patient representation concerns **what information about the patient is available to the analysis and at what level of detail**.

Examples include:

* demographics
* comorbidities
* cardiac measurements
* laboratory measurements
* symptoms
* functional status
* medications
* treatment history
* patient-reported outcomes
* socioeconomic characteristics

These are conceptually different questions from technical data quality.

> **Technical data quality evaluates the quality of the information that is present. Patient-representation assessment evaluates what patient information is present, absent, or simplified.**

---

## Representation Limitations

This project qualitatively documents limitations of the available patient representation.

Examples include:

* patient dimensions that are not recorded
* patient dimensions represented only indirectly
* information captured with limited detail
* continuous information reduced to a coarser form
* absence of longitudinal trajectories

The classifications used in this repository are **project-defined qualitative descriptors**.

They are not:

* validated representation-quality scores
* clinical adequacy ratings
* formal measurements of patient completeness
* validated measures of a representation gap

---

## Representation Gap

A **representation gap** can conceptually describe a difference between patient information relevant to an analytical or healthcare question and the patient information actually represented in the available data.

This repository does **not** estimate a validated representation-gap metric.

Instead, it provides two foundations for studying the broader problem:

1. qualitative identification of representation limitations
2. quantitative evaluation of **representation sensitivity**

This distinction is intentional.

---

## Representation Sensitivity

In this project:

> **Representation sensitivity refers to changes in statistical model outputs that occur when the amount or granularity of patient information supplied to the model changes while the underlying analytical patient sample is held constant.**

The core comparison is:

```text
Same Patients
      +
Different Available Information
      ↓
Different Digital Representation
      ↓
Statistical Model
      ↓
Potentially Different Statistical Output
```

Representation sensitivity does not determine which representation is clinically correct.

It only evaluates whether analytical outputs are sensitive to changes in the representation supplied to the model.

---

# Research Questions

The project addresses four connected areas.

## 1. Digital Patient Representation

* Which patient-information dimensions are represented in the dataset?
* Which relevant dimensions are absent or only partially represented?
* At what level of granularity is patient information available?
* How should technical data quality be distinguished from representation limitations?

## 2. Statistical Analysis

* What are the main characteristics of the observed patient sample?
* Which characteristics differ between patients with and without a recorded death event during observed follow-up?
* Which baseline characteristics show statistical associations with the binary recorded death-event outcome?
* How do unadjusted and multivariable associations differ?

## 3. Representation Sensitivity

* How does model behavior change when the amount of available patient information changes?
* How stable are regression coefficients across nested representations?
* How sensitive are patient-level fitted probabilities to information reduction?
* What happens when a continuous patient characteristic is represented in a simplified binary form?

## 4. Interpretation Boundaries

* Which conclusions are supported by the available data?
* Which conclusions remain outside the scope of the project?
* How should statistical findings be separated from clinical or decision-level claims?
* How might representation limitations matter when statistical evidence is later used for decision support?

---

# Dataset

The project uses the **Heart Failure Clinical Records** dataset from the UCI Machine Learning Repository.

The analytical dataset contains:

* **299 patients**
* **11 baseline explanatory variables**
* **1 follow-up-duration variable**
* **1 binary recorded death-event outcome**
* **no documented missing values in the UCI version**

Each row represents one patient record.

The data originate from a clinical cohort of patients with heart failure described by Ahmad et al. and were later made available through the UCI Machine Learning Repository.

The original clinical study included patients with left ventricular systolic dysfunction and advanced heart-failure severity and followed patients for varying lengths of time.

The UCI dataset is distributed under:

```text
Creative Commons Attribution 4.0 International
CC BY 4.0
```

Dataset DOI:

```text
10.24432/C5Z89R
```

---

# Variable Structure

## Baseline Numerical Variables

| Variable                   | Unit             | Description                        |
| -------------------------- | ---------------- | ---------------------------------- |
| `age`                      | years            | Age                                |
| `creatinine_phosphokinase` | mcg/L            | Blood CPK concentration            |
| `ejection_fraction`        | %                | Left-ventricular ejection fraction |
| `platelets`                | kiloplatelets/mL | Platelet concentration             |
| `serum_creatinine`         | mg/dL            | Serum creatinine                   |
| `serum_sodium`             | mEq/L            | Serum sodium                       |

## Baseline Categorical Variables

| Variable              | Coding | Description                  |
| --------------------- | ------ | ---------------------------- |
| `anaemia`             | 0 / 1  | Recorded anaemia status      |
| `diabetes`            | 0 / 1  | Recorded diabetes status     |
| `high_blood_pressure` | 0 / 1  | Recorded hypertension status |
| `sex`                 | 0 / 1  | Sex recorded in the dataset  |
| `smoking`             | 0 / 1  | Recorded smoking status      |

## Observation Information

| Variable | Unit | Description                 |
| -------- | ---- | --------------------------- |
| `time`   | days | Observed follow-up duration |

## Outcome

| Variable      | Coding | Description                                                             |
| ------------- | ------ | ----------------------------------------------------------------------- |
| `DEATH_EVENT` | 0 / 1  | Whether a death event was recorded during the observed follow-up period |

This separation is important.

`time` is **observation information**, not a baseline patient characteristic.

`DEATH_EVENT` is an **outcome**, not a patient-representation dimension.

---

# Available Digital Patient Representation

The available baseline variables capture selected aspects of the patient.

The following map is a **qualitative project-level description**, not a validated clinical scoring system.

| Patient-Information Domain         | Representation in Dataset | Available Information                                   |
| ---------------------------------- | ------------------------- | ------------------------------------------------------- |
| Demographics                       | Partial                   | Age, sex                                                |
| Cardiac function                   | Partial                   | Ejection fraction                                       |
| Renal information                  | Partial                   | Serum creatinine                                        |
| Hematological information          | Partial                   | Anaemia, platelets                                      |
| Other laboratory information       | Partial                   | Serum sodium, CPK                                       |
| Selected comorbidities             | Partial                   | Anaemia, diabetes, hypertension                         |
| Behavioral information             | Very limited              | Smoking status                                          |
| Detailed symptom burden            | Not represented           | No structured symptom measurements                      |
| Functional status                  | Not represented           | No structured functional assessment                     |
| Detailed medication information    | Not represented           | No medication variables                                 |
| Detailed treatment information     | Not represented           | No treatment variables                                  |
| Patient-reported outcomes          | Not represented           | No quality-of-life or patient-reported symptom measures |
| Socioeconomic context              | Not represented           | No socioeconomic variables                              |
| Longitudinal clinical trajectories | Not represented           | No repeated clinical measurements                       |

The purpose of this map is to define the **informational boundary of the analysis**.

A label such as `Partial` does not mean that the represented information is clinically inadequate.

Similarly, `Not represented` does not imply that the missing information would necessarily be required for every analytical question.

The relevance of any representation limitation depends on the question being investigated.

---

# Representation Layers

The representation-sensitivity analysis uses four **nested, project-defined baseline representations**.

These layers are analytical constructions.

They are not:

* validated clinical representation levels
* rankings of clinical importance
* measurements of patient completeness
* a progression toward a true or complete patient representation

Their purpose is to create controlled differences in the amount of information available to the statistical model.

## Layer 1 — Basic Demographic Representation

```text
age
sex
```

## Layer 2 — Demographics, Comorbidities and Risk Factors

Layer 1 plus:

```text
anaemia
diabetes
high_blood_pressure
smoking
```

## Layer 3 — Expanded Clinical Representation

Layer 2 plus:

```text
ejection_fraction
serum_creatinine
serum_sodium
```

## Layer 4 — Full Available Baseline Representation

Layer 3 plus:

```text
creatinine_phosphokinase
platelets
```

The layers are nested:

```text
Layer 1 ⊂ Layer 2 ⊂ Layer 3 ⊂ Layer 4
```

Layer 4 contains all baseline variables available in this dataset.

> **Layer 4 is the full available baseline representation within this dataset. It is not the complete real-world patient and is not treated as a clinical ground truth.**

---

# Analytical Workflow

The project follows a deliberately sequential workflow.

```text
01  Data Import and Setup
        ↓
02  Patient Representation and Data Quality
        ↓
03  Descriptive Statistics
        ↓
04  Data Visualization
        ↓
05  Descriptive Outcome-Group Comparisons
        ↓
06  Formal Hypothesis Testing
        ↓
07  Exploratory Correlation Analysis
        ↓
08  Logistic Regression Analysis
        ↓
09  Representation Sensitivity Analysis
        ↓
10  Final Synthesis and Interpretation
```

Each stage has a distinct role:

| Stage | Primary Purpose                                                      |
| ----- | -------------------------------------------------------------------- |
| `01`  | Import, validate source coding, and configure the analytical dataset |
| `02`  | Audit technical data quality and map patient representation          |
| `03`  | Describe the complete observed sample                                |
| `04`  | Visualize distributions and outcome-group patterns                   |
| `05`  | Compare outcome groups descriptively                                 |
| `06`  | Perform formal group-level inference                                 |
| `07`  | Explore correlation structure                                        |
| `08`  | Estimate binary-outcome associations using logistic regression       |
| `09`  | Evaluate sensitivity to changes in patient representation            |
| `10`  | Integrate previous outputs without fitting new models                |

Later analytical stages are intentionally not performed prematurely in earlier scripts.

---

# Statistical Methods

## Data Quality

The technical data-quality audit evaluates:

* expected dataset structure
* source coding
* variable classes
* categorical levels
* missing values
* exact duplicate rows
* non-finite numerical values
* basic logical plausibility
* constant variables
* potential numerical outliers

Potential numerical outliers are identified using the conventional:

```text
1.5 × IQR rule
```

They are flagged for inspection rather than automatically removed.

Exact duplicate rows are treated as duplicate **records**, not automatically as proven duplicate patients, because the dataset does not contain a unique patient identifier.

---

## Descriptive Statistics

Numerical variables are summarized using:

* number of observations
* mean
* standard deviation
* median
* first quartile
* third quartile
* interquartile range
* minimum
* maximum

Categorical variables are summarized using:

* counts
* proportions
* percentages

Statistical calculations use unrounded values.

Rounding is applied only for presentation.

---

## Data Visualization

`ggplot2` is used for descriptive visualization of:

* numerical distributions
* numerical outliers and spread
* categorical distributions
* baseline numerical characteristics by recorded death-event status

Visualization is descriptive and does not replace formal inference.

---

## Outcome-Group Comparisons

Patients are compared according to whether a death event was recorded during their observed follow-up.

The groups are:

```text
No recorded death event
Death event recorded
```

Baseline numerical characteristics are summarized separately for both groups.

Categorical characteristics are compared using counts and within-group proportions.

Follow-up duration is summarized separately because it is an observation-time variable rather than a baseline patient characteristic.

---

## Hypothesis Testing

Formal group-level inference uses:

* Welch two-sample t-tests
* Wilcoxon rank-sum tests
* Pearson chi-squared tests
* Fisher's exact tests

Cramér's V is calculated for categorical comparisons where appropriate.

The primary family of baseline group-comparison p-values is adjusted using the:

```text
Benjamini-Hochberg procedure
```

to limit false-discovery inflation across multiple comparisons.

Test selection and interpretation remain exploratory and dataset-specific.

---

## Correlation Analysis

Relationships among continuous baseline characteristics are explored using:

```text
Spearman rank correlation
```

The analysis is exploratory.

Observed correlations do not establish:

* causality
* clinical relevance
* prognostic importance

---

# Logistic Regression

Binary logistic regression is used to explore associations between available baseline patient characteristics and:

```text
DEATH_EVENT
```

The project includes:

* univariable logistic regression
* a full multivariable logistic regression model
* regression coefficients
* odds ratios
* approximate 95% confidence intervals
* nominal regression p-values
* model-fit summaries
* basic influence diagnostics

Adjusted associations are conditional on the information represented in the dataset.

They do not establish causal effects.

---

## Model Evaluation

The full logistic model is described using:

* convergence status
* analytical sample size
* number of recorded death events
* null deviance
* residual deviance
* AIC
* log-likelihood
* McFadden pseudo-R²
* in-sample Brier score

These quantities describe **in-sample model behavior**.

They do not constitute:

* cross-validation
* external validation
* clinical validation
* evidence of real-world predictive performance

---

## Influence Diagnostics

Basic observation-level diagnostics include:

* Cook's distance
* leverage
* standardized deviance residuals

Diagnostic thresholds are used as screening tools only.

Flagged observations are not automatically interpreted as erroneous and are not automatically excluded.

---

# Outcome and Follow-Up Structure

A major methodological limitation of this project is the relationship between:

```text
DEATH_EVENT
```

and:

```text
time
```

The dataset contains variable follow-up duration.

The original clinical study therefore has an underlying **time-to-event structure** and analyzed survival using methods such as Kaplan-Meier estimation and Cox regression.

The current project deliberately uses logistic regression as an **illustrative binary-outcome framework** for the representation-sensitivity analysis.

It evaluates:

> **Was a death event recorded during the observed follow-up period?**

It does not explicitly model:

> **When did the event occur?**

For this reason, fitted probabilities from the logistic models must not be interpreted as validated fixed-horizon mortality risks.

Methods such as:

* Kaplan-Meier estimation
* log-rank testing
* Cox proportional hazards regression

remain outside the current v1.0 analytical workflow.

---

# Representation Sensitivity Analysis

The central methodological extension of the project examines whether statistical output changes when the representation supplied to the model changes.

A **common analytical sample** is used across the four nested representation models.

This is essential because it separates two possible sources of change:

```text
Different Patients
```

from:

```text
Different Information About the Same Patients
```

The representation comparison is designed around the second case.

---

## Representation-Model Comparison

One logistic regression model is fitted for each representation layer.

The models are compared using:

* AIC
* residual deviance
* McFadden pseudo-R²
* in-sample Brier score

These are descriptive model-comparison measures within the analyzed sample.

A richer representation is not automatically interpreted as clinically superior.

---

## Sequential Information Addition

Because the four representation models are nested, likelihood-ratio tests compare:

```text
Layer 1 → Layer 2
Layer 2 → Layer 3
Layer 3 → Layer 4
```

These comparisons evaluate whether adding the specified blocks of information changes model fit.

They do not establish that the added information is clinically necessary.

---

## Coefficient Stability

Terms shared across multiple representation models are compared across layers.

This evaluates whether estimated associations change when additional patient information becomes available to the model.

Observed coefficient changes may reflect changes in:

* adjustment structure
* correlations among predictors
* available information
* model specification

They are not interpreted as causal effects.

---

## Patient-Level Fitted-Probability Sensitivity

Each representation model generates **in-sample fitted probabilities** for the same analytical patients.

Reduced representations are compared with Layer 4 using:

* mean absolute probability difference
* root mean squared probability difference
* maximum absolute probability difference
* Spearman correlation between fitted probabilities

Layer 4 is used as an analytical comparison reference because it contains the full available baseline variable set.

It is **not** treated as ground truth.

Therefore, these quantities measure:

> **output sensitivity to information reduction**

rather than prediction error relative to a clinically correct representation.

---

## Illustrative Reclassification

An illustrative threshold of:

```text
0.50
```

is used to examine whether representation changes can alter a binary model classification.

The threshold is purely methodological.

It is not:

* a clinical threshold
* a treatment threshold
* a triage threshold
* a management threshold
* a validated risk threshold

The analysis is included only to demonstrate that changes in representation can, under a fixed analytical rule, alter downstream classifications.

---

# Information Simplification: Ejection Fraction

Representation sensitivity is not limited to the complete absence of variables.

Information can also be simplified.

The project therefore compares ejection fraction represented as:

```text
Continuous ejection fraction
```

with:

```text
Median-based binary ejection-fraction representation
```

The sample median is used as an **arbitrary, non-clinical methodological cutoff**.

It is not interpreted as a medically validated threshold.

The comparison evaluates whether reducing the granularity of an available patient characteristic changes:

* model fit
* regression output
* patient-level fitted probabilities
* illustrative classifications

This analysis demonstrates the distinction between:

```text
Information absent
```

and:

```text
Information present but simplified
```

---

# Key Analytical Findings

The primary value of this project is methodological rather than clinical.

## Observed Outcome

Among the 299 patient records:

```text
203  no recorded death event
96   recorded death event
```

The observed proportion of recorded death events is approximately:

```text
32.1%
```

This is a property of the analyzed sample and its follow-up structure.

It is not a population-level heart-failure mortality estimate.

---

## Group-Level Statistical Evidence

After Benjamini-Hochberg adjustment, the clearest baseline differences between the recorded death-event groups were observed for:

* age
* ejection fraction
* serum creatinine
* serum sodium

These are sample-specific statistical findings.

They are not interpreted as causal effects or clinical decision rules.

---

## Representation Sensitivity

The representation analysis shows that model behavior is not independent of the patient information supplied to the model.

Across the nested representations, changes can be observed in:

* model fit
* estimated coefficients
* odds ratios
* patient-level fitted probabilities

The ejection-fraction experiment further illustrates that reducing the granularity of an available clinical measurement can alter statistical output.

The central methodological observation is therefore:

> **The same patients can generate different statistical outputs when the information used to represent those patients changes.**

This does not demonstrate that one representation is universally correct.

It demonstrates that statistical evidence can be **representation-sensitive**.

Detailed numerical results are generated by the analytical scripts and summarized in `docs/insights_summary.md`.

---

# Interpretation Principles

The project follows several explicit interpretation boundaries.

### 1. Association is not causation

The underlying data are observational.

Statistical associations do not establish causal effects.

### 2. Statistical significance is not clinical importance

P-values alone do not establish medical relevance.

Effect magnitude, uncertainty, measurement scale, context, and study design also matter.

### 3. Digital patient data are representations

The dataset does not contain the complete real-world patient.

Unrecorded information cannot directly enter the statistical model.

### 4. More variables do not automatically mean a better clinical representation

Additional information may improve statistical model fit without proving improved clinical or decision relevance.

### 5. Layer 4 is not ground truth

Layer 4 contains the full available baseline variable set in this dataset.

It is not a complete representation of the patient.

### 6. Representation sensitivity is not representation validity

Sensitivity to representation changes demonstrates dependence of model output on representation.

It does not identify which representation is clinically optimal.

### 7. In-sample model behavior is not external validation

Model-fit statistics and fitted probabilities describe the analyzed sample.

They do not establish generalizable predictive performance.

### 8. Binary mortality modeling does not replace survival analysis

Variable follow-up duration creates a time-to-event structure that is not fully modeled by logistic regression.

### 9. Statistical evidence is not decision validity

A statistically coherent result does not automatically support a clinically or managerially valid healthcare decision.

---

# What the Project Can and Cannot Establish

## The Project Can Evaluate

* technical characteristics of the available data
* observed patient characteristics
* descriptive outcome-group differences
* formal group-level statistical differences
* exploratory correlations
* unadjusted statistical associations
* adjusted statistical associations within the available representation
* in-sample model behavior
* influence diagnostics
* representation sensitivity
* output sensitivity to information reduction
* output sensitivity to information simplification

## The Project Cannot Establish

* causal effects
* individual treatment effects
* treatment appropriateness
* individualized treatment recommendations
* validated clinical thresholds
* validated mortality-risk predictions
* complete clinical adequacy of a representation
* whether an omitted variable is necessary for every healthcare question
* whether a healthcare-management decision is valid
* whether use of the model improves patient outcomes

---

# Decision-Support Perspective

The dataset does not directly contain healthcare-management actions such as:

* resource-allocation decisions
* capacity decisions
* staffing interventions
* treatment-allocation decisions
* quality-improvement interventions

The project therefore does **not** evaluate these decisions.

Its relevance to data-driven decision support is more fundamental:

> **Statistical evidence used for decision support is generated from the digital patient representation available to the model.**

If model outputs are sensitive to that representation, the representation itself becomes relevant when interpreting the evidence.

The project therefore examines a prerequisite for responsible data-driven decision support rather than validating any particular decision.

---

# Limitations

Important limitations include:

* relatively small sample size (`n = 299`)
* observational data
* potential unmeasured confounding
* incomplete digital patient representation
* project-defined rather than clinically validated representation layers
* no validated representation-quality or representation-gap metric
* unavailable detailed medication information
* unavailable detailed treatment information
* unavailable structured symptom information
* unavailable functional-status information
* unavailable patient-reported outcomes
* unavailable socioeconomic information
* limited longitudinal information
* variable follow-up duration
* logistic regression does not explicitly model event timing or censoring
* no comprehensive modeling of nonlinear continuous effects
* no internal resampling validation in the current workflow
* no external validation
* no causal inference
* no validated clinical prediction model
* no evaluation of actual healthcare-management decisions

These limitations define the intended scope of the project rather than being treated as problems that the current analysis has solved.

---

# Repository Structure

```text
representation-sensitivity-analysis-in-heart-failure-with-r/
│
├── README.md
│
├── LICENSE
├── CITATION.cff
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
│   └── 10_final_synthesis_and_interpretation.R
│
└── docs/
    ├── healthcare_context.md
    ├── dataset_description.md
    ├── patient_representation.md
    ├── statistical_methods.md
    ├── decision_context.md
    └── insights_summary.md
```

`LICENSE` and `CITATION.cff` are included as part of the v1.0 release preparation.

---

# Documentation

The `docs/` directory provides extended documentation that is intentionally kept outside the main README.

## `healthcare_context.md`

Provides concise clinical context for heart failure and the analyzed variables.

## `dataset_description.md`

Documents:

* dataset origin
* cohort context
* variable structure
* coding
* follow-up structure
* outcome structure
* dataset licensing

## `patient_representation.md`

Documents:

* represented patient-information domains
* unavailable patient-information domains
* distinction between technical completeness and patient representation
* interpretation of representation limitations
* representation-layer design

## `statistical_methods.md`

Documents:

* descriptive methods
* inferential methods
* regression methods
* model evaluation
* representation-sensitivity methods
* statistical assumptions
* interpretation boundaries

## `decision_context.md`

Separates:

* statistical evidence
* patient representation
* potential decision-support relevance
* actual decision validity

## `insights_summary.md`

Provides an extended synthesis of:

* analytical findings
* representation sensitivity
* methodological interpretation
* supported and unsupported conclusions

The README provides the project-level overview.

The `docs/` files contain the detailed supporting explanation.

---

# Running the Analysis

The analytical workflow is designed to be executed from the repository root in a single R session.

Run the scripts sequentially:

```r
source("R/01_data_import_and_setup.R")
source("R/02_patient_representation_and_data_quality.R")
source("R/03_descriptive_statistics.R")
source("R/04_data_visualization.R")
source("R/05_outcome_group_comparisons.R")
source("R/06_hypothesis_testing.R")
source("R/07_correlation_analysis.R")
source("R/08_regression_analysis.R")
source("R/09_representation_sensitivity_analysis.R")
source("R/10_final_synthesis_and_interpretation.R")
```

The dataset is read from:

```text
data/heart_failure_clinical_records_dataset.csv
```

Later scripts use objects created by earlier stages.

They should therefore normally be executed in sequence rather than independently.

---

# Software and Reproducibility

The project is implemented in **R**.

The workflow primarily uses:

* base R
* `stats`
* `ggplot2`

The v1.0 release should preserve:

* the exact analytical scripts
* dataset provenance
* software-session information
* package versions required for reproduction
* fixed repository version
* formal citation metadata

The purpose of versioning is to ensure that a cited analytical artifact remains distinguishable from future project development.

---

# Reusable Analytical Logic

Although the current dataset concerns heart failure, the broader analytical logic is reusable.

```text
1. Define the analytical question

2. Identify what patient information is available

3. Separate patient information from outcomes and observation variables

4. Evaluate technical data quality

5. Document representation limitations

6. Describe the observed population

7. Perform appropriate statistical analysis

8. Construct alternative analytical representations

9. Hold the analytical population constant where possible

10. Evaluate representation sensitivity

11. Separate statistical findings from clinical claims

12. Define the limits of decision-support interpretation
```

The reusable element is therefore not a specific logistic-regression model.

It is the analytical principle:

```text
Patient Reality
      ↓
Digital Representation
      ↓
Statistical Analysis
      ↓
Statistical Evidence
      ↓
Interpretation
      ↓
Potential Decision Support
```

with explicit attention to the fact that statistical evidence depends on the information entering the analysis.

---

# Skills Demonstrated

The project demonstrates practical experience in:

### Data Handling

* structured CSV import
* variable configuration
* factor handling
* reusable variable groups
* source-data validation

### Data Quality

* schema validation
* missing-value assessment
* exact duplicate-row screening
* plausibility checks
* outlier screening

### Statistical Analysis

* descriptive statistics
* outcome-group comparisons
* Welch t-tests
* Wilcoxon rank-sum tests
* chi-squared tests
* Fisher's exact tests
* Cramér's V
* Benjamini-Hochberg adjustment
* Spearman correlation
* univariable logistic regression
* multivariable logistic regression

### Model Assessment

* odds ratios
* confidence intervals
* AIC
* log-likelihood
* McFadden pseudo-R²
* Brier score
* influence diagnostics
* nested likelihood-ratio testing

### Representation Analysis

* qualitative patient-representation mapping
* nested representation design
* coefficient-stability analysis
* patient-level fitted-probability comparison
* information-reduction analysis
* information-simplification analysis

### Research Practice

* structured analytical workflows
* reproducible documentation
* transparent limitations
* separation of statistical and clinical interpretation
* healthcare-data reasoning

---

# Learning Approach and AI Usage

This project was intentionally developed as a hands-on learning environment.

The analytical workflow, R implementation, project structure, methodological decisions, and final interpretations were primarily developed and implemented by the project author.

AI-assisted tools were used as **learning, review, and quality-improvement tools**.

Their role included:

* reviewing code
* reviewing statistical reasoning
* identifying potential weaknesses
* explaining alternative statistical approaches
* suggesting alternative R implementations
* challenging interpretations
* improving code readability
* improving documentation structure and language

AI-generated suggestions were not accepted automatically.

Suggestions were reviewed and evaluated before implementation.

Responsibility for the final:

* code
* methodological choices
* analytical workflow
* interpretation
* documentation

remains with the project author.

The purpose of AI use was to support an interactive learning and review process rather than to replace the analytical work.

---

# Citation

A formal machine-readable citation is provided in:

```text
CITATION.cff
```

For the v1.0 release, the repository should be cited using the archived version-specific metadata rather than an unspecified future state of the repository.

Suggested human-readable form:

```text
Bilgin E. Representation Sensitivity Analysis in Heart Failure with R.
Version 1.0.0. 2026.
```

The version-specific repository or archival identifier should be included where required by the citation style.

---

# Licensing

## Project Code

The project code is released under the **MIT License**.

See:

```text
LICENSE
```

## Dataset

The Heart Failure Clinical Records dataset is distributed separately under:

```text
Creative Commons Attribution 4.0 International
CC BY 4.0
```

The original dataset attribution and licensing requirements remain applicable.

---

# References

1. **Heart Failure Clinical Records [Dataset].** UCI Machine Learning Repository. 2020. doi: **10.24432/C5Z89R**

2. **Ahmad T, Munir A, Bhatti SH, Aftab M, Raza MA.** Survival analysis of heart failure patients: A case study. *PLoS One.* 2017;12(7):e0181001. doi: **10.1371/journal.pone.0181001**

3. **Chicco D, Jurman G.** Machine learning can predict survival of patients with heart failure from serum creatinine and ejection fraction alone. *BMC Medical Informatics and Decision Making.* 2020;20:16. doi: **10.1186/s12911-020-1023-5**

---

# Final Perspective

The project is built around one central distinction:

> **The statistical model sees the digital representation, not the complete patient.**

A dataset can be technically clean while still representing only selected aspects of the patient.

Likewise, statistical output can be internally coherent while remaining dependent on which patient information was available to the model.

The representation-sensitivity analysis makes this dependence observable by holding the analytical patient sample constant while changing the amount or granularity of information used to represent those patients.

The resulting question is not:

> **Which representation is the complete patient?**

but rather:

> **How much do our statistical conclusions depend on the patient representation from which they were generated?**
