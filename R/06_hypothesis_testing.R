# ============================================================
# Project: Representation Sensitivity Analysis
#          in Heart Failure with R
# File: 06_hypothesis_testing.R
# Purpose: Perform formal baseline group-level hypothesis
#          tests according to recorded death-event status,
#          with multiple-testing adjustment and explicit
#          interpretation boundaries.
# ============================================================


# ============================================================
# 1. Confirm required setup objects from script 01
# ============================================================

required_objects <- c(
  "heart_failure",
  "baseline_numerical_variables",
  "baseline_categorical_variables",
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
      "Hypothesis testing failed. '",
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
      "Hypothesis testing failed. Unexpected factor levels ",
      "for '",
      outcome_variable,
      "'. Check script 01."
    )
  )
}

no_event_label <- outcome_labels[1]
event_label <- outcome_labels[2]


# ============================================================
# 3. Define significance level and primary testing family
# ============================================================
#
# All formal baseline group-comparison tests belong to one
# primary multiple-testing family.
#
# Benjamini-Hochberg-adjusted p-values provide the primary
# inferential decision criterion.
#
# Raw p-values are retained for transparency.
# ============================================================

alpha <- 0.05


# ============================================================
# 4. Define numerical test plan
# ============================================================
#
# Test allocation is specified explicitly rather than selected
# automatically from a formal normality test.
#
# Welch tests are used where comparison of group means is
# considered an interpretable summary of the observed
# distribution.
#
# Wilcoxon rank-sum tests are used for variables with stronger
# skew, discreteness, or influential extreme observations,
# where a rank-based comparison is more appropriate for this
# exploratory dataset.
#
# This allocation is project-specific and should not be treated
# as a universal clinical or statistical rule.
# ============================================================

numerical_test_plan <- data.frame(
  
  Variable = baseline_numerical_variables,
  
  Test_Method = c(
    "Welch t-test",              # age
    "Wilcoxon rank-sum test",    # creatinine_phosphokinase
    "Wilcoxon rank-sum test",    # ejection_fraction
    "Wilcoxon rank-sum test",    # platelets
    "Wilcoxon rank-sum test",    # serum_creatinine
    "Welch t-test"               # serum_sodium
  ),
  
  Rationale = c(
    "Mean comparison retained as an interpretable summary",
    "Rank-based comparison used for strongly skewed values",
    "Rank-based comparison used for discrete and non-normal values",
    "Rank-based comparison used for skew and extreme observations",
    "Rank-based comparison used for skew and extreme observations",
    "Mean comparison retained as an interpretable summary"
  ),
  
  stringsAsFactors = FALSE
)


if (!identical(
  numerical_test_plan$Variable,
  baseline_numerical_variables
)) {
  stop(
    paste0(
      "Hypothesis-testing setup failed. Numerical test plan ",
      "does not match baseline_numerical_variables."
    )
  )
}


t_test_variables <- numerical_test_plan$Variable[
  numerical_test_plan$Test_Method ==
    "Welch t-test"
]

wilcoxon_variables <- numerical_test_plan$Variable[
  numerical_test_plan$Test_Method ==
    "Wilcoxon rank-sum test"
]


# ============================================================
# 5. Helper: extract observed outcome groups
# ============================================================
#
# Missing values in the tested baseline variable are excluded
# separately for each test.
#
# The groups reflect recorded death-event status during each
# patient's observed follow-up period.
# ============================================================

get_outcome_groups <- function(
    data,
    variable,
    outcome,
    no_event_level,
    event_level
) {
  
  no_event_values <- data[
    !is.na(data[[outcome]]) &
      data[[outcome]] == no_event_level,
    variable
  ]
  
  event_values <- data[
    !is.na(data[[outcome]]) &
      data[[outcome]] == event_level,
    variable
  ]
  
  list(
    
    no_event = no_event_values[
      !is.na(no_event_values)
    ],
    
    event = event_values[
      !is.na(event_values)
    ]
  )
}


# ============================================================
# 6. Welch two-sample t-tests
# ============================================================
#
# Difference direction:
#
# Death event recorded - No recorded death event
#
# Welch's test does not assume equal group variances.
# ============================================================

