# Heart Failure Clinical Statistical Analysis with R

## Overview

This project presents a structured statistical analysis of digital clinical records from patients with heart failure using R.

The project has two connected objectives.

First, it applies a complete statistical workflow to investigate patient characteristics, clinical measurements, mortality patterns, and associations between available health variables and recorded mortality.

Second, it examines a broader methodological question that is central to data-driven healthcare:

> **How adequately can a patient be represented through available digital health data, and how reliable are statistical conclusions and potential healthcare decisions when they are based on this representation?**

The dataset contains clinical records from 299 patients with heart failure, including demographic characteristics, comorbidities, laboratory measurements, cardiac function, follow-up duration, and a recorded mortality outcome.

The project therefore treats the dataset not simply as a collection of variables, but as a **partial digital representation of real patients**.

This distinction is important.

A statistical model can only analyze information that has been digitally recorded. Relevant patient information that is absent, simplified, aggregated, or transformed cannot directly contribute to the resulting statistical evidence.

The analytical framework of the project can therefore be summarized as:

```text
Real Patient
    ↓
Digital Patient Representation
    ↓
Data Quality and Statistical Analysis
    ↓
Statistical Evidence
    ↓
Reliability Assessment
    ↓
Potential Decision Implications
    ↓
Clinical and Methodological Limits
```

The project is exploratory and explanatory. It does not provide clinical recommendations, establish causal relationships, or represent a clinically validated prediction system.

---

## Research Framework

This project is the first implementation of a broader analytical framework focused on the relationship between **digital patient representation, statistical reliability, and data-driven healthcare decision-making**.

The central idea is that healthcare datasets contain representations of patients rather than the patients themselves.

Formally, the distinction can be conceptualized as:

```text
Real Patient ≠ Digital Patient Representation
```

A real patient may be characterized by a large and continuously changing set of clinical, physiological, behavioral, therapeutic, social, and contextual characteristics.

A digital dataset captures only a subset of this information.

The resulting analytical process can therefore be represented as:

```text
P(real)
    ↓
P(digital)
    ↓
Statistical Model
    ↓
Statistical Evidence
    ↓
Decision Support
```

The reliability of the final conclusion depends partly on the quality and completeness of the digital representation on which it is based.

This project therefore distinguishes between two concepts:

> **Statistical reliability:**  
> Whether a statistical result is methodologically supported by the available data.

and

> **Clinical validity:**  
> Whether the available information and resulting statistical evidence are sufficient and appropriate for interpretation in the real clinical context.

These concepts are related but not equivalent.

A model may be statistically well specified within the available dataset while important clinical information remains unobserved.

This distinction forms the methodological foundation of the project.

---

## Research Questions

The analysis addresses five connected groups of research questions.

### 1. Patient Representation

- Which dimensions of the patients are represented in the available digital dataset?
- How are these dimensions encoded?
- Which information is continuous, categorical, binary, or time-dependent?
- Which potentially relevant patient dimensions are not represented?

### 2. Statistical Description

- What are the main demographic and clinical characteristics of the observed patient population?
- How frequently did mortality occur during the available follow-up period?
- How are important clinical measurements distributed?

### 3. Statistical Associations

- Which characteristics differ between patients with and without a recorded death event?
- Which variables show statistically supported associations with mortality?
- Which associations remain after adjustment for other available patient characteristics?
- How consistent are findings across different statistical approaches?

### 4. Representation Reliability

- How dependent are statistical conclusions on the amount and form of patient information available?
- What happens when the digital patient representation becomes less informative?
- Which patient-information domains contribute meaningfully to the resulting statistical evidence?
- How sensitive are analytical conclusions to simplification or information loss?

### 5. Decision and Clinical Interpretation

- Which conclusions could potentially contribute to healthcare decision support?
- Which conclusions remain too uncertain for decision-making?
- Which limitations arise from missing patient information?
- Where does statistical interpretation end and additional clinical expertise become necessary?

Together, these questions move the project beyond conventional exploratory data analysis toward a structured examination of the reliability of digital patient information.

---

## Healthcare Context

Heart failure is a complex cardiovascular condition in which the heart is unable to provide sufficient circulatory function to meet the physiological requirements of the body.

Patient prognosis may be related to multiple interacting dimensions of health, including:

- age
- cardiac function
- renal function
- metabolic and hematological measurements
- comorbidities
- cardiovascular risk factors
- treatment characteristics
- disease severity
- longitudinal disease development

