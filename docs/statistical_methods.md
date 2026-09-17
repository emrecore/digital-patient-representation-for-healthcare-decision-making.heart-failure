# Statistical Methods

## Analytical Approach

This project uses a structured statistical workflow to analyze heart-failure patient data and evaluate how statistical outputs depend on the available digital patient representation.

The analytical sequence is:

```text
Data Import and Setup
        ↓
Patient Representation and Data Quality
        ↓
Descriptive Statistics
        ↓
Data Visualization
        ↓
Descriptive Outcome-Group Comparisons
        ↓
Formal Hypothesis Testing
        ↓
Exploratory Correlation Analysis
        ↓
Logistic Regression Analysis
        ↓
Representation Sensitivity Analysis
        ↓
Final Synthesis and Interpretation
```

The workflow deliberately separates:

```text
Description
≠
Exploration
≠
Formal Group-Level Inference
≠
Regression Association Modeling
≠
Representation Sensitivity
```

This separation is important because the corresponding statistical outputs do not represent interchangeable forms of evidence.

---

# Core Computational Principle

Throughout the project:

> **Statistical calculations are performed using unrounded values.**

Rounding and formatting are applied only when results are prepared for display.

The general rule is:

```text
Raw Values
    ↓
Statistical Calculation
    ↓
Unrounded Analytical Result
    ↓
Presentation Formatting
```

Inferential decisions are therefore never made from rounded p-values, coefficients, confidence intervals, or model-fit measures.

---

# 1. Data Import and Analytical Configuration

The source dataset is imported from:

```text
data/heart_failure_clinical_records_dataset.csv
```

Two objects are maintained:

```text
heart_failure_raw
```

and:

```text
heart_failure
```

`heart_failure_raw` preserves the imported source data.

`heart_failure` is the configured analytical dataset used throughout the subsequent workflow.

This separation allows the project to distinguish between:

```text
Source Data
```

and:

```text
Configured Analytical Representation
```

---

## Variable Structure

The variables are separated into three analytical categories.

### Baseline Patient Characteristics

Numerical:

* `age`
* `creatinine_phosphokinase`
* `ejection_fraction`
* `platelets`
* `serum_creatinine`
* `serum_sodium`

Categorical:

* `anaemia`
* `diabetes`
* `high_blood_pressure`
* `sex`
* `smoking`

### Observation Information

* `time`

### Outcome

* `DEATH_EVENT`

This separation is retained throughout the analytical workflow.

Follow-up duration is not treated as a baseline patient characteristic, and the recorded death-event outcome is not treated as part of the baseline patient representation.

---

# 2. Technical Data-Quality Assessment

Technical data quality is evaluated separately from patient representation.

The audit includes:

* expected dataset structure
* unexpected variables
* duplicate column names
* original binary source coding
* configured variable classes
* configured categorical factor levels
* missing values
* exact duplicate records
* non-finite numerical values
* broad logical plausibility
* constant variables
* potential numerical outliers

These checks evaluate the information that is actually present in the dataset.

They do not establish whether the available variables provide a clinically sufficient patient representation.

---

## Binary Source Coding

Binary variables are validated against the expected source coding:

```text
0 / 1
```

before factor conversion.

This includes:

* anaemia
* diabetes
* high blood pressure
* smoking
* sex
* recorded death-event outcome

Unexpected or non-numeric source codes cause the workflow to stop.

---

## Missingness

Missing values are examined in both:

```text
heart_failure_raw
```

and:

```text
heart_failure
```

This provides a check that analytical configuration has not unintentionally introduced additional missing values.

---

## Exact Duplicate Records

Exact duplicate rows are identified using the available source variables.

Because the distributed dataset does not contain a unique patient identifier:

> **an exact duplicate row is not automatically interpreted as a confirmed duplicate patient.**

The analysis therefore refers to:

```text
exact duplicate records
```

rather than:

```text
duplicate patients
```

---

## Logical Plausibility

Broad logical checks are applied to numerical variables.

Examples include:

* age > 0
* ejection fraction between 0 and 100
* laboratory values ≥ 0
* follow-up duration ≥ 0

