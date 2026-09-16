# ============================================================
# Project: Digital Patient Representation for
#          Healthcare Decision-Making: Heart Failure
# File: 02_patient_representation_and_data_quality.R
# Purpose: Assess digital patient representation and
#          technical data quality.
# ============================================================


# ============================================================
# 1. Confirm required setup objects from script 01
# ============================================================

required_setup_objects <- c(
  "heart_failure",
  "baseline_numerical_variables",
  "baseline_categorical_variables",
  "numerical_variables",
  "categorical_variables",
  "baseline_variables",
  "follow_up_variable",
  "outcome_variable"
)

missing_setup_objects <- required_setup_objects[
  !vapply(
    required_setup_objects,
    exists,
    logical(1),
    inherits = TRUE
  )
]

if (length(missing_setup_objects) > 0) {
  stop(
    paste(
      "Run 01_data_import_and_setup.R first. Missing objects:",
      paste(missing_setup_objects, collapse = ", ")
    )
  )
}


# ============================================================
# 2. Check expected dataset structure
# ============================================================

expected_variables <- c(
  baseline_variables,
  follow_up_variable,
  outcome_variable
)

missing_variables <- setdiff(
  expected_variables,
  names(heart_failure)
)

unexpected_variables <- setdiff(
  names(heart_failure),
  expected_variables
)

if (length(missing_variables) > 0) {
  stop(
    paste(
      "Expected variables are missing:",
      paste(missing_variables, collapse = ", ")
    )
  )
}


# ============================================================
# 3. Validate configured variable classes
# ============================================================

variable_class_check <- data.frame(
  Variable = expected_variables,
  Expected_Class = ifelse(
    expected_variables %in% numerical_variables,
    "numeric",
    "factor"
  ),
  Actual_Class = vapply(
    heart_failure[expected_variables],
    function(x) {
      if (is.numeric(x)) {
        "numeric"
      } else if (is.factor(x)) {
        "factor"
      } else {
        class(x)[1]
      }
    },
    character(1)
  ),
  stringsAsFactors = FALSE
)

variable_class_check$Valid <-
  variable_class_check$Expected_Class ==
  variable_class_check$Actual_Class

if (any(!variable_class_check$Valid)) {
  stop(
    "Unexpected variable classes detected. Check script 01."
  )
}


# ============================================================
# 4. Validate categorical factor levels
# ============================================================

expected_factor_levels <- list(
  anaemia = c("No", "Yes"),
  diabetes = c("No", "Yes"),
  high_blood_pressure = c("No", "Yes"),
  smoking = c("No", "Yes"),
  sex = c("Female", "Male"),
  DEATH_EVENT = c(
    "No death event",
    "Death event"
  )
)

factor_level_check <- do.call(
  rbind,
  lapply(
    names(expected_factor_levels),
    function(variable) {
      
      actual <- levels(
        heart_failure[[variable]]
      )
      
      expected <- expected_factor_levels[[variable]]
      
      data.frame(
        Variable = variable,
        Expected_Levels = paste(
          expected,
          collapse = " | "
        ),
        Actual_Levels = paste(
          actual,
          collapse = " | "
        ),
        Valid = identical(
          actual,
          expected
        ),
        stringsAsFactors = FALSE
      )
    }
  )
)

row.names(factor_level_check) <- NULL


# ============================================================
# 5. Map the digital patient representation
# ============================================================

