# ============================================================
# Project: Representation Sensitivity Analysis
#          in Heart Failure with R
# File: 05_outcome_group_comparisons.R
# Purpose: Compare baseline patient characteristics
#          descriptively according to recorded death-event
#          status during observed follow-up.
# ============================================================


# ============================================================
# 1. Confirm required setup objects from script 01
# ============================================================

required_objects <- c(
  "heart_failure",
  "baseline_numerical_variables",
  "baseline_categorical_variables",
  "follow_up_variable",
  "observation_variables",
  "outcome_variable",
  "outcome_labels"
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
# 2. Verify recorded death-event outcome configuration
# ============================================================

if (!is.factor(
  heart_failure[[outcome_variable]]
)) {
  stop(
    paste0(
      "Outcome-group comparison failed. '",
      outcome_variable,
      "' must be configured as a factor."
    )
  )
}

actual_outcome_levels <- levels(
  heart_failure[[outcome_variable]]
)

if (!identical(
  actual_outcome_levels,
  outcome_labels
)) {
  stop(
    paste0(
      "Outcome-group comparison failed. Unexpected factor ",
      "levels for '",
      outcome_variable,
      "'. Check script 01."
    )
  )
}

no_event_label <- outcome_labels[1]
event_label <- outcome_labels[2]


# ============================================================
# 3. Summarize recorded death-event groups
# ============================================================

outcome_missing_n <- sum(
  is.na(
    heart_failure[[outcome_variable]]
  )
)

outcome_counts <- table(
  factor(
    heart_failure[[outcome_variable]],
    levels = outcome_labels
  ),
  useNA = "no"
)

observed_outcome_n <- sum(
  outcome_counts
)

outcome_group_summary <- data.frame(
  
  Recorded_Death_Event_Status =
    names(outcome_counts),
  
  N =
    as.vector(outcome_counts),
  
  Percentage_of_Observed =
    if (observed_outcome_n > 0) {
      as.vector(outcome_counts) /
        observed_outcome_n *
        100
    } else {
      rep(
        NA_real_,
        length(outcome_counts)
      )
    },
  
  stringsAsFactors = FALSE
)

outcome_group_summary$Percentage_of_Observed <- round(
  outcome_group_summary$Percentage_of_Observed,
  2
)

outcome_data_overview <- data.frame(
  
  Analytical_Sample_N =
    nrow(heart_failure),
  
  Observed_Outcome_N =
    observed_outcome_n,
  
  Missing_Outcome_N =
    outcome_missing_n,
  
  stringsAsFactors = FALSE
)


# ============================================================
# 4. Define numerical group-summary helper
# ============================================================

summarize_numerical_by_outcome <- function(
    data,
    variable,
    outcome,
    outcome_levels
) {
  
  do.call(
    rbind,
    lapply(
      outcome_levels,
      function(outcome_level) {
        
        group_index <-
          !is.na(data[[outcome]]) &
          data[[outcome]] == outcome_level
        
        x <- data[
          group_index,
          variable
        ]
        
        group_n <- length(x)
        observed_values <- x[
          !is.na(x)
        ]
        
        observed_n <- length(
          observed_values
        )
        
        missing_n <- sum(
          is.na(x)
        )
        
        if (observed_n == 0) {
          
          return(
            data.frame(
              Variable = variable,
              Recorded_Death_Event_Status =
                outcome_level,
              Group_N = group_n,
              Observed_N = 0,
              Missing_N = missing_n,
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
          
          Variable = variable,
          
          Recorded_Death_Event_Status =
            outcome_level,
          
          Group_N =
            group_n,
          
          Observed_N =
            observed_n,
          
          Missing_N =
            missing_n,
          
          Mean =
            mean(
              observed_values
            ),
          
          Standard_Deviation =
            if (observed_n > 1) {
              sd(
                observed_values
              )
            } else {
              NA_real_
            },
          
          Median =
            median(
              observed_values
            ),
          
          Q1 =
            as.numeric(
              quantile(
                observed_values,
                probs = 0.25,
                names = FALSE,
                type = 7
              )
            ),
          
          Q3 =
            as.numeric(
              quantile(
                observed_values,
                probs = 0.75,
                names = FALSE,
                type = 7
              )
            ),
          
          IQR =
            IQR(
              observed_values,
              type = 7
            ),
          
          Minimum =
            min(
              observed_values
            ),
          
          Maximum =
            max(
              observed_values
            ),
          
          stringsAsFactors = FALSE
        )
      }
    )
  )
}


# ============================================================
# 5. Define categorical group-summary helper
# ============================================================

summarize_categorical_by_outcome <- function(
    data,
    variable,
    outcome,
    outcome_levels
) {
  
  variable_levels <- levels(
    data[[variable]]
  )
  
  do.call(
    rbind,
    lapply(
      outcome_levels,
      function(outcome_level) {
        
        group_index <-
          !is.na(data[[outcome]]) &
          data[[outcome]] == outcome_level
        
        x <- data[
          group_index,
          variable
        ]
        
        group_n <- length(x)
        
        observed_n <- sum(
          !is.na(x)
        )
        
        missing_n <- sum(
          is.na(x)
        )
        
        counts <- table(
          factor(
            x,
            levels = variable_levels
          ),
          useNA = "no"
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
          
          Variable =
            variable,
          
          Category =
            variable_levels,
          
          Recorded_Death_Event_Status =
            outcome_level,
          
          Group_N =
            group_n,
          
          Observed_N =
            observed_n,
          
          Missing_N =
            missing_n,
          
          Count =
            as.vector(counts),
          
          Percentage =
            percentages,
          
          stringsAsFactors = FALSE
        )
      }
    )
  )
}


# ============================================================
# 6. Define presentation helpers
# ============================================================

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
# 7. Summarize baseline numerical characteristics
#    by recorded death-event status
# ============================================================

grouped_numerical_summary_raw <- do.call(
  rbind,
  lapply(
    baseline_numerical_variables,
    function(variable) {
      
      summarize_numerical_by_outcome(
        data = heart_failure,
        variable = variable,
        outcome = outcome_variable,
        outcome_levels = outcome_labels
      )
    }
  )
)

row.names(
  grouped_numerical_summary_raw
) <- NULL


grouped_numerical_summary <-
  create_display_numerical_summary(
    grouped_numerical_summary_raw
  )


# ============================================================
# 8. Calculate descriptive numerical differences
# ============================================================
#
# Direction:
#
# Death event recorded - No recorded death event
#
# These are raw descriptive differences within each variable.
# They are not standardized and must not be ranked across
# variables measured on different scales.
# ============================================================

numerical_group_differences_raw <- do.call(
  rbind,
  lapply(
    baseline_numerical_variables,
    function(variable) {
      
      no_event_values <- heart_failure[
        !is.na(
          heart_failure[[outcome_variable]]
        ) &
          heart_failure[[outcome_variable]] ==
          no_event_label,
        variable
      ]
      
      event_values <- heart_failure[
        !is.na(
          heart_failure[[outcome_variable]]
        ) &
          heart_failure[[outcome_variable]] ==
          event_label,
        variable
      ]
      
      no_event_observed <- no_event_values[
        !is.na(no_event_values)
      ]
      
      event_observed <- event_values[
        !is.na(event_values)
      ]
      
      mean_difference <- if (
        length(no_event_observed) > 0 &&
        length(event_observed) > 0
      ) {
        mean(event_observed) -
          mean(no_event_observed)
      } else {
        NA_real_
      }
      
      median_difference <- if (
        length(no_event_observed) > 0 &&
        length(event_observed) > 0
      ) {
        median(event_observed) -
          median(no_event_observed)
      } else {
        NA_real_
      }
      
      data.frame(
        
        Variable =
          variable,
        
        Mean_Difference_Event_Minus_No_Event =
          mean_difference,
        
        Median_Difference_Event_Minus_No_Event =
          median_difference,
        
        stringsAsFactors = FALSE
      )
    }
  )
)

row.names(
  numerical_group_differences_raw
) <- NULL


numerical_group_differences <-
  numerical_group_differences_raw

numerical_group_differences[
  ,
  -1,
  drop = FALSE
] <- lapply(
  numerical_group_differences[
    ,
    -1,
    drop = FALSE
  ],
  round,
  digits = 2
)


# ============================================================
# 9. Summarize baseline categorical characteristics
#    by recorded death-event status
# ============================================================
#
# Percentages are calculated within each outcome group and
# among observations with non-missing values for the
# respective baseline characteristic.
# ============================================================

categorical_group_summary_raw <- do.call(
  rbind,
  lapply(
    baseline_categorical_variables,
    function(variable) {
      
      summarize_categorical_by_outcome(
        data = heart_failure,
        variable = variable,
        outcome = outcome_variable,
        outcome_levels = outcome_labels
      )
    }
  )
)

row.names(
  categorical_group_summary_raw
) <- NULL


categorical_group_summary <-
  create_display_categorical_summary(
    categorical_group_summary_raw
  )


# ============================================================
# 10. Summarize follow-up duration separately
# ============================================================
#
# Follow-up duration is observation information rather than a
# baseline patient characteristic.
#
# It is therefore described separately according to recorded
# death-event status.
# ============================================================

follow_up_summary_raw <-
  summarize_numerical_by_outcome(
    data = heart_failure,
    variable = follow_up_variable,
    outcome = outcome_variable,
    outcome_levels = outcome_labels
  )

row.names(
  follow_up_summary_raw
) <- NULL


follow_up_summary <-
  create_display_numerical_summary(
    follow_up_summary_raw
  )


# ============================================================
# 11. Verify group denominators
# ============================================================

expected_group_counts <- setNames(
  as.vector(
    outcome_counts
  ),
  names(
    outcome_counts
  )
)


numerical_denominator_check <- vapply(
  seq_len(
    nrow(grouped_numerical_summary_raw)
  ),
  function(i) {
    
    status <-
      grouped_numerical_summary_raw$
      Recorded_Death_Event_Status[i]
    
    grouped_numerical_summary_raw$
      Group_N[i] ==
      expected_group_counts[[status]]
  },
  logical(1)
)


categorical_denominator_check <- vapply(
  seq_len(
    nrow(categorical_group_summary_raw)
  ),
  function(i) {
    
    status <-
      categorical_group_summary_raw$
      Recorded_Death_Event_Status[i]
    
    categorical_group_summary_raw$
      Group_N[i] ==
      expected_group_counts[[status]]
  },
  logical(1)
)


follow_up_denominator_check <- vapply(
  seq_len(
    nrow(follow_up_summary_raw)
  ),
  function(i) {
    
    status <-
      follow_up_summary_raw$
      Recorded_Death_Event_Status[i]
    
    follow_up_summary_raw$
      Group_N[i] ==
      expected_group_counts[[status]]
  },
  logical(1)
)


if (
  !all(numerical_denominator_check) ||
  !all(categorical_denominator_check) ||
  !all(follow_up_denominator_check)
) {
  stop(
    paste0(
      "Outcome-group comparison failed. ",
      "Unexpected group denominator detected."
    )
  )
}


# ============================================================
# 12. Consolidate descriptive outcome-group comparisons
# ============================================================

outcome_group_comparisons <- list(
  
  Outcome_Data_Overview =
    outcome_data_overview,
  
  Outcome_Group_Summary =
    outcome_group_summary,
  
  Baseline_Numerical_Summary_Raw =
    grouped_numerical_summary_raw,
  
  Baseline_Numerical_Summary =
    grouped_numerical_summary,
  
  Baseline_Numerical_Differences_Raw =
    numerical_group_differences_raw,
  
  Baseline_Numerical_Differences =
    numerical_group_differences,
  
  Baseline_Categorical_Summary_Raw =
    categorical_group_summary_raw,
  
  Baseline_Categorical_Summary =
    categorical_group_summary,
  
  Follow_Up_Summary_Raw =
    follow_up_summary_raw,
  
  Follow_Up_Summary =
    follow_up_summary
)


# ============================================================
# 13. Display descriptive comparison overview
# ============================================================

cat(
  "\n",
  "============================================================\n",
  "DESCRIPTIVE OUTCOME-GROUP COMPARISONS\n",
  "============================================================\n",
  sep = ""
)


cat(
  "\nOUTCOME DATA OVERVIEW\n"
)

print(
  outcome_data_overview,
  row.names = FALSE
)


cat(
  "\nRECORDED DEATH-EVENT GROUPS\n"
)

print(
  outcome_group_summary,
  row.names = FALSE
)


cat(
  "\nBASELINE NUMERICAL CHARACTERISTICS\n"
)

print(
  grouped_numerical_summary,
  row.names = FALSE
)


cat(
  "\nDESCRIPTIVE NUMERICAL DIFFERENCES\n"
)

print(
  numerical_group_differences,
  row.names = FALSE
)


cat(
  "\nBASELINE CATEGORICAL CHARACTERISTICS\n"
)

print(
  categorical_group_summary,
  row.names = FALSE
)


cat(
  "\nFOLLOW-UP DURATION\n"
)

print(
  follow_up_summary,
  row.names = FALSE
)


# ============================================================
# 14. Interpretation note
# ============================================================

cat(
  "\nINTERPRETATION NOTE\n",
  "\n",
  "All comparisons in this script are descriptive.\n",
  "\n",
  "Groups are defined according to whether a death event was ",
  "recorded during each patient's observed follow-up period.\n",
  "\n",
  "Because follow-up duration varies between patients, these ",
  "groups must not be interpreted as fixed-horizon survival ",
  "or mortality groups.\n",
  "\n",
  "Baseline patient characteristics are compared separately ",
  "from follow-up duration, which represents observation ",
  "information rather than baseline patient information.\n",
  "\n",
  "Raw numerical differences are calculated as 'Death event ",
  "recorded' minus 'No recorded death event'. They are not ",
  "standardized and are not ranked across variables with ",
  "different measurement scales.\n",
  "\n",
  "Observed group differences do not establish statistical ",
  "significance, causality, prognostic importance, or ",
  "clinical relevance.\n",
  "\n",
  "Formal group-level inference is performed in ",
  "06_hypothesis_testing.R.\n",
  sep = ""
)


# ============================================================
# 15. Return complete comparison object
# ============================================================

outcome_group_comparisons

