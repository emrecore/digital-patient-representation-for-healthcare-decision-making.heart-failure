# Insights Summary

## Overview

This document summarizes the main analytical findings of the project:

**Representation Sensitivity Analysis in Heart Failure with R**

The project analyzes clinical records from **299 patients with heart failure** and combines conventional statistical analysis with a methodological investigation of **digital patient representation**.

The central question is:

> **How sensitive are statistical model outputs to changes in the amount and granularity of patient information available to the model?**

The project does not attempt to build a validated clinical prediction system.

Its main contribution is methodological:

> **Statistical models analyze the digital patient representation supplied to them, not the complete real-world patient.**

---

# 1. Observed Analytical Sample

The dataset contains:

```text
299 patient records
```

with:

```text
203 patients with no recorded death event
96 patients with a recorded death event
```

A death event was therefore recorded for approximately:

```text
32.1%
```

of the observed sample.

This percentage describes the dataset and its particular follow-up structure.

It must not be interpreted as:

* a general heart-failure mortality rate
* a fixed-horizon mortality probability
* an individual patient's mortality risk
* a population-level survival estimate

Patients were observed for different lengths of time.

The outcome should therefore be understood as:

> **whether a death event was recorded during the available observed follow-up period.**

---

# 2. Technical Data Quality and Patient Representation Are Different

The project separates two analytical questions.

## Technical Data Quality

Technical data-quality assessment examines the information that is actually present.

Examples include:

* expected variables
* source coding
* data types
* missing values
* exact duplicate records
* non-finite values
* logical plausibility
* constant variables
* potential numerical outliers

---

## Patient Representation

Patient representation asks:

> **What information about the patient is available to the analytical system in the first place?**

The available baseline data contain selected information about:

* demographics
* cardiac function
* renal information
* hematological information
* other laboratory measurements
* selected comorbidities
* smoking status

However, several broader patient-information domains are not represented.

These include:

* detailed symptom burden
* functional status
* detailed medication information
* detailed treatment information
* patient-reported outcomes
* socioeconomic context
* longitudinal clinical trajectories

Therefore:

> **Technical completeness does not imply complete patient representation.**

A dataset can contain technically usable values for every recorded variable while still representing only selected aspects of the patient.

---

# 3. Descriptive Outcome-Group Patterns

Baseline patient characteristics were compared descriptively according to:

```text
No recorded death event
```

and:

```text
Death event recorded
```

These comparisons describe observed sample differences only.

They do not establish:

* statistical significance
* causality
* prognostic validity
* clinical importance

Because follow-up duration varies between patients, these groups should not be interpreted as standardized survival or fixed-horizon mortality groups.

---

# 4. Primary Formal Baseline Group-Level Findings

Formal baseline group comparisons were performed using:

* Welch two-sample t-tests
* Wilcoxon rank-sum tests
* Pearson chi-squared tests
* Fisher's exact tests

depending on the variable and analytical conditions.

The resulting baseline testing family was adjusted using the:

> **Benjamini-Hochberg procedure**

The clearest BH-adjusted baseline group differences were observed for:

* **age**
* **ejection fraction**
* **serum creatinine**
* **serum sodium**

These findings mean that the corresponding baseline distributions differed between the recorded death-event groups within the defined analytical sample and testing framework.

They do not establish:

* causal effects
* clinical importance
* treatment relevance
* fixed-horizon prognostic validity

---

# 5. Logistic Regression Findings

Logistic regression was used to examine associations between available baseline patient characteristics and whether a death event was recorded during observed follow-up.

The regression models deliberately exclude follow-up duration as a predictor because `time` represents observation information rather than baseline patient information.

---

## Age

Higher age showed a positive conditional association with the recorded binary outcome.

In the full multivariable logistic model, the estimated odds ratio was approximately:

```text
OR ≈ 1.06 per additional year
```

This indicates higher modeled odds of a recorded death event with increasing age within the available dataset and model specification.

It does not establish a causal effect of age.

---

## Ejection Fraction

Higher ejection fraction showed an inverse conditional association with the recorded binary outcome.

