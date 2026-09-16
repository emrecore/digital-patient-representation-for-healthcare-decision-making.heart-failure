# ============================================================
# Project: Heart Failure Clinical Statistical Analysis with R
# File: 05_outcome_group_comparisons.R
# Purpose: Compare demographic and clinical patient
# characteristics descriptively between patients with and
# without a recorded death event during follow-up.
# Language: R
# ============================================================


# ============================================================
# 1. Define outcome variable and outcome groups
# Confirm the mortality outcome categories used throughout the
# descriptive group-comparison stage.
# ============================================================

outcome_variable <- "DEATH_EVENT"

outcome_levels <- levels(
  heart_failure[[outcome_variable]]
)

expected_outcome_levels <- c(
  "No death event",
  "Death event"
)

if (
  !all(
    expected_outcome_levels %in%
    outcome_levels
  )
) {
  
  stop(
    paste(
      "The expected DEATH_EVENT levels are not available.",
      "Run the data import and setup script before executing",
      "05_outcome_group_comparisons.R."
    )
  )
}

outcome_levels


# ============================================================
# 2. Summarize mortality outcome groups
# Count patients with and without a recorded death event and
# calculate the corresponding sample proportions.
# ============================================================

outcome_counts <- table(
  heart_failure$DEATH_EVENT
)

outcome_group_summary <- data.frame(
  
  Mortality_Outcome =
    names(
      outcome_counts
    ),
  
  N =
    as.vector(
      outcome_counts
    ),
  
  Percentage =
    round(
      as.vector(
        prop.table(
          outcome_counts
        )
      ) * 100,
      2
    ),
  
  stringsAsFactors = FALSE
)

row.names(
  outcome_group_summary
) <- NULL

outcome_group_summary


# ============================================================
# 3. Define variables for group comparison
# Separate baseline numerical patient characteristics,
# categorical baseline characteristics, and follow-up duration.
#
# Follow-up time is considered separately because it represents
# observation duration rather than baseline patient information.
# ============================================================

baseline_numerical_variables <- c(
  "age",
  "creatinine_phosphokinase",
  "ejection_fraction",
  "platelets",
  "serum_creatinine",
  "serum_sodium"
)

categorical_variables <- c(
  "anaemia",
  "diabetes",
  "high_blood_pressure",
  "sex",
  "smoking"
)

follow_up_variable <- "time"


# ============================================================
# 4. Confirm required comparison variables
# Ensure all variables needed for the descriptive comparison
# are available in the configured dataset.
# ============================================================

required_comparison_variables <- c(
  baseline_numerical_variables,
  categorical_variables,
  follow_up_variable,
  outcome_variable
)

missing_comparison_variables <- setdiff(
  required_comparison_variables,
  names(
    heart_failure
  )
)

if (
  length(
    missing_comparison_variables
  ) > 0
) {
  
  stop(
    paste(
      "The following variables required for outcome-group",
      "comparisons are missing:",
      paste(
        missing_comparison_variables,
        collapse = ", "
      )
    )
  )
}


# ============================================================
# 5. Compare baseline numerical variables by mortality outcome
# Calculate descriptive statistics separately for patients with
# and without a recorded death event.
#
# This stage is descriptive only.
# Formal hypothesis testing is performed in script 06.
# ============================================================

grouped_numerical_summary_raw <- do.call(
  rbind,
  lapply(
    baseline_numerical_variables,
    function(variable) {
      
      do.call(
        rbind,
        lapply(
          expected_outcome_levels,
          function(outcome) {
            
            values <- heart_failure[
              heart_failure$DEATH_EVENT ==
                outcome,
              variable
            ]
            
            data.frame(
              
              Variable =
                variable,
              
              Mortality_Outcome =
                outcome,
              
              N =
                sum(
                  !is.na(
                    values
                  )
                ),
              
              Mean =
                mean(
                  values,
                  na.rm = TRUE
                ),
              
              Standard_Deviation =
                sd(
                  values,
                  na.rm = TRUE
                ),
              
              Median =
                median(
                  values,
                  na.rm = TRUE
                ),
              
              Q1 =
                as.numeric(
                  quantile(
                    values,
                    0.25,
                    na.rm = TRUE
                  )
                ),
              
              Q3 =
                as.numeric(
                  quantile(
                    values,
                    0.75,
                    na.rm = TRUE
                  )
                ),
              
              IQR =
                IQR(
                  values,
                  na.rm = TRUE
                ),
              
              Minimum =
                min(
                  values,
                  na.rm = TRUE
                ),
              
              Maximum =
                max(
                  values,
                  na.rm = TRUE
                ),
              
              stringsAsFactors = FALSE
            )
          }
        )
      )
    }
  )
)

