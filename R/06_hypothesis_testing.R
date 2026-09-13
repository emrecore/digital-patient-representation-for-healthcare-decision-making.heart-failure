# ============================================================
# Project: Heart Failure Clinical Statistical Analysis with R
# File: 06_hypothesis_testing.R
# Purpose: Test statistical differences in clinical and
# categorical characteristics across mortality outcomes.
# Language: R
# ============================================================


# ============================================================
# 1. Define significance level
# Statistical significance is evaluated using an alpha level
# of 0.05.
#
# Benjamini-Hochberg adjustment is applied across all tests
# to account for multiple hypothesis testing.
# ============================================================

alpha <- 0.05


# ============================================================
# 2. Define variables for parametric testing
# Welch's t-test is used for selected numerical variables
# where comparison of group means is appropriate.
# ============================================================

t_test_variables <- c(
  "age",
  "serum_sodium"
)


# ============================================================
# 3. Perform Welch's t-tests
# Compare mean values between patients with and without a
# recorded death event.
#
# H0: The group means are equal.
# H1: The group means are different.
#
# Raw values are retained without rounding.
# ============================================================

t_test_results <- do.call(
  rbind,
  lapply(
    t_test_variables,
    function(variable) {
      
      group_no_death <- heart_failure[
        heart_failure$DEATH_EVENT == "No death event",
        variable
      ]
      
      group_death <- heart_failure[
        heart_failure$DEATH_EVENT == "Death event",
        variable
      ]
      
      group_no_death <- group_no_death[
        !is.na(group_no_death)
      ]
      
      group_death <- group_death[
        !is.na(group_death)
      ]
      
      test <- t.test(
        group_no_death,
        group_death,
        var.equal = FALSE
      )
      
      data.frame(
        Variable = variable,
        Test = "Welch t-test",
        Mean_No_Death = mean(group_no_death),
        Mean_Death = mean(group_death),
        Mean_Difference =
          mean(group_no_death) -
          mean(group_death),
        Statistic = unname(test$statistic),
        CI_Lower = test$conf.int[1],
        CI_Upper = test$conf.int[2],
        P_Value = test$p.value
      )
    }
  )
)


# ============================================================
# 4. Define variables for non-parametric testing
# The Wilcoxon rank-sum test is used for clinical variables
# with skewed distributions or substantial outliers.
# ============================================================

wilcoxon_variables <- c(
  "creatinine_phosphokinase",
  "ejection_fraction",
  "platelets",
  "serum_creatinine"
)


# ============================================================
# 5. Perform Wilcoxon rank-sum tests
# Compare distributions between mortality groups without
# assuming normality.
#
# H0: The distributions are equal between groups.
# H1: The distributions differ between groups.
#
# Median values are included for descriptive interpretation.
# ============================================================

wilcoxon_results <- do.call(
  rbind,
  lapply(
    wilcoxon_variables,
    function(variable) {
      
      group_no_death <- heart_failure[
        heart_failure$DEATH_EVENT == "No death event",
        variable
      ]
      
      group_death <- heart_failure[
        heart_failure$DEATH_EVENT == "Death event",
        variable
      ]
      
      group_no_death <- group_no_death[
        !is.na(group_no_death)
      ]
      
      group_death <- group_death[
        !is.na(group_death)
      ]
      
      test <- wilcox.test(
        group_no_death,
        group_death,
        exact = FALSE,
        conf.int = TRUE
      )
      
      data.frame(
        Variable = variable,
        Test = "Wilcoxon rank-sum test",
        Median_No_Death = median(group_no_death),
        Median_Death = median(group_death),
        Statistic = unname(test$statistic),
        Location_Shift_Estimate =
          unname(test$estimate),
        CI_Lower = test$conf.int[1],
        CI_Upper = test$conf.int[2],
        P_Value = test$p.value
      )
    }
  )
)


# ============================================================
# 6. Define categorical variables
# Select categorical patient characteristics for association
# testing with mortality outcome.
# ============================================================

categorical_variables <- c(
  "anaemia",
  "diabetes",
  "high_blood_pressure",
  "sex",
  "smoking"
)


# ============================================================
# 7. Perform categorical association tests
# Pearson's Chi-square test is used when expected frequencies
# are sufficiently large.
#
# Fisher's exact test is used automatically if at least one
# expected cell frequency is below 5.
#
# Cramer's V is reported as an effect-size measure.
# ============================================================

chi_square_results <- do.call(
  rbind,
  lapply(
    categorical_variables,
    function(variable) {
      
      contingency_table <- table(
        heart_failure[[variable]],
        heart_failure$DEATH_EVENT
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
        P_Value = p_value,
        Minimum_Expected_Count =
          minimum_expected,
        Cramers_V = cramers_v
      )
    }
  )
)


# ============================================================
# 8. Create combined hypothesis-test summary
# Combine all inferential tests before multiple-testing
# adjustment.
# ============================================================

