# ============================================================
# Project: Heart Failure Clinical Statistical Analysis with R
# File: 07_correlation_analysis.R
# Purpose: Examine the correlation structure between continuous
# baseline patient characteristics using Spearman rank
# correlation and exploratory visualizations.
# Language: R
# ============================================================


# ============================================================
# 1. Load visualization package
# ggplot2 is used to visualize selected relationships between
# continuous baseline patient characteristics.
# ============================================================

library(ggplot2)


# ============================================================
# 2. Define continuous baseline variables
# Restrict the primary correlation analysis to continuous
# baseline patient characteristics.
#
# Follow-up time is deliberately excluded because it represents
# observation duration rather than baseline patient information.
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
# 3. Confirm required variables
# Verify that all variables required for the correlation
# analysis are available in the configured dataset.
# ============================================================

missing_correlation_variables <- setdiff(
  correlation_variables,
  names(
    heart_failure
  )
)

if (
  length(
    missing_correlation_variables
  ) > 0
) {
  
  stop(
    paste(
      "The following variables required for the correlation",
      "analysis are missing:",
      paste(
        missing_correlation_variables,
        collapse = ", "
      )
    )
  )
}


# ============================================================
# 4. Confirm numerical variable types
# Spearman correlation requires variables that can be ranked
# numerically.
# ============================================================

non_numeric_correlation_variables <-
  correlation_variables[
    !vapply(
      heart_failure[
        correlation_variables
      ],
      is.numeric,
      logical(1)
    )
  ]

if (
  length(
    non_numeric_correlation_variables
  ) > 0
) {
  
  stop(
    paste(
      "The following correlation variables are not numeric:",
      paste(
        non_numeric_correlation_variables,
        collapse = ", "
      )
    )
  )
}


# ============================================================
# 5. Create correlation dataset
# Restrict the analysis to the selected continuous baseline
# variables.
# ============================================================

correlation_data <- heart_failure[
  correlation_variables
]


# ============================================================
# 6. Summarize data availability
# Count available and missing observations for each variable.
#
# This ensures that the data basis of the correlation analysis
# remains explicit even if future versions of the dataset
# contain missing observations.
# ============================================================

correlation_data_availability <- data.frame(
  
  Variable =
    correlation_variables,
  
  Available_N =
    vapply(
      correlation_data,
      function(variable) {
        
        sum(
          !is.na(
            variable
          )
        )
      },
      numeric(1)
    ),
  
  Missing_N =
    vapply(
      correlation_data,
      function(variable) {
        
        sum(
          is.na(
            variable
          )
        )
      },
      numeric(1)
    ),
  
  stringsAsFactors = FALSE
)

correlation_data_availability$Missing_Percentage <-
  round(
    (
      correlation_data_availability$Missing_N /
        nrow(
          correlation_data
        )
    ) * 100,
    2
  )

row.names(
  correlation_data_availability
) <- NULL

correlation_data_availability


# ============================================================
# 7. Calculate Spearman correlation matrix
# Spearman rank correlation evaluates monotonic relationships
# and is less sensitive than Pearson correlation to skewed
# distributions and extreme observations.
#
# Pairwise complete observations are used so that each
# correlation can use all available observations for that
# variable pair if missing values occur in future datasets.
# ============================================================

correlation_matrix <- cor(
  correlation_data,
  method = "spearman",
  use = "pairwise.complete.obs"
)

correlation_matrix


# ============================================================
# 8. Create display version of correlation matrix
# Preserve the full-precision matrix internally and round only
# the presentation version.
# ============================================================

correlation_matrix_display <- round(
  correlation_matrix,
  3
)

correlation_matrix_display


# ============================================================
# 9. Define all unique variable pairs
# Generate every unique pair of continuous baseline variables.
# ============================================================

correlation_pairs <- combn(
  correlation_variables,
  2,
  simplify = FALSE
)

length(
  correlation_pairs
)


# ============================================================
# 10. Calculate pairwise Spearman statistics
# Estimate Spearman's rho and raw exploratory p-values for each
# unique pair of continuous baseline variables.
#
# H0:
# There is no monotonic association between the two variables.
#
# H1:
# A monotonic association exists between the two variables.
#
# The p-values are retained as exploratory information.
# Correlation testing is not used as the primary inferential
# evidence of the project.
# ============================================================

