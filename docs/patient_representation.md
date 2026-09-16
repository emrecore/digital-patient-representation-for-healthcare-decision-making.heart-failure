# Digital Patient Representation

## Purpose

This document describes how the patients contained in the Heart Failure Clinical Records dataset are represented through digitally available health information.

The dataset is not treated as a complete description of each patient.

Instead, every observation is understood as a **partial digital representation of a real patient**.

This distinction is central to the analytical framework of the project.

A real patient contains substantially more information than can be captured by a single structured dataset. Clinical history, symptoms, treatment decisions, medication, functional status, longitudinal development, patient-reported outcomes, socioeconomic circumstances, and many other factors may influence the patient's health state while remaining unavailable to the statistical analysis.

The statistical workflow therefore operates on:

```text
Real Patient
    ↓
Digitally Recorded Patient Information
    ↓
Statistical Representation
    ↓
Statistical Analysis
    ↓
Evidence
    ↓
Potential Decision Support
```

The purpose of this document is to make the informational boundaries of this process explicit.

The central methodological principle is:

> **A statistical model does not analyze the real patient directly. It analyzes the available digital representation of the patient.**

---

# 1. Target Patient Population

The dataset contains clinical records from **299 patients with heart failure**.

Each row represents one patient.

The available information includes selected:

- demographic characteristics
- comorbidities
- cardiovascular measurements
- laboratory measurements
- behavioral information
- follow-up duration
- mortality outcome

The dataset therefore provides a structured representation of selected characteristics of patients with heart failure.

It does not provide a complete digital patient record.

---

# 2. Available Digital Patient Information

The dataset contains the following variables:

| Variable | Type | Patient Dimension | Description |
|---|---|---|---|
| `age` | Numeric | Demographics | Age of the patient |
| `anaemia` | Binary | Comorbidity / hematology | Presence of anaemia |
| `creatinine_phosphokinase` | Numeric | Biochemical information | Creatinine phosphokinase level |
| `diabetes` | Binary | Comorbidity | Presence of diabetes |
| `ejection_fraction` | Numeric | Cardiac function | Percentage of blood leaving the left ventricle during contraction |
| `high_blood_pressure` | Binary | Comorbidity / cardiovascular risk | Presence of hypertension |
| `platelets` | Numeric | Hematological information | Platelet concentration |
| `serum_creatinine` | Numeric | Renal function | Serum creatinine concentration |
| `serum_sodium` | Numeric | Biochemical information | Serum sodium concentration |
| `sex` | Binary | Demographics | Biological sex recorded in the dataset |
| `smoking` | Binary | Behavioral risk factor | Recorded smoking status |
| `time` | Numeric | Follow-up | Duration of follow-up |
| `DEATH_EVENT` | Binary | Outcome | Recorded mortality during follow-up |

These variables form the digital information available for statistical analysis.

---

# 3. Patient Representation Map

The available variables can be grouped into broader patient-information dimensions.

| Patient Dimension | Representation Status | Available Information |
|---|---|---|
| Demographics | Partial | Age, sex |
| Cardiac function | Partial | Ejection fraction |
| Renal status | Partial | Serum creatinine |
| Hematological information | Partial | Anaemia, platelets |
| Biochemical information | Partial | Creatinine phosphokinase, serum sodium, serum creatinine |
| Comorbidities | Partial | Anaemia, diabetes, high blood pressure |
| Behavioral risk factors | Very limited | Smoking status |
| Mortality outcome | Available | Recorded death event |
| Follow-up information | Available | Follow-up duration |
| Detailed disease severity | Limited | Ejection fraction and selected clinical measurements |
| Medication | Not represented | No detailed medication information |
| Treatment interventions | Not represented | No detailed treatment information |
| Symptoms | Not represented | No structured symptom information |
| Functional status | Not represented | No detailed functional assessment |
| Longitudinal clinical measurements | Not represented | No repeated clinical measurement trajectories |
| Patient-reported outcomes | Not represented | No quality-of-life or symptom-reported outcomes |
| Socioeconomic context | Not represented | No socioeconomic characteristics |
| Healthcare resource use | Not represented | No staffing, cost, capacity, utilization, or resource variables |
| Management decisions | Not represented | No observed healthcare-management interventions |

