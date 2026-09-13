# Statistical Methods

## Overview

This project applies a structured statistical workflow to investigate clinical characteristics associated with mortality among patients with heart failure.

The analysis combines:

* descriptive statistics
* graphical exploration
* group comparisons
* inferential hypothesis testing
* multiple-testing adjustment
* correlation analysis
* logistic regression

The analytical objective is primarily **explanatory and exploratory**.

Statistical results are used to identify and quantify associations within the available dataset rather than to establish causal relationships or develop a clinically validated prediction model.

Unless otherwise stated, statistical tests are interpreted using a significance level of:

$$
\alpha = 0.05
$$

---

## Descriptive Statistics

Descriptive statistics are calculated before inferential analyses in order to characterize the study population and understand the empirical distributions of the variables.

For continuous variables, the analysis considers measures including:

* mean
* median
* standard deviation
* interquartile range
* minimum
* maximum
* quartiles

Both location and dispersion measures are considered because several clinical variables are skewed or contain extreme observations.

For categorical variables, the analysis uses:

* absolute frequencies
* relative frequencies
* proportions

Descriptive statistics are calculated for the overall sample and, where appropriate, separately for survivors and non-survivors.

---

## Distribution Assessment

Continuous variables are inspected graphically before selecting statistical procedures.

The analysis uses visualizations such as:

* histograms
* boxplots
* density-based comparisons

Particular attention is given to variables with substantial skewness or extreme observations, including:

* creatinine phosphokinase
* platelets
* serum creatinine

The choice between parametric and non-parametric procedures is therefore based on the characteristics of the respective variable rather than applying a single test to all continuous measurements.

---

## Mortality Group Comparisons

Patients are divided according to the binary outcome variable `DEATH_EVENT`:

* `0` = survived during follow-up
* `1` = died during follow-up

Clinical variables are then compared between these two groups.

The selected statistical method depends on the measurement scale and distributional characteristics of each variable.

---

## Welch Two-Sample t-Test

For continuous variables where comparison of group means is considered appropriate, the project uses the **Welch two-sample t-test**.

The null hypothesis is:

$$
H_0: \mu_1 = \mu_0
$$

where:

* \(\mu_1\) represents the population mean among patients who died
* \(\mu_0\) represents the population mean among patients who survived

The alternative hypothesis is:

$$
H_A: \mu_1 \neq \mu_0
$$

The Welch formulation is preferred over the classical Student two-sample t-test because it does not require equal variances between the two groups.

This makes it more robust when group variances or sample sizes differ.

Results are interpreted using:

* difference in group means
* test statistic
* p-value
* confidence interval where applicable

---

## Wilcoxon Rank-Sum Test

For continuous variables with substantial skewness, extreme observations, or distributions for which a mean-based comparison may be less appropriate, the analysis uses the **Wilcoxon rank-sum test**.

This non-parametric procedure compares the distributions of two independent groups based on ranks rather than relying directly on the raw numerical values.

The test is particularly useful for variables such as:

* creatinine phosphokinase
* serum creatinine

where the observed distributions may be strongly right-skewed.

The Wilcoxon test avoids the normality assumption required by conventional parametric mean comparisons.

Its result is interpreted as evidence of a systematic difference in the distributions of the two mortality groups rather than simply as a difference between arithmetic means.

---

## Tests for Categorical Variables

Associations between categorical patient characteristics and mortality are evaluated using contingency-table methods.

Variables considered include:

* anaemia
* diabetes
* high blood pressure
* sex
* smoking

For sufficiently large expected cell frequencies, the analysis uses the **Pearson chi-squared test of independence**.

The null hypothesis is:

$$
H_0:
\text{The categorical variable and mortality status are independent.}
$$

The alternative hypothesis is:

$$
H_A:
\text{The categorical variable and mortality status are associated.}
$$

When expected cell frequencies are too small for the chi-squared approximation to be considered reliable, **Fisher's exact test** provides an exact alternative.

This ensures that the selected test remains appropriate for the structure of the contingency table.