row.names(
  grouped_numerical_summary_raw
) <- NULL


# ============================================================
# 6. Create display version of numerical group summary
# Preserve the unrounded numerical results internally and apply
# rounding only to the presentation version.
# ============================================================

grouped_numerical_summary <-
  grouped_numerical_summary_raw

numerical_summary_columns <- c(
  "Mean",
  "Standard_Deviation",
  "Median",
  "Q1",
  "Q3",
  "IQR",
  "Minimum",
  "Maximum"
)

grouped_numerical_summary[
  ,
  numerical_summary_columns
] <- round(
  grouped_numerical_summary[
    ,
    numerical_summary_columns
  ],
  2
)

grouped_numerical_summary


# ============================================================
# 7. Calculate descriptive differences between outcome groups
# Quantify the observed differences in means and medians between
# patients with and without a recorded death event.
#
# Difference direction:
#
# Death-event group - No-death-event group
#
# Positive values therefore indicate higher values in the
# death-event group.
#
# These are descriptive differences only.
# ============================================================

numerical_group_differences_raw <- do.call(
  rbind,
  lapply(
    baseline_numerical_variables,
    function(variable) {
      
      no_death_values <- heart_failure[
        heart_failure$DEATH_EVENT ==
          "No death event",
        variable
      ]
      
      death_values <- heart_failure[
        heart_failure$DEATH_EVENT ==
          "Death event",
        variable
      ]
      
      mean_no_death <- mean(
        no_death_values,
        na.rm = TRUE
      )
      
      mean_death <- mean(
        death_values,
        na.rm = TRUE
      )
      
      median_no_death <- median(
        no_death_values,
        na.rm = TRUE
      )
      
      median_death <- median(
        death_values,
        na.rm = TRUE
      )
      
      data.frame(
        
        Variable =
          variable,
        
        Mean_No_Death =
          mean_no_death,
        
        Mean_Death =
          mean_death,
        
        Mean_Difference =
          mean_death -
          mean_no_death,
        
        Median_No_Death =
          median_no_death,
        
        Median_Death =
          median_death,
        
        Median_Difference =
          median_death -
          median_no_death,
        
        stringsAsFactors = FALSE
      )
    }
  )
)

row.names(
  numerical_group_differences_raw
) <- NULL


# ============================================================
# 8. Create display version of numerical differences
# Raw values are preserved because numerical variables have
# different measurement scales.
#
# No ranking across variables is performed because raw mean or
# median differences measured in different units are not
# directly comparable.
# ============================================================

numerical_group_differences <-
  numerical_group_differences_raw

numerical_group_differences[
  ,
  -1
] <- round(
  numerical_group_differences[
    ,
    -1
  ],
  2
)

numerical_group_differences


# ============================================================
# 9. Compare follow-up duration by mortality outcome
# Describe follow-up time separately because this variable
# represents observation duration rather than a baseline
# patient characteristic.
#
# Differences in follow-up duration should not be interpreted in
# the same way as baseline demographic or clinical differences.
# ============================================================

follow_up_summary_raw <- do.call(
  rbind,
  lapply(
    expected_outcome_levels,
    function(outcome) {
      
      values <- heart_failure[
        heart_failure$DEATH_EVENT ==
          outcome,
        follow_up_variable
      ]
      
      data.frame(
        
        Mortality_Outcome =
          outcome,
        
        N =
          sum(
            !is.na(
              values
            )
          ),
        
        Mean =
          mean(
            values,
            na.rm = TRUE
          ),
        
        Standard_Deviation =
          sd(
            values,
            na.rm = TRUE
          ),
        
        Median =
          median(
            values,
            na.rm = TRUE
          ),
        
        Q1 =
          as.numeric(
            quantile(
              values,
              0.25,
              na.rm = TRUE
            )
          ),
        
        Q3 =
          as.numeric(
            quantile(
              values,
              0.75,
              na.rm = TRUE
            )
          ),
        
        IQR =
          IQR(
            values,
            na.rm = TRUE
          ),
        
        Minimum =
          min(
            values,
            na.rm = TRUE
          ),
        
        Maximum =
          max(
            values,
            na.rm = TRUE
          ),
        
        stringsAsFactors = FALSE
      )
    }
  )
)

row.names(
  follow_up_summary_raw
) <- NULL


# ============================================================
# 10. Create display version of follow-up summary
# ============================================================

follow_up_summary <-
  follow_up_summary_raw

