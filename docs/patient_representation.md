# Patient Representation

## Concept

This project treats healthcare data as a **digital representation of selected information about real patients**.

A statistical model does not directly observe the complete patient.

It receives only the patient information that has been:

1. observed or measured,
2. recorded,
3. encoded,
4. stored,
5. made available for analysis.

The analytical relationship can therefore be represented as:

```text
Patient Reality
      ↓
Recorded Patient Information
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

The central principle of the project is:

> **A statistical model does not analyze the complete patient directly. It analyzes the available digital representation of the patient.**

This distinction matters because statistical results depend not only on the statistical method, but also on the information supplied to that method.

---

# Digital Patient Representation

In this project, **digital patient representation** refers to:

> **the patient information available to an analytical system and the form in which that information is represented.**

Representation therefore has at least two components:

```text
Information Availability
        +
Information Granularity
```

The first asks:

> **Which patient characteristics are represented?**

The second asks:

> **How much detail is preserved when those characteristics are represented?**

For example:

```text
Ejection fraction absent
```

and:

```text
Ejection fraction available only as a binary category
```

represent two different forms of information reduction.

The first removes the characteristic entirely.

The second preserves the characteristic but reduces its granularity.

Both may change statistical model output.

---

# Patient Reality and Digital Representation

The distinction between patient reality and digital representation does **not** imply that a useful healthcare dataset must digitally reproduce every characteristic of a real patient.

A complete digital copy of a person is neither assumed nor required by this project.

Instead, the relevant question is:

> **Does the available representation contain the information required for the analytical or healthcare question being considered?**

Representation adequacy is therefore **question-specific**.

Information that is irrelevant to one analytical question may be essential to another.

For this reason:

```text
More patient information
        ≠
Automatically better representation
```

and:

```text
Fewer variables
        ≠
Automatically inadequate representation
```

The analytical relevance of patient information depends on context.

---

# Available Patient Representation in This Dataset

The Heart Failure Clinical Records dataset contains selected information from several broad patient-information domains.

The table below describes the informational boundaries of the available baseline representation.

| Patient-Information Domain         | Representation Status | Available Information                  |
| ---------------------------------- | --------------------- | -------------------------------------- |
| Demographics                       | Partial               | Age, sex                               |
| Cardiac function                   | Partial               | Ejection fraction                      |
| Renal information                  | Partial               | Serum creatinine                       |
| Hematological information          | Partial               | Anaemia, platelets                     |
| Other laboratory information       | Partial               | Serum sodium, creatinine phosphokinase |
| Selected comorbidities             | Partial               | Anaemia, diabetes, high blood pressure |
| Behavioral information             | Very limited          | Smoking status                         |
| Detailed symptom burden            | Not represented       | None                                   |
| Functional status                  | Not represented       | None                                   |
| Detailed medication information    | Not represented       | None                                   |
| Detailed treatment information     | Not represented       | None                                   |
| Patient-reported outcomes          | Not represented       | None                                   |
| Socioeconomic context              | Not represented       | None                                   |
| Longitudinal clinical trajectories | Not represented       | None                                   |

These classifications are **qualitative and project-defined**.

They are not:

* validated representation-quality ratings
* clinical adequacy scores
* patient-completeness scores
* quantitative measures of missing patient reality
* validated representation-gap measurements

A domain classified as `Partial` simply means that the dataset contains selected information from that broader domain.

It does not imply a known percentage of completeness.

---

# Representation Limitations

The project uses the term **representation limitation** for broad patient-information domains that are:

* partially represented
* very limited
* not represented

This terminology is deliberately descriptive.

For example, the absence of detailed medication information is a representation limitation because medication information is outside the available digital representation.

However, the project does **not** automatically conclude that this omission invalidates every analysis.

Whether an omitted characteristic matters depends on the question being asked.

Therefore:

> **Representation limitation does not automatically imply analytical inadequacy.**

This distinction is important for the later concept of the Representation Gap.

---

# Technical Data Quality Versus Patient Representation

Technical data quality evaluates properties of the information that is actually present.

Examples include:

* expected variables
* source coding
* data types
* missing values
* duplicate records
* non-finite values
* logical plausibility
* constant variables
* potential outliers

Patient representation asks a different question:

> **What information about the patient is available to the analysis in the first place?**

A dataset can therefore be technically clean while representing only selected aspects of the patient.

For example:

```text
No missing values
+ valid coding
+ valid numerical values
+ consistent data types
```

does not imply:

```text
All question-relevant patient information is represented
```

Therefore:

> **Technical completeness ≠ Complete patient representation**

and more importantly:

> **Technical data quality ≠ Representation adequacy for a specific question**

The two concepts should be assessed separately.

---

# Observation and Outcome Information

Two important variables in the dataset are deliberately **not** treated as baseline patient-representation dimensions.

| Information Type        | Variable      | Interpretation                                               |
| ----------------------- | ------------- | ------------------------------------------------------------ |
| Observation information | `time`        | Observed follow-up duration                                  |
| Outcome                 | `DEATH_EVENT` | Whether a death event was recorded during observed follow-up |

`time` describes the observation process.

`DEATH_EVENT` describes the recorded outcome.

They are analytically important, but they are not part of the baseline patient representation used in the representation layers.

This distinction prevents:

```text
Patient Information
```

from being conflated with:

```text
Observation Information
```

or:

```text
Outcome Information
```

---

# Representation Layers

The representation-sensitivity analysis defines four nested baseline patient representations.

These layers deliberately change the amount of patient information supplied to the statistical model.

## Layer 1 — Basic Demographic Representation

```text
age
sex
```

---

## Layer 2 — Demographics, Comorbidities and Risk Factors

Layer 1 plus:

```text
anaemia
diabetes
high_blood_pressure
smoking
```

---

## Layer 3 — Expanded Clinical Representation

Layer 2 plus:

```text
ejection_fraction
serum_creatinine
serum_sodium
```

---

## Layer 4 — Full Available Baseline Representation

Layer 3 plus:

```text
creatinine_phosphokinase
platelets
```

The layers are nested:

```text
Layer 1
   ⊂
