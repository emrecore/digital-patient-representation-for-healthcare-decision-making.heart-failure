# Heart Failure Clinical Statistical Analysis with R

## Overview

This project analyzes clinical data from patients with heart failure using R. The objective is to examine patient characteristics, clinical measurements, mortality outcomes, and statistical relationships between relevant health variables.

The dataset is publicly available and contains clinical records of 299 patients with heart failure collected during a follow-up period. It includes 12 predictor variables and one mortality outcome variable. The dataset contains no missing values.

## Key Findings

Across the complete statistical workflow, three clinical characteristics showed the most consistent associations with mortality:

* **Higher age**
* **Lower ejection fraction**
* **Higher serum creatinine**

Among the 299 patients:

* **203 patients survived during follow-up**
* **96 patients experienced a recorded death event**

This corresponds to an observed mortality proportion of approximately **32.1%**.

In the multivariable logistic regression model:

| Variable            |           Adjusted Odds Ratio | Interpretation                                                                  |
| ------------------- | ----------------------------: | ------------------------------------------------------------------------------- |
| `age`               |             **1.06** per year | Higher age was associated with higher mortality odds                            |
| `ejection_fraction` | **0.93** per percentage point | Higher ejection fraction was associated with lower mortality odds               |
| `serum_creatinine`  |          **1.94** per 1 mg/dL | Higher serum creatinine was associated with substantially higher mortality odds |

These variables were supported consistently across descriptive comparisons, hypothesis testing, and regression analysis.

Serum sodium showed evidence of an unadjusted association with mortality but did not retain the same level of statistical evidence after simultaneous adjustment for the other clinical characteristics.

Creatinine phosphokinase reached statistical significance in the adjusted model, although the estimated effect per single unit is small because of the variable's measurement scale and should therefore be interpreted cautiously.

---

## Healthcare Context

Heart failure is a serious cardiovascular condition in which the heart is unable to pump blood effectively enough to meet the body's needs.

Clinical characteristics such as age, ejection fraction, serum creatinine, serum sodium, diabetes, anaemia, smoking status, and hypertension may be associated with patient outcomes.

This project uses statistical analysis in R to explore these relationships and identify clinically relevant patterns within the dataset.

## Analysis Scope

```text
Data Import
→ Data Type Configuration
→ Data Quality Assessment
→ Descriptive Statistics
→ Data Visualization
→ Group Comparisons
→ Hypothesis Testing
→ Correlation Analysis
→ Regression Analysis
→ Final Clinical Insights
```

## Data Model

The dataset consists of the following variables:

| Variable                   | Purpose                                                        |
| -------------------------- | -------------------------------------------------------------- |
| `age`                      | Age of the patient                                             |
| `anaemia`                  | Indicates whether the patient has anaemia                      |
| `creatinine_phosphokinase` | CPK enzyme level in the blood                                  |
| `diabetes`                 | Indicates whether the patient has diabetes                     |
| `ejection_fraction`        | Percentage of blood leaving the heart during contraction       |
| `high_blood_pressure`      | Indicates whether the patient has hypertension                 |
| `platelets`                | Platelet count                                                 |
| `serum_creatinine`         | Serum creatinine level                                         |
| `serum_sodium`             | Serum sodium level                                             |
| `sex`                      | Patient sex                                                    |
| `smoking`                  | Indicates whether the patient smokes                           |
| `time`                     | Follow-up period                                               |
| `DEATH_EVENT`              | Indicates whether the patient died during the follow-up period |

## Key Analyses

The statistical analysis covers:

* Patient population characteristics
* Mortality outcome distribution
* Clinical variable distributions
* Comparison of survivors and non-survivors
* Relationships between categorical variables
* Correlations between continuous clinical variables
* Statistical hypothesis testing
* Identification of variables associated with mortality
* Regression-based outcome analysis
* Data quality checks

## Statistical Methods

The project applies a structured statistical workflow combining:

* Descriptive statistics
* Distribution assessment
* Mortality-group comparisons
* Welch two-sample t-tests
* Wilcoxon rank-sum tests
* Pearson chi-squared tests
* Fisher's exact tests where expected cell frequencies are insufficient
* Benjamini-Hochberg multiple-testing adjustment
* Spearman rank correlation
* Univariable logistic regression
* Multivariable logistic regression
* Odds ratios
* 95% confidence intervals

