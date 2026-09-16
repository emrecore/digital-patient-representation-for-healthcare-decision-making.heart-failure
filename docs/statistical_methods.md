# Statistical Methods

## Analytical Approach

This project uses a structured statistical workflow to analyze heart-failure patient data and evaluate how statistical results change when the available digital patient representation changes.

The analytical sequence is:

**Data Setup → Data Quality → Description → Visualization → Group Comparison → Hypothesis Testing → Correlation → Logistic Regression → Representation Sensitivity → Final Synthesis**

A central programming principle is maintained throughout the project:

**Raw Values → Statistical Analysis → Display Values**

Statistical decisions are made using unrounded values. Rounding and formatting are applied only for presentation.

---

## Descriptive Statistics

The overall patient population is summarized before inferential analysis.

### Numerical Variables

Numerical characteristics are described using:

- number of observations
- mean
- standard deviation
- median
- first quartile
- third quartile
- interquartile range
- minimum
- maximum

### Categorical Variables

Categorical characteristics are summarized using:

- counts
- proportions
- percentages

Mortality outcome is also summarized descriptively.

---

## Data Visualization

`ggplot2` is used for descriptive visualization.

The project includes:

- histograms for numerical distributions
- boxplots for numerical variables
- bar charts for categorical variables
- mortality-group boxplots for baseline numerical characteristics

Plots are used to support interpretation and do not replace formal statistical testing.

---

## Mortality-Group Comparisons

Patients are compared descriptively according to:

- `No death event`
- `Death event`

Numerical baseline characteristics are summarized separately for both groups.

Mean and median differences are calculated as:

**Death event − No death event**

These differences are interpreted only within each variable and are not ranked across variables with different measurement units.

Categorical characteristics are summarized using counts and within-group percentages.

Follow-up duration is reported separately because it represents observation time rather than baseline patient information.

---

## Hypothesis Testing

Formal group-level inference is performed in `06_hypothesis_testing.R`.

### Continuous Variables

The current analysis uses Welch two-sample t-tests for:

- `age`
- `serum_sodium`

The remaining baseline numerical variables are evaluated using Wilcoxon rank-sum tests:

- `creatinine_phosphokinase`
- `ejection_fraction`
- `platelets`
- `serum_creatinine`

Welch tests compare group means without assuming equal variances.

Wilcoxon tests evaluate distributional differences without requiring normality.

The Wilcoxon location-shift estimate is not interpreted as a simple median difference.

---

## Categorical Variables

Associations between baseline categorical variables and mortality outcome are evaluated using contingency tables.

Pearson's chi-squared test is used when expected cell counts are adequate.

If at least one expected cell count is below 5, Fisher's exact test is used instead.

Categorical association magnitude is summarized using:

**Cramér's V**

This provides an effect-size measure separate from statistical significance.

---

## Multiple-Testing Adjustment

All primary baseline mortality-group hypothesis tests are treated as one multiple-testing family.

The project applies the **Benjamini-Hochberg procedure** to control the false discovery rate.

For each test, both are retained:

- raw p-value
- BH-adjusted p-value

BH-adjusted results provide the primary group-level inferential evidence.

---

## Correlation Analysis

Relationships among continuous baseline patient characteristics are explored using:

**Spearman rank correlation**

Follow-up duration is excluded because it represents observation time rather than baseline patient information.

For each variable pair, the analysis retains:

- complete-pair sample size
- Spearman's rho
- absolute correlation magnitude
- exploratory p-value

Correlations are ranked using the unrounded absolute Spearman coefficient.

The three strongest observed relationships are visualized automatically.

Correlation analysis is exploratory and does not establish causality or clinical importance.

---

## Logistic Regression

Mortality associations are examined using binary logistic regression.

The outcome is:

`DEATH_EVENT`

Follow-up duration is excluded from the predictor set.

The regression models use the available baseline patient characteristics only.

---

## Univariable Regression

Each baseline characteristic is first analyzed separately.

The project reports:

- regression coefficient
- standard error
- odds ratio
- approximate 95% confidence interval
- p-value

These models describe unadjusted associations with mortality.

---

## Multivariable Regression

A full logistic regression model includes all available baseline characteristics simultaneously.

The model reports:

- adjusted regression coefficients
- standard errors
- adjusted odds ratios
- approximate 95% confidence intervals
- p-values

Adjusted associations are conditional on the patient information available in the dataset.

They do not establish causal effects.

---

## Model Evaluation

The multivariable logistic regression model is evaluated using:

- model convergence
- sample size
- number of recorded death events
- null deviance
- residual deviance
- AIC
- log-likelihood
- McFadden pseudo-R²
- Brier score

