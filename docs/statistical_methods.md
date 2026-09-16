# Statistical Methods

## Purpose

This document describes the statistical methods used in the Heart Failure Clinical Records project and explains how each method contributes to the broader analytical framework.

The project combines conventional clinical statistical analysis with an additional methodological focus on **digital patient representation and representation sensitivity**.

The statistical workflow is therefore not limited to identifying variables associated with mortality.

It also investigates:

> **How strongly do statistical conclusions depend on the amount and structure of digitally available patient information?**

The overall analytical framework is:

```text
Real Patient
    ↓
Digital Patient Representation
    ↓
Data Quality Assessment
    ↓
Descriptive Statistics
    ↓
Statistical Associations
    ↓
Multivariable Modeling
    ↓
Representation Sensitivity
    ↓
Statistical Reliability
    ↓
Potential Decision Implications
    ↓
Clinical Boundary
```

The project is exploratory and explanatory.

It is not intended to:

- establish causal relationships
- generate clinical treatment recommendations
- provide a validated mortality prediction tool
- define clinical thresholds
- prescribe healthcare-management decisions

All statistical results are interpreted within the informational limitations of the available dataset.

---

# 1. Analytical Principles

Several statistical principles are applied throughout the project.

## 1.1 Statistical Evidence Is Conditional on Available Data

Every statistical result is conditional on the digitally available representation of the patient.

The analysis therefore distinguishes between:

```text
Real Patient
```

and:

```text
Digital Patient Representation
```

A statistical model cannot directly evaluate patient characteristics that were never recorded.

This means that statistical uncertainty arises not only from sampling variation and model assumptions, but also from limitations in the information represented digitally.

---

## 1.2 Statistical Significance Is Not Clinical Importance

A statistically significant association does not automatically imply:

- clinical importance
- therapeutic relevance
- causality
- decision relevance
- generalizability
- patient-level actionability

Interpretation therefore considers:

- effect direction
- effect magnitude
- confidence intervals
- measurement scale
- consistency across methods
- adjustment for other variables
- sample size
- representation limitations
- clinical context

---

## 1.3 Association Is Not Causation

The dataset is observational.

Therefore, statistical associations cannot establish causal relationships.

Observed relationships may reflect:

- confounding
- selection effects
- measurement limitations
- unobserved patient characteristics
- treatment differences
- disease severity
- chance

Causal language is therefore avoided throughout the project.

---

## 1.4 Raw Statistical Results and Display Values

Where possible, statistical decisions are based on unrounded numerical results.

Rounding is intended only for presentation.

The preferred workflow is:

```text
Raw Result
    ↓
Statistical Decision
    ↓
Formatted Display Result
```

rather than:

```text
Rounded Result
    ↓
Statistical Decision
```

This prevents borderline p-values or other statistics from being misclassified because of numerical rounding.

---

# 2. Software Environment

The analysis is performed in **R**.

The project primarily uses:

- base R
- `stats`
- `ggplot2`

Base R functions are used for:

- descriptive statistics
- contingency tables
- hypothesis testing
- correlation analysis
- generalized linear models
- model comparison
- probability estimation
- sensitivity analysis

`ggplot2` is used for graphical exploration.

The project deliberately avoids unnecessarily complex software dependencies in order to keep the analytical workflow transparent and reproducible.

---

# 3. Data Structure

The dataset contains:

```text
299 patients
```

and includes:

```text
11 baseline patient characteristics
1 follow-up variable
1 mortality outcome
```

The primary outcome is:

```text
DEATH_EVENT
```

with:

```text
0 = No death event
1 = Death event
```

The available baseline patient characteristics are:

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

The variable:

```text
time
```

represents follow-up duration.

It is deliberately treated separately from baseline patient characteristics because it describes the observation period rather than the patient's baseline state.

---

# 4. Variable Types

Variables are classified according to their analytical structure.

## Continuous / Numerical Variables

Examples include:

```text
age
creatinine_phosphokinase
ejection_fraction
platelets
serum_creatinine
serum_sodium
time
```

These variables can be summarized using measures of:

- central tendency
- dispersion
- distribution
- range

and may be used in:

- group comparisons
- correlation analysis
- regression analysis

---

## Categorical Variables

Examples include:

```text
anaemia
diabetes
high_blood_pressure
sex
smoking
DEATH_EVENT
```

These variables are represented as factors with descriptive labels.

They are summarized using:

- frequencies
- percentages
- contingency tables

and may be evaluated using:

- Pearson chi-squared tests
- Fisher's exact tests
- logistic regression

---

# 5. Data Quality Assessment

Before statistical analysis, the dataset is evaluated for technical integrity.

The checks include:

- expected variable names
- unexpected variables
- dataset dimensions
- data types
- missing values
- `NaN` values
- infinite numerical values
- duplicated patient records
- categorical factor levels
- logically invalid numerical values
- constant variables
- unusual numerical observations

---

## Missing Values

For each variable:

```text
Missing Count
```

and:

```text
Missing Percentage
```

are calculated.

The original dataset contains no documented missing values.

Nevertheless, missing-value checks are performed explicitly because preprocessing or future datasets may introduce missing observations.

---

## Duplicate Observations

Complete duplicate rows are identified using:

```r
duplicated()
```

A duplicated row may indicate repeated data entry, although identical patient measurements do not automatically prove that two records represent the same individual.

The check therefore identifies potential duplicates rather than automatically deleting observations.

---

## Logical Plausibility

Basic logical constraints are evaluated.

Examples include:

```text
age > 0
```

```text
creatinine_phosphokinase >= 0
```

```text
0 <= ejection_fraction <= 100
```

```text
platelets >= 0
```

```text
serum_creatinine >= 0
```

```text
serum_sodium >= 0
```

```text
time >= 0
```

These rules identify logically impossible values.

They are not intended to define detailed medical reference ranges.

---

# 6. Identification of Unusual Numerical Observations

Potential statistical outliers are identified using the conventional **1.5 × IQR rule**.

For a numerical variable:

```text
IQR = Q3 - Q1
```

Potential lower outliers are observations below:

```text
Q1 - 1.5 × IQR
```

Potential upper outliers are observations above:

```text
Q3 + 1.5 × IQR
```

These observations are classified as statistical outliers only.

They are **not automatically treated as errors**.

In clinical datasets, unusual values may represent:

- severe disease
- unusual physiology
- high-risk patients
- valid extreme measurements

Therefore, observations are retained unless there is substantive evidence that they are invalid.

---

# 7. Descriptive Statistics

Descriptive statistics are used to characterize the observed patient population before inferential analysis.

For continuous variables, the project calculates:

- number of observations
- mean
- standard deviation
- median
- first quartile
- third quartile
- interquartile range
- minimum
- maximum

---

## Mean

For observations:

```text
x1, x2, ..., xn
```

the arithmetic mean is:

```text
x̄ = (1/n) Σ xi
```

The mean provides a measure of central tendency but may be strongly influenced by skewed distributions and extreme values.

---

## Median

The median represents the central observation after sorting the values.

It is more robust to:

- skewness
- extreme values
- asymmetric distributions

than the arithmetic mean.

For this reason, both mean and median are reported where appropriate.

---

## Standard Deviation

The sample standard deviation measures dispersion around the mean.

Conceptually:

```text
s = sqrt[ Σ(xi - x̄)² / (n - 1) ]
```

---

## Interquartile Range

The interquartile range is:

```text
IQR = Q3 - Q1
```

It describes the spread of the middle 50% of observations and is relatively robust to extreme values.

---

# 8. Descriptive Analysis of Categorical Variables

Categorical variables are summarized using:

```text
Absolute Frequency
```

and:

```text
Relative Frequency
```

For a category with count `k` in a sample of size `n`:

```text
Percentage = (k / n) × 100
```

These summaries describe the observed sample only.

They should not automatically be interpreted as population prevalence estimates.

---

# 9. Data Visualization

Graphical analysis is performed using `ggplot2`.

The visualizations include:

- histograms
- boxplots
- bar charts
- outcome-group comparisons

These visualizations help assess:

- distributional shape
- skewness
- extreme observations
- group differences
- categorical composition

Graphical interpretation complements formal statistical analysis.

It is not used as a substitute for inferential testing.

---

# 10. Mortality Outcome Groups

Patients are divided according to:

```text
DEATH_EVENT
```

into:

```text
No death event
```

and:

```text
Death event
```

Group comparisons are initially descriptive.

The objective is to examine whether demographic and clinical characteristics differ between patients with and without a recorded death event.

Follow-up duration is analyzed separately because it represents observation time rather than a baseline patient characteristic.

---

# 11. Continuous-Variable Group Comparisons

Continuous baseline characteristics are compared between mortality groups.

Depending on distributional characteristics and analytical context, either:

- Welch two-sample t-test
- Wilcoxon rank-sum test

is used.

---

# 12. Welch Two-Sample t-Test

The Welch two-sample t-test evaluates whether two independent groups differ in their mean values.

Unlike the classical Student t-test, Welch's test does not require equal group variances.

This makes it more robust when:

```text
Variance Group 1 ≠ Variance Group 2
```

The null hypothesis is:

```text
H0: μ1 = μ2
```

The alternative hypothesis is:

```text
H1: μ1 ≠ μ2
```

The test statistic can be expressed as:

```text
t =
(x̄1 - x̄2)
/
sqrt(
s1²/n1 + s2²/n2
)
```

Welch-adjusted degrees of freedom are used.

The test is applied when comparison of group means is considered appropriate.

---

# 13. Wilcoxon Rank-Sum Test

The Wilcoxon rank-sum test provides a non-parametric comparison of two independent groups.

Rather than relying directly on means and standard deviations, it compares the ranks of observations.

It is useful when variables show:

- substantial skewness
- extreme values
- distributions that make mean-based comparison less appropriate

The test evaluates whether the distributions of the two groups differ systematically.

The project does not automatically interpret the Wilcoxon test as strictly a test of medians unless additional assumptions justify that interpretation.

---

# 14. Categorical Group Comparisons

Categorical patient characteristics are compared with mortality outcome using contingency tables.

Depending on expected cell counts, the project uses:

- Pearson chi-squared test
- Fisher's exact test

---

# 15. Pearson Chi-Squared Test

The Pearson chi-squared test evaluates whether two categorical variables are statistically independent.

The test statistic is:

```text
χ² = Σ (Observed - Expected)² / Expected
```

The null hypothesis is:

```text
H0:
The categorical patient characteristic and mortality outcome
are independent.
```

The alternative hypothesis is:

```text
H1:
There is an association between the categorical patient
characteristic and mortality outcome.
```

---

# 16. Fisher's Exact Test

When contingency-table expected frequencies are too small for reliable chi-squared approximation, Fisher's exact test is used.

Fisher's test calculates an exact probability under the null hypothesis rather than relying on an asymptotic approximation.

This is particularly useful for relatively small samples or sparse contingency tables.

---

# 17. Cramér's V

For categorical associations, effect magnitude may additionally be summarized using **Cramér's V**.

Conceptually:

```text
V =
sqrt[
χ² /
(
n × min(r - 1, c - 1)
)
]
```

where:

```text
χ² = chi-squared statistic
n  = sample size
r  = number of rows
c  = number of columns
```

Cramér's V ranges approximately between:

```text
0 and 1
```

with larger values indicating stronger categorical association.

It is interpreted as an association measure rather than evidence of causality.

---

# 18. Multiple Hypothesis Testing

Testing many patient characteristics simultaneously increases the probability of false-positive findings.

If each hypothesis is tested independently at:

```text
α = 0.05
```

the probability of obtaining at least one statistically significant result by chance increases as the number of tests grows.

To address this problem, the project uses the **Benjamini-Hochberg procedure** for the primary family of mortality-group hypothesis tests.

---

# 19. Benjamini-Hochberg False Discovery Rate Adjustment

The Benjamini-Hochberg procedure controls the expected **false discovery rate** rather than the probability of any false positive.

Suppose the ordered raw p-values are:

```text
p(1) ≤ p(2) ≤ ... ≤ p(m)
```

where:

```text
m = number of tests
```

The procedure compares ordered p-values with thresholds based on:

```text
(i / m) × α
```

The project reports both:

```text
Raw p-value
```

and:

```text
BH-adjusted p-value
```

The adjusted results are used as the primary inferential evidence for the multiple mortality-group comparisons.

This provides a balance between:

- false-positive control
- statistical power

that is appropriate for an exploratory project examining several patient characteristics.

---

# 20. Statistical Significance Threshold

Unless otherwise stated, the nominal significance level is:

```text
α = 0.05
```

A result may therefore be described as statistically supported when:

```text
p < 0.05
```

or, for analyses using false-discovery-rate correction:

```text
BH-adjusted p < 0.05
```

This threshold is a conventional statistical decision rule.

It is not a threshold for clinical importance.

---

# 21. Correlation Analysis

Relationships between continuous variables are evaluated using **Spearman rank correlation**.

Spearman correlation is preferred over Pearson correlation for the primary pairwise analysis because several clinical variables exhibit:

- skewed distributions
- extreme observations
- potentially non-linear but monotonic relationships

---

# 22. Spearman Rank Correlation

Spearman's correlation coefficient is commonly written as:

```text
ρ
```

and ranges between:

```text
-1 ≤ ρ ≤ 1
```

Interpretation:

```text
ρ > 0
```

indicates a positive monotonic relationship.

```text
ρ < 0
```

indicates a negative monotonic relationship.

```text
ρ ≈ 0
```

indicates limited monotonic association.

The analysis ranks correlations according to their absolute magnitude for descriptive interpretation.

Pairwise correlation p-values are treated as **exploratory evidence** rather than the primary inferential findings of the project.

The main inferential conclusions are based on the explicitly defined group-testing and regression stages.

Correlation does not establish causation.

---

# 23. Logistic Regression

The primary multivariable outcome model uses **binary logistic regression** because:

```text
DEATH_EVENT
```

is binary.

Let:

```text
p = probability of a recorded death event
```

The logistic model is:

```text
log(
p / (1 - p)
)
=
β0
+
β1X1
+
β2X2
+
...
+
βkXk
```

The left side is the log-odds of the outcome.

---

# 24. Odds Ratios

Regression coefficients are exponentiated:

```text
OR = exp(β)
```

to obtain odds ratios.

Interpretation:

```text
OR > 1
```

indicates higher estimated odds of the outcome as the predictor increases or relative to the reference category.

```text
OR < 1
```

indicates lower estimated odds.

```text
OR = 1
```

indicates no estimated difference in odds.

Odds ratios are interpreted relative to the measurement unit of each variable.

For example:

```text
age
```

is interpreted per additional year.

```text
ejection_fraction
```

is interpreted per one-percentage-point increase.

```text
serum_creatinine
```

is interpreted per 1 mg/dL increase.

Measurement scale is therefore essential when interpreting effect magnitude.

---

# 25. Univariable Logistic Regression

Each baseline patient characteristic is initially analyzed individually.

Conceptually:

```text
DEATH_EVENT ~ X
```

For every predictor, the analysis reports:

- regression coefficient
- standard error
- odds ratio
- 95% confidence interval
- p-value

Univariable associations are unadjusted.

They may therefore reflect:

- confounding
- correlated patient characteristics
- disease severity
- other unmeasured factors

They should not be interpreted as independent effects.

---

# 26. Multivariable Logistic Regression

The complete available baseline representation is evaluated using a multivariable logistic regression model.

The included variables are:

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

The model can be represented as:

```text
DEATH_EVENT
~
age
+
anaemia
+
creatinine_phosphokinase
+
diabetes
+
ejection_fraction
+
high_blood_pressure
+
platelets
+
serum_creatinine
+
serum_sodium
+
sex
+
smoking
```

The purpose of multivariable analysis is to examine whether an association remains after accounting for the other **available** baseline characteristics.

The word "available" is important.

Adjustment can only occur for variables represented in the dataset.

Therefore:

```text
Adjusted Association
```

does not mean:

```text
Fully Controlled Causal Effect
```

Unmeasured confounding remains possible.

---

# 27. Why Follow-Up Time Is Excluded From the Baseline Regression

The variable:

```text
time
```

represents follow-up duration.

It is not treated as an ordinary baseline patient characteristic.

Including follow-up time directly as a conventional baseline predictor in the logistic mortality model would mix:

```text
Patient State
```

with:

```text
Observation Process
```

The primary logistic model therefore excludes `time`.

However, this creates an important limitation:

> Logistic regression models whether a death event occurred, but does not explicitly model when it occurred.

This motivates the distinction between binary mortality modeling and time-to-event analysis.

---

# 28. Confidence Intervals

Approximate 95% confidence intervals for logistic regression coefficients are calculated using:

```text
β ± 1.96 × SE
```

For odds ratios, the interval is exponentiated:

```text
Lower CI =
exp(
β - 1.96 × SE
)
```

```text
Upper CI =
exp(
β + 1.96 × SE
)
```

Confidence intervals provide information about uncertainty around the estimated association.

Wide intervals indicate greater uncertainty.

---

# 29. Model Fit

Model fit is evaluated using several complementary statistics.

These include:

- Akaike Information Criterion
- residual deviance
- McFadden pseudo-R²
- Brier score

No single statistic is interpreted as a complete measure of model quality.

---

# 30. Akaike Information Criterion

The Akaike Information Criterion is:

```text
AIC = -2 log(L) + 2k
```

where:

```text
L = maximized likelihood
k = number of estimated parameters
```

AIC balances:

- model fit
- model complexity

When comparing models fitted to the same outcome and observations:

```text
Lower AIC
```

indicates a more favorable balance between fit and complexity.

AIC does not measure clinical usefulness.

---

# 31. Deviance

For generalized linear models, deviance reflects discrepancy between the fitted model and a saturated model.

The project considers:

```text
Residual Deviance
```

Lower residual deviance generally indicates improved fit when models are comparable.

Differences in deviance can also be used for nested likelihood-ratio model comparisons.

---

# 32. McFadden Pseudo-R²

For logistic regression, ordinary linear-model R² is not directly applicable.

The project therefore uses **McFadden pseudo-R²** as one descriptive measure of relative model fit.

It is calculated as:

```text
McFadden R²
=
1 -
[
logLik(fitted model)
/
logLik(null model)
]
```

The null model contains only an intercept.

Higher values indicate greater improvement relative to the null model.

McFadden pseudo-R² should not be interpreted in the same way as R² from ordinary linear regression.

---

