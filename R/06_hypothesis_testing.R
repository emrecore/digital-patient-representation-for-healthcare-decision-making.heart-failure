# ============================================================
# Project: Representation Sensitivity Analysis 
#          in Heart Failure with R
# File: 06_hypothesis_testing.R
# Purpose: Perform formal mortality-group hypothesis tests
#          with multiple-testing adjustment.
# ============================================================


# ============================================================
# 1. Confirm required objects
# ============================================================

required_objects <- c(
  "heart_failure",
  "baseline_numerical_variables",
  "baseline_categorical_variables",
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
# 2. Define significance level and test allocation
# Welch tests are used for variables where mean comparison is
# appropriate. The remaining baseline numerical variables are
# evaluated using Wilcoxon rank-sum tests.
# ============================================================

alpha <- 0.05

t_test_variables <- c(
  "age",
  "serum_sodium"
)

wilcoxon_variables <- setdiff(
  baseline_numerical_variables,
  t_test_variables
)


# ============================================================
# 3. Helper: extract mortality groups
# ============================================================

get_outcome_groups <- function(variable) {
  
  list(
    no_death = na.omit(
      heart_failure[
        heart_failure[[outcome_variable]] ==
          "No death event",
        variable
      ]
    ),
    
    death = na.omit(
      heart_failure[
        heart_failure[[outcome_variable]] ==
          "Death event",
        variable
      ]
    )
  )
}


# ============================================================
# 4. Welch two-sample t-tests
# Difference direction:
#
# Death event - No death event
# ============================================================

t_test_results <- do.call(
  rbind,
  lapply(
    t_test_variables,
    function(variable) {
      
      groups <- get_outcome_groups(
        variable
      )
      
      test <- t.test(
        groups$death,
        groups$no_death,
        var.equal = FALSE
      )
      
      data.frame(
        Variable = variable,
        Test = "Welch t-test",
        
        Mean_No_Death =
          mean(groups$no_death),
        
        Mean_Death =
          mean(groups$death),
        
        Mean_Difference =
          mean(groups$death) -
          mean(groups$no_death),
        
        Statistic =
          unname(test$statistic),
        
        CI_Lower =
          test$conf.int[1],
        
        CI_Upper =
          test$conf.int[2],
        
        P_Value =
          test$p.value,
        
        stringsAsFactors = FALSE
      )
    }
  )
)

row.names(t_test_results) <- NULL


# ============================================================
# 5. Wilcoxon rank-sum tests
# Tests distributional differences without assuming normality.
#
# The location-shift estimate is not interpreted as a simple
# median difference.
# ============================================================

wilcoxon_results <- do.call(
  rbind,
  lapply(
    wilcoxon_variables,
    function(variable) {
      
      groups <- get_outcome_groups(
        variable
      )
      
      test <- wilcox.test(
        groups$death,
        groups$no_death,
        exact = FALSE,
        conf.int = TRUE
      )
      
      data.frame(
        Variable = variable,
        Test = "Wilcoxon rank-sum test",
        
        Median_No_Death =
          median(groups$no_death),
        
        Median_Death =
          median(groups$death),
        
        Statistic =
          unname(test$statistic),
        
        Location_Shift_Estimate =
          unname(test$estimate),
        
        CI_Lower =
          test$conf.int[1],
        
        CI_Upper =
          test$conf.int[2],
        
        P_Value =
          test$p.value,
        
        stringsAsFactors = FALSE
      )
    }
  )
)

row.names(wilcoxon_results) <- NULL


# ============================================================
# 6. Categorical association tests
# Pearson's chi-squared test is used when expected cell counts
# are adequate. Fisher's exact test is used when at least one
# expected count is below 5.
#
# Cramér's V describes categorical association magnitude.
# ============================================================

chi_square_results <- do.call(
  rbind,
  lapply(
    baseline_categorical_variables,
    function(variable) {
      
      contingency_table <- table(
        heart_failure[[variable]],
        heart_failure[[outcome_variable]]
      )
      
      chi_test <- suppressWarnings(
        chisq.test(
          contingency_table,
          correct = FALSE
        )
      )
      
      minimum_expected <- min(
        chi_test$expected
      )
      
      cramers_v <- sqrt(
        unname(chi_test$statistic) /
          (
            sum(contingency_table) *
              min(
                nrow(contingency_table) - 1,
                ncol(contingency_table) - 1
              )
          )
      )
      
      if (minimum_expected < 5) {
        
        test <- fisher.test(
          contingency_table
        )
        
        test_name <- "Fisher's exact test"
        statistic <- NA_real_
        degrees_of_freedom <- NA_real_
        p_value <- test$p.value
        
      } else {
        
        test_name <- "Chi-square test"
        statistic <- unname(
          chi_test$statistic
        )
        degrees_of_freedom <- unname(
          chi_test$parameter
        )
        p_value <- chi_test$p.value
      }
      
      data.frame(
        Variable = variable,
        Test = test_name,
        Statistic = statistic,
        Degrees_of_Freedom =
          degrees_of_freedom,
        Minimum_Expected_Count =
          minimum_expected,
        Cramers_V =
          cramers_v,
        P_Value =
          p_value,
        stringsAsFactors = FALSE
      )
    }
  )
)

row.names(chi_square_results) <- NULL


# ============================================================
# 7. Combine primary hypothesis tests
# All baseline mortality-group tests belong to one primary
# multiple-testing family.
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
  
  chi_square_results[
    c(
      "Variable",
      "Test",
      "P_Value"
    )
  ]
)

