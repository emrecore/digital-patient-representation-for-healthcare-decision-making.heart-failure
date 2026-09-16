# ============================================================
# Project: Heart Failure Clinical Statistical Analysis with R
# File: 05_outcome_group_comparisons.R
# Purpose: Compare demographic and clinical patient
# characteristics between patients with and without a recorded
# death event during follow-up.
# Language: R
# ============================================================


# ============================================================
# 1. Define outcome groups
# Confirm the mortality outcome categories used throughout the
# group comparison stage.
# ============================================================

outcome_variable <- "DEATH_EVENT"

outcome_levels <- levels(
  heart_failure[[outcome_variable]]
)

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
  Mortality_Outcome = names(outcome_counts),
  N = as.vector(outcome_counts),
  Percentage = round(
    as.vector(
      prop.table(outcome_counts)
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
# Separate baseline numerical variables, categorical patient
# characteristics, and follow-up duration.
#
# Follow-up time is considered separately because it is not a
# baseline patient characteristic and is directly related to
# the observation period of the mortality outcome.
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
# 4. Compare baseline numerical variables by mortality outcome
# Calculate descriptive statistics separately for patients
# with and without a recorded death event.
#
# No inferential conclusions are drawn at this stage.
# Formal hypothesis testing is performed in the next script.
# ============================================================

grouped_numerical_summary <- do.call(
  rbind,
  lapply(
    baseline_numerical_variables,
    function(variable) {
      
      do.call(
        rbind,
        lapply(
          outcome_levels,
          function(outcome) {
            
            values <- heart_failure[
              heart_failure$DEATH_EVENT == outcome,
              variable
            ]
            
            data.frame(
              Variable = variable,
              Mortality_Outcome = outcome,
              N = sum(
                !is.na(values)
              ),
              Mean = mean(
                values,
                na.rm = TRUE
              ),
              Standard_Deviation = sd(
                values,
                na.rm = TRUE
              ),
              Median = median(
                values,
                na.rm = TRUE
              ),
              Q1 = as.numeric(
                quantile(
                  values,
                  0.25,
                  na.rm = TRUE
                )
              ),
              Q3 = as.numeric(
                quantile(
                  values,
                  0.75,
                  na.rm = TRUE
                )
              ),
              IQR = IQR(
                values,
                na.rm = TRUE
              ),
              Minimum = min(
                values,
                na.rm = TRUE
              ),
              Maximum = max(
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
  grouped_numerical_summary
) <- NULL

grouped_numerical_summary[
  ,
  c(
    "Mean",
    "Standard_Deviation",
    "Median",
    "Q1",
    "Q3",
    "IQR",
    "Minimum",
    "Maximum"
  )
] <- round(
  grouped_numerical_summary[
    ,
    c(
      "Mean",
      "Standard_Deviation",
      "Median",
      "Q1",
      "Q3",
      "IQR",
      "Minimum",
      "Maximum"
    )
  ],
  2
)

grouped_numerical_summary


# ============================================================
# 5. Calculate descriptive differences between outcome groups
# Quantify the observed difference in means and medians between
# patients with and without a recorded death event.
#
# Positive values indicate that the corresponding statistic is
# higher in the death-event group.
#
# These are descriptive differences only and do not represent
# statistical significance or causal effects.
# ============================================================

numerical_group_differences <- do.call(
  rbind,
  lapply(
    baseline_numerical_variables,
    function(variable) {
      
      no_death_values <- heart_failure[
        heart_failure$DEATH_EVENT == "No death event",
        variable
      ]
      
      death_values <- heart_failure[
        heart_failure$DEATH_EVENT == "Death event",
        variable
      ]
      
      data.frame(
        Variable = variable,
        
        Mean_No_Death = mean(
          no_death_values,
          na.rm = TRUE
        ),
        
        Mean_Death = mean(
          death_values,
          na.rm = TRUE
        ),
        
        Mean_Difference = mean(
          death_values,
          na.rm = TRUE
        ) -
          mean(
            no_death_values,
            na.rm = TRUE
          ),
        
        Median_No_Death = median(
          no_death_values,
          na.rm = TRUE
        ),
        
        Median_Death = median(
          death_values,
          na.rm = TRUE
        ),
        
        Median_Difference = median(
          death_values,
          na.rm = TRUE
        ) -
          median(
            no_death_values,
            na.rm = TRUE
          ),
        
        stringsAsFactors = FALSE
      )
    }
  )
)

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

row.names(
  numerical_group_differences
) <- NULL

numerical_group_differences


# ============================================================
# 6. Compare follow-up duration by mortality outcome
# Describe follow-up time separately because this variable
# represents observation duration rather than a baseline
# patient characteristic.
#
# Differences in follow-up time should therefore not be
# interpreted in the same way as baseline clinical differences.
# ============================================================

follow_up_summary <- do.call(
  rbind,
  lapply(
    outcome_levels,
    function(outcome) {
      
      values <- heart_failure[
        heart_failure$DEATH_EVENT == outcome,
        follow_up_variable
      ]
      
      data.frame(
        Mortality_Outcome = outcome,
        N = sum(
          !is.na(values)
        ),
        Mean = mean(
          values,
          na.rm = TRUE
        ),
        Standard_Deviation = sd(
          values,
          na.rm = TRUE
        ),
        Median = median(
          values,
          na.rm = TRUE
        ),
        Q1 = as.numeric(
          quantile(
            values,
            0.25,
            na.rm = TRUE
          )
        ),
        Q3 = as.numeric(
          quantile(
            values,
            0.75,
            na.rm = TRUE
          )
        ),
        IQR = IQR(
          values,
          na.rm = TRUE
        ),
        Minimum = min(
          values,
          na.rm = TRUE
        ),
        Maximum = max(
          values,
          na.rm = TRUE
        ),
        stringsAsFactors = FALSE
      )
    }
  )
)

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

row.names(
  follow_up_summary
) <- NULL

follow_up_summary


# ============================================================
# 7. Create categorical comparison tables
# Cross-tabulate each categorical patient characteristic with
# mortality outcome.
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
# 8. Calculate categorical percentages within mortality groups
# Calculate the distribution of each categorical patient
# characteristic separately within the two mortality groups.
#
# Column percentages answer the descriptive question:
# "What proportion of each mortality group has this
# characteristic?"
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
# 9. Create combined categorical comparison summary
# Convert all categorical cross-tabulations and percentages
# into one structured table for easier interpretation.
# ============================================================

categorical_group_summary <- do.call(
  rbind,
  lapply(
    categorical_variables,
    function(variable) {
      
      counts <- categorical_comparison_tables[
        [variable]
      ]
      
      percentages <- categorical_percentage_tables[
        [variable]
      ]
      
      do.call(
        rbind,
        lapply(
          row.names(counts),
          function(category) {
            
            data.frame(
              Variable = variable,
              Category = category,
              
              No_Death_N = counts[
                category,
                "No death event"
              ],
              
              No_Death_Percentage = percentages[
                category,
                "No death event"
              ],
              
              Death_Event_N = counts[
                category,
                "Death event"
              ],
              
              Death_Event_Percentage = percentages[
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
# 10. Calculate mortality proportion within each category
# Evaluate the proportion of patients with a recorded death
# event within each level of every categorical characteristic.
#
# This provides a second descriptive perspective:
# "Within this patient subgroup, what proportion experienced
# a recorded death event?"
#
# These proportions are descriptive and are not adjusted for
# other patient characteristics.
# ============================================================

categorical_mortality_summary <- do.call(
  rbind,
  lapply(
    categorical_variables,
    function(variable) {
      
      categories <- levels(
        heart_failure[[variable]]
      )
      
      do.call(
        rbind,
        lapply(
          categories,
          function(category) {
            
            subgroup <- heart_failure[
              heart_failure[[variable]] == category,
              ,
              drop = FALSE
            ]
            
            total_n <- nrow(
              subgroup
            )
            
            death_n <- sum(
              subgroup$DEATH_EVENT == "Death event",
              na.rm = TRUE
            )
            
            no_death_n <- sum(
              subgroup$DEATH_EVENT == "No death event",
              na.rm = TRUE
            )
            
            data.frame(
              Variable = variable,
              Category = category,
              Total_N = total_n,
              No_Death_N = no_death_n,
              Death_Event_N = death_n,
              Death_Event_Percentage = round(
                (
                  death_n /
                    total_n
                ) * 100,
                2
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
  categorical_mortality_summary
) <- NULL

categorical_mortality_summary


# ============================================================
# 11. Compare anaemia by mortality outcome
# Display the individual cross-tabulation and mortality-group
# percentages for anaemia.
# ============================================================

anaemia_comparison <- categorical_comparison_tables[
  ["anaemia"]
]

anaemia_percentages <- categorical_percentage_tables[
  ["anaemia"]
]

anaemia_comparison

anaemia_percentages


# ============================================================
# 12. Compare diabetes by mortality outcome
# Display the individual cross-tabulation and mortality-group
# percentages for diabetes.
# ============================================================

diabetes_comparison <- categorical_comparison_tables[
  ["diabetes"]
]

diabetes_percentages <- categorical_percentage_tables[
  ["diabetes"]
]

diabetes_comparison

diabetes_percentages


# ============================================================
# 13. Compare high blood pressure by mortality outcome
# Display the individual cross-tabulation and mortality-group
# percentages for hypertension.
# ============================================================

blood_pressure_comparison <- categorical_comparison_tables[
  ["high_blood_pressure"]
]

blood_pressure_percentages <- categorical_percentage_tables[
  ["high_blood_pressure"]
]

blood_pressure_comparison

blood_pressure_percentages


# ============================================================
# 14. Compare sex by mortality outcome
# Display the individual cross-tabulation and mortality-group
# percentages for patient sex.
# ============================================================

sex_comparison <- categorical_comparison_tables[
  ["sex"]
]

sex_percentages <- categorical_percentage_tables[
  ["sex"]
]

sex_comparison

sex_percentages


# ============================================================
# 15. Compare smoking status by mortality outcome
# Display the individual cross-tabulation and mortality-group
# percentages for smoking status.
# ============================================================

smoking_comparison <- categorical_comparison_tables[
  ["smoking"]
]

smoking_percentages <- categorical_percentage_tables[
  ["smoking"]
]

smoking_comparison

smoking_percentages


# ============================================================
# 16. Identify largest descriptive numerical differences
# Rank baseline numerical variables according to the absolute
# difference in group medians.
#
# This ranking is descriptive only. It must not be interpreted
# as evidence of statistical significance or clinical
# importance.
# ============================================================

numerical_difference_ranking <- data.frame(
  Variable = numerical_group_differences$Variable,
  
  Median_Difference =
    numerical_group_differences$Median_Difference,
  
  Absolute_Median_Difference = abs(
    numerical_group_differences$Median_Difference
  ),
  
  stringsAsFactors = FALSE
)

numerical_difference_ranking <-
  numerical_difference_ranking[
    order(
      numerical_difference_ranking$Absolute_Median_Difference,
      decreasing = TRUE
    ),
    ,
    drop = FALSE
  ]

row.names(
  numerical_difference_ranking
) <- NULL

numerical_difference_ranking


# ============================================================
# 17. Create complete outcome-group comparison object
# Consolidate the descriptive comparison results so they can
# be reused during later statistical and interpretation stages.
# ============================================================

outcome_group_comparisons <- list(
  
  Outcome_Group_Summary =
    outcome_group_summary,
  
  Numerical_Group_Summary =
    grouped_numerical_summary,
  
  Numerical_Group_Differences =
    numerical_group_differences,
  
  Follow_Up_Summary =
    follow_up_summary,
  
  Categorical_Count_Tables =
    categorical_comparison_tables,
  
  Categorical_Percentage_Tables =
    categorical_percentage_tables,
  
  Categorical_Group_Summary =
    categorical_group_summary,
  
  Categorical_Mortality_Summary =
    categorical_mortality_summary,
  
  Numerical_Difference_Ranking =
    numerical_difference_ranking
)


# ============================================================
# 18. Display final outcome-group comparison overview
# Present the principal descriptive results before formal
# hypothesis testing is performed.
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
  "\nCATEGORICAL CHARACTERISTICS\n"
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


cat(
  "\nIMPORTANT INTERPRETATION NOTE\n",
  "The comparisons in this script are descriptive.\n",
  "Observed differences between mortality groups do not by ",
  "themselves establish statistical significance, clinical ",
  "importance, or causal relationships.\n",
  "Formal hypothesis tests and multiple-testing adjustment are ",
  "performed separately in the next analytical stage.\n",
  "Follow-up duration is interpreted separately because it ",
  "represents observation time rather than a baseline patient ",
  "characteristic.\n",
  sep = ""
)