# 33. Brier Score

The Brier score evaluates the squared difference between predicted probabilities and observed binary outcomes.

For `n` patients:

```text
Brier Score
=
(1/n)
Σ
(pi - yi)²
```

where:

```text
pi = predicted probability
yi = observed outcome coded 0 or 1
```

Interpretation:

```text
Lower Brier Score
```

indicates smaller average squared probability error.

In this project, Brier scores are calculated **in sample**.

They therefore describe model behavior within the analyzed dataset and are not interpreted as externally validated predictive performance.

---

# 34. Digital Patient Representation Sensitivity Analysis

A central methodological extension of the project is the explicit evaluation of how statistical results change when the amount of digitally available patient information changes.

Four nested baseline representations are defined.

---

# 35. Representation Layer 1 — Basic Demographics

Layer 1 contains:

```text
age
sex
```

This is the most information-reduced representation used in the analysis.

It represents the patient through basic demographic information only.

---

# 36. Representation Layer 2 — Demographics, Comorbidities and Risk Factors

Layer 2 contains:

```text
age
sex
anaemia
diabetes
high_blood_pressure
smoking
```

It adds selected comorbidities and behavioral risk information.

---

# 37. Representation Layer 3 — Expanded Clinical Representation

Layer 3 contains:

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

It adds selected information on:

- cardiac function
- renal status
- biochemical status

---

# 38. Representation Layer 4 — Full Available Baseline Representation

Layer 4 contains:

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

This uses all baseline patient characteristics available in the dataset.

Importantly:

> **Layer 4 represents the full available dataset representation, not the complete real-world patient.**

Formally:

```text
P(full available digital)
≠
P(real patient)
```

---

# 39. Nested Representation Models

A separate logistic regression model is fitted for each representation layer.

Conceptually:

```text
Layer 1
    ↓
Model 1

Layer 2
    ↓
Model 2

Layer 3
    ↓
Model 3

Layer 4
    ↓
Model 4
```

The patient population and mortality outcome remain the same.

Only the information available to the model changes.

This creates a controlled framework for investigating information dependence.

---

# 40. Sequential Information Addition

The nested representation models are compared sequentially:

```text
Layer 1 vs Layer 2
```

```text
Layer 2 vs Layer 3
```

```text
Layer 3 vs Layer 4
```

This allows the project to investigate whether adding new patient-information domains meaningfully changes statistical model fit.

---

# 41. Likelihood-Ratio Tests

Nested representation models are compared using likelihood-ratio tests.

The test compares the likelihoods of two nested models.

Conceptually:

```text
D =
-2[
logLik(reduced model)
-
logLik(expanded model)
]
```

Under standard assumptions, the difference can be compared with a chi-squared distribution using degrees of freedom corresponding to the number of additional model parameters.

The null hypothesis is approximately:

```text
The added variables do not improve model fit.
```

The alternative is:

```text
The expanded representation improves model fit.
```

These tests evaluate **statistical model improvement**.

They do not establish that the additional variables are:

- clinically necessary
- causally related to mortality
- sufficient for real-world decisions

---

# 42. Coefficient Stability

Representation sensitivity is also evaluated through changes in regression coefficients.

If a variable is available across several representation layers, its estimated coefficient and odds ratio can be compared as additional patient information is introduced.

Conceptually:

```text
OR(X | limited information)
```

versus:

```text
OR(X | richer information)
```

Changes may indicate that the estimated association depends on the broader patient context represented in the model.

This is particularly relevant to variables such as:

```text
age
sex
```

which are included in all four representation layers.

Coefficient stability is interpreted as a statistical property.

It does not establish causal robustness.

---

# 43. Patient-Level Predicted Probabilities

Each representation model produces an in-sample predicted probability of a recorded death event for every patient.

For patient `i`:

```text
p_i =
P(DEATH_EVENT = 1 | represented patient information)
```

The same patient therefore receives several probabilities:

```text
p_i(Layer 1)
p_i(Layer 2)
p_i(Layer 3)
p_i(Layer 4)
```

Because the patient remains the same, differences between these probabilities reflect changes in the digital information available to the statistical model.

---

# 44. Mean Absolute Probability Difference

Reduced representation models are compared with the full available representation.

For each patient:

```text
Absolute Difference
=
|p(reduced) - p(full)|
```

The average is:

```text
Mean Absolute Probability Difference
=
(1/n)
Σ
|p_i(reduced) - p_i(full)|
```

This provides a direct measure of patient-level representation sensitivity.

Higher values indicate larger average changes in model output after information reduction.

---

# 45. Root Mean Squared Probability Difference

A second probability-sensitivity measure is:

```text
RMS Difference
=
sqrt[
(1/n)
Σ
(
p_i(reduced)
-
p_i(full)
)²
]
```