These are basic logical checks.

They are not comprehensive clinical reference-range assessments.

---

## Potential Numerical Outliers

Potential numerical outliers are identified using the conventional:

```text
1.5 × IQR rule
```

For each numerical variable:

```text
Lower Bound = Q1 − 1.5 × IQR
Upper Bound = Q3 + 1.5 × IQR
```

Observations outside these bounds are flagged for inspection.

They are:

* not automatically treated as errors
* not automatically removed
* not automatically considered clinically implausible

---

# 3. Patient Representation Assessment

The project separately maps broad patient-information domains as:

* Partial
* Very limited
* Not represented

This representation map is qualitative and project-defined.

It is not a:

* validated representation-quality scale
* completeness score
* clinical adequacy rating
* quantitative Representation Gap metric

The methodological distinction is:

```text
Technical Data Quality
        ↓
How usable is the information that is present?

Patient Representation
        ↓
What patient information is available to the analysis?
```

The detailed conceptual framework is documented in:

```text
docs/patient_representation.md
```

---

# 4. Descriptive Statistics

Descriptive statistics characterize the observed analytical sample before formal inference.

Baseline patient characteristics, observation information, and outcome information are summarized separately.

---

## Numerical Variables

Numerical variables are summarized using:

* total sample size
* number observed
* number missing
* mean
* standard deviation
* median
* first quartile
* third quartile
* interquartile range
* minimum
* maximum

Both mean-based and distribution-based summaries are retained because several clinical variables are not expected to be adequately characterized by one location statistic alone.

---

## Categorical Variables

Categorical variables are summarized using:

* counts
* percentages
* observed denominator
* missing-value count

Percentages are calculated among observations with an available value for the corresponding variable.

---

## Observation Information

Follow-up duration is summarized separately from baseline patient characteristics.

This reflects its role as:

> **observation information**

rather than baseline patient information.

---

## Recorded Death-Event Outcome

The binary outcome is summarized using:

* number with no recorded death event
* number with a recorded death event
* corresponding sample percentages

Because follow-up duration differs between patients, the observed recorded-death-event percentage is treated only as a property of the dataset.

It is not interpreted as:

* population mortality
* fixed-horizon mortality risk
* individual mortality probability
* a survival estimate

---

# 5. Data Visualization

`ggplot2` is used for descriptive visualization.

The project includes:

* histograms for baseline numerical characteristics
* boxplots for baseline numerical characteristics
* bar plots for baseline categorical characteristics
* separate plots of follow-up duration
* a separate bar plot of recorded death-event status
* baseline numerical boxplots according to recorded death-event status

The plots are descriptive.

Visual patterns do not establish:

* statistical significance
* causality
* prognostic importance
* clinical importance

Observations beyond boxplot whiskers are not automatically interpreted as data errors.

The figures generated in the analytical workflow are exploratory project visualizations rather than publication-formatted figures.

---

# 6. Descriptive Outcome-Group Comparisons

Baseline patient characteristics are compared descriptively according to:

```text
No recorded death event
```

and:

```text
Death event recorded
```

The groups refer to recorded outcome status during each patient's available follow-up.

Because follow-up durations differ:

> **these are not fixed-horizon mortality or survival groups.**

---

## Numerical Characteristics

For each baseline numerical characteristic, the project reports group-specific:

* mean
* standard deviation
* median
* Q1
* Q3
* IQR
* minimum
* maximum

Raw differences are calculated as:

```text
Death event recorded
−
No recorded death event
```

for both:

* means
* medians

These differences are descriptive.

They are not standardized and are not ranked across variables with different measurement scales.

---

## Categorical Characteristics

Categorical characteristics are summarized using:

* counts
* within-group percentages

Follow-up duration is summarized separately from baseline characteristics.

Formal inference is not performed in this stage.

---

# 7. Formal Baseline Group-Level Hypothesis Testing

Formal group-level inference is performed in:

```text
06_hypothesis_testing.R
```

The testing family is limited to baseline patient characteristics.

Follow-up duration is not part of this family.

---

# Numerical Test Plan

The numerical test allocation is defined explicitly.

