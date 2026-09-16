# ============================================================
# Project: Representation Sensitivity Analysis 
#          in Heart Failure with R
# File: 05_outcome_group_comparisons.R
# Purpose: Compare baseline patient characteristics
#          descriptively by mortality outcome.
# ============================================================


# ============================================================
# 1. Confirm required objects from script 01
# ============================================================

required_objects <- c(
  "heart_failure",
  "baseline_numerical_variables",
  "baseline_categorical_variables",
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
    paste(
      "Run 01_data_import_and_setup.R first. Missing objects:",
      paste(missing_objects, collapse = ", ")
    )
  )
}


# ============================================================
# 2. Define mortality outcome groups
# ============================================================

outcome_levels <- levels(
  heart_failure[[outcome_variable]]
)

if (!identical(
  outcome_levels,
  c("No death event", "Death event")
)) {
  stop(
    "Unexpected DEATH_EVENT factor levels. Check script 01."
  )
}


# ============================================================
# 3. Summarize mortality groups
# ============================================================

outcome_counts <- table(
  heart_failure[[outcome_variable]]
)

outcome_group_summary <- data.frame(
  Mortality_Outcome = names(outcome_counts),
  N = as.vector(outcome_counts),
  Percentage = round(
    as.vector(
      prop.table(outcome_counts) * 100
    ),
    2
  ),
  stringsAsFactors = FALSE
)


# ============================================================
# 4. Summarize baseline numerical variables by outcome
# ============================================================

grouped_numerical_summary_raw <- do.call(
  rbind,
  lapply(
    baseline_numerical_variables,
    function(variable) {
      
      do.call(
        rbind,
        lapply(
          outcome_levels,
          function(outcome) {
            
            x <- heart_failure[
              heart_failure[[outcome_variable]] == outcome,
              variable
            ]
            
            data.frame(
              Variable = variable,
              Mortality_Outcome = outcome,
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
    }
  )
)

row.names(grouped_numerical_summary_raw) <- NULL

grouped_numerical_summary <-
  grouped_numerical_summary_raw

grouped_numerical_summary[, -(1:3)] <- round(
  grouped_numerical_summary[, -(1:3)],
  2
)


# ============================================================
# 5. Calculate descriptive numerical differences
# Direction:
#
# Death event - No death event
#
# Differences are interpreted only within each variable.
# They are not ranked across variables with different units.
# ============================================================

numerical_group_differences_raw <- do.call(
  rbind,
  lapply(
    baseline_numerical_variables,
    function(variable) {
      
      no_death <- heart_failure[
        heart_failure[[outcome_variable]] ==
          "No death event",
        variable
      ]
      
      death <- heart_failure[
        heart_failure[[outcome_variable]] ==
          "Death event",
        variable
      ]
      
      data.frame(
        Variable = variable,
        Mean_Difference =
          mean(death, na.rm = TRUE) -
          mean(no_death, na.rm = TRUE),
        Median_Difference =
          median(death, na.rm = TRUE) -
          median(no_death, na.rm = TRUE),
        stringsAsFactors = FALSE
      )
    }
  )
)

row.names(numerical_group_differences_raw) <- NULL

numerical_group_differences <-
  numerical_group_differences_raw

numerical_group_differences[, -1] <- round(
  numerical_group_differences[, -1],
  2
)


# ============================================================
# 6. Summarize categorical variables by outcome
# Percentages are calculated within each mortality group.
# ============================================================

categorical_group_summary_raw <- do.call(
  rbind,
  lapply(
    baseline_categorical_variables,
    function(variable) {
      
      counts <- table(
        heart_failure[[variable]],
        heart_failure[[outcome_variable]]
      )
      
      percentages <- prop.table(
        counts,
        margin = 2
      ) * 100
      
      do.call(
        rbind,
        lapply(
          row.names(counts),
          function(category) {
            
            data.frame(
              Variable = variable,
              Category = category,
              
              No_Death_N =
                counts[
                  category,
                  "No death event"
                ],
              
              No_Death_Percentage =
                percentages[
                  category,
                  "No death event"
                ],
              
              Death_Event_N =
                counts[
                  category,
                  "Death event"
                ],
              
              Death_Event_Percentage =
                percentages[
                  category,
                  "Death event"
                ],
              
              stringsAsFactors = FALSE
            )
          }
        )
      )
    }
  )
)

row.names(categorical_group_summary_raw) <- NULL

categorical_group_summary <-
  categorical_group_summary_raw

categorical_group_summary[
  ,
  c(
    "No_Death_Percentage",
    "Death_Event_Percentage"
  )
] <- round(
  categorical_group_summary[
    ,
    c(
      "No_Death_Percentage",
      "Death_Event_Percentage"
    )
  ],
  2
)


# ============================================================
# 7. Summarize follow-up duration separately
# Follow-up time represents observation duration rather than
# baseline patient information.
# ============================================================

follow_up_summary_raw <- do.call(
  rbind,
  lapply(
    outcome_levels,
    function(outcome) {
      
      x <- heart_failure[
        heart_failure[[outcome_variable]] == outcome,
        follow_up_variable
      ]
      
      data.frame(
        Mortality_Outcome = outcome,
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

row.names(follow_up_summary_raw) <- NULL

follow_up_summary <- follow_up_summary_raw

follow_up_summary[, -(1:2)] <- round(
  follow_up_summary[, -(1:2)],
  2
)


# ============================================================
# 8. Consolidate outcome-group comparisons
# ============================================================

outcome_group_comparisons <- list(
  
  Outcome_Group_Summary =
    outcome_group_summary,
  
  Numerical_Summary_Raw =
    grouped_numerical_summary_raw,
  
  Numerical_Summary =
    grouped_numerical_summary,
  
  Numerical_Differences_Raw =
    numerical_group_differences_raw,
  
  Numerical_Differences =
    numerical_group_differences,
  
  Categorical_Summary_Raw =
    categorical_group_summary_raw,
  
  Categorical_Summary =
    categorical_group_summary,
  
  Follow_Up_Summary_Raw =
    follow_up_summary_raw,
  
  Follow_Up_Summary =
    follow_up_summary
)


# ============================================================
# 9. Display descriptive comparison overview
# ============================================================

cat(
  "\n",
  "============================================================\n",
  "OUTCOME GROUP COMPARISONS\n",
  "============================================================\n",
  sep = ""
)

cat(
  "\nMORTALITY GROUPS\n"
)

print(
  outcome_group_summary
)

cat(
  "\nBASELINE NUMERICAL CHARACTERISTICS\n"
)

print(
  grouped_numerical_summary
)

cat(
  "\nDESCRIPTIVE NUMERICAL DIFFERENCES\n"
)

print(
  numerical_group_differences
)

cat(
  "\nBASELINE CATEGORICAL CHARACTERISTICS\n"
)

print(
  categorical_group_summary
)

cat(
  "\nFOLLOW-UP DURATION\n"
)

print(
  follow_up_summary
)


# ============================================================
# 10. Final interpretation note
# ============================================================

cat(
  "\nINTERPRETATION NOTE\n",
  "All comparisons in this script are descriptive.\n",
  "Formal statistical testing is performed in ",
  "06_hypothesis_testing.R.\n",
  "Follow-up duration is reported separately because it is ",
  "not a baseline patient characteristic.\n",
  "Raw numerical differences are not ranked across variables ",
  "because their measurement units differ.\n",
  sep = ""
)


# ============================================================
# 11. Return complete comparison object
# ============================================================

outcome_group_comparisons

