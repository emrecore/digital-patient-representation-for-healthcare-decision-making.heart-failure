# ============================================================
# Project: Heart Failure Clinical Statistical Analysis with R
# File: 07_correlation_analysis.R
# Purpose: Analyze relationships between continuous clinical
# variables using correlation coefficients and visualizations.
# Language: R
# ============================================================


# ============================================================
# 1. Load visualization package
# ggplot2 is used to visualize relationships between
# continuous clinical variables.
# ============================================================

library(ggplot2)


# ============================================================
# 2. Define continuous clinical variables
# Select quantitative patient and laboratory characteristics
# for correlation analysis.
# ============================================================

correlation_variables <- c(
  "age",
  "creatinine_phosphokinase",
  "ejection_fraction",
  "platelets",
  "serum_creatinine",
  "serum_sodium"
)


# ============================================================
# 3. Create correlation dataset
# Restrict the analysis to the selected continuous variables.
# ============================================================

correlation_data <- heart_failure[
  correlation_variables
]


# ============================================================
# 4. Calculate Spearman correlation matrix
# Spearman correlation measures monotonic relationships and
# is less sensitive to skewed distributions and outliers.
# ============================================================

correlation_matrix <- cor(
  correlation_data,
  method = "spearman",
  use = "complete.obs"
)

round(
  correlation_matrix,
  3
)


# ============================================================
# 5. Calculate pairwise correlation statistics
# Estimate Spearman correlation coefficients and p-values
# for every pair of continuous clinical variables.
#
# H0: There is no monotonic association between the variables.
# H1: A monotonic association exists between the variables.
# ============================================================

correlation_pairs <- combn(
  correlation_variables,
  2,
  simplify = FALSE
)

correlation_results <- do.call(
  rbind,
  lapply(
    correlation_pairs,
    function(pair) {
      
      test <- cor.test(
        heart_failure[[pair[1]]],
        heart_failure[[pair[2]]],
        method = "spearman",
        exact = FALSE
      )
      
      data.frame(
        Variable_1 = pair[1],
        Variable_2 = pair[2],
        Spearman_Rho = unname(test$estimate),
        P_Value = test$p.value
      )
    }
  )
)

correlation_results$Spearman_Rho <- round(
  correlation_results$Spearman_Rho,
  3
)

correlation_results$P_Value <- round(
  correlation_results$P_Value,
  4
)

correlation_results$Significant <- ifelse(
  correlation_results$P_Value < 0.05,
  "Yes",
  "No"
)

correlation_results


# ============================================================
# 6. Rank correlations by strength
# Order variable pairs according to the absolute magnitude
# of their Spearman correlation coefficient.
# ============================================================

correlation_results$Absolute_Correlation <- abs(
  correlation_results$Spearman_Rho
)

correlation_results_ranked <- correlation_results[
  order(
    -correlation_results$Absolute_Correlation
  ),
]

correlation_results_ranked


# ============================================================
# 7. Prepare correlation matrix for visualization
# Convert the correlation matrix into long format for
# visualization with ggplot2.
# ============================================================

correlation_long <- as.data.frame(
  as.table(
    correlation_matrix
  )
)

names(correlation_long) <- c(
  "Variable_1",
  "Variable_2",
  "Correlation"
)


# ============================================================
# 8. Visualize correlation matrix
# Display the direction and strength of pairwise correlations
# between continuous clinical variables.
# ============================================================

ggplot(
  correlation_long,
  aes(
    x = Variable_1,
    y = Variable_2,
    fill = Correlation
  )
) +
  geom_tile() +
  geom_text(
    aes(
      label = round(
        Correlation,
        2
      )
    )
  ) +
  labs(
    title = "Correlation Matrix of Continuous Clinical Variables",
    x = NULL,
    y = NULL,
    fill = "Spearman\nCorrelation"
  ) +
  theme_minimal() +
  theme(
    axis.text.x = element_text(
      angle = 45,
      hjust = 1
    )
  )


# ============================================================
# 9. Visualize selected clinical relationships
# Scatterplots provide a direct view of relationships between
# selected continuous clinical measurements.
# ============================================================

ggplot(
  heart_failure,
  aes(
    x = ejection_fraction,
    y = serum_creatinine
  )
) +
  geom_point() +
  geom_smooth(
    method = "loess",
    se = FALSE
  ) +
  labs(
    title = "Ejection Fraction vs Serum Creatinine",
    x = "Ejection Fraction (%)",
    y = "Serum Creatinine"
  ) +
  theme_minimal()


ggplot(
  heart_failure,
  aes(
    x = age,
    y = ejection_fraction
  )
) +
  geom_point() +
  geom_smooth(
    method = "loess",
    se = FALSE
  ) +
  labs(
    title = "Age vs Ejection Fraction",
    x = "Age",
    y = "Ejection Fraction (%)"
  ) +
  theme_minimal()


ggplot(
  heart_failure,
  aes(
    x = serum_creatinine,
    y = serum_sodium
  )
) +
  geom_point() +
  geom_smooth(
    method = "loess",
    se = FALSE
  ) +
  labs(
    title = "Serum Creatinine vs Serum Sodium",
    x = "Serum Creatinine",
    y = "Serum Sodium"
  ) +
  theme_minimal()