The available dataset captures some, but not all, of these dimensions.

This makes the dataset particularly useful for demonstrating an important principle of healthcare analytics:

> **The quality of a statistical conclusion depends not only on the statistical method, but also on what information about the patient was available to the analysis in the first place.**

The objective is therefore not merely to identify mortality-associated variables.

The project also evaluates the boundaries of what can reasonably be concluded from the available digital patient representation.

---

## Dataset

The project uses the **Heart Failure Clinical Records** dataset from the UCI Machine Learning Repository.

The dataset contains:

- **299 patients**
- **12 explanatory variables**
- **1 binary mortality outcome**
- **no documented missing values in the original dataset**

Each row represents one patient.

The primary outcome is `DEATH_EVENT`, indicating whether a death event was recorded during the available follow-up period.

### Dataset Source

The dataset is publicly available through the **UCI Machine Learning Repository**.

It is associated with:

> Chicco, D. & Jurman, G.  
> *Machine learning can predict survival of patients with heart failure from serum creatinine and ejection fraction alone.*  
> BMC Medical Informatics and Decision Making, 2020.

UCI Dataset DOI:

```text
10.24432/C5Z89R
```

The dataset is distributed under the **Creative Commons Attribution 4.0 International (CC BY 4.0)** license.

---

## Variable Dictionary

| Variable | Type | Unit / Coding | Description |
|---|---|---|---|
| `age` | Numeric | years | Age of the patient |
| `anaemia` | Binary | 0 = No, 1 = Yes | Indicates whether the patient had anaemia |
| `creatinine_phosphokinase` | Numeric | mcg/L | Creatinine phosphokinase enzyme level |
| `diabetes` | Binary | 0 = No, 1 = Yes | Indicates whether the patient had diabetes |
| `ejection_fraction` | Numeric | % | Percentage of blood leaving the left ventricle during contraction |
| `high_blood_pressure` | Binary | 0 = No, 1 = Yes | Indicates whether the patient had hypertension |
| `platelets` | Numeric | kiloplatelets/mL | Platelet concentration |
| `serum_creatinine` | Numeric | mg/dL | Serum creatinine concentration |
| `serum_sodium` | Numeric | mEq/L | Serum sodium concentration |
| `sex` | Binary | 0 = Female, 1 = Male | Biological sex recorded in the dataset |
| `smoking` | Binary | 0 = No, 1 = Yes | Indicates whether the patient smoked |
| `time` | Numeric | days | Duration of follow-up |
| `DEATH_EVENT` | Binary outcome | 0 = Survived, 1 = Died | Recorded mortality during follow-up |

Binary variables are converted into labelled factors during data preparation where appropriate in order to improve readability and statistical interpretation.

---

# Digital Patient Representation

## Why Patient Representation Matters

The dataset does not contain a complete description of each individual patient.

Instead, every row represents a selected digital abstraction of that patient.

The analytical question is therefore not simply:

> What information is contained in the dataset?

but also:

> **What information about the patient is represented, how is it represented, and what information is absent?**

This distinction becomes particularly important when statistical evidence is intended to inform real healthcare decisions.

---

## Representation Map

The available variables can be organized into broader patient-information domains.

| Patient Dimension | Representation in Dataset | Available Information |
|---|---|---|
| Demographics | Partial | Age, sex |
| Cardiac function | Partial | Ejection fraction |
| Renal status | Partial | Serum creatinine |
| Hematological information | Partial | Platelets, anaemia |
| Biochemical information | Partial | Serum sodium, creatinine phosphokinase |
| Comorbidities | Partial | Diabetes, anaemia, hypertension |
| Behavioral risk factors | Very limited | Smoking status |
| Mortality outcome | Available | Recorded death event |
| Follow-up information | Available | Follow-up duration |
| Medication | Not represented | No detailed medication information |
| Treatment interventions | Not represented | No detailed treatment information |
| Symptoms | Not represented | No structured symptom information |
| Functional status | Not represented | No detailed functional assessment |
| Longitudinal laboratory development | Not represented | No repeated measurement trajectories |
| Patient-reported outcomes | Not represented | No quality-of-life or symptom-reported outcomes |
| Detailed disease severity | Limited | Only selected clinical measurements |
| Socioeconomic context | Not represented | No socioeconomic characteristics |
| Healthcare resource use | Not represented | No staffing, cost, capacity, or utilization variables |
| Management decisions | Not represented | No observed management interventions |