t_test_results <- do.call(
  rbind,
  lapply(
    t_test_variables,
    function(variable) {
      
      groups <- get_outcome_groups(
        data = heart_failure,
        variable = variable,
        outcome = outcome_variable,
        no_event_level = no_event_label,
        event_level = event_label
      )
      
      if (
        length(groups$no_event) < 2 ||
        length(groups$event) < 2
      ) {
        stop(
          paste0(
            "Welch t-test failed for '",
            variable,
            "'. Each outcome group requires at least ",
            "two observed values."
          )
        )
      }
      
      test <- t.test(
        x = groups$event,
        y = groups$no_event,
        var.equal = FALSE,
        conf.level = 0.95
      )
      
      data.frame(
        
        Variable =
          variable,
        
        Test =
          "Welch t-test",
        
        No_Event_N =
          length(groups$no_event),
        
        Event_N =
          length(groups$event),
        
        Mean_No_Event =
          mean(groups$no_event),
        
        Mean_Event =
          mean(groups$event),
        
        Mean_Difference_Event_Minus_No_Event =
          mean(groups$event) -
          mean(groups$no_event),
        
        Statistic =
          unname(test$statistic),
        
        Degrees_of_Freedom =
          unname(test$parameter),
        
        CI_Lower =
          unname(test$conf.int[1]),
        
        CI_Upper =
          unname(test$conf.int[2]),
        
        P_Value =
          test$p.value,
        
        stringsAsFactors = FALSE
      )
    }
  )
)

row.names(
  t_test_results
) <- NULL


# ============================================================
# 7. Wilcoxon rank-sum tests
# ============================================================
#
# The Wilcoxon rank-sum test evaluates distributional
# differences using ranks and does not require normally
# distributed observations.
#
# The reported location-shift estimate is the Hodges-Lehmann-
# type location-shift estimate returned by wilcox.test().
#
# It must not be interpreted as a simple difference between
# the two observed sample medians.
# ============================================================

wilcoxon_results <- do.call(
  rbind,
  lapply(
    wilcoxon_variables,
    function(variable) {
      
      groups <- get_outcome_groups(
        data = heart_failure,
        variable = variable,
        outcome = outcome_variable,
        no_event_level = no_event_label,
        event_level = event_label
      )
      
      if (
        length(groups$no_event) < 1 ||
        length(groups$event) < 1
      ) {
        stop(
          paste0(
            "Wilcoxon rank-sum test failed for '",
            variable,
            "'. Both outcome groups require observed values."
          )
        )
      }
      
      test <- suppressWarnings(
        wilcox.test(
          x = groups$event,
          y = groups$no_event,
          exact = FALSE,
          correct = TRUE,
          conf.int = TRUE,
          conf.level = 0.95
        )
      )
      
      location_shift_estimate <- if (
        !is.null(test$estimate)
      ) {
        unname(test$estimate)
      } else {
        NA_real_
      }
      
      confidence_interval <- if (
        !is.null(test$conf.int)
      ) {
        unname(test$conf.int)
      } else {
        c(
          NA_real_,
          NA_real_
        )
      }
      
      data.frame(
        
        Variable =
          variable,
        
        Test =
          "Wilcoxon rank-sum test",
        
        No_Event_N =
          length(groups$no_event),
        
        Event_N =
          length(groups$event),
        
        Median_No_Event =
          median(groups$no_event),
        
        Median_Event =
          median(groups$event),
        
        Observed_Median_Difference_Event_Minus_No_Event =
          median(groups$event) -
          median(groups$no_event),
        
        Statistic =
          unname(test$statistic),
        
        Location_Shift_Estimate =
          location_shift_estimate,
        
        CI_Lower =
          confidence_interval[1],
        
        CI_Upper =
          confidence_interval[2],
        
        P_Value =
          test$p.value,
        
        stringsAsFactors = FALSE
      )
    }
  )
)

row.names(
  wilcoxon_results
) <- NULL


# ============================================================
# 8. Categorical association tests
# ============================================================
#
# Pearson's chi-squared test is used when all expected cell
# counts are at least 5.
#
# Fisher's exact test is used when at least one expected cell
# count is below 5.
#
# Cramér's V is reported as a descriptive measure of
# categorical association magnitude and is calculated from the
# Pearson chi-squared statistic regardless of which p-value
# method is ultimately selected.
# ============================================================