Compared with the mean absolute difference, this measure places greater weight on large individual changes.

---

# 46. Maximum Absolute Probability Difference

The maximum observed patient-level difference is:

```text
max
|p_i(reduced) - p_i(full)|
```

This identifies the largest model-output change observed for any individual patient.

It is descriptive and does not by itself indicate clinical importance.

---

# 47. Spearman Correlation of Predicted Probabilities

Predicted probabilities from reduced representations are compared with the full representation using Spearman rank correlation.

This evaluates whether patients remain similarly ordered by the different models.

A high correlation may indicate broadly similar ranking.

However:

```text
High Correlation
```

does not imply:

```text
Identical Probabilities
```

Two models may rank patients similarly while assigning substantially different absolute probability estimates.

---

# 48. Illustrative Reclassification

To demonstrate how representation changes can affect a discrete analytical output, the project uses an illustrative probability threshold:

```text
0.50
```

Patients are classified as:

```text
Lower model probability
```

or:

```text
Higher model probability
```

The project then calculates how often reduced patient representations produce a different category from the full representation.

---

## Reclassification Rate

The reclassification percentage is:

```text
Reclassification Rate
=
(Number of changed classifications / N)
× 100
```

This experiment is purely methodological.

The `0.50` threshold is:

- not a clinical mortality threshold
- not a treatment threshold
- not a triage threshold
- not a resource-allocation threshold
- not externally validated

The purpose is to illustrate:

```text
Same Patient
    +
Different Available Information
    ↓
Potentially Different Model Output
```

---

# 49. Information Loss Through Dichotomization

The project additionally examines how statistical results change when a continuous clinical variable is simplified into a binary representation.

The selected example is:

```text
ejection_fraction
```

The original representation preserves continuous information:

```text
31
32
33
34
...
```

The simplified representation reduces the variable to:

```text
Lower or equal to median
```

versus:

```text
Higher than median
```

The sample median is used deliberately as a neutral methodological cutoff.

It is not interpreted as a clinical threshold.

---

# 50. Continuous vs Dichotomized Models

Two otherwise comparable models are fitted.

## Continuous Model

```text
DEATH_EVENT
~
full baseline variables
including continuous ejection fraction
```

## Dichotomized Model

```text
DEATH_EVENT
~
full baseline variables
with ejection fraction replaced by a binary group
```

The models are compared using:

- AIC
- residual deviance
- McFadden pseudo-R²
- Brier score
- patient-level probability differences
- illustrative reclassification

This allows the project to investigate the statistical consequences of reducing numerical information.

---

# 51. Interpretation of Dichotomization

Dichotomization can make variables easier to:

- communicate
- operationalize
- categorize
- use in simple rule systems

However, it may also remove information.

For example:

```text
EF = 31%
```

and:

```text
EF = 39%
```

may become identical after categorization even though the original measurements differ.

The project therefore evaluates the trade-off between:

```text
Simplification
```

and:

```text
Information Preservation
```

without claiming that continuous variables should never be categorized.

The appropriateness of categorization depends on the clinical and decision context.

---

# 52. Cross-Method Evidence

The final analytical stage compares evidence across several statistical approaches.

These include:

```text
BH-adjusted mortality-group comparison
```

```text
Univariable logistic regression
```

```text
Multivariable logistic regression
```

A patient characteristic is considered more **internally consistent within this dataset** when evidence appears across several analytical approaches.

This consistency is not interpreted as a causal proof or clinical ranking.

---

# 53. Why Methods May Produce Different Results

Different statistical methods answer different questions.

For example:

## Group Comparison

asks:

> Do observed values differ between mortality groups?

## Univariable Regression

asks:

> Is this patient characteristic individually associated with mortality odds?

## Multivariable Regression

asks:

> Is the characteristic associated with mortality odds after accounting for other available baseline variables?

Therefore:

```text
Significant in one method
```

and:

```text
Not significant in another method
```

are not necessarily contradictory.

The difference may reflect:

- confounding
- adjustment
- measurement scale
- sampling variability
- correlations between predictors
- different statistical assumptions

---

# 54. Representation Sensitivity Is Not Clinical Validation

The representation sensitivity analysis evaluates:

```text
Statistical Dependence on Available Information
```

It does not determine:

```text
Clinical Sufficiency
```

If adding a variable improves model fit, this does not prove that the variable is medically essential.

Likewise, if removing a variable produces only a small statistical change, this does not prove that the variable is medically unimportant.

Clinical relevance requires additional evidence.

---

# 55. In-Sample Evaluation

The representation models are evaluated using the same dataset in which they are fitted.

Therefore:

```text
Model Fitting Sample
=
Model Evaluation Sample
```