The purpose of this map is not to classify the dataset as inadequate.

Every healthcare dataset necessarily represents only selected dimensions of reality.

Instead, the map makes the informational boundaries of the analysis explicit.

---

## Representation Layers

For methodological purposes, the available baseline patient information can also be considered in increasingly information-rich layers.

### Layer 1 — Basic Demographic Representation

```text
age
sex
```

### Layer 2 — Demographics, Comorbidities and Risk Factors

```text
age
sex
anaemia
diabetes
high_blood_pressure
smoking
```

### Layer 3 — Clinical and Laboratory Representation

The previous information is supplemented by:

```text
creatinine_phosphokinase
ejection_fraction
platelets
serum_creatinine
serum_sodium
```

### Layer 4 — Full Available Baseline Representation

All available baseline patient characteristics are used simultaneously.

This layered structure makes it possible to investigate how statistical conclusions change as the digital representation becomes more or less informative.

---

# Analysis Workflow

The analytical workflow is designed to move systematically from raw digital patient records toward increasingly complex statistical interpretation.

```text
Data Import
    ↓
Variable Configuration
    ↓
Patient Representation Assessment
    ↓
Data Quality Assessment
    ↓
Descriptive Statistics
    ↓
Data Visualization
    ↓
Mortality Group Comparisons
    ↓
Hypothesis Testing
    ↓
Multiple-Testing Adjustment
    ↓
Correlation Analysis
    ↓
Univariable Regression
    ↓
Multivariable Regression
    ↓
Representation Sensitivity Analysis
    ↓
Reliability Assessment
    ↓
Decision Implications
    ↓
Clinical and Methodological Limits
    ↓
Final Analytical Summary
```

Each analytical stage is implemented separately to keep the workflow transparent, reproducible, and interpretable.

---

# Data Quality Assessment

Digital patient information must first be evaluated before statistical conclusions are drawn from it.

The project therefore performs explicit checks for:

- missing values
- duplicated observations
- variable classes
- binary-variable coding
- logically implausible values
- unexpected numerical observations
- unusual distributions
- potential outliers
- inconsistencies introduced during preprocessing

The original UCI dataset contains no documented missing observations.

Nevertheless, missing-value checks are performed explicitly rather than assuming that imported or transformed data remain complete.

Extreme observations are not removed automatically.

In healthcare datasets, unusual values may represent genuinely high-risk or clinically unusual patients rather than data-entry errors.

Removal would therefore require substantive justification.

---

# Descriptive Statistics

Descriptive analysis is used to characterize the digital patient population before inferential statistical methods are applied.

For continuous variables, the project considers measures including:

- mean
- median
- standard deviation
- interquartile range
- quartiles
- minimum
- maximum

For categorical variables, the analysis considers:

- absolute frequencies
- relative frequencies
- proportions

These statistics are evaluated for the overall patient population and, where appropriate, separately according to mortality status.

Using several measures of central tendency and dispersion is particularly important because some clinical variables show substantial skewness or extreme observations.

---

# Data Visualization

Clinical variables are explored graphically using `ggplot2`.

Visualizations include:

- histograms
- boxplots
- bar charts
- mortality-group comparisons

The visual analysis supports the assessment of:

- distributional shape
- skewness
- extreme observations
- differences between mortality groups
- potential limitations of purely numerical summaries

Graphical exploration is therefore used as a complement to, rather than a replacement for, formal statistical analysis.

---

# Mortality Group Comparisons

Patients are compared according to the binary outcome variable `DEATH_EVENT`.

```text
0 = survived during follow-up
1 = recorded death during follow-up
```

The selected statistical procedure depends on the structure and empirical distribution of the respective variable.

Depending on the analytical context, the project uses:

- Welch two-sample t-tests
- Wilcoxon rank-sum tests
- Pearson chi-squared tests
- Fisher's exact tests

This allows continuous and categorical patient characteristics to be evaluated using methods appropriate to their measurement scale and distribution.

---

# Multiple-Testing Adjustment

Evaluating many clinical characteristics simultaneously increases the probability of obtaining statistically significant results by chance.

The project therefore applies the **Benjamini-Hochberg procedure** to relevant families of hypothesis tests.

The procedure controls the false discovery rate.

Where appropriate, both values are retained:

```text
Raw p-value
Adjusted p-value
```

This makes it possible to distinguish between nominal statistical significance and evidence that remains supported after accounting for multiple comparisons.

