# ============================================================
# Project: Digital Patient Representation for
#          Healthcare Decision-Making: Heart Failure
# File: 03_descriptive_statistics.R
# Purpose: Describe the overall observed patient population.
# ============================================================


# ============================================================
# 1. Confirm required objects from script 01
# ============================================================

required_objects <- c(
  "heart_failure",
  "numerical_variables",
  "categorical_variables",
  "outcome_variable"
)

missing_objects <- required_objects[
  !vapply(
    required_objects,
    exists,
    logical(1),
    inherits = TRUE
  )
]

if (length(missing_objects) > 0) {
  stop(
    paste(
      "Run 01_data_import_and_setup.R first. Missing objects:",
      paste(missing_objects, collapse = ", ")
    )
  )
}


# ============================================================
# 2. Summarize patient population size
# ============================================================

patient_count <- nrow(
  heart_failure
)


# ============================================================
# 3. Summarize numerical variables
# Includes baseline numerical characteristics and follow-up
# duration for the overall patient population.
# ============================================================

numerical_summary_raw <- do.call(
  rbind,
  lapply(
    numerical_variables,
    function(variable) {
      
      x <- heart_failure[[variable]]
      
      data.frame(
        Variable = variable,
        N = sum(!is.na(x)),
        Mean = mean(x, na.rm = TRUE),
        Standard_Deviation = sd(x, na.rm = TRUE),
        Median = median(x, na.rm = TRUE),
        Q1 = as.numeric(
          quantile(x, 0.25, na.rm = TRUE)
        ),
        Q3 = as.numeric(
          quantile(x, 0.75, na.rm = TRUE)
        ),
        IQR = IQR(x, na.rm = TRUE),
        Minimum = min(x, na.rm = TRUE),
        Maximum = max(x, na.rm = TRUE),
        stringsAsFactors = FALSE
      )
    }
  )
)

row.names(numerical_summary_raw) <- NULL

numerical_summary <- numerical_summary_raw

numerical_summary[, -c(1, 2)] <- round(
  numerical_summary[, -c(1, 2)],
  2
)


# ============================================================
# 4. Summarize categorical variables
# Includes baseline categorical characteristics and mortality
# outcome for the overall patient population.
# ============================================================

categorical_summary_raw <- do.call(
  rbind,
  lapply(
    categorical_variables,
    function(variable) {
      
      counts <- table(
        heart_failure[[variable]]
      )
      
      data.frame(
        Variable = variable,
        Category = names(counts),
        Count = as.vector(counts),
        Percentage = as.vector(
          prop.table(counts) * 100
        ),
        stringsAsFactors = FALSE
      )
    }
  )
)

row.names(categorical_summary_raw) <- NULL

categorical_summary <- categorical_summary_raw

categorical_summary$Percentage <- round(
  categorical_summary$Percentage,
  2
)


# ============================================================
# 5. Extract mortality outcome summary
# Mortality is summarized descriptively only.
# Group comparisons are performed later in script 05.
# ============================================================

mortality_summary <- categorical_summary[
  categorical_summary$Variable ==
    outcome_variable,
  c(
    "Category",
    "Count",
    "Percentage"
  ),
  drop = FALSE
]

row.names(mortality_summary) <- NULL


# ============================================================
# 6. Consolidate descriptive results
# ============================================================

descriptive_statistics <- list(
  
  Patient_Count =
    patient_count,
  
  Numerical_Summary_Raw =
    numerical_summary_raw,
  
  Numerical_Summary =
    numerical_summary,
  
  Categorical_Summary_Raw =
    categorical_summary_raw,
  
  Categorical_Summary =
    categorical_summary,
  
  Mortality_Summary =
    mortality_summary
)


# ============================================================
# 7. Display descriptive overview
# ============================================================

cat(
  "\n",
  "============================================================\n",
  "DESCRIPTIVE STATISTICS\n",
  "============================================================\n",
  sep = ""
)

cat(
  "\nPATIENT COUNT\n",
  patient_count,
  "\n",
  sep = ""
)

cat(
  "\nNUMERICAL VARIABLES\n"
)

print(
  numerical_summary
)

cat(
  "\nCATEGORICAL VARIABLES\n"
)

print(
  categorical_summary
)

cat(
  "\nMORTALITY OUTCOME\n"
)

print(
  mortality_summary
)


# ============================================================
# 8. Return complete descriptive statistics object
# ============================================================

descriptive_statistics

