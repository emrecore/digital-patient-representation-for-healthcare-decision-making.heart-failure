# Heart Failure Clinical Statistical Analysis with R

## Overview

This project presents a structured statistical analysis of clinical data from patients with heart failure using **R**.

The objective is to explore patient characteristics, clinical measurements, mortality outcomes, and statistical relationships between relevant health variables while applying a complete analytical workflow from data preparation to multivariable regression and final interpretation.

The dataset contains clinical records from **299 patients with heart failure**, including **12 predictor variables** and one recorded mortality outcome variable.

The project was designed as both a **healthcare analytics portfolio project** and a practical learning environment for developing statistical analysis skills in R.

---

## Project Objectives

The analysis addresses the following questions:

* What are the main demographic and clinical characteristics of the patient population?
* How frequently did mortality occur during the observed follow-up period?
* Which clinical characteristics differ between survivors and patients with a recorded death event?
* Which variables show statistically supported associations with mortality?
* Which associations remain after adjusting for other patient characteristics?
* How should statistical findings be interpreted within their clinical and methodological limitations?

The project focuses on **statistical associations and interpretation**, not causal inference or clinical prediction.

---

## Healthcare Context

Heart failure is a serious cardiovascular condition in which the heart is unable to pump blood effectively enough to meet the body's physiological needs.

Patient outcomes may be related to several demographic and clinical characteristics, including:

* age
* cardiac function
* renal function
* serum biomarkers
* anaemia
* diabetes
* hypertension
* smoking status

This project uses statistical methods in R to investigate these relationships within an observational clinical dataset.

The purpose is not to provide medical recommendations, but to demonstrate how structured statistical analysis can be used to extract interpretable evidence from healthcare data.

---

## Analysis Workflow

```text
Data Import
    ↓
Data Type Configuration
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
Clinical Interpretation
    ↓
Final Analytical Summary
```

Each stage is implemented in a separate R script to keep the analytical workflow transparent and easy to follow.

---

## Dataset

The analysis uses the **Heart Failure Clinical Records** dataset.

The dataset contains **299 observations** and the following variables:

| Variable                   | Description                                                   |
| -------------------------- | ------------------------------------------------------------- |
| `age`                      | Age of the patient                                            |
| `anaemia`                  | Indicates whether the patient has anaemia                     |
| `creatinine_phosphokinase` | Creatinine phosphokinase enzyme level                         |
| `diabetes`                 | Indicates whether the patient has diabetes                    |
| `ejection_fraction`        | Percentage of blood leaving the heart during contraction      |
| `high_blood_pressure`      | Indicates whether the patient has hypertension                |
| `platelets`                | Platelet count                                                |
| `serum_creatinine`         | Serum creatinine concentration                                |
| `serum_sodium`             | Serum sodium concentration                                    |
| `sex`                      | Patient sex                                                   |
| `smoking`                  | Indicates whether the patient smokes                          |
| `time`                     | Follow-up duration                                            |
| `DEATH_EVENT`              | Indicates whether a death event was recorded during follow-up |

The dataset contains **no missing values**.

Binary variables are converted into labelled factors during the data-preparation stage to improve readability and statistical interpretation.

---

## Statistical Methods

The project combines descriptive, inferential, and regression-based statistical methods.

### Descriptive Statistics

The dataset is first summarized using measures such as:

* mean
* median
* standard deviation
* quartiles
* minimum and maximum
* frequencies
* percentages

These analyses provide an overview of the patient population and the distributions of relevant clinical measurements.

---

### Data Visualization

Clinical variables are explored using `ggplot2`.

Visualizations include:

* histograms
* boxplots
* bar charts
* mortality-group comparisons

The visual analysis supports the identification of:

* distributional patterns
* skewed variables
* potential outliers
* differences between mortality groups

---

### Group Comparisons

Patients with and without a recorded death event are compared across demographic and clinical characteristics.

Depending on the variable structure and analytical assumptions, the project uses:

* independent-samples t-tests
* non-parametric tests
* chi-square tests

This allows continuous and categorical patient characteristics to be evaluated appropriately.

---

### Multiple-Testing Adjustment

Because several variables are tested simultaneously, group-level hypothesis-test results are additionally evaluated using the **Benjamini-Hochberg procedure**.

