# ============================================================
# Project: Representation Sensitivity Analysis
#          in Heart Failure with R
# File: 03_descriptive_statistics.R
# Purpose: Describe the observed analytical sample while
#          keeping baseline patient characteristics,
#          observation information, and outcome information
#          analytically separate.
# ============================================================


# ============================================================
# 1. Confirm required setup objects from script 01
# ============================================================

required_objects <- c(
  "heart_failure",
  "baseline_numerical_variables",
  "baseline_categorical_variables",
  "baseline_variables",
  "observation_variables",
  "follow_up_variable",
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
    paste0(
      "Run 01_data_import_and_setup.R first. Missing object(s): ",
      paste(missing_objects, collapse = ", ")
    )
  )
}


# ============================================================
# 2. Define descriptive-summary helper functions
# ============================================================

summarize_numerical_variable <- function(
    x,
    variable_name
) {
  
  non_missing_values <- x[
    !is.na(x)
  ]
  
  n_total <- length(x)
  n_observed <- length(non_missing_values)
  n_missing <- sum(is.na(x))
  
  if (n_observed == 0) {
    return(
      data.frame(
        Variable = variable_name,
        Total_N = n_total,
        Observed_N = 0,
        Missing_N = n_missing,
        Mean = NA_real_,
        Standard_Deviation = NA_real_,
        Median = NA_real_,
        Q1 = NA_real_,
        Q3 = NA_real_,
        IQR = NA_real_,
        Minimum = NA_real_,
        Maximum = NA_real_,
        stringsAsFactors = FALSE
      )
    )
  }
  
  data.frame(
    Variable = variable_name,
    Total_N = n_total,
    Observed_N = n_observed,
    Missing_N = n_missing,
    
    Mean = mean(
      non_missing_values
    ),
    
    Standard_Deviation = if (
      n_observed > 1
    ) {
      sd(non_missing_values)
    } else {
      NA_real_
    },
    
    Median = median(
      non_missing_values
    ),
    
    Q1 = as.numeric(
      quantile(
        non_missing_values,
        probs = 0.25,
        names = FALSE,
        type = 7
      )
    ),
    
    Q3 = as.numeric(
      quantile(
        non_missing_values,
        probs = 0.75,
        names = FALSE,
        type = 7
      )
    ),
    
    IQR = IQR(
      non_missing_values,
      type = 7
    ),
    
    Minimum = min(
      non_missing_values
    ),
    
    Maximum = max(
      non_missing_values
    ),
    
    stringsAsFactors = FALSE
  )
}


summarize_categorical_variable <- function(
    x,
    variable_name
) {
  
  counts <- table(
    x,
    useNA = "no"
  )
  
  observed_n <- sum(
    counts
  )
  
  missing_n <- sum(
    is.na(x)
  )
  
  percentages <- if (
    observed_n > 0
  ) {
    as.vector(counts) /
      observed_n *
      100
  } else {
    rep(
      NA_real_,
      length(counts)
    )
  }
  
  data.frame(
    Variable = variable_name,
    Category = names(counts),
    Count = as.vector(counts),
    Percentage = percentages,
    Observed_N = observed_n,
    Missing_N = missing_n,
    stringsAsFactors = FALSE
  )
}


create_display_numerical_summary <- function(
    summary_table,
    digits = 2
) {
  
  display_table <- summary_table
  
  columns_to_round <- c(
    "Mean",
    "Standard_Deviation",
    "Median",
    "Q1",
    "Q3",
    "IQR",
    "Minimum",
    "Maximum"
  )
  
  display_table[
    columns_to_round
  ] <- lapply(
    display_table[
      columns_to_round
    ],
    round,
    digits = digits
  )
  
  display_table
}


create_display_categorical_summary <- function(
    summary_table,
    digits = 2
) {
  
  display_table <- summary_table
  
  display_table$Percentage <- round(
    display_table$Percentage,
    digits = digits
  )
  
  display_table
}


# ============================================================
# 3. Summarize analytical sample size
# ============================================================

analytical_sample_size <- nrow(
  heart_failure
)

sample_overview <- data.frame(
  Analytical_Sample_N =
    analytical_sample_size,
  
  Baseline_Variables_N =
    length(
      baseline_variables
    ),
  
  Baseline_Numerical_Variables_N =
    length(
      baseline_numerical_variables
    ),
  
  Baseline_Categorical_Variables_N =
    length(
      baseline_categorical_variables
    ),
  
  Observation_Variables_N =
    length(
      observation_variables
    ),
  
  Outcome_Variables_N =
    1,
  
  stringsAsFactors = FALSE
)


# ============================================================
# 4. Summarize baseline numerical characteristics
# ============================================================

baseline_numerical_summary_raw <- do.call(
  rbind,
  lapply(
    baseline_numerical_variables,
    function(variable) {
      summarize_numerical_variable(
        heart_failure[[variable]],
        variable
      )
    }
  )
)

row.names(
  baseline_numerical_summary_raw
) <- NULL


baseline_numerical_summary <-
  create_display_numerical_summary(
    baseline_numerical_summary_raw
  )


# ============================================================
# 5. Summarize baseline categorical characteristics
# ============================================================

