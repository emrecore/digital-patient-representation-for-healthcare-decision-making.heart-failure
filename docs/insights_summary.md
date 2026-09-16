# Insights Summary

## Overview

This document summarizes the main findings of the project and connects the statistical results with the broader questions of **digital patient representation, statistical reliability, and potential healthcare decision support**.

The analysis is based on clinical records from **299 patients with heart failure**.

The project does not attempt to build a validated clinical prediction system.

Instead, it asks:

> **How does the available digital representation of a patient influence the statistical evidence generated from healthcare data?**

---

## Patient Population

The dataset contains:

- **299 patients**
- **203 patients with no recorded death event**
- **96 patients with a recorded death event**

The observed mortality proportion is approximately **32.1%**.

This value describes the analyzed sample only and should not be generalized to a broader patient population.

---

## Mortality-Related Evidence

After Benjamini-Hochberg adjustment, the clearest mortality-group differences were observed for:

- age
- ejection fraction
- serum creatinine
- serum sodium

These findings represent statistical evidence within the available dataset.

They do not establish causal relationships or clinical importance by themselves.

---

## Age

Higher age was associated with higher mortality odds.

In the multivariable logistic regression model, the adjusted odds ratio was approximately:

**OR = 1.06 per additional year**

This indicates an association between increasing age and higher mortality odds within the analyzed dataset.

---

## Ejection Fraction

Higher ejection fraction was associated with lower mortality odds.

The adjusted odds ratio was approximately:

**OR = 0.93 per one-percentage-point increase**

This association remained visible after adjustment for the other available baseline characteristics.

---

## Serum Creatinine

Higher serum creatinine was associated with higher mortality odds.

The adjusted odds ratio was approximately:

**OR = 1.94 per 1 mg/dL increase**

Among the available variables, serum creatinine therefore showed a clear adjusted mortality association.

---

## Serum Sodium

Lower serum sodium showed mortality-related evidence in group-level and univariable analyses.

The association weakened after multivariable adjustment.

This illustrates why adjusted and unadjusted analyses should not be interpreted as answering the same statistical question.

---

## Creatinine Phosphokinase

Creatinine phosphokinase reached nominal statistical significance in the full multivariable logistic regression model.

Its per-unit odds ratio remained close to `1.00`.

This demonstrates the importance of considering the measurement scale when interpreting odds ratios.

---

## Cross-Method Evidence

The final synthesis compares three mortality-related analytical stages:

- BH-adjusted group testing
- univariable logistic regression
- multivariable logistic regression

This allows each baseline variable to be evaluated according to whether statistical support appears across multiple analytical approaches.

The comparison reflects **internal consistency of statistical evidence**.

It does not represent:

- clinical importance
- causal evidence
- treatment relevance
- a clinical ranking of variables

---

## Correlation Structure

Spearman correlation analysis was used to explore relationships among continuous baseline patient characteristics.

The correlations describe how available variables move together within the dataset.

They are exploratory and should not be interpreted as causal relationships.

Strong correlation also does not imply clinical importance.

---

## Digital Patient Representation

The dataset contains meaningful information about:

- demographics
- cardiac function
- renal status
- biochemical measurements
- hematological characteristics
- selected comorbidities
- smoking status
- mortality
- follow-up duration

However, important patient dimensions are unavailable, including detailed:

- medication
- treatment interventions
- symptoms
- functional status
- longitudinal clinical development
- patient-reported outcomes
- socioeconomic context
- healthcare resource use
- management decisions

Therefore:

**A technically complete dataset can still represent only part of the real patient.**

---

## Representation Sensitivity

The central methodological analysis evaluates whether statistical results change when the amount of available patient information changes.

Four nested patient representations are compared while keeping the analyzed patient population constant.

The analysis evaluates changes in:

- model fit
- regression coefficients
- odds ratios
- patient-level probabilities
- illustrative classifications

This creates the comparison:

**Same Patients + Different Available Information → Different Statistical Outputs**