This reduces the risk of interpreting isolated significant results that may arise from multiple testing.

Both raw and adjusted p-values are retained within the analytical workflow.

---

### Correlation Analysis

**Spearman correlation analysis** is used to examine monotonic relationships between continuous clinical variables.

Correlation results are ranked by absolute correlation magnitude.

These analyses are used to identify relationships between clinical measurements while avoiding causal interpretation.

---

### Logistic Regression

The binary mortality outcome is investigated using logistic regression.

The project includes:

* univariable logistic regression
* multivariable logistic regression
* odds ratios
* 95% confidence intervals
* statistical significance testing
* model-fit assessment

Univariable models examine each characteristic separately.

The multivariable model evaluates associations after simultaneously accounting for the other available baseline characteristics.

---

## Key Findings

### Mortality Outcome

Among the **299 patients**:

* **203 patients survived during follow-up**
* **96 patients experienced a recorded death event**

This corresponds to an observed mortality proportion of approximately:

**32.1%**

---

### Mortality Group Differences

After adjustment for multiple testing using the Benjamini-Hochberg procedure, the clearest differences between patients with and without a recorded death event were observed for:

* **age**
* **ejection fraction**
* **serum creatinine**
* **serum sodium**

These variables therefore showed the strongest group-level statistical evidence of association with mortality status within the dataset.

---

## Most Consistent Mortality-Associated Characteristics

Across descriptive comparisons, hypothesis testing, and regression analysis, three characteristics emerged particularly consistently:

### 1. Age

Patients who experienced a recorded death event tended to be older.

In the multivariable logistic regression model, the adjusted odds ratio was approximately:

**OR = 1.06 per additional year**

This indicates that increasing age was associated with higher mortality odds after adjustment for the other included characteristics.

---

### 2. Ejection Fraction

Patients who experienced mortality generally had lower ejection fractions.

The adjusted odds ratio was approximately:

**OR = 0.93 per one-percentage-point increase**

Higher ejection fraction was therefore associated with lower estimated mortality odds.

The consistency of this finding across several analytical stages makes ejection fraction one of the strongest findings in the project.

---

### 3. Serum Creatinine

Higher serum creatinine levels were consistently associated with mortality.

The adjusted odds ratio was approximately:

**OR = 1.94 per 1 mg/dL increase**

Serum creatinine showed one of the strongest and most consistent mortality associations across:

* group comparisons
* hypothesis testing
* univariable regression
* multivariable regression

This highlights the statistical relevance of renal-function-related clinical status within the analyzed heart failure population.

---

## Additional Findings

### Serum Sodium

Lower serum sodium levels were associated with mortality in the unadjusted analyses.

Serum sodium also remained statistically supported in the mortality-group comparison after multiple-testing adjustment.

However, the association weakened after simultaneous adjustment for other patient characteristics and was no longer statistically significant at the conventional 0.05 threshold in the multivariable model.

This illustrates the difference between an isolated statistical association and one that remains supported after accounting for additional variables.

---

### Creatinine Phosphokinase

Creatinine phosphokinase reached statistical significance in the multivariable regression model.

However, its estimated odds ratio per individual measurement unit is very close to **1.00** because the variable is measured on a comparatively large numerical scale.

The finding is therefore interpreted cautiously.

It demonstrates an important statistical principle:

> Statistical significance must always be interpreted together with effect magnitude and the measurement scale of the predictor.

---

### Categorical Characteristics

The analyzed categorical characteristics included:

* anaemia
* diabetes
* high blood pressure
* sex
* smoking status

These variables did not show sufficiently strong statistical evidence of mortality differences in the primary multiple-testing-adjusted group comparisons.

This should **not** be interpreted as evidence that these characteristics are clinically irrelevant.

It only indicates that clear mortality associations were not statistically established for these variables within the current dataset and analytical framework.

---

## Correlation Findings

Pairwise Spearman correlations between continuous clinical measurements were generally **weak to moderate**.

No extremely strong correlations were identified among the baseline continuous variables.

This suggests that the clinical measurements generally capture different aspects of patient status rather than representing highly redundant information.

Importantly:

**Correlation magnitude is not equivalent to clinical importance.**

A variable may show only limited correlation with other clinical measurements while still being associated with mortality.

---

## Main Clinical Pattern