The purpose of this representation map is not to classify the dataset as inadequate.

All healthcare datasets necessarily select particular dimensions of reality.

Instead, the map documents **what the statistical analysis can observe and what remains outside the available digital representation**.

---

# 4. Representation Status

The patient-information dimensions can be interpreted using four broad representation states.

## Available

A dimension is classified as **available** when the dataset directly contains information corresponding to the analytical concept.

Examples:

```text
Mortality outcome
Follow-up duration
```

Availability does not necessarily imply that the information is complete.

For example, mortality is available as a recorded binary outcome, but the dataset does not contain every possible clinical outcome experienced by the patient.

---

## Partial

A dimension is classified as **partial** when the dataset contains relevant information but only represents one part of the broader clinical concept.

For example:

```text
Renal status → serum creatinine
Cardiac function → ejection fraction
Demographics → age and sex
```

Renal status cannot be reduced completely to one creatinine measurement, and cardiac function cannot be described completely by ejection fraction alone.

The variables nevertheless provide meaningful digital information about these dimensions.

---

## Limited or Very Limited

A dimension is classified as **limited** when only a narrow approximation of a broader patient characteristic is available.

For example:

```text
Behavioral information → smoking status
```

Behavioral health could include many additional factors such as:

- physical activity
- dietary behavior
- adherence
- alcohol consumption
- healthcare-seeking behavior
- self-management

The dataset captures only smoking status.

---

## Not Represented

A dimension is classified as **not represented** when no corresponding variable exists in the dataset.

Examples include:

```text
Medication
Detailed treatment
Symptoms
Functional status
Patient-reported outcomes
Socioeconomic context
Healthcare resource use
Management interventions
```

These dimensions cannot be reconstructed reliably from the available variables.

Their absence is therefore considered a **representation limitation**, not merely a technical missing-value problem.

---

# 5. Technical Missingness vs Representational Missingness

An important distinction in digital health data is the difference between:

```text
Technical Missingness
```

and

```text
Representational Missingness
```

## Technical Missingness

Technical missingness occurs when a variable exists in the dataset but the corresponding value is unavailable for one or more patients.

Example:

```text
serum_creatinine = NA
```

The Heart Failure Clinical Records dataset contains no documented missing values in the original data.

Technical completeness is therefore comparatively high.

---

## Representational Missingness

Representational missingness occurs when an entire patient-information dimension is absent from the dataset.

For example:

```text
Medication history
Symptoms
Treatment interventions
Quality of life
Functional status
```

These dimensions cannot produce conventional `NA` values because no corresponding variables exist.

This distinction is analytically important.

A dataset may contain:

```text
0 missing values
```

while still representing only a small subset of the real patient's clinically relevant information.

Therefore:

> **Technical completeness does not imply complete patient representation.**

---

# 6. Information Granularity

Patient information differs not only in whether it is available, but also in **how much detail is preserved**.

The dataset contains a mixture of:

- continuous numerical measurements
- binary indicators
- categorical information
- follow-up information
- binary outcome information

Different representation forms preserve different amounts of information.

---

## Continuous Information

Examples include:

```text
age
ejection_fraction
serum_creatinine
serum_sodium
platelets
creatinine_phosphokinase
time
```

Continuous measurements can preserve relatively detailed numerical variation.

For example:

```text
Ejection fraction = 31%
Ejection fraction = 32%
Ejection fraction = 33%
```

remain distinguishable observations.

---

## Binary Information

Examples include:

```text
diabetes = Yes / No
anaemia = Yes / No
high blood pressure = Yes / No
smoking = Yes / No
```

Binary variables provide simpler representations.

For example:

```text
diabetes = Yes
```

does not communicate:

- disease duration
- disease severity
- treatment status
- glycemic control
- complications
- medication
- progression

The variable therefore indicates the presence of a condition but not its complete clinical state.

---

# 7. Information Loss Through Simplification

Digital health information may be transformed for statistical, administrative, or operational reasons.

Examples include:

```text
Continuous → categorical
Continuous → binary
Detailed → aggregated
Longitudinal → cross-sectional
Multiple measurements → single summary
Clinical narrative → coded variable
```

Every transformation may reduce information.

For example:

```text
Ejection fraction = 32%
Ejection fraction = 38%
```