This is an important limitation.

In-sample measures may appear more favorable than performance in new patients.

The project therefore does not interpret:

- Brier score
- predicted probabilities
- reclassification
- model-fit improvements

as evidence of externally validated predictive performance.

Future extensions could include:

- cross-validation
- bootstrap validation
- temporal validation
- external validation

---

# 56. Sample Size and Model Complexity

The dataset contains:

```text
299 patients
```

with:

```text
96 recorded death events
```

The full baseline model includes multiple predictors.

This sample size limits:

- model complexity
- precision
- stability of some regression estimates
- confidence in patient-level prediction

The project therefore treats the regression models primarily as explanatory and methodological tools rather than deployable prediction systems.

---

# 57. Potential Multicollinearity

Clinical variables may contain overlapping information.

For example:

```text
different physiological measurements
```

may reflect related aspects of the patient's health state.

Multivariable coefficients are conditional on the other variables included in the model.

Therefore, coefficient changes after adjustment may partly reflect shared information between predictors.

The project does not interpret individual adjusted coefficients as isolated biological effects.

---

# 58. Functional Form Limitations

Continuous predictors enter the logistic models primarily through linear terms on the log-odds scale.

This assumes:

```text
log-odds change linearly with the predictor
```

unless otherwise modeled.

Real clinical relationships may be:

- non-linear
- threshold-dependent
- U-shaped
- interaction-dependent

The current project does not perform comprehensive flexible modeling of these functional forms.

This is an acknowledged limitation.

Future analyses could examine:

- splines
- polynomial terms
- generalized additive models
- clinically justified transformations

where appropriate.

---

# 59. Survival Analysis Considerations

The combination of:

```text
DEATH_EVENT
```

and:

```text
time
```

creates a time-to-event structure.

A dedicated mortality-time analysis could therefore use survival-analysis methods.

Potential methods include:

```text
Kaplan-Meier estimation
```

```text
log-rank testing
```

```text
Cox proportional hazards regression
```

These methods would explicitly account for follow-up duration.

The current project does not treat survival analysis as part of the primary workflow.

Instead, logistic regression is used to investigate the binary mortality outcome.

This methodological limitation is explicitly documented rather than ignored.

---

# 60. Kaplan-Meier Estimation as a Future Extension

For a time-to-event outcome, Kaplan-Meier estimation could be used to estimate:

```text
S(t)
=
P(T > t)
```

where:

```text
T = event time
```

and:

```text
S(t) = probability of remaining event-free beyond time t
```

The method can account for censoring.

This would allow mortality experience to be examined over time rather than only through a binary endpoint.

---

# 61. Cox Proportional Hazards Regression as a Future Extension

A Cox proportional hazards model could be written as:

```text
h(t | X)
=
h0(t)
×
exp(
β1X1
+
β2X2
+
...
+
βkXk
)
```

where:

```text
h(t | X)
```

is the hazard at time `t` conditional on covariates.

This would permit analysis of associations with the rate of the event over follow-up.

Such an extension would require evaluation of assumptions including proportional hazards.

It is not part of the current primary analysis.

---

# 62. Decision Context

The statistical methods provide information that could potentially contribute to healthcare decision support.

However, the project does not directly evaluate:

- resource allocation
- staffing
- hospital capacity
- treatment selection
- clinical prioritization
- quality interventions
- management policies

The dataset contains no direct management-intervention variables.

Therefore:

```text
Statistical Model Output
```

is interpreted as:

```text
Potential Decision Information
```

rather than:

```text
Validated Decision Rule
```

---

# 63. Statistical Reliability vs Decision Validity

The project distinguishes between:

```text
Statistical Reliability
```

and:

```text
Decision Validity
```

Statistical reliability concerns questions such as:

- Is the association statistically supported?
- How uncertain is the estimate?
- Does the result remain similar after adjustment?
- How sensitive is the model to information reduction?
- Does simplification materially change model outputs?

Decision validity additionally requires:

- appropriate target population
- clinically relevant outcomes
- adequate patient information
- justified decision thresholds
- understanding of error consequences
- evidence that the intervention improves outcomes
- organizational feasibility
- clinical validation

Therefore:

> **A statistically reliable model is not automatically a valid healthcare decision system.**

---

# 64. Statistical Reliability vs Clinical Validity

Likewise:

```text
Statistical Reliability
≠
Clinical Validity
```

Statistics can determine whether an association exists within the available data.

Statistics alone cannot determine whether:

- an omitted variable is medically essential
- a difference is clinically important
- treatment should change
- a patient requires an intervention
- a management decision is medically appropriate

These questions require clinical knowledge and additional evidence.

---

# 65. Interpretation of p-Values

