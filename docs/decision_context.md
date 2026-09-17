# Decision Context

## Purpose

This project does not evaluate actual healthcare-management or clinical decisions.

Instead, it examines a methodological prerequisite for data-driven healthcare decision support:

> **How strongly does statistical evidence depend on the digital patient representation from which it was generated?**

The project therefore connects patient representation, statistical modeling, and potential decision support without claiming to validate real-world decisions.

Its focus is the analytical chain:

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
      ↓
Healthcare Decision
```

The current project directly examines only part of this chain.

It studies:

```text
Digital Patient Representation
        ↓
Statistical Model
        ↓
Statistical Output
```

The later transition from statistical evidence to an actual healthcare decision requires additional evidence that is outside the scope of this repository.

---

# Why Patient Representation Matters for Decision Support

Statistical models can use only the patient information available to them.

If relevant patient information is:

* absent
* simplified
* coarsened
* recorded with limited granularity
* unavailable over time

then the resulting statistical output may differ from the output generated from another representation of the same patients.

This creates a direct methodological connection between:

```text
Patient Representation
        ↓
Statistical Evidence
```

and any later attempt to use that evidence for decision support.

The central implication is:

> **The validity of a statistical calculation alone does not establish that the underlying patient representation is adequate for the decision the evidence is intended to support.**

---

# Representation Adequacy Is Decision-Specific

A useful patient representation does not need to contain every possible characteristic of the real patient.

Instead, the relevant question is:

> **Does the representation contain the patient information required for the specific analytical or healthcare decision context?**

This means:

```text
More information
      ≠
Automatically better decision support
```

and:

```text
Less information
      ≠
Automatically inadequate decision support
```

The importance of any patient characteristic depends on:

* the analytical question
* the target population
* the intended decision
* the consequences of error
* the clinical context
* the organizational context

Representation adequacy is therefore inherently **question- and decision-specific**.

---

# Representation Limitations and Decision Context

The dataset used in this project contains selected information on:

* demographics
* cardiac function
* renal information
* hematological information
* selected laboratory measurements
* selected comorbidities
* smoking status

Other patient-information domains are not represented in the analytical dataset.

Examples include:

* detailed symptoms
* functional status
* detailed medication information
* treatment history
* patient-reported outcomes
* socioeconomic context
* detailed longitudinal clinical trajectories

These absences are documented as:

> **representation limitations**

They are not automatically classified as decision-critical deficiencies.

Whether an omitted characteristic matters depends on the intended decision.

For example:

```text
Representation Limitation
        ≠
Automatically Decision-Relevant Gap
```

A meaningful decision-level assessment therefore requires an additional question:

> **Was the omitted information relevant to the particular decision being supported?**

---

# Representation Gap and Decision Support

The broader conceptual framework associated with this project defines the **Representation Gap** as:

> **the difference between patient information relevant to a healthcare question and the information actually represented in the data available for analysis.**

Within a decision context, this can be represented as:

```text
Patient Information Relevant
to the Intended Decision
            ↓
        compared with
            ↓
Patient Information Available
to the Statistical Model
```

The current repository does **not** calculate a validated Representation Gap metric.

It cannot determine from the dataset alone which omitted patient characteristics are necessary for a specific real-world healthcare decision.

Instead, the project provides two analytical components that can inform such an assessment:

```text
Representation Limitations
        +
Representation Sensitivity
```

Representation limitations describe the informational boundaries of the dataset.

Representation sensitivity examines whether changing those informational boundaries changes statistical output.

A decision-specific Representation Gap requires an additional assessment of **relevance to the intended decision**.

---

# Representation Sensitivity

The representation-sensitivity analysis evaluates whether statistical outputs change when the amount or granularity of patient information supplied to the model changes while the analyzed patient sample remains constant.

The project evaluates changes in:

* model fit
* regression coefficients
* odds ratios
* patient-level in-sample fitted probabilities
* illustrative binary classifications

The core design is:

```text
Same Patients
     +
Different Available Information
     ↓
Different Digital Representations
     ↓
Potentially Different Statistical Outputs
```

This is relevant to decision support because downstream evidence cannot be completely separated from the representation from which it was generated.

However:

> **Representation sensitivity does not establish decision validity.**

A result may change strongly when representation changes without demonstrating which representation is clinically appropriate.

Likewise, a statistically stable result may still be based on information that is insufficient for a particular decision.

Therefore:

```text
Representation Stability
        ≠
Decision Validity
```

and:

```text
Representation Sensitivity
        ≠