---

## Multiple Hypothesis Testing

Testing several clinical variables individually increases the probability of obtaining statistically significant results purely by chance.

To address this issue, the project applies the **Benjamini-Hochberg procedure** to the set of hypothesis-test p-values.

The procedure controls the **false discovery rate (FDR)** rather than the probability of any false positive.

This approach is suitable for an exploratory analysis in which several potentially relevant clinical associations are evaluated simultaneously.

Both values are retained where relevant:

* raw p-value
* Benjamini-Hochberg adjusted p-value

Statistical evidence is therefore interpreted primarily using the adjusted results when multiple comparisons belong to the same family of analyses.

Adjustment does not change the estimated effect itself; it changes the strength of statistical evidence assigned to the corresponding hypothesis test.

---

## Correlation Analysis

Relationships between continuous clinical variables are evaluated using pairwise correlation analysis.

Because several variables contain skewed distributions or extreme observations, the project uses **Spearman's rank correlation coefficient** where a rank-based measure is appropriate.

Spearman's correlation is defined by the monotonic relationship between two variables rather than requiring a strictly linear relationship between their raw values.

The coefficient ranges from:

$$
-1 \leq \rho \leq 1
$$

where:

* values close to `+1` indicate a strong positive monotonic association
* values close to `-1` indicate a strong negative monotonic association
* values close to `0` indicate little or no monotonic association

Correlation magnitude and direction are considered together.

Correlation is not interpreted as evidence of causation.

Additionally, a low pairwise correlation does not necessarily imply complete statistical independence between two variables.

---

## Logistic Regression

Because `DEATH_EVENT` is binary, mortality associations are further investigated using **binary logistic regression**.

The model describes the log odds of mortality as a linear combination of explanatory variables:

$$
\log\left(\frac{p}{1-p}\right)
=
\beta_0
+
\beta_1X_1
+
\beta_2X_2
+
\cdots
+
\beta_kX_k
$$

where:

* \(p\) is the probability of `DEATH_EVENT = 1`
* \(\beta_0\) is the intercept
* \(\beta_j\) represents the regression coefficient associated with predictor \(X_j\)

The coefficients are exponentiated to obtain **odds ratios**:

$$
OR_j = e^{\beta_j}
$$

---

## Univariable Logistic Regression

Univariable logistic regression models evaluate each selected predictor separately.

These models provide an estimate of the unadjusted association between an individual variable and mortality.

For each predictor, the analysis reports quantities such as:

* regression coefficient
* odds ratio
* 95% confidence interval
* p-value

An odds ratio greater than `1` indicates that higher values or the respective category are associated with higher odds of mortality.

An odds ratio below `1` indicates an association with lower odds of mortality.

These associations are unadjusted and may therefore reflect confounding by other patient characteristics.

---

## Multivariable Logistic Regression

A multivariable logistic regression model is used to estimate associations while accounting simultaneously for multiple patient characteristics.

The model allows the association between a predictor and mortality to be interpreted **conditional on the other variables included in the model**.

Results are presented as adjusted odds ratios with:

* 95% confidence intervals
* p-values

Interpretation focuses not only on statistical significance but also on:

* magnitude of the estimated association
* direction of the association
* uncertainty represented by the confidence interval
* clinical plausibility

An adjusted odds ratio should not be interpreted as a causal effect.

It represents an association conditional on the particular variables and functional form included in the model.

---

## Odds Ratio Interpretation

For a continuous predictor, the odds ratio represents the multiplicative change in the odds of mortality associated with a one-unit increase in that predictor, assuming other variables in the multivariable model remain constant.

For example:

$$
OR = 1.20
$$

would correspond to approximately 20% higher odds per one-unit increase in the predictor.

Conversely:

$$
OR = 0.80
$$

would correspond to approximately 20% lower odds per one-unit increase.

The practical meaning of a one-unit increase must always be considered.

For variables measured on very small or very large numerical scales, the unit of measurement can substantially influence how intuitive an odds ratio appears.

