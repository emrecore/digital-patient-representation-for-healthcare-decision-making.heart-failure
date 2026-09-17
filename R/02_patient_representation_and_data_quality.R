# ============================================================
# Project: Representation Sensitivity Analysis
#          in Heart Failure with R
# File: 02_patient_representation_and_data_quality.R
# Purpose: Audit technical data quality and document the
#          informational boundaries of the available digital
#          patient representation.
# ============================================================


# ============================================================
# 1. Confirm required setup objects from script 01
# ============================================================

required_setup_objects <- c(
  "heart_failure_raw",
  "heart_failure",
  "baseline_numerical_variables",
  "yes_no_variables",
  "baseline_categorical_variables",
  "baseline_variables",
  "follow_up_variable",
  "observation_variables",
  "outcome_variable",
  "numerical_variables",
  "categorical_variables",
  "expected_variables",
  "binary_source_variables",
  "yes_no_labels",
  "sex_labels",
  "outcome_labels"
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
    paste0(
      "Run 01_data_import_and_setup.R first. Missing object(s): ",
      paste(missing_setup_objects, collapse = ", ")
    )
  )
}


# ============================================================
# 2. Verify source and configured dataset dimensions
# ============================================================

if (
  nrow(heart_failure_raw) != nrow(heart_failure) ||
  ncol(heart_failure_raw) != ncol(heart_failure)
) {
  stop(
    paste0(
      "Dataset audit failed. Raw and configured datasets ",
      "do not have identical dimensions."
    )
  )
}


# ============================================================
# 3. Audit expected dataset structure
# ============================================================

raw_missing_variables <- setdiff(
  expected_variables,
  names(heart_failure_raw)
)

raw_unexpected_variables <- setdiff(
  names(heart_failure_raw),
  expected_variables
)

configured_missing_variables <- setdiff(
  expected_variables,
  names(heart_failure)
)

configured_unexpected_variables <- setdiff(
  names(heart_failure),
  expected_variables
)

duplicate_raw_column_names <- unique(
  names(heart_failure_raw)[
    duplicated(names(heart_failure_raw))
  ]
)

duplicate_configured_column_names <- unique(
  names(heart_failure)[
    duplicated(names(heart_failure))
  ]
)

if (
  length(raw_missing_variables) > 0 ||
  length(configured_missing_variables) > 0
) {
  stop(
    paste0(
      "Dataset audit failed. Expected variable(s) are missing. ",
      "Raw dataset: ",
      ifelse(
        length(raw_missing_variables) == 0,
        "none",
        paste(raw_missing_variables, collapse = ", ")
      ),
      ". Configured dataset: ",
      ifelse(
        length(configured_missing_variables) == 0,
        "none",
        paste(configured_missing_variables, collapse = ", ")
      ),
      "."
    )
  )
}

if (
  length(raw_unexpected_variables) > 0 ||
  length(configured_unexpected_variables) > 0
) {
  stop(
    paste0(
      "Dataset audit failed. Unexpected variable(s) detected. ",
      "Raw dataset: ",
      ifelse(
        length(raw_unexpected_variables) == 0,
        "none",
        paste(raw_unexpected_variables, collapse = ", ")
      ),
      ". Configured dataset: ",
      ifelse(
        length(configured_unexpected_variables) == 0,
        "none",
        paste(configured_unexpected_variables, collapse = ", ")
      ),
      "."
    )
  )
}

if (
  length(duplicate_raw_column_names) > 0 ||
  length(duplicate_configured_column_names) > 0
) {
  stop(
    "Dataset audit failed. Duplicate column names detected."
  )
}

