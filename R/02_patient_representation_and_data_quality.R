# ============================================================
# Project: Heart Failure Clinical Statistical Analysis with R
# File: 02_patient_representation_and_data_quality.R
# Purpose: Assess the digital representation of the patient,
# dataset integrity, completeness, variable validity,
# numerical plausibility, and unusual observations.
# Language: R
# ============================================================


# ============================================================
# 1. Define expected dataset structure
# Specify the variables that are expected to be available in
# the heart failure clinical records dataset.
# ============================================================

expected_variables <- c(
  "age",
  "anaemia",
  "creatinine_phosphokinase",
  "diabetes",
  "ejection_fraction",
  "high_blood_pressure",
  "platelets",
  "serum_creatinine",
  "serum_sodium",
  "sex",
  "smoking",
  "time",
  "DEATH_EVENT"
)

expected_variables


# ============================================================
# 2. Check expected and unexpected variables
# Confirm that the imported dataset contains the intended
# variables and identify any unexpected additions.
# ============================================================

missing_expected_variables <- setdiff(
  expected_variables,
  names(heart_failure)
)

unexpected_variables <- setdiff(
  names(heart_failure),
  expected_variables
)

variable_structure_check <- data.frame(
  Check = c(
    "Expected variables",
    "Observed variables",
    "Missing expected variables",
    "Unexpected variables"
  ),
  Count = c(
    length(expected_variables),
    ncol(heart_failure),
    length(missing_expected_variables),
    length(unexpected_variables)
  )
)

variable_structure_check

missing_expected_variables

unexpected_variables


# ============================================================
# 3. Check dataset dimensions
# Confirm the number of patient observations and variables
# available for analysis.
# ============================================================

dataset_dimensions <- data.frame(
  Observations = nrow(heart_failure),
  Variables = ncol(heart_failure)
)

dataset_dimensions


# ============================================================
# 4. Define analytical variable groups
# Separate numerical patient measurements, categorical patient
# characteristics, follow-up information, and outcome data.
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
  "smoking",
  "DEATH_EVENT"
)

baseline_variables <- c(
  "age",
  "anaemia",
  "creatinine_phosphokinase",
  "diabetes",
  "ejection_fraction",
  "high_blood_pressure",
  "platelets",
  "serum_creatinine",
  "serum_sodium",
  "sex",
  "smoking"
)

follow_up_variable <- "time"

outcome_variable <- "DEATH_EVENT"