A p-value describes how compatible the observed data are with the null hypothesis under the assumptions of the statistical model.

It is not:

- the probability that the null hypothesis is true
- the probability that the result occurred by chance
- the probability that an association is clinically important
- a measure of effect magnitude

A small p-value therefore provides evidence against a specified null hypothesis but should always be interpreted together with effect size, uncertainty, and context.

---

# 66. Interpretation of Confidence Intervals

Confidence intervals provide information about the range of parameter values compatible with the observed data under the statistical model.

They help assess:

- precision
- uncertainty
- possible effect magnitude

A narrow interval generally indicates greater statistical precision.

A wide interval indicates greater uncertainty.

Confidence intervals do not eliminate:

- bias
- confounding
- model misspecification
- representation limitations

---

# 67. Interpretation of Effect Magnitude

Effect magnitude is interpreted relative to the variable scale.

For example, an odds ratio close to:

```text
1.00
```

may appear small when expressed per one measurement unit.

However, if the measurement range spans hundreds or thousands of units, the cumulative association across a meaningful range may differ substantially.

Therefore:

> **Odds ratios should never be interpreted independently of the measurement unit.**

---

# 68. Reproducibility

The analytical workflow is divided into sequential R scripts.

The methodological sequence is:

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

The scripts are designed to make each analytical stage explicit.

This modular structure allows:

- individual methods to be inspected
- results to be reproduced
- future datasets to reuse the same general framework
- analytical assumptions to remain transparent

---

# 69. Methodological Blueprint for Future Projects

The specific methods used in future projects may differ according to:

- outcome type
- dataset structure
- sample size
- repeated measurements
- follow-up structure
- variable distributions
- clinical context

However, the general methodological framework is intended to remain stable.

```text
1. Define the patient population

2. Identify the digital patient representation

3. Evaluate technical data quality

4. Identify representation gaps

5. Describe the patient population statistically

6. Explore distributions visually

7. Compare clinically relevant groups

8. Perform appropriate inferential tests

9. Adjust for multiple testing where necessary

10. Examine relationships between variables

11. Build an appropriate multivariable model

12. Evaluate uncertainty and model fit

13. Reduce or modify the patient representation

14. Measure representation sensitivity

15. Evaluate information loss

16. Examine patient-level model changes

17. Define potential decision implications

18. Explicitly state the clinical boundary
```

The exact statistical method should always be chosen according to the structure of the data rather than forcing all datasets into the same model.

---

# 70. Core Methodological Principles

The statistical methodology of the project can be summarized through the following principles.

### Principle 1

> **Understand the patient representation before modeling the outcome.**

### Principle 2

> **Technical data quality and representational adequacy are different concepts.**

### Principle 3

> **Use descriptive statistics before inferential statistics.**

### Principle 4

> **Choose tests according to variable structure and empirical distribution.**

### Principle 5

> **Correct for multiple testing when several related hypotheses are evaluated.**

### Principle 6

> **Report effect estimates and uncertainty rather than relying only on p-values.**

### Principle 7

> **Separate unadjusted from adjusted associations.**

### Principle 8

> **Do not interpret statistical associations as causal effects.**

### Principle 9

> **Evaluate how statistical conclusions depend on the available patient representation.**

### Principle 10

> **Treat information reduction as an analytical intervention that may change model output.**

### Principle 11

> **Do not interpret in-sample probabilities as externally validated clinical predictions.**

### Principle 12

> **Statistical reliability does not establish clinical validity.**

---

# 71. Final Methodological Interpretation

The project begins as a conventional statistical analysis of clinical patient records but extends beyond ordinary descriptive and regression-based healthcare analytics.

The conventional workflow evaluates:

```text
What patterns exist in the available data?
```

The representation sensitivity framework adds a second question:

```text
How dependent are these patterns on the way the patient is digitally represented?
```

This distinction is important because a statistical model only has access to recorded information.

The full methodological chain is therefore:

```text
Real Patient
    ↓
Digital Patient Representation
    ↓
Data Quality
    ↓
Descriptive Statistics
    ↓
Group Comparisons
    ↓
Hypothesis Testing
    ↓
Correlation Analysis
    ↓
Regression Modeling
    ↓
Representation Sensitivity
    ↓
Information-Loss Analysis
    ↓
Statistical Reliability
    ↓
Potential Decision Support
    ↓
Clinical Boundary
```

The project therefore treats statistical modeling as one component of a broader healthcare-data problem.

The central methodological conclusion is:

> **The reliability of data-driven healthcare conclusions depends not only on which statistical model is used, but also on what information about the patient was digitally available to that model and how that information was represented.**

This methodological framework is intended to serve as a reusable blueprint for future analyses involving different patient populations, diseases, outcomes, and healthcare datasets.