It is not automatically selected using a normality-test rule.

## Welch Two-Sample t-Test

Used for:

* `age`
* `serum_sodium`

Welch's two-sample t-test compares group means without requiring equal group variances.

The reported difference direction is:

```text
Death event recorded
−
No recorded death event
```

Approximate 95% confidence intervals are retained.

---

## Wilcoxon Rank-Sum Test

Used for:

* `creatinine_phosphokinase`
* `ejection_fraction`
* `platelets`
* `serum_creatinine`

These variables are evaluated with a rank-based method because of characteristics such as:

* skew
* discreteness
* influential extreme observations

The allocation is project-specific.

It is not intended as a universal statistical rule for these clinical variables.

The Wilcoxon analysis reports:

* group medians
* observed median difference
* rank-sum statistic
* location-shift estimate
* corresponding confidence interval
* p-value

The location-shift estimate returned by the test is not interpreted as the simple difference between the two observed sample medians.

---

# Categorical Association Tests

Associations between baseline categorical characteristics and recorded death-event status are evaluated using contingency tables.

The project first calculates Pearson expected cell counts.

### Pearson Chi-Squared Test

Used when:

```text
minimum expected cell count ≥ 5
```

### Fisher's Exact Test

Used when at least one expected cell count is:

```text
< 5
```

This provides a deterministic test-selection rule.

---

## Cramér's V

Categorical association magnitude is summarized using:

```text
Cramér's V
```

Cramér's V is calculated from the Pearson chi-squared statistic and reported separately from the selected p-value procedure.

It is treated as a descriptive measure of categorical association magnitude.

Statistical significance and association magnitude are not treated as equivalent concepts.

---

# 8. Multiple-Testing Adjustment

The formal baseline group comparisons form one predefined multiple-testing family.

This family contains one primary test for each baseline characteristic.

The project applies the:

> **Benjamini-Hochberg procedure**

to control the false discovery rate.

For each baseline comparison, both are retained:

* raw p-value
* BH-adjusted p-value

The primary formal group-level inference uses:

```text
BH-adjusted p-value < 0.05
```

Raw p-values are retained for transparency.

Therefore:

> **BH-adjusted results from script 06 represent the project's primary formal baseline group-level inferential criterion.**

This distinction becomes important when later regression p-values are interpreted.

---

# 9. Exploratory Correlation Analysis

Relationships among continuous baseline patient characteristics are explored using:

> **Spearman rank correlation**

Only numerical baseline patient characteristics are included.

Excluded are:

* `time`
* `DEATH_EVENT`

because the correlation stage is intended to characterize relationships among baseline numerical patient information only.

---

## Pairwise Analysis

For every unique variable pair, the analysis retains:

* number of complete finite observation pairs
* Spearman's rho
* absolute Spearman correlation
* exploratory p-value

A pairwise sample-size matrix is also created.

---

## Ranking

Correlations are ranked using:

```text
absolute unrounded Spearman rho
```

The three strongest observed relationships are selected for descriptive visualization.

This ranking describes observed statistical correlation magnitude only.

It does not rank:

* clinical importance
* prognostic importance
* causal relevance
* representation importance

---

## Inferential Status

Correlation p-values are:

> **exploratory**

They are not treated as a second primary multiple-testing family and are not used to select variables for regression.

No regression variable is included or excluded based on script 07.

Spearman correlation does not establish causality.

---

# 10. Logistic Regression Analysis

Binary logistic regression is used to examine associations between available baseline patient characteristics and:

```text
DEATH_EVENT
```

The modeled event is:

```text
Death event recorded
```

with:

```text
No recorded death event
```

as the outcome reference level.

The models therefore estimate associations with whether a death event was recorded during each patient's observed follow-up period.

---

# Follow-Up Limitation

The dataset contains variable follow-up duration.

The logistic models do not model:

* event timing
* censoring structure
* survival functions
* standardized follow-up horizons

Therefore, they must not be interpreted as:

* validated fixed-horizon mortality-risk models
* survival models
* clinically validated prediction models

The original time-to-event structure remains an important interpretation limitation.

---