hypothesis_test_summary <- rbind(
  
  data.frame(
    Variable = t_test_results$Variable,
    Test = t_test_results$Test,
    P_Value = t_test_results$P_Value
  ),
  
  data.frame(
    Variable = wilcoxon_results$Variable,
    Test = wilcoxon_results$Test,
    P_Value = wilcoxon_results$P_Value
  ),
  
  data.frame(
    Variable = chi_square_results$Variable,
    Test = chi_square_results$Test,
    P_Value = chi_square_results$P_Value
  )
)


# ============================================================
# 9. Adjust for multiple hypothesis testing
# Benjamini-Hochberg adjustment controls the false discovery
# rate across the complete set of hypothesis tests.
#
# Both raw and adjusted results are retained.
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


# ============================================================
# 10. Define primary significance decision
# The multiple-testing-adjusted result is used as the primary
# significance decision.
#
# The column name "Significant" is retained for compatibility
# with subsequent project scripts.
# ============================================================

hypothesis_test_summary$Significant <-
  hypothesis_test_summary$Significant_BH


# ============================================================
# 11. Add adjusted results to individual test tables
# ============================================================

add_adjusted_results <- function(result_table) {
  
  result_key <- paste(
    result_table$Variable,
    result_table$Test
  )
  
  summary_key <- paste(
    hypothesis_test_summary$Variable,
    hypothesis_test_summary$Test
  )
  
  match_index <- match(
    result_key,
    summary_key
  )
  
  result_table$P_Adjusted_BH <-
    hypothesis_test_summary$P_Adjusted_BH[
      match_index
    ]
  
  result_table$Significant_Raw <-
    hypothesis_test_summary$Significant_Raw[
      match_index
    ]
  
  result_table$Significant_BH <-
    hypothesis_test_summary$Significant_BH[
      match_index
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
# 12. Create presentation versions
# Raw numerical results remain unchanged.
# Rounding and p-value formatting are applied only to copies
# used for output.
# ============================================================

t_test_results_display <- t_test_results

t_test_results_display[
  c(
    "Mean_No_Death",
    "Mean_Death",
    "Mean_Difference",
    "Statistic",
    "CI_Lower",
    "CI_Upper"
  )
] <- round(
  t_test_results_display[
    c(
      "Mean_No_Death",
      "Mean_Death",
      "Mean_Difference",
      "Statistic",
      "CI_Lower",
      "CI_Upper"
    )
  ],
  3
)

t_test_results_display$P_Value <- format.pval(
  t_test_results$P_Value,
  digits = 4,
  eps = 0.0001
)

t_test_results_display$P_Adjusted_BH <- format.pval(
  t_test_results$P_Adjusted_BH,
  digits = 4,
  eps = 0.0001
)


wilcoxon_results_display <- wilcoxon_results

wilcoxon_results_display[
  c(
    "Median_No_Death",
    "Median_Death",
    "Statistic",
    "Location_Shift_Estimate",
    "CI_Lower",
    "CI_Upper"
  )
] <- round(
  wilcoxon_results_display[
    c(
      "Median_No_Death",
      "Median_Death",
      "Statistic",
      "Location_Shift_Estimate",
      "CI_Lower",
      "CI_Upper"
    )
  ],
  3
)

wilcoxon_results_display$P_Value <- format.pval(
  wilcoxon_results$P_Value,
  digits = 4,
  eps = 0.0001
)

wilcoxon_results_display$P_Adjusted_BH <- format.pval(
  wilcoxon_results$P_Adjusted_BH,
  digits = 4,
  eps = 0.0001
)


chi_square_results_display <- chi_square_results

chi_square_results_display$Statistic <- round(
  chi_square_results$Statistic,
  3
)

chi_square_results_display$Minimum_Expected_Count <- round(
  chi_square_results$Minimum_Expected_Count,
  2
)

chi_square_results_display$Cramers_V <- round(
  chi_square_results$Cramers_V,
  3
)

chi_square_results_display$P_Value <- format.pval(
  chi_square_results$P_Value,
  digits = 4,
  eps = 0.0001
)

chi_square_results_display$P_Adjusted_BH <- format.pval(
  chi_square_results$P_Adjusted_BH,
  digits = 4,
  eps = 0.0001
)


hypothesis_test_summary_display <-
  hypothesis_test_summary

hypothesis_test_summary_display$P_Value <- format.pval(
  hypothesis_test_summary$P_Value,
  digits = 4,
  eps = 0.0001
)

hypothesis_test_summary_display$P_Adjusted_BH <- format.pval(
  hypothesis_test_summary$P_Adjusted_BH,
  digits = 4,
  eps = 0.0001
)


# ============================================================
# 13. Display final results
# ============================================================

t_test_results_display

wilcoxon_results_display

chi_square_results_display

hypothesis_test_summary_display