Taken together, the analysis identifies a consistent statistical pattern involving three dimensions of patient health:

| Dimension                 | Main Variable     | Observed Pattern                                              |
| ------------------------- | ----------------- | ------------------------------------------------------------- |
| Demographic vulnerability | Age               | Higher age associated with higher mortality odds              |
| Cardiac function          | Ejection fraction | Lower ejection fraction associated with higher mortality odds |
| Renal function            | Serum creatinine  | Higher serum creatinine associated with higher mortality odds |

The agreement between multiple analytical approaches makes these findings more informative than relying on a single statistical test alone.

---

## Key Takeaways

1. Approximately **one-third of the patients** experienced a recorded death event during follow-up.

2. **Age, ejection fraction, serum creatinine, and serum sodium** differed between mortality groups after Benjamini-Hochberg adjustment.

3. These same four variables showed statistically significant individual associations with mortality in univariable logistic regression.

4. **Age, ejection fraction, and serum creatinine** remained the most consistent mortality-associated characteristics after multivariable adjustment.

5. Serum sodium showed an unadjusted association with mortality, but the statistical evidence weakened after adjustment for other characteristics.

6. Creatinine phosphokinase reached statistical significance in the multivariable model, but its effect requires cautious interpretation because of its measurement scale and comparatively small per-unit effect.

7. The evaluated binary patient characteristics did not show strong mortality associations in the primary adjusted group comparisons.

8. Pairwise correlations between continuous clinical variables were generally not strong enough to indicate substantial redundancy.

9. The results describe **statistical associations**, not causal relationships.

---

## R Skills Demonstrated

The project demonstrates practical experience with:

* clinical data import
* data type configuration
* factor handling
* data quality assessment
* missing-value checks
* duplicate checks
* descriptive statistics
* grouped summaries
* statistical visualization
* `ggplot2`
* mortality-group comparisons
* t-tests
* non-parametric testing
* chi-square tests
* multiple-testing correction
* confidence intervals
* Spearman correlation
* univariable logistic regression
* multivariable logistic regression
* odds-ratio interpretation
* model-fit assessment
* statistical interpretation
* clinical-context interpretation

---

## Repository Structure

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

---

## File Overview

### `01_data_import_and_setup.R`

Imports the clinical dataset, inspects its structure, and configures numerical and categorical variables for analysis.

### `02_data_quality_checks.R`

Evaluates the dataset for missing values, duplicate observations, inconsistent values, and unusual numerical observations.

### `03_descriptive_statistics.R`

Summarizes the clinical characteristics of the patient population using descriptive statistical measures.

### `04_data_visualization.R`

Visualizes clinical distributions, categorical patient characteristics, and mortality outcomes using `ggplot2`.

### `05_group_comparisons.R`

Compares clinical characteristics between patients with and without recorded mortality events.

### `06_hypothesis_testing.R`

Performs formal statistical hypothesis tests and applies multiple-testing adjustment.

### `07_correlation_analysis.R`

Examines monotonic relationships between continuous clinical variables using Spearman correlation.

### `08_regression_analysis.R`

Performs univariable and multivariable logistic regression and calculates odds ratios and confidence intervals.

### `09_final_clinical_insights.R`

Consolidates the main descriptive, inferential, correlation, and regression findings into a structured final analytical summary.

---

## Documentation

Additional documentation is provided in the `docs/` directory.

### `healthcare_context.md`

Explains the healthcare and clinical context behind the selected variables and analysis.

### `dataset_description.md`

Documents the structure, variables, coding, and characteristics of the dataset.

### `statistical_methods.md`

Explains the statistical methods used throughout the project and the reasoning behind their application.

### `insights_summary.md`

Provides an extended interpretation of the main findings and their statistical and clinical context.

---

## Running the Analysis

The scripts are designed to be executed sequentially from the repository root.

```text
01_data_import_and_setup.R
02_data_quality_checks.R
03_descriptive_statistics.R
04_data_visualization.R
05_group_comparisons.R
06_hypothesis_testing.R
07_correlation_analysis.R
08_regression_analysis.R
09_final_clinical_insights.R
```

The dataset is imported using the relative path:

```r
data/heart_failure_clinical_records_dataset.csv
```

The visualization stage requires:

```r
library(ggplot2)
```