The estimated adjusted odds ratio was approximately:

```text
OR ≈ 0.93 per one-percentage-point increase
```

The association therefore remained visible after adjustment for the other available baseline characteristics.

This does not establish a clinically validated risk effect or treatment implication.

---

## Serum Creatinine

Higher serum creatinine showed a positive conditional association with the recorded binary outcome.

The estimated adjusted odds ratio was approximately:

```text
OR ≈ 1.94 per 1 mg/dL increase
```

This association remained visible in the full multivariable model.

Again, the estimate is conditional on the patient information represented in the dataset.

---

## Serum Sodium

Serum sodium showed BH-adjusted evidence of a baseline group difference and evidence in less-adjusted analyses.

Its association weakened after adjustment in the full multivariable logistic model.

This illustrates an important principle:

> **Group comparisons, univariable models, and multivariable models answer different statistical questions.**

The disappearance or weakening of an association after adjustment should therefore not automatically be interpreted as contradiction.

---

## Creatinine Phosphokinase

Creatinine phosphokinase produced a nominal p-value below the project alpha level in the full multivariable model.

Its per-unit odds ratio remained numerically close to:

```text
1.00
```

because one model unit corresponds to only one unit on a measurement scale spanning substantially larger values.

This demonstrates why odds ratios must always be interpreted together with:

* measurement scale
* coefficient magnitude
* uncertainty
* analytical context

---

# 6. Different Evidence Levels Are Kept Separate

The project deliberately does **not** create a combined evidence score.

In particular:

```text
BH-adjusted baseline group test
            ≠
nominal univariable regression
            ≠
nominal multivariable regression
```

These methods differ in:

* statistical question
* adjustment structure
* estimand
* multiplicity treatment
* interpretation

They may show related patterns, but they are not treated as independent votes on one common hypothesis.

Therefore, the project does not classify variables as:

```text
supported in 1 / 2 / 3 methods
```

or create a cross-method evidence ranking.

---

# 7. Exploratory Correlation Structure

Spearman correlation analysis was used to explore monotonic relationships among continuous baseline patient characteristics.

The correlation analysis excludes:

* follow-up duration
* the recorded death-event outcome

Its purpose is to characterize how available baseline numerical characteristics relate to one another.

The correlations are:

> **exploratory**

They are not used for regression variable selection.

A strong observed correlation does not establish:

* causality
* clinical importance
* prognostic importance
* representation importance

---

# 8. Full Multivariable Model

The full logistic model includes the complete available baseline variable set.

Variables are not selected according to:

* hypothesis-test significance
* correlation strength
* univariable regression p-values

This ensures that the full model represents:

> **the full available baseline patient information within the dataset**

rather than a subset selected after observing statistical significance.

Adjusted associations should therefore be interpreted as:

> **associations conditional on the other baseline information represented in the model.**

Unrepresented patient information remains outside the adjustment set.

---

# 9. In-Sample Model Behavior

The full model is summarized using:

* null deviance
* residual deviance
* AIC
* log-likelihood
* McFadden pseudo-R²
* in-sample Brier score
* convergence
* influence diagnostics

These measures describe:

> **in-sample model behavior**

They do not constitute:

* cross-validation
* external validation
* clinical validation
* validated real-world predictive performance

Similarly, model-generated probabilities are referred to as:

> **in-sample fitted probabilities**

rather than validated mortality-risk predictions.

---

# 10. Digital Patient Representation

The conventional statistical analyses operate on a specific digital representation of the patient.

The analytical relationship is:

```text
Real-World Patient
        ↓
Recorded Patient Information
        ↓
Digital Patient Representation
        ↓
Statistical Model
        ↓
Statistical Output
```

The statistical model cannot directly use patient information that is:

* unrecorded
* unavailable
* omitted
* simplified beyond the available granularity

This motivates the central representation-sensitivity analysis.

---

# 11. Representation Layers

Four nested baseline patient representations are constructed.

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

Layer 4 contains the complete available baseline variable set.

It is therefore called:

> **the full available baseline representation**

It is not:

* the complete real-world patient
* clinical ground truth
* a validated optimal representation
* a clinically sufficient representation benchmark

---

# 12. Same Patients, Different Information

A central methodological feature of the project is that all representation models use the same analytical patient sample.

The design is therefore:

```text
Same Patients
      +
Different Available Information
      ↓
Different Digital Representations
```

rather than:

```text
Different Patients
      +
Different Available Information
```

This allows differences in model output to be interpreted as **representation sensitivity** rather than differences intentionally created by changing the patient population.

---

# 13. Representation Sensitivity

The central analysis demonstrates that statistical model behavior is not independent of the patient information supplied to the model.

Across the nested representations, changes can be observed in:

* model fit
* regression coefficients
* odds ratios
* patient-level in-sample fitted probabilities

The central observation is:

> **The same patients can generate different statistical outputs when the information used to represent those patients changes.**

This is the core result of the project.

---

# 14. Sequential Information Addition

Nested models are compared sequentially:

```text
Layer 1 → Layer 2
Layer 2 → Layer 3
Layer 3 → Layer 4
```

Likelihood-ratio tests evaluate whether adding the next group of represented patient characteristics produces detectable changes in statistical model fit.

These p-values are exploratory and nominal.

A detectable model-fit improvement does not establish that the added information is:

* clinically necessary
* clinically sufficient
* required for every analytical question
* evidence of a superior patient representation

Likewise, failure to detect a model-fit improvement does not prove that the information is clinically irrelevant.

---

# 15. Coefficient Sensitivity

Regression coefficients are compared across representation layers.

Estimated associations can change as additional patient information enters the model.

Such changes may arise through:

* statistical adjustment
* relationships among predictors
* model specification
* differences in represented information

Therefore:

> **An estimated association is partly conditional on the surrounding information represented in the model.**

Coefficient changes do not establish causal effects or identify a clinically correct representation.

---

# 16. Patient-Level Fitted-Probability Sensitivity

Representation sensitivity is also examined at the individual analytical-record level.

Reduced representations are compared with Layer 4 using:

* mean signed fitted-probability difference
* mean absolute fitted-probability difference
* root mean squared difference
* maximum absolute difference
* Spearman correlation

These comparisons demonstrate that:

> **the statistical output assigned to the same patient record can change when the information used to represent that patient changes.**

Layer 4 is only the analytical reference.

Differences from Layer 4 do not represent prediction error relative to a clinically correct patient state.

---

# 17. Illustrative Classification Sensitivity

A probability threshold of:

```text
0.50
```

is applied as a methodological illustration.

The analysis evaluates whether reduced patient representations produce different binary classifications from Layer 4 under the same fixed analytical rule.

The threshold has no validated:

* clinical meaning
* treatment meaning
* triage meaning
* mortality-risk meaning
* healthcare-management meaning

The classification analysis demonstrates only:

> **representation changes can alter a downstream binary model output when the decision rule is held constant.**

It does not evaluate an actual healthcare decision.

---

# 18. Information Simplification

Representation sensitivity can arise even when a patient characteristic is not removed entirely.

Information may instead be represented at lower granularity.

The project demonstrates this with:

```text
ejection_fraction
```

by comparing:

```text
continuous ejection fraction
```

with:

```text
median-based binary ejection fraction
```

The sample median is an:

> **arbitrary, non-clinical methodological cutoff**

and is not interpreted as a medically validated threshold.

The comparison demonstrates that:

> **simplifying available patient information can change statistical model output.**

The project therefore distinguishes two mechanisms:

```text
Information Reduction
        +
Information Simplification
```

---

# 19. Representation Sensitivity Is Not Representation Validity

The project demonstrates dependence of statistical output on digital patient representation.

It does not determine which representation is clinically correct.

Therefore:

```text
Representation Sensitivity
        ≠
Representation Validity
```

A statistically sensitive result does not automatically imply that a representation is inadequate.

Likewise:

```text
Representation Stability
        ≠
Representation Validity
```

A statistically stable result does not prove that all clinically or decision-relevant patient information is represented.

---

# 20. Representation Limitations and the Representation Gap