categorical_test_results <- do.call(
  rbind,
  lapply(
    baseline_categorical_variables,
    function(variable) {
      
      complete_index <-
        !is.na(
          heart_failure[[variable]]
        ) &
        !is.na(
          heart_failure[[outcome_variable]]
        )
      
      variable_data <- droplevels(
        heart_failure[
          complete_index,
          c(
            variable,
            outcome_variable
          )
        ]
      )
      
      contingency_table <- table(
        variable_data[[variable]],
        variable_data[[outcome_variable]]
      )
      
      if (
        nrow(contingency_table) < 2 ||
        ncol(contingency_table) < 2
      ) {
        stop(
          paste0(
            "Categorical hypothesis test failed for '",
            variable,
            "'. At least two observed categories are ",
            "required in both dimensions."
          )
        )
      }
      
      chi_test <- suppressWarnings(
        chisq.test(
          contingency_table,
          correct = FALSE
        )
      )
      
      expected_counts <- chi_test$expected
      
      minimum_expected_count <- min(
        expected_counts
      )
      
      expected_below_five_n <- sum(
        expected_counts < 5
      )
      
      expected_below_five_percentage <-
        expected_below_five_n /
        length(expected_counts) *
        100
      
      cramers_v_denominator <- (
        sum(contingency_table) *
          min(
            nrow(contingency_table) - 1,
            ncol(contingency_table) - 1
          )
      )
      
      cramers_v <- if (
        cramers_v_denominator > 0
      ) {
        sqrt(
          unname(chi_test$statistic) /
            cramers_v_denominator
        )
      } else {
        NA_real_
      }
      
      if (minimum_expected_count < 5) {
        
        selected_test <- fisher.test(
          contingency_table
        )
        
        test_name <-
          "Fisher's exact test"
        
        statistic <-
          NA_real_
        
        degrees_of_freedom <-
          NA_real_
        
        p_value <-
          selected_test$p.value
        
      } else {
        
        test_name <-
          "Pearson chi-squared test"
        
        statistic <-
          unname(
            chi_test$statistic
          )
        
        degrees_of_freedom <-
          unname(
            chi_test$parameter
          )
        
        p_value <-
          chi_test$p.value
      }
      
      data.frame(
        
        Variable =
          variable,
        
        Test =
          test_name,
        
        Complete_Case_N =
          sum(contingency_table),
        
        Statistic =
          statistic,
        
        Degrees_of_Freedom =
          degrees_of_freedom,
        
        Minimum_Expected_Count =
          minimum_expected_count,
        
        Expected_Cells_Below_5_N =
          expected_below_five_n,
        
        Expected_Cells_Below_5_Percentage =
          expected_below_five_percentage,
        
        Cramers_V =
          cramers_v,
        
        P_Value =
          p_value,
        
        stringsAsFactors = FALSE
      )
    }
  )
)

row.names(
  categorical_test_results
) <- NULL


# ============================================================
# 9. Combine the primary baseline hypothesis-testing family
# ============================================================
#
# One formal group-comparison p-value is contributed by each
# baseline characteristic.
#
# Follow-up duration is intentionally excluded because it is
# observation information rather than a baseline patient
# characteristic and because the dataset has an underlying
# time-to-event structure.
# ============================================================

hypothesis_test_summary <- rbind(
  
  t_test_results[
    c(
      "Variable",
      "Test",
      "P_Value"
    )
  ],
  
  wilcoxon_results[
    c(
      "Variable",
      "Test",
      "P_Value"
    )
  ],
  
  categorical_test_results[
    c(
      "Variable",
      "Test",
      "P_Value"
    )
  ]
)

row.names(
  hypothesis_test_summary
) <- NULL


# ============================================================
# 10. Verify primary testing family
# ============================================================

expected_primary_variables <- c(
  baseline_numerical_variables,
  baseline_categorical_variables
)

if (
  nrow(hypothesis_test_summary) !=
  length(expected_primary_variables)
) {
  stop(
    paste0(
      "Hypothesis-testing audit failed. Expected ",
      length(expected_primary_variables),
      " primary baseline tests but obtained ",
      nrow(hypothesis_test_summary),
      "."
    )
  )
}

if (
  !setequal(
    hypothesis_test_summary$Variable,
    expected_primary_variables
  )
) {
  stop(
    paste0(
      "Hypothesis-testing audit failed. Primary testing ",
      "family does not match the defined baseline variables."
    )
  )
}