row.names(hypothesis_test_summary) <- NULL


# ============================================================
# 8. Apply Benjamini-Hochberg adjustment
# Statistical decisions are made using raw numerical values.
# Rounding is performed only for presentation.
# ============================================================

hypothesis_test_summary$P_Adjusted_BH <- p.adjust(
  hypothesis_test_summary$P_Value,
  method = "BH"
)

hypothesis_test_summary$Significant_Raw <- ifelse(
  hypothesis_test_summary$P_Value < alpha,
  "Yes",
  "No"
)

hypothesis_test_summary$Significant_BH <- ifelse(
  hypothesis_test_summary$P_Adjusted_BH < alpha,
  "Yes",
  "No"
)

# Primary inferential decision used by later scripts.
hypothesis_test_summary$Significant <-
  hypothesis_test_summary$Significant_BH


# ============================================================
# 9. Add adjusted results to individual test tables
# ============================================================

add_adjusted_results <- function(result_table) {
  
  index <- match(
    result_table$Variable,
    hypothesis_test_summary$Variable
  )
  
  result_table$P_Adjusted_BH <-
    hypothesis_test_summary$P_Adjusted_BH[
      index
    ]
  
  result_table$Significant_Raw <-
    hypothesis_test_summary$Significant_Raw[
      index
    ]
  
  result_table$Significant_BH <-
    hypothesis_test_summary$Significant_BH[
      index
    ]
  
  result_table$Significant <-
    result_table$Significant_BH
  
  result_table
}

t_test_results <- add_adjusted_results(
  t_test_results
)

wilcoxon_results <- add_adjusted_results(
  wilcoxon_results
)

chi_square_results <- add_adjusted_results(
  chi_square_results
)


# ============================================================
# 10. Create presentation versions
# ============================================================

format_results <- function(
    result_table,
    round_columns
) {
  
  display <- result_table
  
  display[round_columns] <- round(
    display[round_columns],
    3
  )
  
  display$P_Value <- format.pval(
    result_table$P_Value,
    digits = 4,
    eps = 0.0001
  )
  
  display$P_Adjusted_BH <- format.pval(
    result_table$P_Adjusted_BH,
    digits = 4,
    eps = 0.0001
  )
  
  display
}


t_test_results_display <- format_results(
  t_test_results,
  c(
    "Mean_No_Death",
    "Mean_Death",
    "Mean_Difference",
    "Statistic",
    "CI_Lower",
    "CI_Upper"
  )
)


wilcoxon_results_display <- format_results(
  wilcoxon_results,
  c(
    "Median_No_Death",
    "Median_Death",
    "Statistic",
    "Location_Shift_Estimate",
    "CI_Lower",
    "CI_Upper"
  )
)


chi_square_results_display <- format_results(
  chi_square_results,
  c(
    "Statistic",
    "Minimum_Expected_Count",
    "Cramers_V"
  )
)


hypothesis_test_summary_display <-
  hypothesis_test_summary

hypothesis_test_summary_display$P_Value <-
  format.pval(
    hypothesis_test_summary$P_Value,
    digits = 4,
    eps = 0.0001
  )

hypothesis_test_summary_display$P_Adjusted_BH <-
  format.pval(
    hypothesis_test_summary$P_Adjusted_BH,
    digits = 4,
    eps = 0.0001
  )


# ============================================================
# 11. Consolidate hypothesis-testing results
# ============================================================

hypothesis_testing <- list(
  
  Significance_Level =
    alpha,
  
  Welch_Tests =
    t_test_results,
  
  Wilcoxon_Tests =
    wilcoxon_results,
  
  Categorical_Tests =
    chi_square_results,
  
  Primary_Test_Summary =
    hypothesis_test_summary
)


# ============================================================
# 12. Display inferential results
# ============================================================

cat(
  "\n",
  "============================================================\n",
  "HYPOTHESIS TESTING\n",
  "============================================================\n",
  sep = ""
)

cat(
  "\nWELCH T-TESTS\n"
)

print(
  t_test_results_display
)

cat(
  "\nWILCOXON RANK-SUM TESTS\n"
)

print(
  wilcoxon_results_display
)

cat(
  "\nCATEGORICAL ASSOCIATION TESTS\n"
)

print(
  chi_square_results_display
)

cat(
  "\nPRIMARY MULTIPLE-TESTING-ADJUSTED SUMMARY\n"
)

print(
  hypothesis_test_summary_display
)


# ============================================================
# 13. Final interpretation note
# ============================================================

cat(
  "\nINTERPRETATION NOTE\n",
  "Benjamini-Hochberg-adjusted p-values provide the primary ",
  "group-level inferential evidence.\n",
  "Statistical significance does not establish causality or ",
  "clinical importance.\n",
  "Cramer's V describes categorical association magnitude.\n",
  sep = ""
)


# ============================================================
# 14. Return complete hypothesis-testing object
# ============================================================

hypothesis_testing