Layer 2
   ⊂
Layer 3
   ⊂
Layer 4
```

Layer 4 contains all baseline variables available to the project.

This is why it is described as:

> **the full available baseline representation**

This phrase must not be confused with:

* the complete real-world patient
* clinical ground truth
* a validated optimal patient representation
* a clinically sufficient representation
* a representation-quality benchmark

Layer 4 is simply the most information-rich baseline representation available **within this dataset**.

---

# Representation Layers Are Not a Clinical Hierarchy

The four layers are **project-defined analytical constructions**.

They are not intended to rank patient information according to clinical importance.

For example, placing a variable in Layer 3 rather than Layer 2 does not imply that the variable is:

* more clinically important
* more prognostically important
* more causally important
* more necessary for healthcare decisions

The ordering exists to create controlled variation in information availability.

Its methodological purpose is:

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

# Holding the Patient Sample Constant

A central design feature of the representation-sensitivity analysis is that the **analytical patient sample is held constant across representation layers**.

This is essential.

Otherwise, differences between models could arise from two sources simultaneously:

```text
Different patients
+
Different information
```

The project instead aims to isolate:

```text
Same patients
+
Different information about those patients
```

All four nested representation models are therefore fitted using the same common analytical sample.

This allows changes in model output to be interpreted as **representation sensitivity** rather than as a consequence of intentionally changing the analyzed patient population.

---

# Representation Sensitivity

The project defines **representation sensitivity** as:

> **changes in statistical model outputs that occur when the amount or granularity of patient information supplied to the model changes while the underlying analytical patient sample is held constant.**

Representation sensitivity is evaluated across multiple statistical outputs.

These include:

* model fit
* residual deviance
* AIC
* McFadden pseudo-R²
* in-sample Brier score
* regression coefficients
* odds ratios
* patient-level in-sample fitted probabilities
* illustrative binary classifications

The analysis therefore asks:

> **How much does the statistical output depend on the representation from which it was generated?**

---

# Information Reduction

The nested representation layers examine **information reduction**.

For example:

```text
Layer 4
Full available baseline representation

        ↓ remove information

Layer 3

        ↓ remove information

Layer 2

        ↓ remove information

Layer 1
Basic demographic representation
```

Because the patients remain constant, the comparison evaluates whether removing available patient information changes statistical model behavior.

The project compares reduced representations with Layer 4.

However:

> **Layer 4 is an analytical reference, not ground truth.**

A difference from Layer 4 therefore represents:

> **output sensitivity relative to the full available baseline representation**

not:

> **error relative to the clinically correct patient representation**

---

# Information Granularity

Patient representation can also change without removing a variable completely.

Information may instead be simplified.

The project demonstrates this using:

```text
ejection_fraction
```

The original representation preserves ejection fraction as a continuous numerical measurement.

The simplification experiment replaces it with:

```text
At or below sample median
Above sample median
```

This creates:

```text
Continuous Information
        ↓
Reduced Granularity
        ↓
Binary Information
```

The sample median is an **arbitrary, non-clinical methodological cutoff**.

It is not interpreted as:

* a clinical ejection-fraction threshold
* a diagnostic boundary
* a treatment threshold
* a validated risk threshold

The experiment asks only:

> **Does simplifying an available patient characteristic change statistical model output?**

This complements the nested-layer analysis.

Together, the project therefore studies:

```text
Information Reduction
        +