# Predictor Set

The logistic regression analyses use:

> **baseline patient characteristics only**

Follow-up duration is excluded.

The full multivariable model includes the complete available baseline variable set.

Variable inclusion is deliberately **not** based on:

* script 06 hypothesis-test p-values
* script 07 correlations
* univariable regression p-values

This avoids constructing the full model through post hoc significance screening.

---

# 11. Univariable Logistic Regression

Each baseline patient characteristic is analyzed separately.

For each model term, the project reports:

* regression coefficient
* standard error
* odds ratio
* approximate 95% Wald confidence interval
* nominal p-value
* analytical sample size

The confidence interval is calculated as:

```text
exp(
  coefficient ± 1.96 × standard error
)
```

For continuous variables, the odds ratio corresponds to:

> **a one-unit increase on the original measurement scale.**

For categorical variables, the odds ratio compares the modeled factor level with the documented reference level.

These models describe unadjusted statistical associations.

They do not establish causal effects.

---

# 12. Full Multivariable Logistic Regression

The full model includes all available baseline patient characteristics simultaneously.

The resulting coefficients and odds ratios represent:

> **associations conditional on the other baseline information represented in the model.**

The model reports:

* regression coefficient
* standard error
* odds ratio
* approximate 95% Wald confidence interval
* nominal p-value

These associations remain conditional on the information available in the dataset.

Unrepresented or unmeasured patient characteristics cannot be adjusted for by the model.

---

# Regression P-Values

Regression p-values are treated as:

> **nominal p-values**

A p-value below:

```text
0.05
```

is stored descriptively as:

```text
Nominal_P_Below_Alpha
```

It is deliberately not labeled simply as:

```text
Significant
```

Regression p-values are not combined with the BH-adjusted group tests into a single evidence score.

Therefore:

```text
BH-adjusted group-level inference
≠
nominal univariable regression evidence
≠
nominal multivariable regression evidence
```

---

# 13. In-Sample Model Evaluation

The full logistic regression model is summarized using:

* analytical sample size
* number excluded for missingness
* recorded outcome counts
* number of model parameters
* null deviance
* residual deviance
* AIC
* log-likelihood
* McFadden pseudo-R²
* in-sample Brier score
* model convergence

---

## McFadden Pseudo-R²

McFadden pseudo-R² is calculated as:

```text
1 − (
  Full Model Log-Likelihood
  /
  Null Model Log-Likelihood
)
```

It is a model-fit summary and is not interpreted as the proportion of outcome variance explained in the ordinary linear-regression sense.

---

## In-Sample Brier Score

The Brier score is calculated from:

```text
mean(
  (fitted probability − observed binary outcome)^2
)
```

using the same observations used to fit the model.

It is therefore explicitly labeled:

```text
In_Sample_Brier_Score
```

This distinction is intentional.

The project does not perform:

* cross-validation
* bootstrap validation
* external validation

Consequently, model-fit statistics and fitted probabilities describe:

> **in-sample model behavior**

rather than validated predictive performance.

---

# 14. Influence Diagnostics

Observation-level diagnostics include:

* Cook's distance
* leverage
* standardized deviance residuals

The project uses descriptive screening thresholds.

### Cook's Distance

```text
4 / n
```

### Leverage

```text
2p / n
```

where:

* `p` = number of fitted model parameters including the intercept
* `n` = model sample size

### Standardized Deviance Residual

Flagged when:

```text
|standardized deviance residual| > 3
```

These thresholds identify observations for inspection.

Diagnostic flags are not automatic exclusion criteria.

No patient record is automatically removed merely because it exceeds one of these screening thresholds.

---

# 15. Representation Sensitivity Analysis

Representation sensitivity is the central methodological component of the project.

It is defined as:

> **changes in statistical model outputs that occur when the amount or granularity of patient information supplied to the model changes while the underlying analytical patient sample is held constant.**

The central design is:

```text
Same Patients
      +
Different Available Information
      ↓
Different Digital Representations
      ↓
Potentially Different Statistical Outputs
```

---

# 16. Representation Layers

Four nested baseline representations are used.

## Layer 1