contains more numerical information than:

```text
Ejection fraction = lower group
```

Both patients may become identical in the simplified representation despite having different original measurements.

The representation sensitivity analysis therefore explicitly investigates the consequences of reducing available patient information.

The methodological question is:

> **How strongly do statistical conclusions change when the same underlying patient is represented with less information?**

---

# 8. Nested Digital Patient Representations

The project constructs several increasingly information-rich representations of the same patient population.

This allows statistical model outputs to be compared under different levels of available patient information.

---

## Layer 1 — Basic Demographic Representation

```text
age
sex
```

This is the most reduced patient representation used in the sensitivity analysis.

It contains basic demographic information but no comorbidity, laboratory, or cardiac-function information.

Conceptually:

```text
Patient
    ↓
Age + Sex
```

---

## Layer 2 — Demographic, Comorbidity and Risk-Factor Representation

Layer 2 adds:

```text
anaemia
diabetes
high_blood_pressure
smoking
```

The resulting representation contains:

```text
age
sex
anaemia
diabetes
high_blood_pressure
smoking
```

This representation therefore describes the patient using basic demographics, selected comorbidities, and limited behavioral information.

---

## Layer 3 — Expanded Clinical Representation

Layer 3 additionally includes:

```text
ejection_fraction
serum_creatinine
serum_sodium
```

The representation therefore incorporates selected information on:

- cardiac function
- renal function
- biochemical status

Conceptually:

```text
Demographics
    +
Comorbidities
    +
Risk factors
    +
Selected clinical measurements
```

---

## Layer 4 — Full Available Baseline Representation

Layer 4 additionally contains:

```text
creatinine_phosphokinase
platelets
```

The full available baseline representation is therefore:

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

This layer uses all available baseline patient characteristics included in the dataset.

Importantly:

> **Layer 4 is the fullest representation available in the dataset, not a complete representation of the real patient.**

The distinction remains essential.

```text
Full available dataset representation
≠
Full real-world patient representation
```

---

# 9. Why Follow-Up Time Is Treated Separately

The variable:

```text
time
```

represents follow-up duration.

It is therefore not treated as a baseline patient characteristic within the representation layers.

This distinction is important because follow-up duration is related to the observation process itself.

The primary representation sensitivity analysis therefore compares baseline patient information without using `time` as if it were an ordinary clinical predictor available at the beginning of observation.

Follow-up information remains relevant for interpreting the mortality outcome and the limitations of logistic regression.

---

# 10. Outcome Representation

The primary outcome is represented as:

```text
DEATH_EVENT
```

with:

```text
0 = no recorded death event
1 = recorded death event
```

This is a binary representation of mortality.

The representation is informative but simplified.

Mortality is fundamentally a time-dependent event.

Two patients may both have:

```text
DEATH_EVENT = 1
```

while experiencing the event at very different points during follow-up.

Likewise, a patient with:

```text
DEATH_EVENT = 0
```

may simply have had a shorter observation period.

The dataset additionally contains:

```text
time
```

which provides follow-up duration.

This means the mortality process can conceptually be represented as:

```text
Event status + Follow-up time
```

rather than only:

```text
Death / No death
```

The current primary regression analysis uses logistic regression and therefore models whether a death event was recorded.

It does not explicitly model the timing of mortality.

A dedicated time-to-event analysis would require survival-analysis methods such as:

```text
Kaplan-Meier estimation
Cox proportional hazards regression
```

This demonstrates another principle of digital patient representation:

> **The analytical representation of an outcome influences the questions that can be answered from it.**

---

# 11. Representation Sensitivity

The project explicitly evaluates whether statistical conclusions depend on the amount of available patient information.

The same patient population is analyzed through different digital representations:

```text
Layer 1
    ↓
Layer 2
    ↓
Layer 3
    ↓
Layer 4
```

The underlying patients remain unchanged.

Only the information made available to the statistical model changes.

This allows the analysis to examine whether changes occur in:

- model fit
- estimated associations
- confidence intervals
- patient-level predicted probabilities
- illustrative model classifications

The purpose is not to determine which representation is universally correct.

Instead, the purpose is to investigate:

> **How dependent are statistical conclusions on the digital information available about the patient?**

---