---

# Correlation Analysis

Relationships between continuous clinical variables are evaluated using Spearman rank correlation.

Spearman's correlation is particularly useful because several variables contain skewed distributions or extreme observations.

The coefficient ranges between:

```text
-1 ≤ ρ ≤ 1
```

where:

- values approaching `+1` indicate stronger positive monotonic relationships
- values approaching `-1` indicate stronger negative monotonic relationships
- values approaching `0` indicate limited monotonic association

Correlation is not interpreted as evidence of causality.

Likewise, weak correlation between two variables does not imply that either variable lacks clinical or prognostic relevance.

---

# Logistic Regression

Because `DEATH_EVENT` is binary, mortality associations are investigated further using binary logistic regression.

The model can be represented as:

```text
log(p / (1 - p))
=
β0 + β1X1 + β2X2 + ... + βkXk
```

where `p` represents the estimated probability of a recorded mortality event.

Regression coefficients are exponentiated to obtain odds ratios:

```text
ORj = exp(βj)
```

The project includes both univariable and multivariable analyses.

---

## Univariable Regression

Univariable logistic regression evaluates each selected patient characteristic individually.

For each predictor, the analysis considers:

- regression coefficient
- odds ratio
- 95% confidence interval
- p-value

These models describe unadjusted associations.

They should therefore not be interpreted as independent or causal effects.

---

## Multivariable Regression

Multivariable logistic regression evaluates several available patient characteristics simultaneously.

This allows the association between one predictor and mortality to be interpreted conditional on the other variables included in the model.

Interpretation considers:

- direction of association
- estimated effect magnitude
- odds ratio
- 95% confidence interval
- statistical uncertainty
- measurement scale
- consistency with other analytical stages
- clinical plausibility
- limitations of the available patient representation

An adjusted association is not equivalent to a causal effect.

---

# Representation Sensitivity Analysis

A central extension of the conventional statistical workflow is the explicit analysis of **information dependence**.

The objective is to examine whether analytical conclusions remain stable when the digital representation of the patient changes.

Instead of assuming that one available dataset represents the patient sufficiently, the analysis compares increasingly information-rich patient representations.

Conceptually:

```text
Reduced Patient Representation
        ↓
Statistical Model
        ↓
Statistical Evidence

versus

More Complete Available Representation
        ↓
Statistical Model
        ↓
Statistical Evidence
```

The comparison focuses on questions such as:

- Do estimated associations change materially?
- Do uncertainty intervals become wider?
- Do previously supported associations disappear?
- Do additional clinical measurements substantially alter the estimated relationships?
- Are conclusions strongly dependent on a small number of recorded patient dimensions?
- How stable are patient-level statistical estimates when information is reduced?

The purpose is not to identify a universally optimal model.

Instead, the purpose is to understand how strongly statistical conclusions depend on the available digital representation of the patient.

---

## Information Loss

Digital healthcare information can be reduced in several ways.

Examples include:

```text
Variable omission
Categorization
Dichotomization
Aggregation
Rounding
Missing information
Loss of longitudinal information
```

Such transformations may make data easier to store, communicate, or use operationally, but they may also remove statistically relevant information.

This creates a general methodological question:

> **How much patient information can be simplified or removed before the resulting statistical conclusions change meaningfully?**

The heart failure dataset provides a controlled environment in which this problem can be investigated.

---

# Outcome Representation

The primary outcome in this project is represented digitally as:

```text
DEATH_EVENT = 0 or 1
```

This binary representation contains important information, but it also simplifies the underlying clinical process.

The dataset additionally contains `time`, representing follow-up duration.

Mortality status together with follow-up time creates a time-to-event structure.

The current primary analysis deliberately focuses on whether a death event was recorded and therefore uses logistic regression.

However, this representation does not explicitly model **when** the event occurred.

This distinction illustrates another important aspect of digital patient representation:

> The same underlying clinical process can be represented statistically in different ways, and the representation itself influences which questions can be answered.

A dedicated survival-analysis extension could therefore use:

- Kaplan-Meier estimation
- log-rank testing
- Cox proportional hazards regression

when the analytical focus shifts from whether mortality occurred to the timing of mortality.

---

# Statistical Reliability and Clinical Validity

One of the central principles of this project is:

```text
Statistical validity ≠ Clinical validity
```

A statistically supported association does not automatically mean that:

- it is clinically important
- it is causal
- it can be generalized to other patient populations
- it should influence treatment
- it is sufficient for patient-level decision-making
- the digital dataset contains all information required for the corresponding real-world decision

Statistical analysis can evaluate patterns contained in the available data.

It cannot independently determine whether all clinically relevant patient information has been captured.

This distinction becomes increasingly important when statistical models are used to support healthcare management, resource allocation, or clinical decision processes.

---

# Key Findings

## Mortality Outcome

Among the 299 patients:

- **203 patients survived during the recorded follow-up period**
- **96 patients experienced a recorded death event**

The observed mortality proportion was therefore approximately:

```text
32.1%
```

This mortality proportion describes the available sample and follow-up structure.

It should not be interpreted as a population mortality estimate for all patients with heart failure.

---

## Mortality Group Differences

After Benjamini-Hochberg adjustment for multiple testing, the clearest differences between patients with and without a recorded death event were observed for:

- age
- ejection fraction
- serum creatinine
- serum sodium

These variables therefore showed the strongest group-level statistical evidence of association with mortality status within the available dataset.

---

## Age

Patients who experienced a recorded death event tended to be older.

In the multivariable logistic regression model, the adjusted odds ratio was approximately:

```text
OR = 1.06 per additional year
```

Increasing age was therefore associated with higher mortality odds after adjustment for the other included characteristics.

---

## Ejection Fraction

Patients who experienced a recorded death event generally had lower ejection fractions.

The adjusted odds ratio was approximately:

```text
OR = 0.93 per one-percentage-point increase
```

Higher ejection fraction was therefore associated with lower estimated mortality odds.

The consistency of this finding across several analytical stages makes ejection fraction one of the clearest statistical findings within the project.

---

## Serum Creatinine

Higher serum creatinine values were consistently associated with mortality.

The adjusted odds ratio was approximately:

```text
OR = 1.94 per 1 mg/dL increase
```

Serum creatinine showed a consistent association across:

- mortality-group comparisons
- hypothesis testing
- univariable regression
- multivariable regression

Within the available digital patient representation, renal-function-related information therefore contributes substantially to the observed mortality pattern.

---

## Serum Sodium

Lower serum sodium levels were associated with mortality in unadjusted analyses.

The difference between mortality groups remained statistically supported after multiple-testing adjustment.

However, the association weakened after simultaneous adjustment for other available patient characteristics and was no longer statistically significant at the conventional 0.05 threshold in the multivariable model.

This demonstrates why isolated statistical associations should not automatically be interpreted as independent relationships.

---

## Creatinine Phosphokinase

Creatinine phosphokinase reached statistical significance in the multivariable regression model.

However, its estimated odds ratio per individual measurement unit is very close to `1.00` because the variable is measured on a comparatively large numerical scale.

The result is therefore interpreted cautiously.

It demonstrates an important statistical principle:

> **Statistical significance must be interpreted together with effect magnitude and measurement scale.**

---

## Categorical Characteristics

The categorical patient characteristics evaluated included:

- anaemia
- diabetes
- high blood pressure
- sex
- smoking status

These variables did not show sufficiently strong statistical evidence of mortality differences in the primary multiple-testing-adjusted group comparisons.

This should **not** be interpreted as evidence that these characteristics are clinically irrelevant.

It only means that clear mortality associations were not statistically established for these variables within the available sample and analytical framework.

---

# Main Patient-Level Pattern

Across descriptive comparisons, hypothesis testing, and regression analysis, three patient dimensions emerged particularly consistently.

| Patient Dimension | Main Digital Variable | Observed Statistical Pattern |
|---|---|---|
| Demographic vulnerability | Age | Higher age associated with higher mortality odds |
| Cardiac function | Ejection fraction | Lower ejection fraction associated with higher mortality odds |
| Renal function | Serum creatinine | Higher serum creatinine associated with higher mortality odds |

The convergence of several statistical methods provides stronger analytical support than reliance on one isolated test.

At the same time, these three variables represent only selected dimensions of patient health.

They should not be interpreted as a complete description of the patient or as sufficient information for clinical decision-making.

---

# From Patient Data to Decision Support

Healthcare data are frequently used to support decisions concerning areas such as:

- resource allocation
- patient prioritization
- capacity planning
- quality management
- care pathway design
- population segmentation
- risk stratification
- healthcare management

This project does **not** implement or recommend such real-world decisions.

Instead, it examines an analytical prerequisite for them:

> **How reliable is the information on which a potential decision would be based?**

The conceptual chain is:

```text
Patient
    ↓
Digital Patient Data
    ↓
Statistical Analysis
    ↓
Evidence
    ↓
Potential Decision Support
```

If the digital representation omits relevant patient characteristics, uncertainty may propagate through the entire process.

For this reason, the project treats data quality and patient representation as part of decision quality rather than merely technical preprocessing issues.

---

# Management Relevance

The analysis is particularly relevant to data-driven healthcare management.

Management decisions increasingly rely on digitally recorded patient information when evaluating:

- patient populations
- resource requirements
- healthcare demand
- quality outcomes
- risk distributions
- service planning
- operational priorities

The project therefore highlights a fundamental management principle:

> **A data-driven healthcare decision can only be as informative as the patient representation on which the underlying analysis is based.**

A statistically sophisticated model cannot automatically compensate for clinically important information that was never recorded.

This connects quantitative healthcare analytics with healthcare management and clinical interpretation.

---

# Clinical Boundary

The project deliberately separates statistical analysis from medical judgment.

Statistical methods can identify:

- distributions
- associations
- effect estimates
- uncertainty
- model dependence
- information sensitivity
- consistency across analytical approaches

However, statistical analysis alone cannot determine:

- which missing variables are medically essential in every clinical context
- whether an observed association is therapeutically actionable
- whether a statistical difference is clinically meaningful
- which treatment should be selected
- whether an individual patient requires a particular intervention
- whether a healthcare decision is medically appropriate

These questions require additional clinical knowledge and, depending on the question, additional study designs and patient information.

The boundary between statistical evidence and clinical interpretation is therefore treated as an explicit part of the analytical framework rather than an afterthought.

---

# Interpretation Principles

Several principles are applied consistently throughout the project.

## 1. Association Is Not Causation

The dataset is observational.

Observed associations cannot establish that a variable directly causes mortality.

Causal claims are therefore avoided.

---

## 2. Statistical Significance Is Not Clinical Importance

A statistically significant result is not automatically clinically meaningful.

Interpretation also considers:

- effect magnitude
- confidence intervals
- measurement scale
- model adjustment
- sample size
- consistency across methods
- clinical context
- dataset limitations

---

## 3. The Dataset Is a Representation, Not the Patient

Every statistical conclusion is conditional on the information that has been recorded.

Missing patient dimensions cannot be recovered simply by applying more sophisticated statistical models.

---

## 4. Adjusted and Unadjusted Associations May Differ

An association observed in isolation may weaken, disappear, or change after accounting for additional patient characteristics.

This is treated as an analytical finding rather than a contradiction.

---

## 5. Measurement Scale Matters

Effect estimates must always be interpreted relative to the unit in which a predictor is measured.

An odds ratio close to `1.00` per one measurement unit may still correspond to a meaningful change across a larger clinically plausible range.

---

## 6. Extreme Values Are Not Automatically Errors

Unusual clinical observations may represent genuine patients.

Outliers are therefore investigated rather than automatically removed.

---

## 7. Information Loss Matters

Simplifying, categorizing, aggregating, or removing patient information may affect statistical conclusions.

This effect should be examined rather than assumed to be negligible.

---

## 8. Statistical Reliability and Clinical Validity Are Different

A statistically stable result can still be clinically incomplete if relevant patient information is absent.

Conversely, an important clinical relationship may remain statistically uncertain in a small dataset.

---

# Limitations

The findings must be interpreted within several important limitations.

- The dataset contains only 299 patients, limiting statistical precision and model complexity.
- The data are observational and cannot establish causal relationships.
- Unmeasured confounding may influence the observed associations.
- The available variables represent only a subset of the patients' complete clinical states.
- Detailed medication histories are unavailable.
- Detailed treatment information is unavailable.
- Structured symptom information is unavailable.
- Patient-reported outcomes are unavailable.
- Broader disease-severity information is limited.
- Longitudinal clinical measurements are largely unavailable.
- Socioeconomic and broader contextual information is unavailable.
- Healthcare resource utilization and management variables are unavailable.
- The binary mortality analysis does not explicitly model the timing of mortality.
- Follow-up duration differs between patients.
- The regression analysis has not been externally validated.
- The dataset is not representative of the general population.
- Statistical associations cannot automatically be converted into clinical or management recommendations.
- The analysis is exploratory and should not be interpreted as a clinical prediction system.