Decision Invalidity
```

---

# Information Granularity

Decision-relevant evidence may depend not only on whether patient information is present, but also on how that information is represented.

The project demonstrates this using ejection fraction.

It compares:

```text
Continuous Ejection Fraction
```

with:

```text
Median-Based Binary Ejection Fraction
```

The binary representation intentionally reduces information granularity.

The sample median is an arbitrary, non-clinical methodological cutoff.

The analysis asks:

> **Does reducing the granularity of an available patient characteristic change statistical model output?**

It does not ask:

> **Which ejection-fraction threshold should be used for a clinical decision?**

The experiment therefore illustrates **information simplification**, not threshold validation.

---

# Statistical Evidence

The analytical workflow generates several different forms of statistical evidence.

These include:

* descriptive sample characteristics
* descriptive outcome-group differences
* BH-adjusted baseline group-level comparisons
* exploratory correlations
* univariable logistic-regression associations
* multivariable logistic-regression associations
* in-sample model-fit measures
* representation-sensitivity results

These outputs answer different statistical questions.

They should not be interpreted as interchangeable evidence or combined into a single decision-validity score.

---

# From Statistical Output to Statistical Evidence

A statistical result becomes potentially useful evidence only after interpretation.

For example:

```text
Model Coefficient
        ↓
Statistical Association
        ↓
Interpretation in Context
        ↓
Potential Statistical Evidence
```

This interpretation depends on issues such as:

* study design
* uncertainty
* effect magnitude
* represented variables
* omitted variables
* measurement quality
* target population
* intended use

Statistical output therefore does not automatically become decision-ready evidence.

---

# From Statistical Evidence to Decision Support

The next step is even broader.

Potential healthcare decision support may require consideration of:

* clinical relevance
* patient population
* external validity
* treatment options
* treatment effects
* patient preferences
* resource constraints
* organizational context
* cost
* feasibility
* consequences of false-positive and false-negative decisions
* competing risks
* time horizon
* causal evidence
* prospective validation

Most of this information is not available in the current dataset.

The project therefore does not attempt to complete this transition.

---

# Decision Validity

A valid real-world healthcare decision requires more than a statistically coherent model.

The current project does not evaluate whether any actual decision is:

* appropriate
* effective
* cost-effective
* ethically justified
* clinically beneficial
* operationally feasible
* optimal

It also does not evaluate whether using the model improves patient or organizational outcomes.

Accordingly:

> **Statistical evidence does not by itself establish decision validity.**

---

# What the Dataset Does Not Contain

The dataset contains no directly observed information about actual:

* treatment-allocation decisions
* staffing decisions
* capacity decisions
* resource-allocation interventions
* quality-improvement interventions
* healthcare-management decisions
* cost decisions
* operational planning decisions
* downstream consequences of management actions

It therefore cannot be used in this project to estimate the effectiveness or validity of such decisions.

---

# Management and Organizational Context

Healthcare management decisions often involve variables that extend beyond individual clinical characteristics.

Examples may include:

* available capacity
* staffing
* costs
* organizational processes
* treatment availability
* demand
* waiting times
* institutional priorities
* reimbursement structures

These variables are outside the current dataset.

Therefore, although the project's methodological findings may be relevant to **data-driven healthcare management**, the project itself does not model an operational healthcare system.

Its management relevance is conceptual:

> **Evidence intended for management decisions should be interpreted with awareness of the patient representation from which that evidence was generated.**

---

# Clinical Decision Context

The same boundary applies to clinical decisions.

The project does not provide:

* treatment recommendations
* triage rules
* diagnostic rules
* clinical risk thresholds
* validated mortality-risk predictions
* validated survival predictions
* individualized management recommendations
* treatment-effect estimates

The logistic models evaluate whether a death event was recorded during variable observed follow-up.

They are not validated fixed-horizon clinical risk models.

---

# Illustrative Classification Threshold

The representation-sensitivity analysis uses:

```text
0.50
```

as an illustrative binary classification threshold.

This threshold has no validated:

* clinical meaning
* treatment meaning
* triage meaning
* resource-allocation meaning
* management meaning

It exists only to demonstrate that:

> **under a fixed analytical rule, changing patient representation can change a downstream binary output.**

The resulting classification changes are therefore methodological illustrations rather than decision changes observed in practice.

---

# Decision Consequences Are Not Modeled

The project does not assign costs or utilities to model outputs.

For example, it does not specify the consequences of:

```text
False Positive
False Negative
Correct Positive
Correct Negative
```

within any healthcare decision.

Without a defined decision problem and consequence structure, classification differences cannot be translated directly into:

* clinical harm
* financial loss
* resource waste
* patient benefit
* management value

This is another reason the project stops at **potential decision relevance** rather than claiming decision validity.

---

# Analytical Boundary

The project can directly examine:

```text
Digital Patient Representation
        ↓