schema_check <- data.frame(
  Dataset = c(
    "Raw source data",
    "Configured analytical data"
  ),
  Rows = c(
    nrow(heart_failure_raw),
    nrow(heart_failure)
  ),
  Columns = c(
    ncol(heart_failure_raw),
    ncol(heart_failure)
  ),
  Missing_Expected_Variables = c(
    length(raw_missing_variables),
    length(configured_missing_variables)
  ),
  Unexpected_Variables = c(
    length(raw_unexpected_variables),
    length(configured_unexpected_variables)
  ),
  Duplicate_Column_Names = c(
    length(duplicate_raw_column_names),
    length(duplicate_configured_column_names)
  ),
  stringsAsFactors = FALSE
)


# ============================================================
# 4. Audit original binary source coding
# ============================================================

source_coding_check <- do.call(
  rbind,
  lapply(
    binary_source_variables,
    function(variable) {
      
      source_values <- heart_failure_raw[[variable]]
      
      non_missing_values <- source_values[
        !is.na(source_values)
      ]
      
      numeric_values <- suppressWarnings(
        as.numeric(as.character(non_missing_values))
      )
      
      conversion_failure <- is.na(numeric_values)
      
      unexpected_codes <- numeric_values[
        !conversion_failure &
          !(numeric_values %in% c(0, 1))
      ]
      
      data.frame(
        Variable = variable,
        Missing_N = sum(is.na(source_values)),
        Non_Numeric_Code_N = sum(conversion_failure),
        Unexpected_Binary_Code_N = length(
          unexpected_codes
        ),
        Valid_Binary_Source_Coding =
          sum(conversion_failure) == 0 &&
          length(unexpected_codes) == 0,
        stringsAsFactors = FALSE
      )
    }
  )
)

row.names(source_coding_check) <- NULL

if (any(!source_coding_check$Valid_Binary_Source_Coding)) {
  stop(
    paste0(
      "Dataset audit failed. Invalid binary source coding ",
      "detected. Check source_coding_check."
    )
  )
}


# ============================================================
# 5. Validate configured variable classes
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
    paste0(
      "Dataset audit failed. Unexpected configured class for: ",
      paste(
        variable_class_check$Variable[
          !variable_class_check$Valid
        ],
        collapse = ", "
      )
    )
  )
}


# ============================================================
# 6. Validate configured categorical factor levels
# ============================================================

expected_factor_levels <- list(
  anaemia = yes_no_labels,
  diabetes = yes_no_labels,
  high_blood_pressure = yes_no_labels,
  smoking = yes_no_labels,
  sex = sex_labels,
  DEATH_EVENT = outcome_labels
)

factor_level_check <- do.call(
  rbind,
  lapply(
    names(expected_factor_levels),
    function(variable) {
      
      actual_levels <- levels(
        heart_failure[[variable]]
      )
      
      expected_levels <- expected_factor_levels[
        [variable]
      ]
      
      data.frame(
        Variable = variable,
        Expected_Levels = paste(
          expected_levels,
          collapse = " | "
        ),
        Actual_Levels = paste(
          actual_levels,
          collapse = " | "
        ),
        Valid = identical(
          actual_levels,
          expected_levels
        ),
        stringsAsFactors = FALSE
      )
    }
  )
)

row.names(factor_level_check) <- NULL

if (any(!factor_level_check$Valid)) {
  stop(
    paste0(
      "Dataset audit failed. Unexpected factor levels for: ",
      paste(
        factor_level_check$Variable[
          !factor_level_check$Valid
        ],
        collapse = ", "
      )
    )
  )
}


# ============================================================
# 7. Map the available digital patient representation
# ============================================================
#
# The map below is a qualitative, project-defined description
# of broad patient-information domains.
#
# It is NOT:
# - a validated representation-quality scale
# - a clinical adequacy score
# - a patient-completeness score
# - a validated representation-gap metric
#
# Broad domains may be classified as "Partial" even when the
# variables actually present in the dataset are complete,
# because only selected aspects of the broader domain are
# digitally represented.
# ============================================================

