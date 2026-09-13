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
# ============================================================

t_test_results <- do.call(
  rbind,
  lapply(
    t_test_variables,
    function(variable) {
      
      test <- t.test(
        heart_failure[[variable]] ~
          heart_failure$DEATH_EVENT
      )
      
      data.frame(
        Variable = variable,
        Test = "Welch t-test",
        Statistic = unname(test$statistic),
        P_Value = test$p.value,
        CI_Lower = test$conf.int[1],
        CI_Upper = test$conf.int[2]
      )
    }
  )
)

t_test_results[, 3:6] <- round(
  t_test_results[, 3:6],
  4
)

t_test_results$Significant <- ifelse(
  t_test_results$P_Value < alpha,
  "Yes",
  "No"
)

t_test_results


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
# Compare numerical distributions between mortality groups
# without assuming normality.
#
# H0: The distributions are equal between groups.
# H1: The distributions differ between groups.
# ============================================================

wilcoxon_results <- do.call(
  rbind,
  lapply(
    wilcoxon_variables,
    function(variable) {
      
      test <- wilcox.test(
        heart_failure[[variable]] ~
          heart_failure$DEATH_EVENT,
        exact = FALSE
      )
      
      data.frame(
        Variable = variable,
        Test = "Wilcoxon rank-sum test",
        Statistic = unname(test$statistic),
        P_Value = test$p.value
      )
    }
  )
)

wilcoxon_results[, 3:4] <- round(
  wilcoxon_results[, 3:4],
  4
)

wilcoxon_results$Significant <- ifelse(
  wilcoxon_results$P_Value < alpha,
  "Yes",
  "No"
)

wilcoxon_results


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
# 7. Perform Chi-square tests
# Test whether categorical patient characteristics are
# associated with mortality outcome.
#
# H0: The variables are independent.
# H1: The variables are associated.
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
      
      test <- chisq.test(
        contingency_table,
        correct = FALSE
      )
      
      data.frame(
        Variable = variable,
        Test = "Chi-square test",
        Statistic = unname(test$statistic),
        Degrees_of_Freedom = unname(test$parameter),
        P_Value = test$p.value,
        Minimum_Expected_Count = min(test$expected)
      )
    }
  )
)

chi_square_results[, 3:6] <- round(
  chi_square_results[, 3:6],
  4
)

chi_square_results$Significant <- ifelse(
  chi_square_results$P_Value < alpha,
  "Yes",
  "No"
)

chi_square_results


# ============================================================
# 8. Review Chi-square expected frequencies
# Confirm that expected cell frequencies are sufficiently
# large for the Chi-square approximation.
# ============================================================

for (variable in categorical_variables) {
  
  contingency_table <- table(
    heart_failure[[variable]],
    heart_failure$DEATH_EVENT
  )
  
  test <- chisq.test(
    contingency_table,
    correct = FALSE
  )
  
  cat(
    "\nExpected frequencies for:",
    variable,
    "\n"
  )
  
  print(
    round(
      test$expected,
      2
    )
  )
}


# ============================================================
# 9. Summarize hypothesis test results
# Combine p-values and significance decisions without
# performing clinical interpretation.
# ============================================================

hypothesis_test_summary <- rbind(
  data.frame(
    Variable = t_test_results$Variable,
    Test = t_test_results$Test,
    P_Value = t_test_results$P_Value,
    Significant = t_test_results$Significant
  ),
  
  data.frame(
    Variable = wilcoxon_results$Variable,
    Test = wilcoxon_results$Test,
    P_Value = wilcoxon_results$P_Value,
    Significant = wilcoxon_results$Significant
  ),
  
  data.frame(
    Variable = chi_square_results$Variable,
    Test = chi_square_results$Test,
    P_Value = chi_square_results$P_Value,
    Significant = chi_square_results$Significant
  )
)

hypothesis_test_summary