Running the scripts in order ensures that analytical objects created in earlier stages are available to the subsequent analyses.

---

## Interpretation Principles

Several principles were applied consistently throughout the project.

### Association Is Not Causation

The dataset is observational.

Statistical associations identified in this project cannot establish that a variable directly causes mortality.

---

### Statistical Significance Is Not Enough

Results are interpreted using more than p-values alone.

The analysis also considers:

* effect magnitude
* confidence intervals
* measurement scale
* model adjustment
* consistency across statistical methods
* clinical plausibility
* dataset limitations

---

### Adjusted and Unadjusted Associations May Differ

A variable can appear statistically important when analyzed individually but become weaker after accounting for other patient characteristics.

The serum sodium results provide an example of this distinction.

---

### Measurement Scale Matters

Odds ratios must always be interpreted relative to the unit in which the predictor is measured.

The creatinine phosphokinase analysis illustrates why an odds ratio close to 1.00 per single unit can still reach statistical significance.

---

## Limitations

The findings should be interpreted within several important limitations.

* The dataset contains only **299 patients**, limiting statistical precision and model complexity.
* The data are observational and cannot establish causal relationships.
* Unmeasured confounding may influence the observed associations.
* Treatment information and several potential disease-severity characteristics are not available.
* The logistic regression model evaluates whether a death event was recorded but does not explicitly model the timing of the event.
* Follow-up duration differs between patients.
* The model has not been externally validated.
* The analysis is exploratory and should not be interpreted as a clinical prediction tool.
* Findings require validation in independent patient populations before any clinical application.

---

## Follow-Up Time and Survival Analysis

The dataset contains a `time` variable representing patient follow-up duration.

This variable was deliberately **not treated as an ordinary baseline predictor** in the final mortality regression because follow-up duration is directly related to the observation process.

Mortality status together with follow-up time creates a **time-to-event structure**.

A dedicated extension of the project could therefore apply survival-analysis methods such as:

* Kaplan-Meier estimation
* log-rank testing
* Cox proportional hazards regression

The current project intentionally focuses on statistical associations with the binary recorded mortality outcome.

---

## Healthcare Analytics Value

This project demonstrates how R can be used to transform raw clinical patient data into a structured and interpretable statistical analysis.

It combines:

* data preparation
* statistical methodology
* healthcare context
* transparent interpretation
* uncertainty awareness
* reproducible analytical structure

The project is particularly relevant to areas such as:

* Healthcare Analytics
* Medical Statistics
* Clinical Research
* Health Economics
* Health Outcomes Research
* Real-World Evidence
* Evidence-Based Healthcare

---

## Learning Approach and AI Usage

This project was intentionally developed as a **hands-on learning environment for statistical programming and healthcare data analysis in R**.

The R code, analytical workflow, statistical reasoning, and project structure were developed primarily by me.

AI was used as a **learning and review tool** throughout the development process. In particular, it was used to:

* review my analytical approach and code
* identify potential weaknesses or mistakes
* explain alternative ways of implementing analyses in R
* demonstrate different coding approaches for the same statistical task
* improve code readability and documentation
* challenge and refine statistical interpretations

Rather than directly replacing the analytical work, AI served as an interactive learning resource comparable to a tutor or code reviewer.

Suggestions were evaluated, understood, adapted where appropriate, and incorporated only after reviewing their statistical and technical reasoning.

The main purpose of this approach was not only to produce a functioning analysis, but to improve my ability to independently design, implement, and interpret statistical analyses in R.

---

## Final Interpretation

The strongest statistical pattern emerging from this project is the combined importance of:

* **older age**
* **reduced cardiac function**
* **impaired renal function**

Older age, lower ejection fraction, and higher serum creatinine were repeatedly associated with mortality across different stages of the analytical workflow.

The agreement between descriptive analysis, hypothesis testing, and regression modeling strengthens the interpretation of these variables within the analyzed dataset.

At the same time, the project demonstrates an important principle of healthcare statistics:

> A clinically interpretable conclusion should not be based on statistical significance alone.

Effect magnitude, uncertainty, measurement scale, model adjustment, study design, and clinical context must be considered together.

The results should therefore be understood as **exploratory statistical evidence from a limited observational dataset**, providing a foundation for further analysis rather than definitive evidence for patient-level clinical decision making.