These limitations are not only weaknesses of the analysis.

Within the broader research framework, they also demonstrate the central problem of digital patient representation:

> **Real-world patients contain substantially more relevant information than any individual analytical dataset can capture.**

---

# Healthcare Analytics Value

The project demonstrates how R can be used to transform raw digital patient records into a structured, transparent, and critically interpreted statistical analysis.

It combines:

- healthcare data preparation
- data quality assessment
- digital patient representation analysis
- descriptive statistics
- statistical visualization
- inferential statistics
- multiple-testing correction
- correlation analysis
- regression modeling
- uncertainty assessment
- information-sensitivity analysis
- healthcare interpretation
- decision-context analysis
- explicit recognition of clinical boundaries

The framework is particularly relevant to areas such as:

- Healthcare Analytics
- Digital Health
- Medical Statistics
- Health Data Science
- Clinical Research
- Health Economics
- Health Outcomes Research
- Real-World Evidence
- Health Services Research
- Healthcare Management
- Data-Driven Healthcare Decision-Making

---

# R Skills Demonstrated

The project demonstrates practical experience with:

- clinical data import
- data type configuration
- factor handling
- data quality assessment
- missing-value checks
- duplicate checks
- plausibility checks
- descriptive statistics
- grouped summaries
- statistical visualization
- `ggplot2`
- mortality-group comparisons
- Welch t-tests
- Wilcoxon rank-sum tests
- chi-square tests
- Fisher's exact tests
- multiple-testing correction
- confidence intervals
- Spearman correlation
- univariable logistic regression
- multivariable logistic regression
- odds-ratio interpretation
- model comparison
- representation sensitivity analysis
- statistical interpretation
- healthcare-context interpretation
- critical evaluation of digital patient information

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

The structure is intentionally modular.

Each stage of the analytical process has a clearly defined role, allowing the same general framework to be transferred to future analyses involving different healthcare datasets and patient populations.

---

# File Overview

## `01_data_import_and_setup.R`

Imports the clinical dataset, inspects its structure, configures variable types, defines relevant variable groups, and prepares the analytical environment.

---

## `02_patient_representation_and_data_quality.R`

Examines both the technical quality and informational structure of the digital patient representation.

The script evaluates:

- available patient-information domains
- missing patient dimensions
- missing values
- duplicate observations
- variable classes
- unexpected values
- binary coding
- unusual numerical observations
- potential outliers

---

## `03_descriptive_statistics.R`

Describes the patient population using appropriate measures of central tendency, dispersion, frequencies, and proportions.

---

## `04_data_visualization.R`

Visualizes distributions, categorical patient characteristics, mortality patterns, and differences between outcome groups using `ggplot2`.

---

## `05_outcome_group_comparisons.R`

Compares demographic and clinical characteristics between patients with and without recorded mortality events.

---

## `06_hypothesis_testing.R`

Performs formal statistical hypothesis tests and applies multiple-testing adjustment where appropriate.

---

## `07_correlation_analysis.R`

Examines monotonic relationships between continuous clinical measurements using Spearman correlation.

---

## `08_regression_analysis.R`

Performs univariable and multivariable logistic regression and evaluates mortality associations using odds ratios, confidence intervals, and statistical uncertainty.

---

## `09_representation_sensitivity_analysis.R`

Investigates how statistical conclusions change when the amount or structure of digitally represented patient information is modified.

The analysis compares alternative patient representations and evaluates the sensitivity of the resulting statistical evidence to information reduction.

---

## `10_final_clinical_and_decision_insights.R`

Integrates the descriptive, inferential, regression, and representation-sensitivity findings.

The final stage explicitly separates:

```text
What the data show
What the statistical analysis supports
What may be relevant for decision support
What the data cannot establish
What requires additional clinical knowledge
```

---

# Documentation

Additional methodological and contextual documentation is provided in the `docs/` directory.

## `healthcare_context.md`

Explains the healthcare and clinical background of the analyzed variables and outcome.

## `dataset_description.md`

Documents dataset provenance, structure, variables, coding, and analytical characteristics.

## `patient_representation.md`

Maps the patient-information dimensions that are represented digitally and those that remain unavailable.

It also documents the granularity and structure through which patient information enters the statistical analysis.

## `statistical_methods.md`

Explains the statistical methods used throughout the project and the reasoning behind their application.

## `decision_context.md`