The purpose is not to identify one universally correct representation.

Instead, the analysis evaluates how sensitive statistical evidence is to the information available to the model.

---

## Coefficient Stability

Regression coefficients are compared across the representation layers.

If an estimated association changes substantially after additional variables are introduced, this indicates that the association depends partly on the surrounding patient information represented in the model.

Coefficient stability therefore provides one perspective on the robustness of statistical evidence.

It does not establish causal stability or clinical validity.

---

## Patient-Level Probability Sensitivity

The representation models generate different in-sample probabilities for the same patients.

Reduced representations are compared with the full available baseline representation using:

- mean absolute probability difference
- root mean squared probability difference
- maximum absolute probability difference
- Spearman correlation

This demonstrates that patient-level statistical output can depend on the amount of available patient information.

These probabilities are not externally validated clinical risk estimates.

---

## Illustrative Reclassification

A probability threshold of **0.50** is used to illustrate whether representation changes can alter binary classifications.

The threshold is methodological only.

It has no validated clinical meaning and should not be interpreted as:

- a treatment threshold
- a triage threshold
- a mortality-risk cutoff
- a management decision rule

The experiment demonstrates only that information changes can lead to classification changes.

---

## Information Loss Through Dichotomization

The project also examines how statistical results change when continuous information is simplified.

Ejection fraction is compared in two forms:

- continuous representation
- median-based binary representation

The median cutoff is not a clinical threshold.

The analysis evaluates changes in:

- model fit
- patient-level probabilities
- illustrative classifications

This demonstrates that **information granularity itself can influence statistical output**.

---

## Statistical Reliability

The project evaluates statistical reliability through several complementary perspectives:

- formal hypothesis testing
- multiple-testing adjustment
- regression estimates
- confidence intervals
- model-fit measures
- influence diagnostics
- coefficient stability
- probability sensitivity
- representation sensitivity

However, statistical reliability is always conditional on the available data.

A model cannot directly use patient information that was never recorded.

---

## Healthcare Decision Relevance

The dataset does not contain observed:

- staffing decisions
- capacity-allocation decisions
- treatment-allocation strategies
- healthcare resource-use decisions
- management interventions

The project therefore does not evaluate real healthcare-management decisions.

Instead, it examines a prerequisite for data-driven decision support:

> **How stable is statistical evidence when the underlying patient representation changes?**

Potential applications of this type of evidence could include:

- population characterization
- healthcare planning
- patient segmentation
- quality monitoring
- resource planning

These applications are potential contexts only and are not directly evaluated in this project.

---

## Clinical and Methodological Boundary

The project can evaluate:

- patient distributions
- mortality-group differences
- statistical associations
- uncertainty
- correlation structure
- model behavior
- representation sensitivity
- information loss

It cannot establish:

- causal effects
- treatment recommendations
- validated clinical thresholds
- externally validated individual mortality risk
- optimal healthcare-management decisions
- clinical sufficiency of the available patient representation

Additional clinical evidence and domain expertise are required for those conclusions.

---

## Main Interpretation

The conventional statistical analysis identifies recurring mortality-related evidence involving:

- higher age
- lower ejection fraction
- higher serum creatinine

Serum sodium also shows mortality-related evidence, although its association weakens after multivariable adjustment.

The broader project conclusion extends beyond these individual variables.

Statistical evidence is generated from the **digital representation available to the model**, not from the complete real-world patient.

Therefore:

> **A statistical model does not analyze the patient directly. It analyzes the available digital representation of the patient.**

Changes in the amount or granularity of that representation can alter:

- model fit
- estimated associations
- patient-level probabilities
- illustrative classifications

The reliability of data-driven healthcare evidence therefore depends not only on the statistical model, but also on:

- what patient information was measured
- how it was represented
- what information was omitted
- how much information was simplified
- how stable the resulting evidence remains

The central conclusion is:

**Statistical reliability ≠ Clinical validity**

A statistically coherent result may still be based on an incomplete representation of the real patient.