```text
age
sex
```

## Layer 2

Layer 1 plus:

```text
anaemia
diabetes
high_blood_pressure
smoking
```

## Layer 3

Layer 2 plus:

```text
ejection_fraction
serum_creatinine
serum_sodium
```

## Layer 4

Layer 3 plus:

```text
creatinine_phosphokinase
platelets
```

The structure is:

```text
Layer 1
   ⊂
Layer 2
   ⊂
Layer 3
   ⊂
Layer 4
```

Layer 4 contains the:

> **full available baseline representation within this dataset.**

It is not:

* ground truth
* the complete real-world patient
* a validated clinical representation
* an optimal representation
* a clinically sufficient representation benchmark

---

# 17. Common Analytical Sample

All representation models are fitted to the same common analytical patient sample.

The common sample requires:

* complete observations across all Layer 4 baseline variables
* available outcome information
* finite numerical baseline values

This design prevents representation-model differences from being confounded by intentional changes in the analyzed patient population.

The methodological contrast is therefore:

```text
Same patients
+
Different information
```

rather than:

```text
Different patients
+
Different information
```

---

# 18. Representation Model Comparison

One logistic regression model is fitted for each representation layer.

All layers are evaluated using the same types of in-sample model characteristics:

* AIC
* residual deviance
* log-likelihood
* McFadden pseudo-R²
* in-sample Brier score
* convergence

These measures describe how model behavior changes as represented patient information changes.

They do not identify which representation is clinically correct.

---

# 19. Sequential Information Addition

Because the models are nested and fitted to the same observations, sequential likelihood-ratio tests compare:

```text
Layer 1 → Layer 2
Layer 2 → Layer 3
Layer 3 → Layer 4
```

For each comparison, the project records:

* variables added
* degrees of freedom
* deviance change
* nominal p-value

These p-values are:

> **exploratory and nominal**

They are not included in the primary BH-adjusted group-testing family from script 06.

A detectable improvement in statistical model fit does not establish that the additional variables are:

* clinically necessary
* causally important
* sufficient
* required for every healthcare question

Likewise, failure to detect an improvement does not prove that the added information is clinically irrelevant.

---

# 20. Coefficient Stability

Regression coefficients are compared across representation layers.

For terms appearing in multiple models, the project summarizes:

* number of models containing the term
* first layer in which the term appears
* last layer
* first coefficient
* last coefficient
* minimum coefficient
* maximum coefficient
* coefficient range
* whether an observed sign change occurs

This evaluates whether estimated statistical associations remain stable as additional patient information becomes available to the model.

Changes may reflect:

* additional statistical adjustment
* correlation among predictors
* model specification
* differences in available information

Coefficient instability does not itself establish causality or representation inadequacy.

---

# 21. Patient-Level Fitted-Probability Sensitivity

Each representation model generates:

> **in-sample fitted probabilities**

for the same analytical patient records.

Reduced layers are compared with Layer 4.

Layer 4 functions only as the analytical reference because it contains all available baseline variables.

For each comparison, the project calculates:

* mean signed probability difference
* mean absolute probability difference
* root mean squared probability difference
* maximum absolute probability difference
* Spearman correlation between fitted probabilities

These quantities measure:

> **output sensitivity relative to the Layer 4 analytical reference**

They do not measure:

* error relative to the real patient
* error relative to a clinically correct representation
* external prediction error
* calibration error in an external population

---

# 22. Illustrative Classification Sensitivity

The fitted probabilities are additionally converted into binary classifications using:

```text
0.50
```

as a fixed threshold.

For each reduced representation, the project calculates:

* number of classifications that differ from Layer 4
* percentage of classifications that differ from Layer 4

The terminology used is:

> **classification sensitivity**

rather than clinical reclassification.

The 0.50 threshold is purely methodological.

It has no validated meaning as a:

* clinical threshold
* treatment threshold
* triage threshold
* resource-allocation threshold
* healthcare-management threshold

This analysis demonstrates only that representation changes can alter a downstream binary output when the analytical rule is held constant.

---

# 23. Information Simplification

Representation sensitivity can arise not only because information is absent, but because available information is represented with reduced granularity.