Examines how the statistical evidence could relate to healthcare decision support while explicitly identifying informational, methodological, and clinical boundaries.

## `insights_summary.md`

Provides an extended synthesis of the main findings, representation limitations, statistical interpretation, and healthcare relevance.

---

# Running the Analysis

The scripts are designed to be executed sequentially from the repository root.

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

The dataset is imported using the relative path:

```text
data/heart_failure_clinical_records_dataset.csv
```

The visualization stage requires:

```r
library(ggplot2)
```

Running the scripts sequentially ensures that analytical objects created during earlier stages remain available for subsequent analyses.

---

# Reusable Analytical Blueprint

The repository is intentionally structured as a reusable framework for future statistical analyses of digital patient data.

The disease, patient population, variables, and outcome may change between projects.

The underlying analytical logic remains:

```text
1. Understand the healthcare context

2. Define the patient population

3. Identify what aspects of the patient are digitally represented

4. Identify important patient information that is absent

5. Validate data quality

6. Describe the observed patient population

7. Explore distributions and relationships

8. Test statistical associations

9. Build appropriate multivariable models

10. Evaluate how conclusions depend on the available patient representation

11. Assess the reliability and limitations of the resulting evidence

12. Translate findings cautiously into a healthcare decision context

13. Separate statistical conclusions from clinical judgment
```

Future projects can therefore apply the same framework to other patient datasets while adapting the statistical methods to the structure of the respective data.

The purpose is not to force every healthcare dataset into the same statistical model.

Instead, the reusable component is the **research logic**:

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

# Learning Approach and AI Usage

This project was intentionally developed as a hands-on learning environment to strengthen my practical skills in R, statistical analysis, and the structured evaluation of healthcare data.

The R code, statistical workflow, project structure, and analytical decisions were primarily developed and implemented by me.

AI was used as a learning and review tool throughout the project rather than as a substitute for the analytical process.

In particular, AI supported my learning by:

- reviewing parts of my code
- reviewing statistical reasoning
- identifying potential weaknesses
- suggesting alternative analytical approaches
- explaining alternative implementations in R
- challenging interpretations
- improving code clarity and documentation

This allowed me to compare different approaches, improve my understanding of the underlying statistical methods, and refine the quality and readability of the analysis.

All suggestions were critically evaluated before implementation.

Statistical methods, interpretations, and changes to the analytical workflow were incorporated only after I had understood their purpose and verified that they were appropriate for the dataset and research objectives.

The purpose of using AI was therefore not to automate the project, but to create an interactive learning environment in which I could continuously improve my programming, statistical reasoning, and analytical decision-making while remaining responsible for the final implementation and interpretation.

---

# Final Interpretation

The conventional statistical analysis identifies a recurring pattern involving:

- higher age
- lower ejection fraction
- higher serum creatinine

These characteristics showed some of the most consistent associations with recorded mortality across the different stages of the analytical workflow.

Serum sodium also showed evidence of an unadjusted mortality association, although this relationship weakened after adjustment for other available patient characteristics.

These findings demonstrate how structured statistical analysis can identify interpretable patterns in digital clinical data.

However, the broader conclusion of the project extends beyond the individual mortality associations.

The analysis illustrates that every statistical result is conditional on the digital representation from which it was derived.

The dataset contains meaningful information about demographics, selected comorbidities, laboratory measurements, cardiac function, follow-up, and mortality.

At the same time, it does not contain a complete representation of the patient.

Relevant dimensions such as detailed treatment, medication, symptoms, longitudinal clinical development, patient-reported outcomes, and broader contextual information remain unavailable.

The central analytical principle of the project is therefore:

> **A statistical model does not analyze the patient directly. It analyzes the available digital representation of the patient.**

Consequently, increasing statistical sophistication cannot automatically compensate for clinically relevant information that was never recorded.

The reliability of data-driven healthcare decisions therefore depends on more than model performance alone.

It also depends on:

```text
What was measured
How it was represented
What was omitted
How much information was lost
How stable the resulting evidence remains
Whether the available information is clinically sufficient for the intended decision
```

This leads to the broader research perspective underlying the project:

> **How clinically adequate must digital patient representations be for statistical models to provide reliable support for healthcare management and decision-making?**

The heart failure analysis serves as the first implementation of this framework.

Its purpose is therefore not only to analyze one clinical dataset, but to establish a reproducible analytical approach for investigating the relationship between **digital patient data, statistical reliability, healthcare decisions, and clinical reality**.