# 12. Patient-Level Information Sensitivity

Representation sensitivity is also examined at the individual patient level.

For the same patient:

```text
Reduced Digital Representation
        ↓
Estimated Probability A
```

can be compared with:

```text
Full Available Digital Representation
        ↓
Estimated Probability B
```

The difference:

```text
|Probability A - Probability B|
```

quantifies how much the model output changes when additional patient information becomes available.

This does not establish that one probability is clinically correct.

Rather, it demonstrates how strongly the analytical output depends on the patient's digital representation.

---

# 13. Illustrative Reclassification

The project also applies an illustrative probability threshold of:

```text
0.50
```

to examine whether the binary analytical classification of a patient changes between different representations.

The categories are:

```text
Lower model probability
Higher model probability
```

This threshold is used only for methodological demonstration.

It is:

- not a clinical cutoff
- not a treatment threshold
- not a triage threshold
- not a validated mortality-risk threshold

The analytical purpose is to demonstrate the following principle:

```text
Same Patient
    +
Different Available Information
    ↓
Potentially Different Model Output
```

This provides a simplified illustration of why information availability can matter when statistical models contribute to downstream decisions.

---

# 14. Dichotomization as Representation Loss

The project additionally examines the effect of simplifying a continuous patient measurement.

Ejection fraction is originally represented as a continuous numerical variable.

Conceptually:

```text
30%
31%
32%
33%
...
```

For the methodological sensitivity experiment, this information is converted into a binary variable using the sample median as an illustrative cutoff.

The representation therefore changes from:

```text
Continuous Clinical Measurement
```

to:

```text
Lower-or-equal-to-median / Higher-than-median
```

The median is deliberately used as a neutral analytical cutoff.

It is not interpreted as a clinically meaningful threshold.

The objective is to investigate whether reducing the informational granularity of one patient variable changes:

- model fit
- predicted probabilities
- patient-level classification
- overall statistical conclusions

This experiment illustrates a broader problem in digital health:

> **Simplifying patient information may improve interpretability or operational usability while simultaneously removing statistical information.**

---

# 15. Statistical Representation vs Clinical Reality

The dataset contains variables that may be clinically relevant.

However, statistical representation and clinical reality remain distinct.

For example:

```text
serum_creatinine
```

provides information related to renal function.

But:

```text
Renal function ≠ serum creatinine alone
```

Likewise:

```text
ejection_fraction
```

provides information about cardiac function.

But:

```text
Cardiac state ≠ ejection fraction alone
```

And:

```text
diabetes = Yes
```

provides information about a comorbidity.

But:

```text
Diabetes status ≠ complete diabetic disease state
```

Digital variables should therefore be interpreted as **measured representations of broader clinical concepts**, not as the concepts themselves.

---

# 16. Statistical Reliability vs Clinical Validity

The project explicitly distinguishes between:

## Statistical Reliability

Statistical reliability concerns questions such as:

- Is the result stable?
- Is the association supported by the available data?
- How large is the estimated uncertainty?
- Does the result remain similar after adjustment?
- Does the result change when patient information is reduced?
- Does the model behave differently under alternative representations?

---

## Clinical Validity

Clinical validity concerns additional questions such as:

- Is the represented information medically sufficient?
- Is an omitted variable clinically essential?
- Is the observed association therapeutically relevant?
- Is the model valid for individual patient decisions?
- Is the result clinically meaningful?
- Does the model represent the relevant disease process adequately?

These questions cannot be answered from statistical analysis alone.

Therefore:

```text
Statistical Reliability
        ≠
Clinical Validity
```

A model may be statistically stable within the available dataset while still representing the real patient incompletely.

---

# 17. Representation and Healthcare Decision-Making

Digital patient information may contribute to many healthcare-management processes.

Examples include:

- healthcare demand estimation
- resource planning
- capacity planning
- risk-oriented service planning
- quality monitoring
- population segmentation
- patient-flow analysis
- healthcare analytics
- outcome monitoring
- data-driven management models

This project does not directly evaluate such decisions because the dataset contains no observed management interventions.

However, it examines an important analytical prerequisite:

> **How reliable is the digital patient information on which a potential data-driven decision would be based?**

The conceptual relationship can be represented as:

```text
Real Patient
    ↓
Digital Patient Representation
    ↓
Statistical Model
    ↓
Statistical Evidence
    ↓
Potential Decision Support
    ↓
Healthcare Management Decision
```

If relevant patient information is missing or oversimplified, uncertainty may propagate through this entire chain.

---

# 18. Representation Quality and Decision Quality

A more sophisticated statistical model cannot automatically recover patient information that was never collected.

Conceptually:

```text
Missing Clinical Information
        ↓
Incomplete Digital Representation
        ↓
Limited Statistical Evidence
        ↓
Potentially Limited Decision Support
```

This does not mean that every healthcare decision requires a complete digital representation of the patient.

A complete digital representation may not even be practically achievable.

Instead, the relevant question is:

> **Is the available digital representation sufficiently informative for the specific decision being considered?**

This makes patient representation a **decision-specific concept**.

The required data for one management decision may differ substantially from the data required for another.

---

# 19. The Patient as the Starting Point of the Analytical Process

The project deliberately places the patient at the beginning of the analytical framework.

The process is not conceptualized as:

```text
Dataset
    ↓
Model
    ↓
Result
```

Instead:

```text
Patient
    ↓
Recorded Patient Characteristics
    ↓
Digital Representation
    ↓
Statistical Analysis
    ↓
Evidence
```

This distinction matters because data exist as representations of real patient characteristics.

The statistical workflow should therefore remain aware of the clinical reality from which the digital variables originate.

---

# 20. The Patient as the Endpoint of Interpretation

The patient is also relevant at the end of the analytical process.

A statistically significant model result may influence discussions concerning:

- quality
- resource allocation
- healthcare organization
- service delivery
- risk assessment
- management priorities

However, the consequences of these decisions ultimately return to patients.

Therefore, the broader research framework can be expressed as:

```text
Patient
    ↓
Digital Patient Representation
    ↓
Statistical Analysis
    ↓
Healthcare Decision
    ↓
Patient-Relevant Outcome
```

This creates a closed analytical perspective in which the patient is both:

```text
the source of the data
```

and

```text
the final reference point of healthcare decision quality
```

---

# 21. Important Unrepresented Dimensions

Several potentially important patient-information dimensions are absent from the dataset.

These include the following.

## Medication

No detailed medication information is available.

The dataset therefore cannot directly evaluate:

- drug exposure
- dosage
- adherence
- treatment changes
- medication interactions

---

## Treatment

No detailed treatment-intervention information is available.

The analysis therefore cannot determine whether observed mortality differences result from different therapeutic strategies.

---

## Symptoms

No structured symptom information is available.

The dataset does not directly represent factors such as:

- dyspnea
- fatigue
- edema
- chest symptoms
- exercise intolerance

---

## Functional Status

No detailed functional-status measurements are available.

Functional capacity may be important when evaluating disease severity and patient outcomes.

---

## Patient-Reported Outcomes

The dataset contains no structured information about:

- quality of life
- symptom burden
- perceived health status
- treatment satisfaction

The mortality outcome therefore captures only one dimension of patient outcome.

---

## Longitudinal Clinical Development

Most clinical measurements are represented as single values rather than repeated trajectories.

The dataset therefore does not show how:

```text
ejection fraction
serum creatinine
serum sodium
platelets
```

change over time.

---

## Socioeconomic Context

No information is available regarding:

- income
- education
- employment
- living situation
- social support
- access barriers

These dimensions may influence healthcare outcomes but remain outside the digital representation.

---

## Healthcare Resource Use

The dataset contains no direct variables describing:

- hospitalization intensity
- staffing
- bed use
- treatment cost
- service utilization
- resource consumption
- capacity constraints

The project therefore cannot directly estimate the relationship between management-resource decisions and patient outcomes.

---

## Management Decisions

No healthcare-management intervention is observed.

Therefore:

```text
Patient Data
→ Management Decision
→ Clinical Outcome
```

cannot be evaluated directly with this dataset.

The project instead investigates the earlier methodological step:

```text
Patient Data
→ Statistical Reliability
→ Potential Decision Support
```

---

# 22. What the Dataset Can Support

Within its limitations, the dataset can support analyses concerning:

- description of the observed patient population
- mortality-group comparisons
- statistical associations
- correlation structures
- multivariable mortality associations
- dependence of results on available patient information
- sensitivity to representation reduction
- sensitivity to dichotomization
- methodological discussion of digital patient representation

---

# 23. What the Dataset Cannot Establish

The dataset cannot independently establish:

- causal treatment effects
- individualized treatment recommendations
- clinical decision rules
- validated patient-risk thresholds
- optimal management strategies
- effectiveness of resource-allocation decisions
- complete clinical patient states
- clinical sufficiency of the available representation
- generalizability to all patients with heart failure

These limits are treated as part of the scientific interpretation rather than as minor technical caveats.

---

# 24. Core Representation Principles

The following principles summarize the digital patient representation framework used in the project.

### Principle 1

> **The dataset is a representation of the patient, not the patient itself.**

### Principle 2

> **Technical completeness does not imply clinical completeness.**

A dataset can contain no missing values while still omitting entire clinically relevant dimensions.

### Principle 3

> **Representation granularity matters.**

Continuous, categorical, binary, and aggregated variables preserve different amounts of information.

### Principle 4

> **Information loss can change statistical conclusions.**

Removing or simplifying patient information may alter model fit, coefficient estimates, predicted probabilities, or analytical classifications.

### Principle 5

> **More data are not automatically sufficient data.**

Adding variables may improve statistical information without necessarily creating a clinically complete patient representation.

### Principle 6

> **Statistical reliability is not equivalent to clinical validity.**

### Principle 7

> **The required patient representation depends on the decision being supported.**

### Principle 8

> **A sophisticated model cannot fully compensate for clinically relevant information that was never recorded.**

---

# 25. Generalizable Research Framework

The patient-representation framework used in this project is intended to be reusable across future healthcare datasets.

For every new patient dataset, the analysis should address the following questions:

```text
1. Who are the patients?

2. Which aspects of the patients are digitally represented?

3. Which clinically relevant dimensions are absent?

4. At what level of granularity is the information recorded?

5. Which outcome is represented?

6. How reliable are the statistical findings?

7. How do findings change when patient information is reduced
   or simplified?

8. Which potential healthcare decisions could use this type
   of information?

9. Which conclusions cannot be drawn from the available
   representation?

10. Which questions require additional clinical information
    or medical expertise?
```

This creates the reusable analytical structure:

```text
Patient
    ↓
Digital Patient Representation
    ↓
Data Quality
    ↓
Statistical Analysis
    ↓
Representation Sensitivity
    ↓
Statistical Reliability
    ↓
Potential Decision Implications
    ↓
Clinical Boundary
```

The disease, dataset, outcome, and specific statistical methods may change between projects.

The underlying research logic remains consistent.

---

# 26. Final Interpretation

The Heart Failure Clinical Records dataset provides a meaningful but incomplete digital representation of patients with heart failure.

It contains information relating to:

- demographics
- selected comorbidities
- cardiac function
- renal function
- hematological and biochemical measurements
- smoking status
- follow-up duration
- mortality

At the same time, important dimensions remain unavailable, including:

- detailed treatment
- medication
- symptoms
- functional status
- patient-reported outcomes
- longitudinal clinical development
- socioeconomic context
- healthcare resource use
- management interventions

The available dataset can therefore support statistical analysis of selected patient characteristics and mortality patterns, but it cannot represent the complete clinical reality of the patient.

The representation sensitivity analysis extends this interpretation by asking whether statistical conclusions remain stable when the amount or structure of patient information changes.

This produces the central methodological question underlying the project:

> **How clinically adequate must a digital patient representation be for statistical models to provide reliable support for healthcare decision-making?**

The project does not claim to answer this question universally.

Instead, it establishes a reproducible analytical framework for studying it across different patient datasets.

The long-term research perspective is therefore not limited to determining which variables are statistically associated with an outcome.

It focuses on the relationship between:

```text
Patient Reality
        ↓
Digital Representation
        ↓
Statistical Evidence
        ↓
Decision Reliability
        ↓
Patient-Relevant Outcomes
```

The central conclusion is:

> **Data-driven healthcare decisions should not be evaluated only by the statistical model used to generate them. They should also be evaluated by the quality, completeness, and clinical adequacy of the digital patient representation on which the model depends.**