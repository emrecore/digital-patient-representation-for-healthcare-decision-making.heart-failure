# ============================================================
# Project: Representation Sensitivity Analysis
#          in Heart Failure with R
# File: 01_data_import_and_setup.R
# Purpose: Import the dataset, preserve the raw source data,
#          validate source coding required for setup, define
#          reusable variable groups, and configure variables
#          for the sequential analytical workflow.
# ============================================================


# ============================================================
# 1. Define dataset path
# ============================================================

data_path <- "data/heart_failure_clinical_records_dataset.csv"

if (!file.exists(data_path)) {
  stop(
    paste0(
      "Dataset not found at expected path: ",
      data_path
    )
  )
}


# ============================================================
# 2. Import and preserve raw dataset
# ============================================================

heart_failure_raw <- read.csv(
  data_path,
  stringsAsFactors = FALSE
)

# Preserve the imported source data unchanged.
# All subsequent configuration is performed on a separate
# working copy.
heart_failure <- heart_failure_raw


# ============================================================
# 3. Define reusable variable groups
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

observation_variables <- c(
  follow_up_variable
)

outcome_variable <- "DEATH_EVENT"

baseline_variables <- c(
  baseline_numerical_variables,
  baseline_categorical_variables
)

numerical_variables <- c(
  baseline_numerical_variables,
  observation_variables
)

categorical_variables <- c(
  baseline_categorical_variables,
  outcome_variable
)

expected_variables <- c(
  baseline_variables,
  observation_variables,
  outcome_variable
)


# ============================================================
# 4. Define categorical labels
# ============================================================

yes_no_labels <- c(
  "No",
  "Yes"
)

sex_labels <- c(
  "Female",
  "Male"
)

outcome_labels <- c(
  "No recorded death event",
  "Death event recorded"
)


# ============================================================
# 5. Verify variables required for setup
# ============================================================

missing_required_variables <- setdiff(
  expected_variables,
  names(heart_failure_raw)
)

if (length(missing_required_variables) > 0) {
  stop(
    paste0(
      "Dataset setup failed. Missing required variable(s): ",
      paste(missing_required_variables, collapse = ", ")
    )
  )
}

# A complete structural audit, including unexpected variables,
# is performed in 02_patient_representation_and_data_quality.R.
# This setup-stage check only ensures that the variables required
# for configuration are available.


# ============================================================
# 6. Validate binary source coding
# ============================================================

binary_source_variables <- c(
  yes_no_variables,
  "sex",
  outcome_variable
)

for (variable in binary_source_variables) {
  
  source_values <- heart_failure_raw[[variable]]
  
  non_missing_values <- source_values[
    !is.na(source_values)
  ]
  
  numeric_source_values <- suppressWarnings(
    as.numeric(as.character(non_missing_values))
  )
  
  conversion_failed <- is.na(numeric_source_values)
  
  if (any(conversion_failed)) {
    invalid_values <- unique(
      non_missing_values[conversion_failed]
    )
    
    stop(
      paste0(
        "Dataset setup failed. Variable '",
        variable,
        "' contains non-numeric source code(s): ",
        paste(invalid_values, collapse = ", "),
        ". Expected binary coding: 0 or 1."
      )
    )
  }
  
  unexpected_codes <- setdiff(
    unique(numeric_source_values),
    c(0, 1)
  )
  
  if (length(unexpected_codes) > 0) {
    stop(
      paste0(
        "Dataset setup failed. Variable '",
        variable,
        "' contains unexpected source code(s): ",
        paste(unexpected_codes, collapse = ", "),
        ". Expected binary coding: 0 or 1."
      )
    )
  }
}


# ============================================================
# 7. Safely configure numerical variables
# ============================================================

for (variable in numerical_variables) {
  
  source_values <- heart_failure[[variable]]
  
  configured_values <- suppressWarnings(
    as.numeric(as.character(source_values))
  )
  
  conversion_failure <- (
    is.na(configured_values) &
      !is.na(source_values)
  )
  
  if (any(conversion_failure)) {
    invalid_values <- unique(
      source_values[conversion_failure]
    )
    
    stop(
      paste0(
        "Dataset setup failed. Variable '",
        variable,
        "' contains value(s) that cannot be converted ",
        "to numeric format: ",
        paste(invalid_values, collapse = ", ")
      )
    )
  }
  
  heart_failure[[variable]] <- configured_values
}

# Missingness, non-finite values, logical plausibility, and
# potential numerical outliers are evaluated in the dedicated
# data-quality audit in script 02.


# ============================================================
# 8. Configure categorical variables
# ============================================================

heart_failure[yes_no_variables] <- lapply(
  heart_failure[yes_no_variables],
  factor,
  levels = c(0, 1),
  labels = yes_no_labels
)

heart_failure$sex <- factor(
  heart_failure$sex,
  levels = c(0, 1),
  labels = sex_labels
)

heart_failure[[outcome_variable]] <- factor(
  heart_failure[[outcome_variable]],
  levels = c(0, 1),
  labels = outcome_labels
)


# ============================================================
# 9. Verify configured variable classes
# ============================================================

numerical_class_check <- vapply(
  heart_failure[numerical_variables],
  is.numeric,
  logical(1)
)

categorical_class_check <- vapply(
  heart_failure[categorical_variables],
  is.factor,
  logical(1)
)

if (!all(numerical_class_check)) {
  stop(
    paste0(
      "Dataset setup failed. Numerical configuration was ",
      "unsuccessful for: ",
      paste(
        names(numerical_class_check)[
          !numerical_class_check
        ],
        collapse = ", "
      )
    )
  )
}

if (!all(categorical_class_check)) {
  stop(
    paste0(
      "Dataset setup failed. Categorical configuration was ",
      "unsuccessful for: ",
      paste(
        names(categorical_class_check)[
          !categorical_class_check
        ],
        collapse = ", "
      )
    )
  )
}


# ============================================================
# 10. Inspect source and configured datasets
# ============================================================

cat("\n========================================\n")
cat("RAW SOURCE DATASET\n")
cat("========================================\n\n")

str(heart_failure_raw)

cat("\n========================================\n")
cat("CONFIGURED ANALYTICAL DATASET\n")
cat("========================================\n\n")

str(heart_failure)


# ============================================================
# 11. Setup summary
# ============================================================

cat("\n========================================\n")
cat("DATA SETUP COMPLETE\n")
cat("========================================\n")

cat(
  "\nRows:",
  nrow(heart_failure)
)

cat(
  "\nColumns:",
  ncol(heart_failure)
)

cat(
  "\nBaseline variables:",
  length(baseline_variables)
)

cat(
  "\nObservation variables:",
  length(observation_variables)
)

cat(
  "\nOutcome variable:",
  outcome_variable
)

cat(
  "\n\nRaw source data preserved as: heart_failure_raw"
)

cat(
  "\nConfigured analytical data stored as: heart_failure\n"
)