Statistical Model
        ↓
Statistical Output
```

It can partially inform interpretation at the level of:

```text
Statistical Evidence
```

It does not directly evaluate:

```text
Actual Healthcare Decision
        ↓
Decision Consequences
        ↓
Patient or Organizational Outcomes
```

This distinction is central to the project.

---

# Decision-Support Framework

The relationship between the analytical stages can be summarized as:

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
      ↓
Actual Healthcare Decision
      ↓
Decision Consequences
```

The repository primarily evaluates:

```text
Digital Patient Representation
        ↓
Statistical Model
        ↓
Statistical Output
```

The remaining steps require additional evidence.

---

# What the Project Can Establish

The project can evaluate whether:

* the available dataset represents selected patient-information domains
* important informational boundaries remain visible
* statistical outputs change when available patient information changes
* statistical outputs change when information granularity is reduced
* coefficients change across different representations
* in-sample fitted probabilities change across representations
* an illustrative binary classification changes under a fixed analytical rule

These findings can inform discussion about the robustness of statistical evidence to patient representation.

---

# What the Project Cannot Establish

The project cannot establish:

* the correct treatment for a patient
* the optimal healthcare-management decision
* the optimal allocation of resources
* whether a specific patient should receive an intervention
* whether a model should be deployed clinically
* whether a model should be used operationally
* whether a decision based on the model improves outcomes
* whether the available patient representation is sufficient for every decision
* a validated decision threshold
* the consequences of representation-related output changes
* a validated Representation Gap metric
* clinical or management decision validity

---

# Interpretation Principles

## Statistical Model Fit Is Not Decision Quality

A model may fit the observed data better without producing evidence suitable for a real-world decision.

Therefore:

```text
Better Statistical Fit
        ≠
Better Healthcare Decision
```

---

## More Patient Information Is Not Automatically Better

An expanded representation may change or improve statistical model fit.

That does not prove that every added variable is necessary for the intended decision.

Therefore:

```text
More Represented Information
        ≠
Automatically Better Decision Support
```

---

## Statistical Stability Is Not Sufficient Evidence

A model may remain stable across representation changes.

That does not prove that important decision-relevant information is absent from none of the representations.

Therefore:

```text
Stable Statistical Output
        ≠
Validated Representation Adequacy
```

---

## Decision Validity Requires Decision-Specific Evidence

Whether statistical evidence is adequate depends on:

```text
What decision is being made?
        +
For whom?
        +
Over what time horizon?
        +
With what alternatives?
        +
With what consequences?
```

These questions cannot be answered from statistical association alone.

---

# Role of Healthcare Management

The project is relevant to healthcare management because management increasingly depends on digitally represented patient information and model-based evidence.

The methodological implication is:

> **Before statistical evidence is used to support healthcare-management decisions, the informational boundaries of the underlying patient representation should remain visible.**

This does not imply that every management system requires maximally detailed patient data.

Instead, it implies that:

> **the adequacy of the representation should be considered relative to the decision it is intended to support.**

---

# Core Decision-Support Principle

The project's central decision-related principle is:

> **Statistical evidence used for healthcare decision support is generated from a particular digital patient representation. The suitability of that evidence for a real decision therefore depends not only on the statistical model, but also on whether the represented information is adequate for the intended decision context.**

This principle does not claim that representation adequacy can be determined from model sensitivity alone.

Representation sensitivity identifies dependence.

Decision validity requires additional evidence.

---

# Final Boundary

The current project can demonstrate:

```text
Patient Representation
        ↓
can influence
        ↓
Statistical Output
```

It cannot demonstrate:

```text
Statistical Output
        ↓
produces
        ↓
Valid Healthcare Decision
```

The transition from statistical evidence to real-world healthcare decision-making requires additional:

* clinical evidence
* decision-specific evidence
* organizational evidence
* validation
* consequence assessment

The appropriate final interpretation is therefore:

> **Representation sensitivity is relevant to decision support because statistical evidence is representation-dependent. It is not itself a validation of the representation, the model, or the downstream healthcare decision.**