correlation_results_raw <- do.call(
  rbind,
  lapply(
    correlation_pairs,
    function(pair) {
      
      complete_cases <- complete.cases(
        heart_failure[
          ,
          pair,
          drop = FALSE
        ]
      )
      
      variable_1 <- heart_failure[
        complete_cases,
        pair[1]
      ]
      
      variable_2 <- heart_failure[
        complete_cases,
        pair[2]
      ]
      
      test <- cor.test(
        variable_1,
        variable_2,
        method = "spearman",
        exact = FALSE
      )
      
      data.frame(
        
        Variable_1 =
          pair[1],
        
        Variable_2 =
          pair[2],
        
        Complete_Pairs_N =
          length(
            variable_1
          ),
        
        Spearman_Rho =
          unname(
            test$estimate
          ),
        
        Absolute_Correlation =
          abs(
            unname(
              test$estimate
            )
          ),
        
        P_Value =
          test$p.value,
        
        stringsAsFactors = FALSE
      )
    }
  )
)

row.names(
  correlation_results_raw
) <- NULL

correlation_results_raw


# ============================================================
# 11. Add descriptive correlation direction
# Describe only the mathematical direction of the correlation.
#
# This does not imply causality.
# ============================================================

correlation_results_raw$Direction <- ifelse(
  correlation_results_raw$Spearman_Rho > 0,
  "Positive",
  ifelse(
    correlation_results_raw$Spearman_Rho < 0,
    "Negative",
    "None"
  )
)


# ============================================================
# 12. Add descriptive correlation magnitude
# Provide broad descriptive categories based on the absolute
# correlation coefficient.
#
# These categories are used only as communication aids.
# They are not universal clinical thresholds and do not imply
# practical or medical importance.
# ============================================================

correlation_results_raw$Magnitude <- cut(
  correlation_results_raw$Absolute_Correlation,
  breaks = c(
    -Inf,
    0.10,
    0.30,
    0.50,
    0.70,
    Inf
  ),
  labels = c(
    "Very weak",
    "Weak",
    "Moderate",
    "Strong",
    "Very strong"
  ),
  right = FALSE
)


# ============================================================
# 13. Create display version of pairwise results
# Raw statistical values remain unchanged in
# correlation_results_raw.
#
# Rounding is applied only for presentation.
# ============================================================

correlation_results <- correlation_results_raw

correlation_results$Spearman_Rho <- round(
  correlation_results$Spearman_Rho,
  3
)

correlation_results$Absolute_Correlation <- round(
  correlation_results$Absolute_Correlation,
  3
)

correlation_results$P_Value <- format.pval(
  correlation_results$P_Value,
  digits = 4,
  eps = 0.0001
)

correlation_results


# ============================================================
# 14. Rank correlations by absolute strength
# Rank variable pairs using the UNROUNDED absolute Spearman
# coefficient.
#
# This avoids changing the ranking because of presentation
# rounding.
#
# The ranking describes statistical correlation magnitude only.
# It is not a ranking of clinical importance.
# ============================================================

correlation_results_ranked <-
  correlation_results_raw[
    order(
      -correlation_results_raw$
        Absolute_Correlation
    ),
    ,
    drop = FALSE
  ]

row.names(
  correlation_results_ranked
) <- NULL

correlation_results_ranked


# ============================================================
# 15. Create display version of ranked correlations
# ============================================================

correlation_results_ranked_display <-
  correlation_results_ranked

correlation_results_ranked_display$
  Spearman_Rho <- round(
    correlation_results_ranked_display$
      Spearman_Rho,
    3
  )

correlation_results_ranked_display$
  Absolute_Correlation <- round(
    correlation_results_ranked_display$
      Absolute_Correlation,
    3
  )

correlation_results_ranked_display$
  P_Value <- format.pval(
    correlation_results_ranked_display$
      P_Value,
    digits = 4,
    eps = 0.0001
  )

correlation_results_ranked_display


# ============================================================
# 16. Identify strongest observed correlation
# Retain the strongest observed pairwise correlation by
# absolute Spearman coefficient.
#
# This is a descriptive result only.
# ============================================================

strongest_correlation <- correlation_results_ranked[
  1,
  ,
  drop = FALSE
]

strongest_correlation_display <-
  correlation_results_ranked_display[
    1,
    ,
    drop = FALSE
  ]

strongest_correlation_display


# ============================================================
# 17. Prepare correlation matrix for visualization
# Convert the full-precision correlation matrix into long format
# for visualization with ggplot2.
# ============================================================

correlation_long <- as.data.frame(
  as.table(
    correlation_matrix
  )
)

names(
  correlation_long
) <- c(
  "Variable_1",
  "Variable_2",
  "Correlation"
)

correlation_long$Variable_1 <- factor(
  correlation_long$Variable_1,
  levels = correlation_variables
)

correlation_long$Variable_2 <- factor(
  correlation_long$Variable_2,
  levels = correlation_variables
)


# ============================================================
# 18. Visualize correlation matrix
# Display the direction and magnitude of pairwise Spearman
# correlations between continuous baseline characteristics.
# ============================================================