follow_up_summary[
  ,
  -1
] <- round(
  follow_up_summary[
    ,
    -1
  ],
  2
)

follow_up_summary


# ============================================================
# 11. Create categorical comparison tables
# Cross-tabulate each categorical baseline patient
# characteristic with mortality outcome.
# ============================================================

categorical_comparison_tables <- lapply(
  categorical_variables,
  function(variable) {
    
    table(
      heart_failure[[variable]],
      heart_failure$DEATH_EVENT
    )
  }
)

names(
  categorical_comparison_tables
) <- categorical_variables

categorical_comparison_tables


# ============================================================
# 12. Calculate categorical percentages within mortality groups
# Calculate the distribution of each categorical patient
# characteristic separately within the mortality groups.
#
# Column percentages answer:
#
# "What proportion of this mortality group belongs to each
# category?"
# ============================================================

categorical_percentage_tables <- lapply(
  categorical_comparison_tables,
  function(comparison_table) {
    
    round(
      prop.table(
        comparison_table,
        margin = 2
      ) * 100,
      2
    )
  }
)

categorical_percentage_tables


# ============================================================
# 13. Create combined categorical group summary
# Convert categorical cross-tabulations and percentages into one
# structured table for easier comparison.
# ============================================================

categorical_group_summary <- do.call(
  rbind,
  lapply(
    categorical_variables,
    function(variable) {
      
      counts <-
        categorical_comparison_tables[
          [variable]
        ]
      
      percentages <-
        categorical_percentage_tables[
          [variable]
        ]
      
      do.call(
        rbind,
        lapply(
          row.names(
            counts
          ),
          function(category) {
            
            data.frame(
              
              Variable =
                variable,
              
              Category =
                category,
              
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

row.names(
  categorical_group_summary
) <- NULL

categorical_group_summary


# ============================================================
# 14. Calculate mortality proportion within each category
# Evaluate the proportion of patients with a recorded death
# event within each level of every categorical characteristic.
#
# This answers:
#
# "Within this subgroup, what proportion experienced a recorded
# death event?"
#
# These proportions are unadjusted and descriptive.
# ============================================================

categorical_mortality_summary_raw <- do.call(
  rbind,
  lapply(
    categorical_variables,
    function(variable) {
      
      categories <- levels(
        heart_failure[
          [variable]
        ]
      )
      
      do.call(
        rbind,
        lapply(
          categories,
          function(category) {
            
            subgroup <- heart_failure[
              heart_failure[
                [variable]
              ] ==
                category,
              ,
              drop = FALSE
            ]
            
            total_n <- nrow(
              subgroup
            )
            
            death_n <- sum(
              subgroup$DEATH_EVENT ==
                "Death event",
              na.rm = TRUE
            )
            
            no_death_n <- sum(
              subgroup$DEATH_EVENT ==
                "No death event",
              na.rm = TRUE
            )
            
            death_percentage <- if (
              total_n > 0
            ) {
              
              (
                death_n /
                  total_n
              ) * 100
              
            } else {
              
              NA_real_
            }
            
            data.frame(
              
              Variable =
                variable,
              
              Category =
                category,
              
              Total_N =
                total_n,
              
              No_Death_N =
                no_death_n,
              
              Death_Event_N =
                death_n,
              
              Death_Event_Percentage =
                death_percentage,
              
              stringsAsFactors = FALSE
            )
          }
        )
      )
    }
  )
)

row.names(
  categorical_mortality_summary_raw
) <- NULL


# ============================================================
# 15. Create display version of categorical mortality summary
# ============================================================

categorical_mortality_summary <-
  categorical_mortality_summary_raw

categorical_mortality_summary$
  Death_Event_Percentage <- round(
    categorical_mortality_summary$
      Death_Event_Percentage,
    2
  )

categorical_mortality_summary


# ============================================================
# 16. Compare anaemia by mortality outcome
# Display the individual count table and mortality-group
# percentages for anaemia.
# ============================================================

anaemia_comparison <-
  categorical_comparison_tables[
    ["anaemia"]
  ]

anaemia_percentages <-
  categorical_percentage_tables[
    ["anaemia"]
  ]

anaemia_comparison

anaemia_percentages


# ============================================================
# 17. Compare diabetes by mortality outcome
# Display the individual count table and mortality-group
# percentages for diabetes.
# ============================================================

diabetes_comparison <-
  categorical_comparison_tables[
    ["diabetes"]
  ]

diabetes_percentages <-
  categorical_percentage_tables[
    ["diabetes"]
  ]

diabetes_comparison

diabetes_percentages


# ============================================================
# 18. Compare high blood pressure by mortality outcome
# Display the individual count table and mortality-group
# percentages for hypertension.
# ============================================================

blood_pressure_comparison <-
  categorical_comparison_tables[
    ["high_blood_pressure"]
  ]

blood_pressure_percentages <-
  categorical_percentage_tables[
    ["high_blood_pressure"]
  ]

blood_pressure_comparison

blood_pressure_percentages


# ============================================================
# 19. Compare sex by mortality outcome
# Display the individual count table and mortality-group
# percentages for recorded patient sex.
# ============================================================

sex_comparison <-
  categorical_comparison_tables[
    ["sex"]
  ]

sex_percentages <-
  categorical_percentage_tables[
    ["sex"]
  ]

sex_comparison

sex_percentages


# ============================================================
# 20. Compare smoking status by mortality outcome
# Display the individual count table and mortality-group
# percentages for recorded smoking status.
# ============================================================

smoking_comparison <-
  categorical_comparison_tables[
    ["smoking"]
  ]

smoking_percentages <-
  categorical_percentage_tables[
    ["smoking"]
  ]

smoking_comparison

smoking_percentages


# ============================================================
# 21. Create complete outcome-group comparison object
# Consolidate all descriptive results so they can be reused in
# subsequent statistical and interpretation stages.
#
# Raw and presentation-ready versions are both retained where
# appropriate.
# ============================================================

outcome_group_comparisons <- list(
  
  Outcome_Group_Summary =
    outcome_group_summary,
  
  Baseline_Numerical_Variables =
    baseline_numerical_variables,
  
  Categorical_Variables =
    categorical_variables,
  
  Follow_Up_Variable =
    follow_up_variable,
  
  Numerical_Group_Summary_Raw =
    grouped_numerical_summary_raw,
  
  Numerical_Group_Summary =
    grouped_numerical_summary,
  
  Numerical_Group_Differences_Raw =
    numerical_group_differences_raw,
  
  Numerical_Group_Differences =
    numerical_group_differences,
  
  Follow_Up_Summary_Raw =
    follow_up_summary_raw,
  
  Follow_Up_Summary =
    follow_up_summary,
  
  Categorical_Count_Tables =
    categorical_comparison_tables,
  
  Categorical_Percentage_Tables =
    categorical_percentage_tables,
  
  Categorical_Group_Summary =
    categorical_group_summary,
  
  Categorical_Mortality_Summary_Raw =
    categorical_mortality_summary_raw,
  
  Categorical_Mortality_Summary =
    categorical_mortality_summary
)


# ============================================================
# 22. Display final outcome-group comparison overview
# Present the principal descriptive results before formal
# hypothesis testing is performed in script 06.
# ============================================================

cat(
  "\n",
  "============================================================\n",
  "OUTCOME GROUP COMPARISONS\n",
  "============================================================\n",
  sep = ""
)


cat(
  "\nMORTALITY OUTCOME GROUPS\n"
)

print(
  outcome_group_summary
)


cat(
  "\nBASELINE NUMERICAL CHARACTERISTICS BY OUTCOME\n"
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
  "\nCATEGORICAL CHARACTERISTICS BY OUTCOME\n"
)

print(
  categorical_group_summary
)


cat(
  "\nMORTALITY PROPORTION WITHIN CATEGORICAL SUBGROUPS\n"
)

print(
  categorical_mortality_summary
)


cat(
  "\nFOLLOW-UP DURATION BY OUTCOME\n"
)

print(
  follow_up_summary
)


# ============================================================
# 23. Final interpretation note
# Explicitly separate descriptive observations from formal
# statistical inference.
# ============================================================

cat(
  "\nIMPORTANT INTERPRETATION NOTE\n",
  
  "The comparisons in this script are descriptive.\n",
  
  "Observed differences between mortality groups do not by ",
  "themselves establish statistical significance, clinical ",
  "importance, or causal relationships.\n",
  
  "Formal hypothesis testing and multiple-testing adjustment ",
  "are performed separately in ",
  "06_hypothesis_testing.R.\n",
  
  "Follow-up duration is reported separately because it ",
  "represents observation time rather than a baseline patient ",
  "characteristic.\n",
  
  "Numerical variables are measured on different scales and ",
  "in different units. Raw mean and median differences are ",
  "therefore not ranked across variables.\n",
  
  "Categorical mortality proportions are unadjusted and should ",
  "not be interpreted as independent effects of the respective ",
  "patient characteristics.\n",
  
  sep = ""
)


# ============================================================
# 24. Return complete descriptive comparison object
# ============================================================

outcome_group_comparisons