Statistical procedures were selected according to variable type, distributional characteristics, and the respective analytical question rather than applying the same statistical method to all variables.

The analysis is primarily **exploratory and explanatory**.

Statistical significance is therefore not interpreted in isolation. Effect magnitude, uncertainty, measurement scale, sample size, multiple-testing adjustment, and clinical context are considered together.

## R Skills Demonstrated

* Data import
* Data type configuration
* Data quality assessment
* Factor handling
* Descriptive statistics
* Data visualization
* `ggplot2`
* Grouped summaries
* Hypothesis testing
* Chi-square tests
* Fisher's exact tests
* t-tests
* Non-parametric tests
* Multiple-testing adjustment
* Correlation analysis
* Logistic regression
* Odds-ratio interpretation
* Confidence intervals
* Statistical interpretation

## Repository Structure

```text
heart-failure-clinical-statistical-analysis-r/
│
├── README.md
│
├── data/
│   └── heart_failure_clinical_records_dataset.csv
│
├── R/
│   ├── 01_data_import_and_setup.R
│   ├── 02_data_quality_checks.R
│   ├── 03_descriptive_statistics.R
│   ├── 04_data_visualization.R
│   ├── 05_group_comparisons.R
│   ├── 06_hypothesis_testing.R
│   ├── 07_correlation_analysis.R
│   ├── 08_regression_analysis.R
│   └── 09_final_clinical_insights.R
│
└── docs/
    ├── healthcare_context.md
    ├── dataset_description.md
    ├── statistical_methods.md
    └── insights_summary.md
```

## Healthcare Value

This project demonstrates how R can be used to transform clinical patient data into interpretable statistical insights.

The analysis provides greater visibility into patient characteristics, mortality patterns, clinical measurements, and potential relationships between health variables and patient outcomes.

The project illustrates how statistical methods can support evidence-based analysis in healthcare and clinical research.

## Interpretation and Limitations

The results describe statistical associations within the analyzed dataset and should **not** be interpreted as causal effects or clinical treatment recommendations.

Important limitations include:

* The dataset contains only **299 patients**
* The data are observational
* Unmeasured confounding cannot be excluded
* Variables not included in the dataset cannot be controlled statistically
* The regression model has not been externally validated as a clinical prediction model
* Statistical significance does not necessarily imply clinical significance

Extreme clinical observations were not automatically removed because unusual measurements may represent genuine high-risk patients rather than data errors.

The variable `time` represents follow-up duration and was deliberately not treated as an ordinary baseline predictor in the final mortality regression.

Mortality together with follow-up time forms a **time-to-event structure**, for which dedicated survival-analysis methods would be more appropriate.

The present project therefore focuses on associations with the binary recorded mortality outcome rather than modeling survival time directly.

## Potential Extension

A natural methodological extension of this project would be a dedicated survival analysis using:

* Kaplan-Meier survival estimation
* Log-rank testing
* Cox proportional hazards regression
* Proportional-hazards assumption assessment

This would allow the analysis to incorporate both **whether** mortality occurred and **when** it occurred during follow-up.

## Dataset Source

The project uses the **Heart Failure Clinical Records** dataset available through the UCI Machine Learning Repository.

The dataset contains medical records from **299 patients with heart failure**, including 12 predictor variables and the binary mortality outcome `DEATH_EVENT`.

Original dataset and associated publication:

* **UCI Machine Learning Repository:** Heart Failure Clinical Records
* Chicco, D. & Jurman, G. (2020). *Machine learning can predict survival of patients with heart failure from serum creatinine and ejection fraction alone*. BMC Medical Informatics and Decision Making, 20, 16.
* DOI: `10.1186/s12911-020-1023-5`

The dataset contains no documented missing observations.

## AI Usage

AI was used as a review and improvement tool during development. The R code, statistical analysis logic, variable classification, and project structure were created primarily by me.

AI was used to review code, identify potential issues, improve clarity, and suggest refinements. All suggestions were evaluated, adapted, and validated by me before being included.

## About

R-based statistical analysis project focused on heart failure outcomes, clinical characteristics, mortality patterns, and relationships between patient health variables.