The project identifies several **representation limitations**.

These describe patient-information domains that are:

* partially represented
* very limited
* not represented

However, a representation limitation does not automatically constitute a meaningful gap for every analytical question.

The broader concept of the **Representation Gap** is:

> **the difference between patient information relevant to a healthcare question and the information actually represented in the data available for analysis.**

The relevant comparison is therefore:

```text
Question-Relevant Patient Information
                versus
Actually Represented Patient Information
```

The current repository does **not** calculate a validated Representation Gap metric.

It does not produce:

* a Representation Gap score
* a patient-completeness percentage
* a representation-quality percentage
* a universal adequacy rating

Instead:

```text
02
identifies representation limitations

09
evaluates representation sensitivity
```

A decision-specific Representation Gap requires additional knowledge about what patient information is relevant to the intended question.

---

# 21. Healthcare Decision Relevance

The project does not evaluate actual:

* treatment decisions
* staffing decisions
* capacity decisions
* resource-allocation decisions
* quality-improvement interventions
* management interventions

The dataset does not contain the information required to assess the validity or consequences of those decisions.

The project's relevance to healthcare decision support is therefore methodological.

The relevant chain is:

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

The repository primarily evaluates:

```text
Digital Patient Representation
        ↓
Statistical Model
        ↓
Statistical Output
```

The remaining transition toward real-world decision validity requires additional evidence.

---

# 22. Main Analytical Findings

The conventional statistical analysis identifies clear sample-specific patterns involving:

* age
* ejection fraction
* serum creatinine
* serum sodium

The full multivariable model additionally illustrates that association estimates depend on simultaneous adjustment for the available baseline representation.

These findings are analytically relevant, but they are not the project's central methodological conclusion.

The broader result is:

> **Statistical evidence is generated from the digital representation available to the model, not from the complete real-world patient.**

---

# 23. Main Methodological Finding

The representation-sensitivity analysis shows that changing:

```text
how much patient information is available
```

or:

```text
how much granularity that information retains
```

can change statistical output.

Observed changes can involve:

* model fit
* estimated associations
* odds ratios
* patient-level fitted probabilities
* illustrative classifications

Therefore:

> **Statistical conclusions are not determined by the statistical method alone. They are also conditional on the patient representation supplied to that method.**

---

# 24. Interpretation Boundary

The project can evaluate:

* technical data quality
* qualitative representation limitations
* observed sample characteristics
* descriptive outcome-group differences
* BH-adjusted baseline group comparisons
* exploratory baseline correlations
* univariable binary-outcome associations
* multivariable binary-outcome associations
* in-sample logistic-model behavior
* influence diagnostics
* representation sensitivity
* coefficient sensitivity
* fitted-probability sensitivity
* illustrative classification sensitivity
* information simplification

The project cannot establish:

* causal effects
* treatment effects
* treatment recommendations
* validated clinical thresholds
* validated fixed-horizon mortality risk
* survival prediction
* external predictive validity
* clinical prediction validity
* complete patient representation
* universally optimal patient representation
* validated representation quality
* a validated Representation Gap metric
* healthcare-management decision validity
* optimal resource allocation

---

# 25. Final Interpretation

The project begins with a conventional healthcare-data analysis but leads to a broader methodological conclusion.

A statistical model receives a digital representation of the patient.

That representation determines what information the model can use.

Therefore:

```text
Patient Reality
      ↓
Digital Patient Representation
      ↓
Statistical Model
      ↓
Statistical Output
```

The same underlying patients can produce different model outputs when the amount or granularity of the represented patient information changes.

The core project principle is:

> **A statistical model does not analyze the complete patient directly. It analyzes the patient information that has been digitally represented and supplied to the model.**

The central methodological question is therefore:

> **How much do our statistical conclusions depend on the patient representation from which they were generated?**

The project demonstrates that this dependence can be empirically examined.

It does not claim that representation sensitivity alone identifies the clinically correct representation.

Instead, it establishes a narrower and more defensible conclusion:

> **The informational boundaries of digital patient data should remain visible when statistical evidence generated from those data is interpreted.**