patient_representation_map <- data.frame(
  
  Patient_Dimension = c(
    "Demographics",
    "Cardiac function",
    "Renal status",
    "Hematological information",
    "Biochemical information",
    "Comorbidities",
    "Behavioral risk factors",
    "Mortality outcome",
    "Follow-up information",
    "Detailed disease severity",
    "Medication",
    "Treatment interventions",
    "Symptoms",
    "Functional status",
    "Longitudinal clinical development",
    "Patient-reported outcomes",
    "Socioeconomic context",
    "Healthcare resource use",
    "Management decisions"
  ),
  
  Representation = c(
    "Partial",
    "Partial",
    "Partial",
    "Partial",
    "Partial",
    "Partial",
    "Very limited",
    "Available",
    "Available",
    "Limited",
    rep(
      "Not represented",
      9
    )
  ),
  
  Available_Information = c(
    "Age, sex",
    "Ejection fraction",
    "Serum creatinine",
    "Anaemia, platelets",
    "Serum sodium, CPK, serum creatinine",
    "Anaemia, diabetes, hypertension",
    "Smoking status",
    "Recorded death event",
    "Follow-up duration",
    "Selected clinical measurements only",
    "None",
    "None",
    "None",
    "None",
    "None",
    "None",
    "None",
    "None",
    "None"
  ),
  
  stringsAsFactors = FALSE
)


# ============================================================
# 6. Identify representation gaps
# ============================================================

representation_gaps <- patient_representation_map[
  patient_representation_map$Representation !=
    "Available",
  ,
  drop = FALSE
]

unrepresented_dimensions <- patient_representation_map[
  patient_representation_map$Representation ==
    "Not represented",
  ,
  drop = FALSE
]


# ============================================================
# 7. Check missing values
# ============================================================

missing_value_summary <- data.frame(
  
  Variable = expected_variables,
  
  Missing_N = vapply(
    heart_failure[expected_variables],
    function(x) {
      sum(is.na(x))
    },
    numeric(1)
  ),
  
  stringsAsFactors = FALSE
)

missing_value_summary$Missing_Percentage <- round(
  (
    missing_value_summary$Missing_N /
      nrow(heart_failure)
  ) * 100,
  2
)


# ============================================================
# 8. Check duplicated observations
# ============================================================

duplicate_row_indices <- which(
  duplicated(heart_failure)
)

duplicate_row_count <- length(
  duplicate_row_indices
)


# ============================================================
# 9. Check non-finite numerical values
# ============================================================

non_finite_summary <- data.frame(
  
  Variable = numerical_variables,
  
  Non_Finite_N = vapply(
    heart_failure[numerical_variables],
    function(x) {
      sum(
        !is.na(x) &
          !is.finite(x)
      )
    },
    numeric(1)
  ),
  
  stringsAsFactors = FALSE
)


# ============================================================
# 10. Check basic logical validity
# These rules identify impossible values, not clinical
# reference ranges.
# ============================================================

logical_rules <- list(
  age = function(x) x > 0,
  creatinine_phosphokinase =
    function(x) x >= 0,
  ejection_fraction =
    function(x) x >= 0 & x <= 100,
  platelets =
    function(x) x >= 0,
  serum_creatinine =
    function(x) x >= 0,
  serum_sodium =
    function(x) x >= 0,
  time =
    function(x) x >= 0
)

logical_validity_summary <- do.call(
  rbind,
  lapply(
    names(logical_rules),
    function(variable) {
      
      x <- heart_failure[[variable]]
      valid <- logical_rules[[variable]](x)
      
      data.frame(
        Variable = variable,
        Invalid_N = sum(
          !is.na(x) &
            !valid
        ),
        stringsAsFactors = FALSE
      )
    }
  )
)

row.names(logical_validity_summary) <- NULL


# ============================================================
# 11. Check constant variables
# ============================================================

constant_variable_summary <- data.frame(
  
  Variable = expected_variables,
  
  Unique_N = vapply(
    heart_failure[expected_variables],
    function(x) {
      length(
        unique(
          x[!is.na(x)]
        )
      )
    },
    numeric(1)
  ),
  
  stringsAsFactors = FALSE
)

constant_variable_summary$Constant <-
  constant_variable_summary$Unique_N <= 1


# ============================================================
# 12. Identify potential numerical outliers
# Uses the conventional 1.5 × IQR rule.
#
# Outliers are flagged only. They are not removed.
# ============================================================