baseline_categorical_summary_raw <- do.call(
  rbind,
  lapply(
    baseline_categorical_variables,
    function(variable) {
      summarize_categorical_variable(
        heart_failure[[variable]],
        variable
      )
    }
  )
)

row.names(
  baseline_categorical_summary_raw
) <- NULL


baseline_categorical_summary <-
  create_display_categorical_summary(
    baseline_categorical_summary_raw
  )


# ============================================================
# 6. Summarize observation information
# ============================================================
#
# Follow-up duration is summarized separately because it
# represents observation time rather than a baseline patient
# characteristic.
# ============================================================

observation_summary_raw <- do.call(
  rbind,
  lapply(
    observation_variables,
    function(variable) {
      summarize_numerical_variable(
        heart_failure[[variable]],
        variable
      )
    }
  )
)

row.names(
  observation_summary_raw
) <- NULL


observation_summary <-
  create_display_numerical_summary(
    observation_summary_raw
  )


# ============================================================
# 7. Summarize recorded death-event outcome
# ============================================================
#
# The outcome is described separately from baseline patient
# characteristics.
#
# Because follow-up duration varies between patients, the
# observed proportion of recorded death events must not be
# interpreted as a fixed-horizon or population-level
# mortality estimate.
# ============================================================

outcome_summary_raw <-
  summarize_categorical_variable(
    heart_failure[[outcome_variable]],
    outcome_variable
  )

row.names(
  outcome_summary_raw
) <- NULL


outcome_summary <-
  create_display_categorical_summary(
    outcome_summary_raw
  )


# ============================================================
# 8. Verify descriptive-summary denominators
# ============================================================

if (
  any(
    baseline_numerical_summary_raw$Total_N !=
    analytical_sample_size
  )
) {
  stop(
    paste0(
      "Descriptive-statistics audit failed. ",
      "Unexpected denominator in baseline numerical summary."
    )
  )
}

if (
  any(
    baseline_categorical_summary_raw$Observed_N +
    baseline_categorical_summary_raw$Missing_N !=
    analytical_sample_size
  )
) {
  stop(
    paste0(
      "Descriptive-statistics audit failed. ",
      "Unexpected denominator in baseline categorical summary."
    )
  )
}

if (
  any(
    observation_summary_raw$Total_N !=
    analytical_sample_size
  )
) {
  stop(
    paste0(
      "Descriptive-statistics audit failed. ",
      "Unexpected denominator in observation summary."
    )
  )
}

if (
  any(
    outcome_summary_raw$Observed_N +
    outcome_summary_raw$Missing_N !=
    analytical_sample_size
  )
) {
  stop(
    paste0(
      "Descriptive-statistics audit failed. ",
      "Unexpected denominator in outcome summary."
    )
  )
}


# ============================================================
# 9. Consolidate descriptive results
# ============================================================

descriptive_statistics <- list(
  
  Sample_Overview =
    sample_overview,
  
  Baseline_Numerical_Summary_Raw =
    baseline_numerical_summary_raw,
  
  Baseline_Numerical_Summary =
    baseline_numerical_summary,
  
  Baseline_Categorical_Summary_Raw =
    baseline_categorical_summary_raw,
  
  Baseline_Categorical_Summary =
    baseline_categorical_summary,
  
  Observation_Summary_Raw =
    observation_summary_raw,
  
  Observation_Summary =
    observation_summary,
  
  Outcome_Summary_Raw =
    outcome_summary_raw,
  
  Outcome_Summary =
    outcome_summary
)


# ============================================================
# 10. Display descriptive overview
# ============================================================

cat(
  "\n",
  "============================================================\n",
  "DESCRIPTIVE STATISTICS\n",
  "============================================================\n",
  sep = ""
)


cat(
  "\nANALYTICAL SAMPLE OVERVIEW\n"
)

print(
  sample_overview,
  row.names = FALSE
)


cat(
  "\nBASELINE NUMERICAL CHARACTERISTICS\n"
)

print(
  baseline_numerical_summary,
  row.names = FALSE
)


cat(
  "\nBASELINE CATEGORICAL CHARACTERISTICS\n"
)

print(
  baseline_categorical_summary,
  row.names = FALSE
)


cat(
  "\nOBSERVATION INFORMATION\n"
)

print(
  observation_summary,
  row.names = FALSE
)


cat(
  "\nRECORDED DEATH-EVENT OUTCOME\n"
)

print(
  outcome_summary,
  row.names = FALSE
)


# ============================================================
# 11. Interpretation note
# ============================================================

cat(
  "\nINTERPRETATION NOTE\n",
  "\n",
  "These summaries describe the observed analytical sample.\n",
  "\n",
  "Baseline patient characteristics are kept separate from ",
  "follow-up duration and the recorded death-event outcome.\n",
  "\n",
  "All statistical calculations are based on unrounded ",
  "values. Rounding is applied only to presentation tables.\n",
  "\n",
  "The observed proportion of recorded death events is a ",
  "property of this dataset and its variable follow-up ",
  "structure. It must not be interpreted as a fixed-horizon ",
  "or population-level heart-failure mortality estimate.\n",
  "\n",
  "No inferential, causal, prognostic, or clinical conclusions ",
  "are drawn in this descriptive stage.\n",
  sep = ""
)


# ============================================================
# 12. Return complete descriptive-statistics object
# ============================================================

descriptive_statistics

