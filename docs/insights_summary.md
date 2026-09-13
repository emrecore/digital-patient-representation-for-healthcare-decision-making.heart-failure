# Clinical Insights Summary

## Overview

This analysis examined mortality patterns and clinical characteristics in **299 patients with heart failure**.

The statistical workflow combined descriptive analysis, mortality-group comparisons, hypothesis testing, correlation analysis, and logistic regression.

The main findings consistently highlight three clinical characteristics:

* higher age
* lower ejection fraction
* higher serum creatinine

as the most important mortality-associated variables within this dataset.

Serum sodium also differed between mortality groups and showed an unadjusted association with mortality, while its association became weaker after simultaneous adjustment for the other clinical characteristics.

---

## Mortality Outcome

Among the 299 patients:

* **203 patients survived during follow-up**
* **96 patients experienced a recorded death event**

This corresponds to an observed mortality proportion of approximately:

$$
32.1\%
$$

The relatively substantial number of mortality events allows differences between survivors and non-survivors to be explored statistically, while the overall sample size remains limited for extensive clinical modeling.

---

## Mortality Group Differences

After adjustment for multiple hypothesis testing using the Benjamini-Hochberg procedure, the clearest differences between survivors and non-survivors were observed for:

* `age`
* `ejection_fraction`
* `serum_creatinine`
* `serum_sodium`

These results indicate that mortality status was systematically associated with several demographic, cardiac, renal, and biochemical characteristics.

### Age

Patients who experienced a death event tended to be older than patients who survived during follow-up.

The difference remained statistically supported after correction for multiple testing.

This pattern was also consistent with the subsequent regression analysis.

---

### Ejection Fraction

Patients with a recorded death event tended to have lower ejection fractions.

Lower ejection fraction reflects poorer systolic cardiac function and represented one of the clearest differences between the mortality groups.

The association remained important when other patient characteristics were considered simultaneously.

---

### Serum Creatinine

Serum creatinine was higher among patients who experienced mortality.

The variable showed a particularly strong and consistent association across:

* mortality-group comparisons
* hypothesis testing
* univariable logistic regression
* multivariable logistic regression

Because serum creatinine is related to renal function, the result highlights the statistical relevance of kidney-related clinical status within this heart failure population.

---

### Serum Sodium

Lower serum sodium values were associated with mortality in the unadjusted analyses.

The difference between mortality groups remained statistically supported after adjustment for multiple hypothesis testing.

However, serum sodium did not retain the same level of statistical evidence after simultaneous adjustment for the other variables in the multivariable logistic regression model.

This illustrates the distinction between an isolated association and an association that remains independently supported after accounting for additional patient characteristics.

---

## Categorical Patient Characteristics

The categorical characteristics evaluated included:

* anaemia
* diabetes
* high blood pressure
* sex
* smoking

None of these variables showed sufficiently strong evidence of an association with mortality in the primary multiple-testing-adjusted group comparisons.

This does **not** demonstrate that these characteristics are clinically irrelevant.

Rather, the available sample did not provide sufficient statistical evidence to establish clear mortality differences for these variables within the current analytical framework.

---

## Correlation Findings

Spearman correlation analysis was used to examine monotonic relationships among the continuous clinical variables.

Overall, the pairwise relationships were predominantly weak to moderate.

No extremely strong correlations were observed among the baseline continuous variables.

This suggests that the measured clinical characteristics generally capture different aspects of patient status rather than representing highly redundant measurements.

Importantly, correlation magnitude should not be interpreted as clinical importance.

A variable can have only a weak correlation with another clinical measurement while still showing an important association with mortality.

---

## Univariable Mortality Associations

Univariable logistic regression was used to examine each baseline characteristic separately.

Four variables showed statistically significant individual associations with mortality:

* `age`
* `ejection_fraction`
* `serum_creatinine`
* `serum_sodium`

### Age

The estimated odds ratio for age was approximately:

$$
OR = 1.05
$$

per additional year of age.

This indicates that increasing age was associated with progressively higher odds of mortality.

---

### Ejection Fraction

The estimated odds ratio for ejection fraction was approximately:

$$
OR = 0.95
$$

per one-percentage-point increase.

Higher ejection fraction was therefore associated with lower odds of mortality.

---

### Serum Creatinine

The univariable odds ratio for serum creatinine was approximately:

$$
OR = 2.28
$$

per 1 mg/dL increase.

Among the individual predictors, serum creatinine showed one of the strongest estimated mortality associations.

---

### Serum Sodium

The estimated odds ratio for serum sodium was approximately:

$$
OR = 0.91
$$

per 1 mEq/L increase.

Higher sodium levels were associated with lower mortality odds in the univariable model.

However, this association weakened in the multivariable analysis.

---

## Adjusted Mortality Associations

A multivariable logistic regression model was fitted using the available baseline demographic and clinical characteristics.

The analysis identified statistically significant adjusted associations for:

* `age`
* `creatinine_phosphokinase`
* `ejection_fraction`
* `serum_creatinine`

These estimates describe associations with mortality after simultaneously accounting for the other variables included in the model.

---

### Age

Age remained independently associated with mortality after adjustment.

The adjusted odds ratio was approximately:

$$
OR = 1.06
$$

per additional year of age.

This means that each additional year was associated with approximately **6% higher odds of mortality**, conditional on the other variables in the model.

The result should be interpreted as an association rather than a causal effect.

---

### Ejection Fraction

Ejection fraction remained strongly associated with mortality after adjustment.

The adjusted odds ratio was approximately:

$$
OR = 0.93
$$

per one-percentage-point increase.

This corresponds to lower estimated mortality odds at higher levels of ejection fraction, conditional on the remaining model variables.

The consistency between the descriptive, inferential, and regression analyses makes ejection fraction one of the most robust findings in the project.

---

### Serum Creatinine

Serum creatinine also remained strongly associated with mortality in the multivariable model.

The adjusted odds ratio was approximately:

$$
OR = 1.94
$$

per 1 mg/dL increase.

This corresponds to substantially higher estimated mortality odds at higher serum creatinine levels after adjustment for the other included patient characteristics.

Together with ejection fraction and age, serum creatinine represents one of the most consistent findings across the complete analytical workflow.

---

### Creatinine Phosphokinase

Creatinine phosphokinase reached statistical significance in the multivariable regression model.

However, the estimated coefficient per single unit was very small because CPK is measured on a large numerical scale.

Its odds ratio therefore rounds to approximately:

$$
OR = 1.00
$$

per 1 mcg/L increase.

This result demonstrates why odds ratios must always be interpreted in relation to the measurement scale of the predictor.

Statistical significance alone does not imply that a one-unit change represents a clinically meaningful effect.

The CPK finding should therefore be interpreted more cautiously than the associations observed for age, ejection fraction, and serum creatinine.

---

## Comparison of Univariable and Adjusted Findings

The transition from univariable to multivariable analysis provides an important part of the interpretation.

### Consistent Associations

Three variables were clearly supported across both approaches:

* age
* ejection fraction
* serum creatinine

These variables showed mortality associations individually and continued to show statistical evidence after adjustment for the remaining baseline characteristics.

They therefore represent the most consistent mortality-associated factors identified by this project.

### Association Weakened After Adjustment

Serum sodium was associated with mortality in the univariable analysis but was no longer statistically significant at the conventional 0.05 threshold in the multivariable model.

This suggests that part of the observed unadjusted sodium association may overlap with information captured by other patient characteristics.

### Association Emerging After Adjustment

Creatinine phosphokinase was not a significant univariable mortality predictor but reached the conventional significance threshold after simultaneous adjustment.

Because this association is comparatively weak and sensitive to model specification and measurement scale, it should be interpreted cautiously rather than treated as one of the primary findings.

---

## Main Clinical Pattern

Taken together, the analyses suggest that mortality within this patient population is most consistently characterized by a combination of:

### Older Age

Older patients showed higher mortality odds.

### Reduced Cardiac Function

Lower ejection fraction was consistently associated with mortality.

### Impaired Renal Function

Higher serum creatinine showed one of the strongest and most stable associations with mortality.

These findings represent different dimensions of patient health:

* demographic vulnerability
* cardiac function
* renal function

The consistency of these variables across several statistical approaches strengthens their relevance within the analyzed dataset.

---

## What the Analysis Does Not Show

The results should not be interpreted as demonstrating that any measured variable directly causes mortality.

The data are observational, and the analysis cannot eliminate:

* unmeasured confounding
* selection effects
* measurement limitations
* differences in treatment
* additional disease severity factors

The logistic regression model estimates associations conditional on the variables that were available and included.

Variables not contained in the dataset cannot be statistically controlled.

---

## Follow-Up Time

The dataset contains a `time` variable representing follow-up duration.

This variable was not treated as an ordinary baseline clinical predictor in the final mortality regression because it contains information about the observation period itself.

Mortality and follow-up time together form a time-to-event structure.

A dedicated survival-analysis framework, such as:

* Kaplan-Meier estimation
* log-rank testing
* Cox proportional hazards regression

would therefore be more appropriate for investigating the timing of mortality.

The present project instead focuses on associations with the binary recorded mortality outcome.

---

## Key Takeaways

The main conclusions of the analysis are:

1. Approximately one-third of the observed patients experienced a recorded death event during follow-up.

2. Age, ejection fraction, serum creatinine, and serum sodium differed significantly between mortality groups after multiple-testing adjustment.

3. Age, ejection fraction, serum creatinine, and serum sodium were individually associated with mortality in univariable logistic regression.

4. Age, ejection fraction, and serum creatinine remained consistently associated with mortality after adjustment for the other baseline characteristics.

5. CPK reached statistical significance in the multivariable model, but the magnitude and scale of the association require cautious interpretation.

6. Serum sodium showed evidence of an unadjusted mortality association but did not remain statistically significant after multivariable adjustment.

7. The evaluated binary comorbidities and patient characteristics did not show strong mortality associations in the primary group comparisons.

8. Pairwise correlations among continuous clinical measurements were generally not strong enough to suggest substantial redundancy among the variables.

9. The results describe statistical associations within this dataset and should not be interpreted as causal relationships or clinical treatment recommendations.

---

## Final Interpretation

The most robust statistical pattern emerging from this project is the joint importance of **age, cardiac function, and renal function**.

Older age, lower ejection fraction, and higher serum creatinine were repeatedly associated with mortality across different stages of the analysis.

The agreement between descriptive comparisons, hypothesis testing, and regression modeling makes these findings more informative than results obtained from any single statistical procedure.

At the same time, the analysis demonstrates an important principle of healthcare statistics:

> A clinically interpretable conclusion should not be based on statistical significance alone.

Effect magnitude, uncertainty, measurement scale, model adjustment, study design, and clinical context must all be considered together.

The findings should therefore be understood as **exploratory evidence from a limited observational dataset**, providing a foundation for further clinical research rather than definitive evidence for patient-level decision making.