potential_outlier_summary <- do.call(
  rbind,
  lapply(
    numerical_variables,
    function(variable) {
      
      x <- heart_failure[[variable]]
      
      q1 <- as.numeric(
        quantile(
          x,
          0.25,
          na.rm = TRUE
        )
      )
      
      q3 <- as.numeric(
        quantile(
          x,
          0.75,
          na.rm = TRUE
        )
      )
      
      iqr <- IQR(
        x,
        na.rm = TRUE
      )
      
      lower_bound <- q1 - 1.5 * iqr
      upper_bound <- q3 + 1.5 * iqr
      
      outlier_flag <-
        !is.na(x) &
        (
          x < lower_bound |
            x > upper_bound
        )
      
      data.frame(
        Variable = variable,
        Lower_Bound = lower_bound,
        Upper_Bound = upper_bound,
        Potential_Outliers_N = sum(
          outlier_flag
        ),
        stringsAsFactors = FALSE
      )
    }
  )
)

row.names(potential_outlier_summary) <- NULL


# ============================================================
# 13. Create technical data-quality overview
# ============================================================

data_quality_overview <- data.frame(
  
  Rows = nrow(
    heart_failure
  ),
  
  Columns = ncol(
    heart_failure
  ),
  
  Missing_Values = sum(
    missing_value_summary$Missing_N
  ),
  
  Duplicate_Rows =
    duplicate_row_count,
  
  Non_Finite_Values = sum(
    non_finite_summary$Non_Finite_N
  ),
  
  Invalid_Values = sum(
    logical_validity_summary$Invalid_N
  ),
  
  Constant_Variables = sum(
    constant_variable_summary$Constant
  ),
  
  Potential_Outlier_Values = sum(
    potential_outlier_summary$
      Potential_Outliers_N
  )
)


# ============================================================
# 14. Consolidate representation and quality results
# ============================================================

patient_representation_and_quality <- list(
  
  Representation_Map =
    patient_representation_map,
  
  Representation_Gaps =
    representation_gaps,
  
  Unrepresented_Dimensions =
    unrepresented_dimensions,
  
  Variable_Class_Check =
    variable_class_check,
  
  Factor_Level_Check =
    factor_level_check,
  
  Missing_Values =
    missing_value_summary,
  
  Duplicate_Row_Indices =
    duplicate_row_indices,
  
  Non_Finite_Values =
    non_finite_summary,
  
  Logical_Validity =
    logical_validity_summary,
  
  Constant_Variables =
    constant_variable_summary,
  
  Potential_Outliers =
    potential_outlier_summary,
  
  Data_Quality_Overview =
    data_quality_overview
)


# ============================================================
# 15. Display concise audit results
# ============================================================

cat(
  "\n",
  "============================================================\n",
  "PATIENT REPRESENTATION AND DATA QUALITY\n",
  "============================================================\n",
  sep = ""
)

cat(
  "\nDATA QUALITY OVERVIEW\n"
)

print(
  data_quality_overview
)

cat(
  "\nDIGITAL PATIENT REPRESENTATION\n"
)

print(
  patient_representation_map
)

cat(
  "\nREPRESENTATION GAPS\n"
)

print(
  representation_gaps
)

cat(
  "\nPOTENTIAL NUMERICAL OUTLIERS\n"
)

print(
  potential_outlier_summary
)


# ============================================================
# 16. Final interpretation note
# ============================================================

cat(
  "\nINTERPRETATION NOTE\n",
  "Technical data quality and patient representation are ",
  "different concepts.\n",
  "A dataset may contain no missing values while still ",
  "representing only selected dimensions of the real patient.\n",
  "Potential statistical outliers are flagged for inspection ",
  "and are not removed automatically.\n",
  sep = ""
)


# ============================================================
# 17. Return complete audit object
# ============================================================

patient_representation_and_quality