This is examined using:

```text
ejection_fraction
```

Two representations are compared:

```text
Continuous ejection fraction
```

and:

```text
Median-based binary ejection fraction
```

The binary categories are defined relative to the sample median.

The sample median is:

> **an arbitrary, non-clinical methodological cutoff.**

It is not interpreted as:

* a medically validated ejection-fraction threshold
* a diagnostic boundary
* a treatment threshold
* a validated risk threshold

---

## Simplification Comparison

The continuous and simplified representations use the same analytical patient sample.

They are compared using:

* model-fit measures
* patient-level fitted-probability differences
* illustrative classification differences

The experiment therefore evaluates:

> **whether reducing the granularity of available patient information changes statistical output.**

This is conceptually different from removing the patient characteristic entirely.

The project thus examines two representation mechanisms:

```text
Information Reduction
        +
Information Simplification
```

---

# 24. Representation Sensitivity Versus Representation Validity

Representation sensitivity does not establish representation validity.

Formally:

```text
Representation Sensitivity
        ≠
Representation Validity
```

A statistical model may change strongly when representation changes.

This does not prove which representation is clinically correct.

Conversely, statistical stability across representations does not prove that the representation contains all information relevant to a clinical or healthcare-management question.

Representation sensitivity answers:

> **Does statistical output depend on the patient information supplied to the model?**

It does not answer:

> **Is this representation clinically sufficient for the intended decision?**

---

# 25. Representation Gap

The broader conceptual framework distinguishes representation sensitivity from the:

> **Representation Gap**

The Representation Gap is defined conceptually as:

> **the difference between patient information relevant to a healthcare question and the information actually represented in the data available for analysis.**

The current statistical workflow does **not** estimate a validated Representation Gap metric.

It does not calculate:

* a gap score
* a completeness percentage
* a representation-quality score
* a universal adequacy rating

The statistical project instead evaluates:

```text
Representation Limitations
        +
Representation Sensitivity
```

Assessing whether a limitation constitutes a meaningful Representation Gap requires additional knowledge about the information relevant to the specific healthcare question.

---

# 26. Follow-Up and Time-to-Event Structure

The dataset contains both:

* a recorded death-event indicator
* follow-up duration

This creates an underlying time-to-event structure.

The current project deliberately uses logistic regression as an illustrative binary-outcome framework for representation-sensitivity analysis.

The model asks:

> **Was a death event recorded during the observed follow-up period?**

It does not model:

> **When did the event occur?**

Methods such as:

* Kaplan-Meier estimation
* log-rank testing
* Cox proportional-hazards regression

are outside the current v1.0 workflow.

Therefore:

> **binary logistic modeling of `DEATH_EVENT` is not treated as a substitute for survival analysis.**

---

# 27. Statistical Evidence Hierarchy

The project deliberately preserves the distinction between different analytical outputs.

## Descriptive Evidence

Scripts 03–05:

* distributions
* counts
* percentages
* descriptive group differences
* visual patterns

These do not provide formal inferential conclusions.

---

## Primary Formal Baseline Group-Level Inference

Script 06:

```text
BH-adjusted p-values
```

These provide the project's primary formal criterion for baseline outcome-group comparisons.

---

## Exploratory Correlation Evidence

Script 07:

```text
Spearman correlations
+
exploratory nominal p-values
```

These characterize baseline correlation structure.

They are not used for regression variable selection.

---

## Regression Association Evidence

Script 08:

```text
univariable logistic regression
+
full multivariable logistic regression
+
nominal regression p-values
```

These characterize associations with the recorded binary outcome.

They are not combined with script 06 into an overall evidence score.

---

## Representation Sensitivity Evidence

Script 09:

```text
model-behavior changes
+
sequential nominal LRTs
+
coefficient changes
+
fitted-probability changes
+
classification changes
+
information-simplification experiment
```

These characterize statistical dependence on patient representation.

They do not establish clinical representation validity.

---

# 28. No Cross-Method Evidence Score

The project deliberately does not create an aggregate score such as:

```text
Supported in 1 / 2 / 3 methods
```

