# Healthcare Context

## Heart Failure

Heart failure is a cardiovascular syndrome in which the heart cannot adequately meet the body's physiological demands.

Patients with heart failure can differ substantially in demographic characteristics, comorbidities, cardiac function, laboratory measurements, and overall disease severity. These differences may also be associated with prognosis and mortality.

This project analyzes clinical records from **299 patients with heart failure**.

The dataset is treated as a **partial digital representation of real patients**, rather than a complete description of their clinical condition.

---

## Clinical Information Represented

The dataset contains selected information from several patient-health domains.

### Demographics

- age
- sex

### Cardiac Function

- ejection fraction

### Renal and Biochemical Status

- serum creatinine
- serum sodium
- creatinine phosphokinase

### Hematological Information

- anaemia
- platelet count

### Comorbidities and Risk Factors

- diabetes
- high blood pressure
- smoking status

These variables provide clinically interpretable information about the observed patients, but they represent only selected dimensions of the complete clinical picture.

---

## Mortality Outcome and Follow-Up

The primary outcome is:

```text
DEATH_EVENT