correlation_matrix_plot <- ggplot(
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
    title = "Spearman Correlation Matrix",
    subtitle = "Continuous baseline patient characteristics",
    x = NULL,
    y = NULL,
    fill = "Spearman\nrho"
  ) +
  theme_minimal() +
  theme(
    axis.text.x = element_text(
      angle = 45,
      hjust = 1
    )
  )

correlation_matrix_plot


# ============================================================
# 19. Visualize ejection fraction and serum creatinine
# Use a scatterplot with a LOESS smoother to inspect the form of
# the relationship visually without imposing a linear trend.
# ============================================================

ejection_fraction_creatinine_plot <- ggplot(
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
    subtitle = "Exploratory visualization",
    x = "Ejection Fraction (%)",
    y = "Serum Creatinine (mg/dL)"
  ) +
  theme_minimal()

ejection_fraction_creatinine_plot


# ============================================================
# 20. Visualize age and ejection fraction
# ============================================================

age_ejection_fraction_plot <- ggplot(
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
    subtitle = "Exploratory visualization",
    x = "Age",
    y = "Ejection Fraction (%)"
  ) +
  theme_minimal()

age_ejection_fraction_plot


# ============================================================
# 21. Visualize serum creatinine and serum sodium
# ============================================================

creatinine_sodium_plot <- ggplot(
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
    subtitle = "Exploratory visualization",
    x = "Serum Creatinine (mg/dL)",
    y = "Serum Sodium (mEq/L)"
  ) +
  theme_minimal()

creatinine_sodium_plot


# ============================================================
# 22. Create complete correlation analysis object
# Consolidate the numerical results and visualization objects so
# they can be reused by later project stages.
# ============================================================

correlation_analysis <- list(
  
  Variables =
    correlation_variables,
  
  Data_Availability =
    correlation_data_availability,
  
  Correlation_Matrix_Raw =
    correlation_matrix,
  
  Correlation_Matrix_Display =
    correlation_matrix_display,
  
  Pairwise_Results_Raw =
    correlation_results_raw,
  
  Pairwise_Results_Display =
    correlation_results,
  
  Ranked_Results_Raw =
    correlation_results_ranked,
  
  Ranked_Results_Display =
    correlation_results_ranked_display,
  
  Strongest_Correlation_Raw =
    strongest_correlation,
  
  Strongest_Correlation_Display =
    strongest_correlation_display,
  
  Correlation_Matrix_Plot =
    correlation_matrix_plot,
  
  Ejection_Fraction_Creatinine_Plot =
    ejection_fraction_creatinine_plot,
  
  Age_Ejection_Fraction_Plot =
    age_ejection_fraction_plot,
  
  Creatinine_Sodium_Plot =
    creatinine_sodium_plot
)


# ============================================================
# 23. Display final correlation overview
# ============================================================

cat(
  "\n",
  "============================================================\n",
  "CORRELATION ANALYSIS\n",
  "============================================================\n",
  sep = ""
)


cat(
  "\nCONTINUOUS BASELINE VARIABLES\n"
)

print(
  correlation_variables
)


cat(
  "\nDATA AVAILABILITY\n"
)

print(
  correlation_data_availability
)


cat(
  "\nSPEARMAN CORRELATION MATRIX\n"
)

print(
  correlation_matrix_display
)


cat(
  "\nPAIRWISE SPEARMAN CORRELATIONS\n"
)

print(
  correlation_results
)


cat(
  "\nCORRELATIONS RANKED BY ABSOLUTE MAGNITUDE\n"
)

print(
  correlation_results_ranked_display
)


cat(
  "\nSTRONGEST OBSERVED CORRELATION\n"
)

print(
  strongest_correlation_display
)


# ============================================================
# 24. Final interpretation note
# Explicitly define the role of the correlation analysis within
# the broader project.
# ============================================================

cat(
  "\nIMPORTANT INTERPRETATION NOTE\n",
  
  "Spearman correlation describes the direction and strength ",
  "of monotonic relationships between continuous baseline ",
  "patient characteristics.\n",
  
  "Correlation does not establish causality, clinical ",
  "importance, or independent association with mortality.\n",
  
  "Pairwise correlation p-values are retained as exploratory ",
  "information and are not used as the primary inferential ",
  "evidence of this project.\n",
  
  "No binary significant/non-significant classification is ",
  "assigned to the correlation results because the correlation ",
  "analysis is primarily descriptive and exploratory.\n",
  
  "The primary mortality-related inferential evidence is ",
  "evaluated separately through hypothesis testing and ",
  "regression analysis.\n",
  
  "Absolute correlation magnitude is used only to describe and ",
  "order statistical relationships. It must not be interpreted ",
  "as a ranking of clinical importance.\n",
  
  "Follow-up duration is excluded because it represents the ",
  "observation process rather than baseline patient ",
  "information.\n",
  
  sep = ""
)


# ============================================================
# 25. Return complete correlation analysis object
# ============================================================

correlation_analysis