if (
  anyDuplicated(
    hypothesis_test_summary$Variable
  ) > 0
) {
  stop(
    "Hypothesis-testing audit failed. Duplicate primary tests detected."
  )
}


# ============================================================
# 11. Apply Benjamini-Hochberg adjustment
# ============================================================
#
# Statistical decisions use unrounded numerical p-values.
# Rounding and formatted p-values are applied only in
# presentation objects.
# ============================================================

hypothesis_test_summary$P_Adjusted_BH <- p.adjust(
  hypothesis_test_summary$P_Value,
  method = "BH"
)

hypothesis_test_summary$Significant_Raw <-
  hypothesis_test_summary$P_Value <
  alpha

hypothesis_test_summary$Significant_BH <-
  hypothesis_test_summary$P_Adjusted_BH <
  alpha

# Primary inferential flag used by later scripts.
hypothesis_test_summary$Significant <-
  hypothesis_test_summary$Significant_BH


# ============================================================
# 12. Add adjusted results to individual test tables
# ============================================================

add_adjusted_results <- function(
    result_table,
    summary_table
) {
  
  index <- match(
    result_table$Variable,
    summary_table$Variable
  )
  
  if (any(is.na(index))) {
    stop(
      paste0(
        "Hypothesis-testing audit failed. Unable to match ",
        "individual test results to primary summary."
      )
    )
  }
  
  result_table$P_Adjusted_BH <-
    summary_table$P_Adjusted_BH[
      index
    ]
  
  result_table$Significant_Raw <-
    summary_table$Significant_Raw[
      index
    ]
  
  result_table$Significant_BH <-
    summary_table$Significant_BH[
      index
    ]
  
  result_table$Significant <-
    result_table$Significant_BH
  
  result_table
}


t_test_results <- add_adjusted_results(
  t_test_results,
  hypothesis_test_summary
)

wilcoxon_results <- add_adjusted_results(
  wilcoxon_results,
  hypothesis_test_summary
)

categorical_test_results <- add_adjusted_results(
  categorical_test_results,
  hypothesis_test_summary
)


# ============================================================
# 13. Create presentation versions
# ============================================================

format_p_values <- function(x) {
  
  format.pval(
    x,
    digits = 4,
    eps = 0.0001
  )
}


round_selected_columns <- function(
    data,
    columns,
    digits = 3
) {
  
  display <- data
  
  existing_columns <- intersect(
    columns,
    names(display)
  )
  
  display[
    existing_columns
  ] <- lapply(
    display[
      existing_columns
    ],
    round,
    digits = digits
  )
  
  display
}


t_test_results_display <- round_selected_columns(
  t_test_results,
  c(
    "Mean_No_Event",
    "Mean_Event",
    "Mean_Difference_Event_Minus_No_Event",
    "Statistic",
    "Degrees_of_Freedom",
    "CI_Lower",
    "CI_Upper"
  )
)

t_test_results_display$P_Value <-
  format_p_values(
    t_test_results$P_Value
  )

t_test_results_display$P_Adjusted_BH <-
  format_p_values(
    t_test_results$P_Adjusted_BH
  )


wilcoxon_results_display <- round_selected_columns(
  wilcoxon_results,
  c(
    "Median_No_Event",
    "Median_Event",
    "Observed_Median_Difference_Event_Minus_No_Event",
    "Statistic",
    "Location_Shift_Estimate",
    "CI_Lower",
    "CI_Upper"
  )
)

wilcoxon_results_display$P_Value <-
  format_p_values(
    wilcoxon_results$P_Value
  )

wilcoxon_results_display$P_Adjusted_BH <-
  format_p_values(
    wilcoxon_results$P_Adjusted_BH
  )


categorical_test_results_display <-
  round_selected_columns(
    categorical_test_results,
    c(
      "Statistic",
      "Degrees_of_Freedom",
      "Minimum_Expected_Count",
      "Expected_Cells_Below_5_Percentage",
      "Cramers_V"
    )
  )

categorical_test_results_display$P_Value <-
  format_p_values(
    categorical_test_results$P_Value
  )

categorical_test_results_display$P_Adjusted_BH <-
  format_p_values(
    categorical_test_results$P_Adjusted_BH
  )


hypothesis_test_summary_display <-
  hypothesis_test_summary

hypothesis_test_summary_display$P_Value <-
  format_p_values(
    hypothesis_test_summary$P_Value
  )

