# ============================================================
# Project: Digital Patient Representation for
#          Healthcare Decision-Making: Heart Failure
# File: 01_data_import_and_setup.R
# Purpose: Import and configure the dataset for analysis.
# ============================================================


# ============================================================
# 1. Import dataset
# ============================================================

heart_failure <- read.csv(
  "data/heart_failure_clinical_records_dataset.csv",
  stringsAsFactors = FALSE
)

str(heart_failure)


# ============================================================
# 2. Define reusable variable groups
# ============================================================

baseline_numerical_variables <- c(
  "age",
  "creatinine_phosphokinase",
  "ejection_fraction",
  "platelets",
  "serum_creatinine",
  "serum_sodium"
)

yes_no_variables <- c(
  "anaemia",
  "diabetes",
  "high_blood_pressure",
  "smoking"
)

baseline_categorical_variables <- c(
  yes_no_variables,
  "sex"
)

follow_up_variable <- "time"
outcome_variable <- "DEATH_EVENT"

baseline_variables <- c(
  baseline_numerical_variables,
  baseline_categorical_variables
)

numerical_variables <- c(
  baseline_numerical_variables,
  follow_up_variable
)

categorical_variables <- c(
  baseline_categorical_variables,
  outcome_variable
)


# ============================================================
# 3. Configure numerical variables
# ============================================================

heart_failure[numerical_variables] <- lapply(
  heart_failure[numerical_variables],
  as.numeric
)


# ============================================================
# 4. Configure categorical variables
# ============================================================

heart_failure[yes_no_variables] <- lapply(
  heart_failure[yes_no_variables],
  factor,
  levels = c(0, 1),
  labels = c("No", "Yes")
)

heart_failure$sex <- factor(
  heart_failure$sex,
  levels = c(0, 1),
  labels = c("Female", "Male")
)

heart_failure$DEATH_EVENT <- factor(
  heart_failure$DEATH_EVENT,
  levels = c(0, 1),
  labels = c("No death event", "Death event")
)


# ============================================================
# 5. Inspect configured dataset
# ============================================================

str(heart_failure)