# ============================================================
# 5. Map the digital patient representation
# Identify which dimensions of the real patient are represented
# by variables in the dataset and which dimensions remain
# unavailable.
#
# The purpose is not to evaluate the dataset as inherently good
# or bad. Every clinical dataset contains only a partial digital
# representation of the patient.
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
    "Longitudinal clinical measurements",
    "Patient-reported outcomes",
    "Socioeconomic context",
    "Healthcare resource use",
    "Management decisions"
  ),
  
  Representation_Status = c(
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
    "Not represented",
    "Not represented",
    "Not represented",
    "Not represented",
    "Not represented",
    "Not represented",
    "Not represented",
    "Not represented",
    "Not represented"
  ),
  
  Available_Variables = c(
    "age, sex",
    "ejection_fraction",
    "serum_creatinine",
    "anaemia, platelets",
    "creatinine_phosphokinase, serum_sodium, serum_creatinine",
    "anaemia, diabetes, high_blood_pressure",
    "smoking",
    "DEATH_EVENT",
    "time",
    "ejection_fraction and selected clinical measurements",
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

patient_representation_map


# ============================================================
# 6. Summarize patient representation status
# Count how many patient-information dimensions are available,
# partially represented, limited, or not represented.
# ============================================================

representation_status_summary <- as.data.frame(
  table(
    patient_representation_map$Representation_Status
  )
)

names(
  representation_status_summary
) <- c(
  "Representation_Status",
  "Number_of_Dimensions"
)

representation_status_summary


# ============================================================
# 7. Identify explicitly unrepresented patient dimensions
# Retain patient-information dimensions for which no direct
# variables are available in the dataset.
# ============================================================

unrepresented_patient_dimensions <-
  patient_representation_map[
    patient_representation_map$Representation_Status ==
      "Not represented",
    ,
    drop = FALSE
  ]

row.names(
  unrepresented_patient_dimensions
) <- NULL

unrepresented_patient_dimensions


# ============================================================
# 8. Inspect configured dataset structure
# Review variable classes after the configuration performed
# during the data-import stage.
# ============================================================

str(heart_failure)


# ============================================================
# 9. Validate variable data types
# Compare the configured variable classes with the expected
# analytical variable types.
# ============================================================

expected_classes <- c(
  age = "numeric",
  anaemia = "factor",
  creatinine_phosphokinase = "numeric",
  diabetes = "factor",
  ejection_fraction = "numeric",
  high_blood_pressure = "factor",
  platelets = "numeric",
  serum_creatinine = "numeric",
  serum_sodium = "numeric",
  sex = "factor",
  smoking = "factor",
  time = "numeric",
  DEATH_EVENT = "factor"
)

actual_classes <- sapply(
  heart_failure[expected_variables],
  function(x) class(x)[1]
)

variable_class_summary <- data.frame(
  Variable = expected_variables,
  Expected_Class = unname(
    expected_classes[
      expected_variables
    ]
  ),
  Observed_Class = unname(
    actual_classes[
      expected_variables
    ]
  ),
  Class_Valid = unname(
    actual_classes[
      expected_variables
    ]
  ) ==
    unname(
      expected_classes[
        expected_variables
      ]
    )
)

row.names(
  variable_class_summary
) <- NULL

variable_class_summary


# ============================================================
# 10. Check missing values
# Identify missing patient information overall and separately
# for each variable.
# ============================================================

total_missing_values <- sum(
  is.na(heart_failure)
)

missing_value_summary <- data.frame(
  Variable = names(heart_failure),
  
  Missing_Count = sapply(
    heart_failure,
    function(x) sum(
      is.na(x)
    )
  ),
  
  Missing_Percentage = round(
    sapply(
      heart_failure,
      function(x) {
        mean(
          is.na(x)
        ) * 100
      }
    ),
    2
  )
)

row.names(
  missing_value_summary
) <- NULL

total_missing_values

missing_value_summary


# ============================================================
# 11. Check undefined and infinite numerical values
# Identify NaN or infinite values separately from ordinary
# missing observations.
# ============================================================

non_finite_summary <- data.frame(
  
  Variable = numerical_variables,
  
  NaN_Count = sapply(
    heart_failure[numerical_variables],
    function(x) {
      sum(
        is.nan(x)
      )
    }
  ),
  
  Infinite_Count = sapply(
    heart_failure[numerical_variables],
    function(x) {
      sum(
        is.infinite(x)
      )
    }
  )
)

row.names(
  non_finite_summary
) <- NULL

non_finite_summary


# ============================================================
# 12. Check duplicate patient records
# Identify observations that are completely duplicated across
# all recorded patient variables.
# ============================================================

duplicate_count <- sum(
  duplicated(heart_failure)
)

duplicate_records <- heart_failure[
  duplicated(heart_failure),
  ,
  drop = FALSE
]

duplicate_count

duplicate_records


# ============================================================
# 13. Validate categorical variable levels
# Confirm that categorical variables contain the intended
# factor definitions created during data configuration.
# ============================================================

expected_factor_levels <- list(
  
  anaemia = c(
    "No",
    "Yes"
  ),
  
  diabetes = c(
    "No",
    "Yes"
  ),
  
  high_blood_pressure = c(
    "No",
    "Yes"
  ),
  
  sex = c(
    "Female",
    "Male"
  ),
  
  smoking = c(
    "No",
    "Yes"
  ),
  
  DEATH_EVENT = c(
    "No death event",
    "Death event"
  )
)

categorical_level_summary <- do.call(
  rbind,
  lapply(
    names(expected_factor_levels),
    function(variable) {
      
      observed_levels <- levels(
        heart_failure[[variable]]
      )
      
      expected_levels <-
        expected_factor_levels[
          [variable]
        ]
      
      data.frame(
        Variable = variable,
        
        Expected_Levels = paste(
          expected_levels,
          collapse = " | "
        ),
        
        Observed_Levels = paste(
          observed_levels,
          collapse = " | "
        ),
        
        Levels_Valid = setequal(
          observed_levels,
          expected_levels
        ),
        
        stringsAsFactors = FALSE
      )
    }
  )
)

row.names(
  categorical_level_summary
) <- NULL

categorical_level_summary


# ============================================================
# 14. Inspect categorical frequencies
# Review the number of observations within each categorical
# level and identify unexpected empty or missing categories.
# ============================================================

categorical_frequency_summary <- do.call(
  rbind,
  lapply(
    categorical_variables,
    function(variable) {
      
      counts <- table(
        heart_failure[[variable]],
        useNA = "ifany"
      )
      
      data.frame(
        Variable = variable,
        Category = names(counts),
        Count = as.vector(counts),
        stringsAsFactors = FALSE
      )
    }
  )
)

row.names(
  categorical_frequency_summary
) <- NULL

categorical_frequency_summary


# ============================================================
# 15. Inspect numerical value ranges
# Summarize the observed distribution boundaries of numerical
# patient measurements before evaluating plausibility.
# ============================================================

numerical_range_summary <- data.frame(
  
  Variable = numerical_variables,
  
  Minimum = sapply(
    heart_failure[numerical_variables],
    min,
    na.rm = TRUE
  ),
  
  Q1 = sapply(
    heart_failure[numerical_variables],
    function(x) {
      quantile(
        x,
        0.25,
        na.rm = TRUE
      )
    }
  ),
  
  Median = sapply(
    heart_failure[numerical_variables],
    median,
    na.rm = TRUE
  ),
  
  Q3 = sapply(
    heart_failure[numerical_variables],
    function(x) {
      quantile(
        x,
        0.75,
        na.rm = TRUE
      )
    }
  ),
  
  Maximum = sapply(
    heart_failure[numerical_variables],
    max,
    na.rm = TRUE
  )
)

numerical_range_summary[, -1] <- round(
  numerical_range_summary[, -1],
  2
)

row.names(
  numerical_range_summary
) <- NULL

numerical_range_summary


# ============================================================
# 16. Check logically invalid numerical values
# Identify observations outside basic logical measurement
# boundaries.
#
# These checks detect logically impossible values rather than
# establishing detailed clinical reference ranges.
# ============================================================

logical_validity_summary <- data.frame(
  
  Variable = c(
    "age",
    "creatinine_phosphokinase",
    "ejection_fraction",
    "platelets",
    "serum_creatinine",
    "serum_sodium",
    "time"
  ),
  
  Logical_Rule = c(
    "age > 0",
    "creatinine_phosphokinase >= 0",
    "0 <= ejection_fraction <= 100",
    "platelets >= 0",
    "serum_creatinine >= 0",
    "serum_sodium >= 0",
    "time >= 0"
  ),
  
  Invalid_Count = c(
    
    sum(
      heart_failure$age <= 0,
      na.rm = TRUE
    ),
    
    sum(
      heart_failure$creatinine_phosphokinase < 0,
      na.rm = TRUE
    ),
    
    sum(
      heart_failure$ejection_fraction < 0 |
        heart_failure$ejection_fraction > 100,
      na.rm = TRUE
    ),
    
    sum(
      heart_failure$platelets < 0,
      na.rm = TRUE
    ),
    
    sum(
      heart_failure$serum_creatinine < 0,
      na.rm = TRUE
    ),
    
    sum(
      heart_failure$serum_sodium < 0,
      na.rm = TRUE
    ),
    
    sum(
      heart_failure$time < 0,
      na.rm = TRUE
    )
  ),
  
  stringsAsFactors = FALSE
)

logical_validity_summary


# ============================================================
# 17. Check unique values and constant variables
# Identify variables with insufficient analytical variation.
#
# A constant variable contains only one observed non-missing
# value and therefore provides no variation for statistical
# analysis.
# ============================================================

unique_value_summary <- data.frame(
  
  Variable = names(heart_failure),
  
  Unique_Non_Missing_Values = sapply(
    heart_failure,
    function(x) {
      length(
        unique(
          x[
            !is.na(x)
          ]
        )
      )
    }
  )
)

unique_value_summary$Constant <- ifelse(
  unique_value_summary$Unique_Non_Missing_Values <= 1,
  "Yes",
  "No"
)

row.names(
  unique_value_summary
) <- NULL

unique_value_summary


# ============================================================
# 18. Identify unusual numerical observations
# Apply the conventional 1.5 x IQR rule to identify unusually
# low or high numerical observations.
#
# These observations are statistical outliers only.
# They are not automatically interpreted as data errors or
# clinically implausible measurements.
# ============================================================

iqr_outlier_summary <- do.call(
  rbind,
  lapply(
    numerical_variables,
    function(variable) {
      
      values <- heart_failure[
        [variable]
      ]
      
      finite_values <- values[
        is.finite(values)
      ]
      
      q1 <- quantile(
        finite_values,
        0.25,
        na.rm = TRUE
      )
      
      q3 <- quantile(
        finite_values,
        0.75,
        na.rm = TRUE
      )
      
      variable_iqr <- IQR(
        finite_values,
        na.rm = TRUE
      )
      
      lower_boundary <-
        q1 -
        1.5 *
        variable_iqr
      
      upper_boundary <-
        q3 +
        1.5 *
        variable_iqr
      
      outlier_count <- sum(
        finite_values <
          lower_boundary |
          finite_values >
          upper_boundary
      )
      
      data.frame(
        
        Variable = variable,
        
        Q1 = as.numeric(
          q1
        ),
        
        Q3 = as.numeric(
          q3
        ),
        
        IQR = as.numeric(
          variable_iqr
        ),
        
        Lower_Boundary = as.numeric(
          lower_boundary
        ),
        
        Upper_Boundary = as.numeric(
          upper_boundary
        ),
        
        Potential_Outliers =
          outlier_count,
        
        Outlier_Percentage = (
          outlier_count /
            length(
              finite_values
            )
        ) * 100,
        
        stringsAsFactors = FALSE
      )
    }
  )
)

iqr_outlier_summary[
  ,
  c(
    "Q1",
    "Q3",
    "IQR",
    "Lower_Boundary",
    "Upper_Boundary",
    "Outlier_Percentage"
  )
] <- round(
  iqr_outlier_summary[
    ,
    c(
      "Q1",
      "Q3",
      "IQR",
      "Lower_Boundary",
      "Upper_Boundary",
      "Outlier_Percentage"
    )
  ],
  2
)

row.names(
  iqr_outlier_summary
) <- NULL

iqr_outlier_summary


# ============================================================
# 19. Inspect individual potential outlier observations
# Retain the actual values identified by the IQR rule for
# transparent review.
# ============================================================

potential_outlier_values <- do.call(
  rbind,
  lapply(
    numerical_variables,
    function(variable) {
      
      values <- heart_failure[
        [variable]
      ]
      
      finite_values <- values[
        is.finite(values)
      ]
      
      q1 <- quantile(
        finite_values,
        0.25,
        na.rm = TRUE
      )
      
      q3 <- quantile(
        finite_values,
        0.75,
        na.rm = TRUE
      )
      
      variable_iqr <- IQR(
        finite_values,
        na.rm = TRUE
      )
      
      lower_boundary <-
        q1 -
        1.5 *
        variable_iqr
      
      upper_boundary <-
        q3 +
        1.5 *
        variable_iqr
      
      outlier_positions <- which(
        is.finite(values) &
          (
            values <
              lower_boundary |
              values >
              upper_boundary
          )
      )
      
      if (
        length(
          outlier_positions
        ) == 0
      ) {
        
        return(
          NULL
        )
      }
      
      data.frame(
        Row = outlier_positions,
        Variable = variable,
        Value = values[
          outlier_positions
        ],
        stringsAsFactors = FALSE
      )
    }
  )
)

if (
  is.null(
    potential_outlier_values
  )
) {
  
  potential_outlier_values <- data.frame(
    Row = integer(0),
    Variable = character(0),
    Value = numeric(0)
  )
}

row.names(
  potential_outlier_values
) <- NULL

potential_outlier_values


# ============================================================
# 20. Summarize digital representation gaps
# Extract the dimensions that are either unavailable or only
# weakly represented in the current digital patient record.
# ============================================================

representation_gaps <-
  patient_representation_map[
    patient_representation_map$Representation_Status %in%
      c(
        "Limited",
        "Very limited",
        "Not represented"
      ),
    ,
    drop = FALSE
  ]

row.names(
  representation_gaps
) <- NULL

representation_gaps


# ============================================================
# 21. Create overall data quality summary
# Consolidate the principal technical quality checks into one
# concise overview.
#
# Potential IQR outliers are reported separately from invalid
# values because unusual clinical measurements are not
# automatically data errors.
# ============================================================

data_quality_overview <- data.frame(
  
  Check = c(
    "Missing expected variables",
    "Unexpected variables",
    "Missing values",
    "NaN values",
    "Infinite values",
    "Duplicate patient records",
    "Invalid variable classes",
    "Invalid categorical level definitions",
    "Logically invalid numerical observations",
    "Constant variables",
    "Potential IQR outlier observations"
  ),
  
  Count = c(
    
    length(
      missing_expected_variables
    ),
    
    length(
      unexpected_variables
    ),
    
    total_missing_values,
    
    sum(
      non_finite_summary$NaN_Count
    ),
    
    sum(
      non_finite_summary$Infinite_Count
    ),
    
    duplicate_count,
    
    sum(
      !variable_class_summary$Class_Valid
    ),
    
    sum(
      !categorical_level_summary$Levels_Valid
    ),
    
    sum(
      logical_validity_summary$Invalid_Count
    ),
    
    sum(
      unique_value_summary$Constant == "Yes"
    ),
    
    sum(
      iqr_outlier_summary$Potential_Outliers
    )
  ),
  
  stringsAsFactors = FALSE
)

data_quality_overview


# ============================================================
# 22. Create patient representation summary object
# Consolidate the representation and quality assessments for
# later analytical stages.
# ============================================================

patient_representation_and_quality <- list(
  
  Dataset_Dimensions =
    dataset_dimensions,
  
  Variable_Structure =
    variable_structure_check,
  
  Patient_Representation_Map =
    patient_representation_map,
  
  Representation_Status =
    representation_status_summary,
  
  Representation_Gaps =
    representation_gaps,
  
  Variable_Classes =
    variable_class_summary,
  
  Missing_Values =
    missing_value_summary,
  
  Non_Finite_Values =
    non_finite_summary,
  
  Duplicate_Count =
    duplicate_count,
  
  Categorical_Levels =
    categorical_level_summary,
  
  Numerical_Ranges =
    numerical_range_summary,
  
  Logical_Validity =
    logical_validity_summary,
  
  Unique_Value_Counts =
    unique_value_summary,
  
  Potential_Outliers =
    iqr_outlier_summary,
  
  Data_Quality_Overview =
    data_quality_overview
)


# ============================================================
# 23. Display final representation and quality overview
# Provide a concise summary of the digital patient
# representation and technical dataset integrity.
# ============================================================

cat(
  "\n",
  "============================================================\n",
  "DIGITAL PATIENT REPRESENTATION AND DATA QUALITY\n",
  "============================================================\n",
  sep = ""
)

cat(
  "\nDATASET DIMENSIONS\n"
)

print(
  dataset_dimensions
)


cat(
  "\nPATIENT REPRESENTATION STATUS\n"
)

print(
  representation_status_summary
)


cat(
  "\nDATA QUALITY OVERVIEW\n"
)

print(
  data_quality_overview
)


cat(
  "\nREPRESENTATION GAPS\n"
)

print(
  representation_gaps
)


cat(
  "\nIMPORTANT INTERPRETATION NOTE\n",
  "The dataset represents selected dimensions of the patient ",
  "rather than the complete clinical patient state.\n",
  "Potential statistical outliers are retained for further ",
  "analysis unless there is evidence that they represent ",
  "invalid observations.\n",
  "Missing clinical dimensions are treated as limitations of ",
  "the available digital patient representation rather than ",
  "technical data-quality errors.\n",
  sep = ""
)