hypothesis_test_summary_display$P_Adjusted_BH <-
  format_p_values(
    hypothesis_test_summary$P_Adjusted_BH
  )


# ============================================================
# 14. Identify BH-supported baseline group differences
# ============================================================
#
# This object is a convenience subset for later synthesis.
#
# "Supported" here means only that the corresponding
# Benjamini-Hochberg-adjusted p-value is below alpha within the
# defined baseline group-comparison family.
#
# It does not imply causality, prognostic validity, clinical
# relevance, or decision relevance.
# ============================================================

bh_supported_group_differences <-
  hypothesis_test_summary[
    hypothesis_test_summary$Significant_BH,
    ,
    drop = FALSE
  ]


# ============================================================
# 15. Consolidate hypothesis-testing results
# ============================================================

hypothesis_testing <- list(
  
  Significance_Level =
    alpha,
  
  Numerical_Test_Plan =
    numerical_test_plan,
  
  Welch_Tests =
    t_test_results,
  
  Wilcoxon_Tests =
    wilcoxon_results,
  
  Categorical_Tests =
    categorical_test_results,
  
  Primary_Test_Summary =
    hypothesis_test_summary,
  
  BH_Supported_Group_Differences =
    bh_supported_group_differences
)


# ============================================================
# 16. Display inferential results
# ============================================================

cat(
  "\n",
  "============================================================\n",
  "FORMAL BASELINE GROUP-LEVEL INFERENCE\n",
  "============================================================\n",
  sep = ""
)


cat(
  "\nNUMERICAL TEST PLAN\n"
)

print(
  numerical_test_plan,
  row.names = FALSE
)


cat(
  "\nWELCH TWO-SAMPLE T-TESTS\n"
)

print(
  t_test_results_display,
  row.names = FALSE
)


cat(
  "\nWILCOXON RANK-SUM TESTS\n"
)

print(
  wilcoxon_results_display,
  row.names = FALSE
)


cat(
  "\nCATEGORICAL ASSOCIATION TESTS\n"
)

print(
  categorical_test_results_display,
  row.names = FALSE
)


cat(
  "\nPRIMARY BENJAMINI-HOCHBERG-ADJUSTED SUMMARY\n"
)

print(
  hypothesis_test_summary_display,
  row.names = FALSE
)


cat(
  "\nBH-SUPPORTED BASELINE GROUP DIFFERENCES\n"
)

if (
  nrow(
    bh_supported_group_differences
  ) > 0
) {
  
  print(
    hypothesis_test_summary_display[
      hypothesis_test_summary$Significant_BH,
      ,
      drop = FALSE
    ],
    row.names = FALSE
  )
  
} else {
  
  cat(
    "No baseline group comparison met the BH-adjusted ",
    "significance criterion.\n"
  )
}


# ============================================================
# 17. Interpretation note
# ============================================================

cat(
  "\nINTERPRETATION NOTE\n",
  "\n",
  "These tests compare baseline patient characteristics ",
  "according to whether a death event was recorded during ",
  "each patient's observed follow-up period.\n",
  "\n",
  "Because follow-up duration varies between patients, these ",
  "comparisons must not be interpreted as fixed-horizon ",
  "survival or mortality comparisons.\n",
  "\n",
  "Follow-up duration is intentionally excluded from the ",
  "primary testing family because it is observation ",
  "information rather than a baseline patient characteristic.\n",
  "\n",
  "Benjamini-Hochberg-adjusted p-values provide the primary ",
  "group-level inferential criterion across the defined ",
  "baseline testing family. Raw p-values are retained for ",
  "transparency.\n",
  "\n",
  "The numerical test allocation is project-specific and was ",
  "defined from the observed distributional and measurement ",
  "characteristics of the variables rather than from a ",
  "mechanical normality-test rule.\n",
  "\n",
  "For Wilcoxon tests, the reported location-shift estimate ",
  "must not be interpreted as the simple difference between ",
  "the two observed sample medians.\n",
  "\n",
  "Cramer's V provides a descriptive measure of categorical ",
  "association magnitude. Statistical significance alone does ",
  "not establish effect importance.\n",
  "\n",
  "None of these tests establishes causality, prognostic ",
  "validity, clinical importance, or decision relevance.\n",
  sep = ""
)


# ============================================================
# 18. Return complete hypothesis-testing object
# ============================================================

hypothesis_testing

