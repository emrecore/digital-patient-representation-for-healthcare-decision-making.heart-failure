# ============================================================
# Project: Heart Failure Clinical Statistical Analysis with R
# File: 05_group_comparisons.R
# Purpose: Compare clinical characteristics between patients
# with and without a recorded death event during follow-up.
# Language: R
# ============================================================


# ============================================================
# 1. Define variable groups
# Select numerical and categorical variables for comparisons
# across mortality outcome groups.
# ============================================================

numerical_variables <- c(
  "age",
  "creatinine_phosphokinase",
  "ejection_fraction",
  "platelets",
  "serum_creatinine",
  "serum_sodium",
  "time"
)

categorical_variables <- c(
  "anaemia",
  "diabetes",
  "high_blood_pressure",
  "sex",
  "smoking"
)


# ============================================================
# 2. Compare numerical variables by mortality outcome
# Calculate descriptive statistics separately for patients
# with and without a recorded death event.
# ============================================================

grouped_numerical_summary <- do.call(
  rbind,
  lapply(
    numerical_variables,
    function(variable) {
      
      do.call(
        rbind,
        lapply(
          levels(heart_failure$DEATH_EVENT),
          function(outcome) {
            
            values <- heart_failure[
              heart_failure$DEATH_EVENT == outcome,
              variable
            ]
            
            data.frame(
              Variable = variable,
              Mortality_Outcome = outcome,
              N = sum(!is.na(values)),
              Mean = mean(values, na.rm = TRUE),
              Median = median(values, na.rm = TRUE),
              Standard_Deviation = sd(values, na.rm = TRUE),
              Q1 = quantile(
                values,
                0.25,
                na.rm = TRUE
              ),
              Q3 = quantile(
                values,
                0.75,
                na.rm = TRUE
              ),
              IQR = IQR(
                values,
                na.rm = TRUE
              )
            )
          }
        )
      )
    }
  )
)

row.names(grouped_numerical_summary) <- NULL

grouped_numerical_summary[, 3:9] <- round(
  grouped_numerical_summary[, 3:9],
  2
)

grouped_numerical_summary


# ============================================================
# 3. Compare anaemia by mortality outcome
# Cross-tabulate anaemia status and mortality outcome.
# ============================================================

anaemia_comparison <- table(
  heart_failure$anaemia,
  heart_failure$DEATH_EVENT
)

anaemia_comparison

round(
  prop.table(
    anaemia_comparison,
    margin = 2
  ) * 100,
  2
)


# ============================================================
# 4. Compare diabetes by mortality outcome
# Cross-tabulate diabetes status and mortality outcome.
# ============================================================

diabetes_comparison <- table(
  heart_failure$diabetes,
  heart_failure$DEATH_EVENT
)

diabetes_comparison

round(
  prop.table(
    diabetes_comparison,
    margin = 2
  ) * 100,
  2
)


# ============================================================
# 5. Compare high blood pressure by mortality outcome
# Cross-tabulate hypertension status and mortality outcome.
# ============================================================

blood_pressure_comparison <- table(
  heart_failure$high_blood_pressure,
  heart_failure$DEATH_EVENT
)

blood_pressure_comparison

round(
  prop.table(
    blood_pressure_comparison,
    margin = 2
  ) * 100,
  2
)


# ============================================================
# 6. Compare sex by mortality outcome
# Cross-tabulate patient sex and mortality outcome.
# ============================================================

sex_comparison <- table(
  heart_failure$sex,
  heart_failure$DEATH_EVENT
)

sex_comparison

round(
  prop.table(
    sex_comparison,
    margin = 2
  ) * 100,
  2
)


# ============================================================
# 7. Compare smoking status by mortality outcome
# Cross-tabulate smoking status and mortality outcome.
# ============================================================

smoking_comparison <- table(
  heart_failure$smoking,
  heart_failure$DEATH_EVENT
)

smoking_comparison

round(
  prop.table(
    smoking_comparison,
    margin = 2
  ) * 100,
  2
)