The analytical stages differ in:

* statistical question
* estimand
* adjustment structure
* multiplicity treatment
* interpretation

They are therefore not treated as independent votes on the same scientific hypothesis.

Cross-method patterns may be discussed descriptively, but they are not converted into a quantitative evidence score.

---

# 29. Final Synthesis

The final script:

```text
10_final_synthesis_and_interpretation.R
```

does not fit additional models or perform additional hypothesis tests.

It integrates already generated results from the preceding workflow.

Its function is to:

* preserve analytical boundaries
* summarize results
* distinguish evidence levels
* document representation sensitivity
* define what the project can and cannot establish

No new inferential evidence is generated in the synthesis stage.

---

# 30. Interpretation Principles

## Association Is Not Causation

The dataset is observational.

Observed statistical associations do not establish causal relationships.

---

## Statistical Significance Is Not Clinical Importance

A low p-value does not establish clinical relevance.

Interpretation also depends on:

* effect magnitude
* uncertainty
* measurement scale
* clinical context
* study design
* represented patient information

---

## Adjusted Associations Depend on Represented Information

Multivariable regression adjusts only for variables available to the model.

Unmeasured and unrepresented patient characteristics remain outside the adjustment set.

Therefore:

> **an adjusted association is conditional on the available digital patient representation.**

---

## Technical Data Quality Is Not Representation Adequacy

A technically clean dataset may still omit patient information relevant to a specific healthcare question.

Therefore:

```text
Technical Data Quality
        ≠
Question-Specific Representation Adequacy
```

---

## More Variables Are Not Automatically Better

A more information-rich representation is not automatically clinically superior.

Additional information may be:

* irrelevant
* redundant
* poorly measured
* contextually unnecessary

Representation adequacy is question-specific.

---

## Layer 4 Is Not Ground Truth

Layer 4 contains the complete available baseline variable set.

It is not:

* the real patient
* clinical ground truth
* an optimal representation
* a validated adequacy benchmark

---

## In-Sample Model Behavior Is Not Validation

Model-fit measures and fitted probabilities are generated from the same analytical sample used for model estimation.

The project does not claim:

* cross-validated performance
* externally validated performance
* clinical prediction validity

---

## Binary Outcome Modeling Is Not Survival Analysis

Variable follow-up remains an important methodological limitation.

The logistic models do not model event timing.

---

## Statistical Evidence Is Not Decision Validity

The project examines:

```text
Digital Patient Representation
        ↓
Statistical Model
        ↓
Statistical Output
```

It does not directly evaluate actual healthcare-management decisions.

Therefore:

> **statistically coherent output does not automatically establish valid healthcare decision support.**

---

# 31. Methodological Scope

The project can evaluate:

* technical properties of the recorded dataset
* qualitative patient-representation limitations
* observed patient distributions
* descriptive baseline outcome-group differences
* formal BH-adjusted baseline group comparisons
* exploratory baseline correlation structure
* univariable binary-outcome associations
* multivariable binary-outcome associations
* in-sample logistic-model behavior
* observation-level influence diagnostics
* representation sensitivity
* sequential information addition
* coefficient stability
* patient-level fitted-probability sensitivity
* illustrative classification sensitivity
* information simplification

The project cannot establish:

* causal effects
* individual treatment effects
* treatment recommendations
* validated clinical thresholds
* validated fixed-horizon mortality risk
* survival predictions
* external predictive validity
* clinical prediction validity
* complete patient representation
* universally optimal patient representation
* validated representation quality
* a validated Representation Gap metric
* healthcare-management decision validity
* optimal healthcare resource allocation

---

# Methodological Summary

The statistical workflow is designed around a simple principle:

```text
Statistical Method
        +
Digital Patient Representation
        ↓
Statistical Output
```

Statistical results therefore depend not only on how a model is estimated, but also on what information about the patient is available to that model.

The project evaluates this dependence while preserving a clear boundary between:

```text
Statistical Output
```

and:

```text
Clinical or Decision Validity
```

Its central methodological question is:

> **How much do our statistical conclusions depend on the patient representation from which they were generated?**