The Brier score is calculated from in-sample predicted probabilities.

These measures describe model behavior within the analyzed dataset and do not constitute external validation.

---

## Influence Diagnostics

Basic observation-level diagnostics include:

- Cook's distance
- leverage
- standardized deviance residuals

Observations are flagged using descriptive screening thresholds.

Diagnostic flags indicate observations that may warrant inspection.

They are not automatic exclusion criteria.

---

## Representation Sensitivity Analysis

The project evaluates how statistical model outputs change when the amount of baseline patient information changes.

Four nested representation layers are used.

All representation models are fitted on a **common complete-case sample**.

This ensures that comparisons reflect differences in available patient information rather than differences in the patients included in each model.

The general comparison is:

**Same Patients + Different Available Information → Different Model Outputs**

---

## Representation Model Comparison

One logistic regression model is fitted for each representation layer.

Models are compared using:

- AIC
- residual deviance
- McFadden pseudo-R²
- Brier score

These measures are interpreted as in-sample model characteristics.

---

## Sequential Information Addition

The nested representation models are compared using likelihood-ratio tests:

- Layer 1 → Layer 2
- Layer 2 → Layer 3
- Layer 3 → Layer 4

These tests examine whether additional patient information improves statistical model fit.

They do not establish whether the added information is clinically necessary.

---

## Coefficient Stability

Regression coefficients and odds ratios are compared across representation models.

For terms appearing in multiple models, the project summarizes:

- minimum coefficient
- maximum coefficient
- coefficient range
- minimum odds ratio
- maximum odds ratio

This evaluates whether estimated associations remain stable as additional patient information becomes available.

---

## Patient-Level Probability Sensitivity

Each representation model generates in-sample predicted probabilities for the same patients.

Reduced representations are compared with Layer 4 using:

- mean absolute probability difference
- root mean squared probability difference
- maximum absolute probability difference
- Spearman correlation between predicted probabilities

This evaluates whether patient-level model output is sensitive to information reduction.

These probabilities are not externally validated clinical risk estimates.

---

## Illustrative Reclassification

An illustrative probability threshold of:

**0.50**

is used to examine whether representation changes can alter binary model classifications.

The analysis reports:

- number of reclassified patients
- percentage of reclassified patients

The threshold is methodological only.

It is not a validated clinical, treatment, triage, or management threshold.

---

## Information Loss Through Dichotomization

The project also examines the effect of reducing the granularity of a continuous variable.

Ejection fraction is represented in two forms:

- continuous
- median-based binary representation

The sample median is used only as a neutral methodological cutoff.

The continuous and dichotomized models are compared using:

- model-fit measures
- patient-level probability differences
- illustrative reclassification

This evaluates whether simplifying patient information changes statistical output.

---

## Follow-Up and Survival Structure

The dataset contains both:

- mortality status
- follow-up duration

This creates an underlying time-to-event structure.

The current project uses logistic regression to evaluate whether a death event was recorded and does not explicitly model event timing.

Methods such as:

- Kaplan-Meier estimation
- log-rank testing
- Cox proportional hazards regression

are therefore possible future extensions rather than part of the current workflow.

---

## Interpretation Principles

The statistical analysis follows several boundaries.

### Association Is Not Causation

The dataset is observational.

Observed associations do not establish causal relationships.

### Statistical Significance Is Not Clinical Importance

P-values do not determine whether an effect is clinically meaningful.

Effect magnitude, uncertainty, measurement scale, and context must also be considered.

### Adjusted Associations Depend on Available Variables

Multivariable regression can adjust only for patient characteristics represented in the dataset.

Unmeasured factors remain outside the model.

### Statistical Reliability Is Not Clinical Validity

A statistically coherent result may still be based on incomplete patient information.

Therefore:

**Statistical reliability ≠ Clinical validity**

### In-Sample Performance Is Not External Validation

Model-fit statistics and predicted probabilities describe the analyzed dataset only.

The project does not claim externally validated predictive performance.

---

## Methodological Scope

The project can evaluate:

- patient distributions
- mortality-group differences
- statistical associations
- uncertainty
- correlation structure
- logistic-regression behavior
- model fit
- representation sensitivity
- coefficient stability
- probability sensitivity
- information loss

It does not establish:

- causal effects
- treatment recommendations
- validated clinical thresholds
- externally validated individual risk predictions
- clinical decision validity
- optimal healthcare-management decisions

The statistical methods therefore support structured analysis of the available digital patient representation while explicitly preserving the boundary between statistical evidence and clinical interpretation.