patient_representation_map <- data.frame(
  
  Patient_Information_Domain = c(
    "Demographics",
    "Cardiac function",
    "Renal information",
    "Hematological information",
    "Other laboratory information",
    "Selected comorbidities",
    "Behavioral information",
    "Detailed symptom burden",
    "Functional status",
    "Detailed medication information",
    "Detailed treatment information",
    "Patient-reported outcomes",
    "Socioeconomic context",
    "Longitudinal clinical trajectories"
  ),
  
  Representation_Status = c(
    "Partial",
    "Partial",
    "Partial",
    "Partial",
    "Partial",
    "Partial",
    "Very limited",
    "Not represented",
    "Not represented",
    "Not represented",
    "Not represented",
    "Not represented",
    "Not represented",
    "Not represented"
  ),
  
  Available_Information = c(
    "Age, sex",
    "Ejection fraction",
    "Serum creatinine",
    "Anaemia, platelets",
    "Serum sodium, CPK",
    "Anaemia, diabetes, hypertension",
    "Smoking status",
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
# 8. Document qualitative representation limitations
# ============================================================
#
# This object identifies broad patient-information domains
# that are partial, very limited, or not represented.
#
# It must not be interpreted as a numerical quality score or
# as a validated measurement of a "representation gap".
# ============================================================

representation_limitations <- patient_representation_map[
  patient_representation_map$Representation_Status %in% c(
    "Partial",
    "Very limited",
    "Not represented"
  ),
  ,
  drop = FALSE
]

unrepresented_dimensions <- patient_representation_map[
  patient_representation_map$Representation_Status ==
    "Not represented",
  ,
  drop = FALSE
]


# ============================================================
# 9. Separate observation and outcome information
# ============================================================
#
# Follow-up duration and the recorded death-event outcome are
# analytically important but are not treated as dimensions of
# the baseline digital patient representation.
# ============================================================

observation_and_outcome_context <- data.frame(
  
  Information_Type = c(
    "Observation information",
    "Outcome"
  ),
  
  Variable = c(
    follow_up_variable,
    outcome_variable
  ),
  
  Interpretation = c(
    "Observed follow-up duration",
    "Whether a death event was recorded during observed follow-up"
  ),
  
  Patient_Representation_Dimension = c(
    FALSE,
    FALSE
  ),
  
  stringsAsFactors = FALSE
)


# ============================================================
# 10. Audit missing values
# ============================================================

missing_value_summary <- data.frame(
  
  Variable = expected_variables,
  
  Raw_Missing_N = vapply(
    heart_failure_raw[expected_variables],
    function(x) {
      sum(is.na(x))
    },
    numeric(1)
  ),
  
  Configured_Missing_N = vapply(
    heart_failure[expected_variables],
    function(x) {
      sum(is.na(x))
    },
    numeric(1)
  ),
  
  stringsAsFactors = FALSE
)

missing_value_summary$Raw_Missing_Percentage <- round(
  (
    missing_value_summary$Raw_Missing_N /
      nrow(heart_failure_raw)
  ) * 100,
  2
)

missing_value_summary$Configured_Missing_Percentage <- round(
  (
    missing_value_summary$Configured_Missing_N /
      nrow(heart_failure)
  ) * 100,
  2
)

missing_value_summary$Missingness_Changed_During_Setup <-
  missing_value_summary$Raw_Missing_N !=
  missing_value_summary$Configured_Missing_N

if (
  any(
    missing_value_summary$
    Missingness_Changed_During_Setup
  )
) {
  stop(
    paste0(
      "Dataset audit failed. Missingness changed during ",
      "data configuration. Check missing_value_summary."
    )
  )
}


# ============================================================
# 11. Identify exact duplicate source-data records
# ============================================================
#
# Without a unique patient identifier, identical rows cannot
# automatically be interpreted as confirmed duplicate patients.
# They are therefore reported as exact duplicate records.
# ============================================================

duplicate_row_indices <- which(
  duplicated(
    heart_failure_raw[expected_variables]
  )
)

duplicate_row_count <- length(
  duplicate_row_indices
)


# ============================================================
# 12. Audit non-finite numerical values
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
# 13. Audit basic logical plausibility
# ============================================================
#
# These checks identify values that violate broad logical
# constraints.
#
# They are NOT clinical reference-range checks.
# ============================================================

logical_rules <- list(
  
  age = function(x) {
    x > 0
  },
  
  creatinine_phosphokinase = function(x) {
    x >= 0
  },
  
  ejection_fraction = function(x) {
    x >= 0 & x <= 100
  },
  
  platelets = function(x) {
    x >= 0
  },
  
  serum_creatinine = function(x) {
    x >= 0
  },
  
  serum_sodium = function(x) {
    x >= 0
  },
  
  time = function(x) {
    x >= 0
  }
)

logical_validity_summary <- do.call(
  rbind,
  lapply(
    names(logical_rules),
    function(variable) {
      
      x <- heart_failure[[variable]]
      
      valid <- logical_rules[
        [variable]
      ](x)
      
      invalid_flag <-
        !is.na(x) &
        !is.na(valid) &
        !valid
      
      data.frame(
        Variable = variable,
        Invalid_N = sum(
          invalid_flag
        ),
        stringsAsFactors = FALSE
      )
    }
  )
)

row.names(logical_validity_summary) <- NULL


# ============================================================
# 14. Audit constant variables
# ============================================================

constant_variable_summary <- data.frame(
  
  Variable = expected_variables,
  
  Unique_N = vapply(
    heart_failure[expected_variables],
    function(x) {
      
      non_missing_values <- x[
        !is.na(x)
      ]
      
      length(
        unique(non_missing_values)
      )
    },
    numeric(1)
  ),
  
  stringsAsFactors = FALSE
)

constant_variable_summary$Constant <-
  constant_variable_summary$Unique_N <= 1


# ============================================================
# 15. Identify potential numerical outliers
# ============================================================
#
# The conventional 1.5 × IQR rule is used as a descriptive
# screening procedure.
#
# Potential outliers are flagged only.
# They are not automatically removed or treated as errors.
# ============================================================

calculate_iqr_outlier_summary <- function(
    x,
    variable_name
) {
  
  finite_values <- x[
    !is.na(x) &
      is.finite(x)
  ]
  
  if (length(finite_values) == 0) {
    return(
      data.frame(
        Variable = variable_name,
        Q1 = NA_real_,
        Q3 = NA_real_,
        IQR = NA_real_,
        Lower_Bound = NA_real_,
        Upper_Bound = NA_real_,
        Potential_Outliers_N = NA_integer_,
        stringsAsFactors = FALSE
      )
    )
  }
  
  q1 <- as.numeric(
    quantile(
      finite_values,
      probs = 0.25,
      names = FALSE,
      type = 7
    )
  )
  
  q3 <- as.numeric(
    quantile(
      finite_values,
      probs = 0.75,
      names = FALSE,
      type = 7
    )
  )
  
  iqr_value <- IQR(
    finite_values,
    type = 7
  )
  
  lower_bound <- q1 - 1.5 * iqr_value
  upper_bound <- q3 + 1.5 * iqr_value
  
  outlier_flag <-
    !is.na(x) &
    is.finite(x) &
    (
      x < lower_bound |
        x > upper_bound
    )
  
  data.frame(
    Variable = variable_name,
    Q1 = q1,
    Q3 = q3,
    IQR = iqr_value,
    Lower_Bound = lower_bound,
    Upper_Bound = upper_bound,
    Potential_Outliers_N = sum(
      outlier_flag
    ),
    stringsAsFactors = FALSE
  )
}

potential_outlier_summary <- do.call(
  rbind,
  lapply(
    numerical_variables,
    function(variable) {
      calculate_iqr_outlier_summary(
        heart_failure[[variable]],
        variable
      )
    }
  )
)

row.names(potential_outlier_summary) <- NULL


# ============================================================
# 16. Create technical data-quality overview
# ============================================================

data_quality_overview <- data.frame(
  
  Rows = nrow(
    heart_failure
  ),
  
  Columns = ncol(
    heart_failure
  ),
  
  Missing_Values = sum(
    missing_value_summary$
      Configured_Missing_N
  ),
  
  Exact_Duplicate_Records =
    duplicate_row_count,
  
  Non_Finite_Values = sum(
    non_finite_summary$
      Non_Finite_N
  ),
  
  Logically_Invalid_Values = sum(
    logical_validity_summary$
      Invalid_N
  ),
  
  Constant_Variables = sum(
    constant_variable_summary$
      Constant
  ),
  
  Potential_Outlier_Values = sum(
    potential_outlier_summary$
      Potential_Outliers_N,
    na.rm = TRUE
  ),
  
  stringsAsFactors = FALSE
)


# ============================================================
# 17. Consolidate representation and quality results
# ============================================================

patient_representation_and_quality <- list(
  
  Schema_Check =
    schema_check,
  
  Source_Coding_Check =
    source_coding_check,
  
  Variable_Class_Check =
    variable_class_check,
  
  Factor_Level_Check =
    factor_level_check,
  
  Representation_Map =
    patient_representation_map,
  
  Representation_Limitations =
    representation_limitations,
  
  Unrepresented_Dimensions =
    unrepresented_dimensions,
  
  Observation_And_Outcome_Context =
    observation_and_outcome_context,
  
  Missing_Values =
    missing_value_summary,
  
  Exact_Duplicate_Record_Indices =
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
# 18. Display concise audit results
# ============================================================

cat(
  "\n",
  "============================================================\n",
  "TECHNICAL DATA QUALITY AND PATIENT REPRESENTATION\n",
  "============================================================\n",
  sep = ""
)


cat(
  "\nTECHNICAL DATA-QUALITY OVERVIEW\n"
)

print(
  data_quality_overview
)


cat(
  "\nDIGITAL PATIENT REPRESENTATION\n"
)

print(
  patient_representation_map,
  row.names = FALSE
)


cat(
  "\nOBSERVATION AND OUTCOME INFORMATION\n"
)

print(
  observation_and_outcome_context,
  row.names = FALSE
)


cat(
  "\nUNREPRESENTED PATIENT-INFORMATION DOMAINS\n"
)

print(
  unrepresented_dimensions,
  row.names = FALSE
)


cat(
  "\nPOTENTIAL NUMERICAL OUTLIERS\n"
)

print(
  potential_outlier_summary,
  row.names = FALSE
)


# ============================================================
# 19. Final interpretation note
# ============================================================

cat(
  "\nINTERPRETATION NOTE\n",
  "\n",
  "Technical data quality and patient representation are ",
  "different analytical concepts.\n",
  "\n",
  "Technical data-quality checks evaluate the data that are ",
  "present in the dataset.\n",
  "\n",
  "The patient-representation map documents which broad ",
  "patient-information domains are represented, partially ",
  "represented, very limited, or not represented.\n",
  "\n",
  "These representation classifications are qualitative and ",
  "project-defined. They are not validated clinical adequacy ",
  "scores, patient-completeness measures, or representation-",
  "gap metrics.\n",
  "\n",
  "Follow-up duration and the recorded death-event outcome are ",
  "documented separately because they are observation and ",
  "outcome information rather than baseline patient-",
  "representation dimensions.\n",
  "\n",
  "A dataset may contain no missing values within its defined ",
  "variables while still representing only selected aspects ",
  "of the real patient.\n",
  "\n",
  "Potential numerical outliers are flagged for inspection ",
  "and are not removed automatically.\n",
  sep = ""
)


# ============================================================
# 20. Return complete audit object
# ============================================================

patient_representation_and_quality