Information Simplification
```

as two mechanisms through which digital patient representation can affect statistical output.

---

# Patient-Level Output Sensitivity

Representation sensitivity is not evaluated only at the overall model level.

The project also compares **patient-level in-sample fitted probabilities** across representations.

Reduced layers are compared with Layer 4 using:

* mean signed difference
* mean absolute difference
* root mean squared difference
* maximum absolute difference
* Spearman correlation

These quantities evaluate whether the statistical output assigned to the same patient changes when the available patient information changes.

They do not measure:

* prediction error relative to patient reality
* clinical risk-estimation error
* calibration against an external population
* representation validity

Again:

> **Layer 4 is the analytical reference, not the correct answer.**

---

# Illustrative Classification Sensitivity

The project additionally applies a fixed probability threshold of:

```text
0.50
```

to demonstrate whether changes in representation can alter a downstream binary classification.

This threshold is purely methodological.

It is not:

* a clinical threshold
* a treatment threshold
* a triage threshold
* a resource-allocation threshold
* a validated management threshold

The classification analysis therefore demonstrates only:

> **under a fixed analytical rule, representation changes can potentially change the resulting binary output.**

It does not evaluate an actual healthcare decision.

---

# The Representation Gap

The broader research perspective associated with this project introduces the concept of a **Representation Gap**.

The Representation Gap can be defined as:

> **the difference between patient information relevant to a healthcare question and the information actually represented in the data available for analysis.**

This definition is intentionally **question-specific**.

The relevant comparison is not:

```text
Complete Real Patient
        versus
Digital Patient
```

because an analytical system does not necessarily need every conceivable patient characteristic.

Instead:

```text
Patient Information Relevant to the Question
                    versus
Patient Information Actually Represented
```

The gap may arise through:

* omitted information
* insufficient granularity
* simplified categories
* incomplete temporal information
* incomplete clinical context

However, the current repository does **not** estimate a validated Representation Gap metric.

It does not assign:

* a Representation Gap score
* a percentage of patient completeness
* a representation-quality percentage
* a universal adequacy rating

The qualitative representation map identifies **representation limitations**.

The statistical analysis evaluates **representation sensitivity**.

Determining whether those limitations constitute a meaningful Representation Gap requires an additional judgment about what information is relevant to the intended healthcare question.

---

# Representation Sensitivity Is Not Representation Validity

A model may be statistically sensitive to representation changes.

That does not establish which representation is clinically correct.

Likewise, a model may remain statistically stable across representation changes.

That does not prove that important patient information is absent from none of them.

Therefore:

```text
Representation Stability
        ≠
Representation Validity
```

and:

```text
Representation Sensitivity
        ≠
Clinical Inadequacy
```

Representation sensitivity answers:

> **Does the statistical result depend on how the patient is represented?**

It does not answer:

> **Which representation is clinically sufficient?**

The second question requires additional clinical and decision-specific evidence.

---

# Statistical Evidence and Decision Support

The project's broader analytical logic is:

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
Potential Healthcare Decision Support
```

The current project directly studies the first part of this chain:

```text
Digital Patient Representation
        ↓
Statistical Model
        ↓
Statistical Output
```

It does not evaluate actual healthcare-management decisions.

Therefore:

> **Statistically coherent output ≠ Clinically sufficient evidence**

and:

> **Statistical evidence ≠ Decision validity**

A model can produce mathematically valid output while still depending on a representation that may be insufficient for a particular healthcare question.

Whether that matters depends on the downstream decision context.

---

# What the Project Can Establish

The project can evaluate whether:

* different amounts of represented baseline information change statistical model behavior
* regression coefficients change across nested representations
* model-fit measures change across representations
* patient-level fitted probabilities change across representations
* an illustrative classification changes under a fixed analytical rule
* reducing the granularity of ejection fraction changes model output

These are questions of **representation sensitivity**.

---

# What the Project Cannot Establish

The project cannot determine:

* the complete clinical state of each patient
* the universally correct digital representation of a patient
* the minimum clinically sufficient representation for every healthcare question
* whether every omitted variable is clinically necessary
* a validated representation-quality score
* a validated Representation Gap metric
* causal effects
* validated fixed-horizon mortality risk
* clinical prediction validity
* treatment recommendations
* actual healthcare-decision validity
* whether a more information-rich representation is always better

These boundaries are intentional.

---

# Role in the Project

The patient-representation framework connects the main analytical stages of the repository:

```text
02
Map technical data quality
and representation limitations
        ↓

08
Model the recorded binary outcome
using the available baseline representation
        ↓

09
Change the amount or granularity
of represented patient information
        ↓

10
Synthesize how statistical output
depends on patient representation
```

The resulting methodological question is:

> **How much do our statistical conclusions depend on the patient representation from which they were generated?**

The project does not assume that digital healthcare data are inherently inadequate.

Instead, it emphasizes that:

> **the informational boundaries of a dataset should remain visible when statistical evidence generated from that dataset is interpreted.**