---

## Confidence Intervals

Where applicable, parameter estimates are accompanied by **95% confidence intervals**.

Confidence intervals communicate the uncertainty surrounding an estimated association.

For odds ratios:

* an interval entirely above `1` indicates a positive association at the corresponding confidence level
* an interval entirely below `1` indicates a negative association
* an interval containing `1` indicates that the data remain compatible with no association at that confidence level

Confidence intervals provide more information than a binary significant/non-significant interpretation because they also communicate the precision and plausible magnitude of the estimate.

---

## Statistical Significance

A conventional threshold of:

$$
p < 0.05
$$

is used as a reference for statistical significance.

However, p-values are not interpreted in isolation.

The project also considers:

* effect magnitude
* confidence intervals
* distributional characteristics
* multiple-testing adjustment
* clinical context
* sample size

A p-value does not measure the size or clinical importance of an association and does not provide the probability that the null hypothesis is true.

Consequently, statistical significance and clinical relevance are treated as distinct concepts.

---

## Treatment of `time`

The variable `time` represents the duration of patient follow-up.

Unlike conventional baseline clinical characteristics, follow-up duration is directly connected to the observation process and the timing of the mortality outcome.

Its inclusion in ordinary mortality regression requires caution because it contains temporal information that would normally be handled explicitly in a time-to-event or survival-analysis framework.

For this reason, `time` is not treated as an ordinary clinical exposure when interpreting baseline mortality associations in this project.

A dedicated survival analysis using methods such as Kaplan-Meier estimation or Cox proportional hazards regression would be more appropriate if the primary research question concerned **when** mortality occurs rather than whether mortality occurred during the recorded follow-up.

---

## Missing Data

The original dataset contains no documented missing observations.

Therefore, no statistical imputation procedure is required in the current analysis.

Nevertheless, missing-value checks are performed explicitly during data quality assessment before statistical analyses begin.

This avoids assuming that imported data remain complete after preprocessing or transformation.

---

## Outliers

Potential outliers are identified through descriptive statistics and graphical inspection.

Extreme observations are not automatically removed.

In clinical datasets, unusual measurements may represent genuine high-risk patients rather than data errors.

Removal would therefore require a substantive reason, such as:

* an impossible value
* an identified data-entry error
* a documented measurement problem

Where extreme values remain valid observations, the analysis instead uses statistical procedures that are less sensitive to them when appropriate.

---

## Analytical Principles

Several principles guide the statistical workflow.

### 1. Match the method to the variable

Statistical procedures are selected according to:

* variable type
* distribution
* comparison structure
* analytical question

### 2. Preserve clinically plausible observations

Extreme clinical measurements are not removed solely because they are statistically unusual.

### 3. Separate description from inference

Descriptive statistics characterize the observed sample, whereas inferential procedures evaluate evidence for broader statistical associations.

### 4. Report uncertainty

Confidence intervals and adjusted p-values are used where applicable rather than relying exclusively on point estimates.

### 5. Avoid causal language

The observational design does not support causal conclusions.

Terms such as:

* associated with
* related to
* higher or lower odds

are preferred over causal statements.

### 6. Distinguish statistical and clinical importance

A statistically significant result is not automatically clinically meaningful, and a clinically relevant association may remain statistically uncertain in a small dataset.

---

## Scope of the Statistical Analysis

The statistical methods in this project are intended to provide a transparent and interpretable analysis of the available heart failure records.

The workflow is designed to answer questions such as:

* How is the patient population distributed across important clinical characteristics?
* Which variables differ between survivors and non-survivors?
* Which observed differences remain statistically supported after adjustment for multiple testing?
* How are continuous clinical measurements related to one another?
* Which variables remain associated with mortality after accounting for other measured characteristics?

The analysis does **not** attempt to establish causal treatment effects, validate clinical thresholds, or produce a deployable mortality prediction model.

The resulting estimates should therefore be interpreted as exploratory statistical evidence within the context and limitations of the available dataset.
