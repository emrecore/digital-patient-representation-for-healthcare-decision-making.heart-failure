# ============================================================
# Project: Representation Sensitivity Analysis 
#          in Heart Failure with R
# File: 07_correlation_analysis.R
# Purpose: Explore monotonic relationships between continuous
#          baseline patient characteristics.
# ============================================================


# ============================================================
# 1. Confirm required objects
# ============================================================

required_objects <- c(
  "heart_failure",
  "baseline_numerical_variables"
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
# 2. Load visualization package
# ============================================================

library(ggplot2)


# ============================================================
# 3. Create baseline correlation dataset
# Follow-up time is excluded because it represents observation
# duration rather than baseline patient information.
# ============================================================

correlation_data <- heart_failure[
  baseline_numerical_variables
]


# ============================================================
# 4. Calculate Spearman correlation matrix
# ============================================================

correlation_matrix <- cor(
  correlation_data,
  method = "spearman",
  use = "pairwise.complete.obs"
)

correlation_matrix_display <- round(
  correlation_matrix,
  3
)


# ============================================================
# 5. Calculate pairwise Spearman correlations
# p-values are retained as exploratory information only.
# ============================================================

correlation_pairs <- combn(
  baseline_numerical_variables,
  2,
  simplify = FALSE
)

correlation_results <- do.call(
  rbind,
  lapply(
    correlation_pairs,
    function(pair) {
      
      complete <- complete.cases(
        heart_failure[
          ,
          pair,
          drop = FALSE
        ]
      )
      
      x <- heart_failure[
        complete,
        pair[1]
      ]
      
      y <- heart_failure[
        complete,
        pair[2]
      ]
      
      test <- cor.test(
        x,
        y,
        method = "spearman",
        exact = FALSE
      )
      
      data.frame(
        Variable_1 = pair[1],
        Variable_2 = pair[2],
        Complete_Pairs_N = length(x),
        Spearman_Rho = unname(
          test$estimate
        ),
        Absolute_Correlation = abs(
          unname(test$estimate)
        ),
        P_Value = test$p.value,
        stringsAsFactors = FALSE
      )
    }
  )
)

row.names(correlation_results) <- NULL


# ============================================================
# 6. Rank correlations by absolute magnitude
# Ranking is based on unrounded coefficients.
#
# This ranks statistical correlation strength only and does not
# represent clinical importance.
# ============================================================

correlation_results_ranked <- correlation_results[
  order(
    -correlation_results$Absolute_Correlation
  ),
  ,
  drop = FALSE
]

row.names(
  correlation_results_ranked
) <- NULL


# ============================================================
# 7. Create presentation versions
# Raw values remain unchanged for later analytical use.
# ============================================================

correlation_results_display <- correlation_results

correlation_results_display$Spearman_Rho <- round(
  correlation_results$Spearman_Rho,
  3
)

correlation_results_display$Absolute_Correlation <- round(
  correlation_results$Absolute_Correlation,
  3
)

correlation_results_display$P_Value <- format.pval(
  correlation_results$P_Value,
  digits = 4,
  eps = 0.0001
)


correlation_results_ranked_display <-
  correlation_results_display[
    match(
      paste(
        correlation_results_ranked$Variable_1,
        correlation_results_ranked$Variable_2
      ),
      paste(
        correlation_results$Variable_1,
        correlation_results$Variable_2
      )
    ),
    ,
    drop = FALSE
  ]

row.names(
  correlation_results_ranked_display
) <- NULL


# ============================================================
# 8. Prepare correlation matrix visualization
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
  "Spearman_Rho"
)


correlation_matrix_plot <- ggplot(
  correlation_long,
  aes(
    x = Variable_1,
    y = Variable_2,
    fill = Spearman_Rho
  )
) +
  geom_tile() +
  geom_text(
    aes(
      label = round(
        Spearman_Rho,
        2
      )
    )
  ) +
  labs(
    title = "Spearman Correlation Matrix",
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


# ============================================================
# 9. Visualize strongest observed relationships
# The three strongest correlations are selected automatically
# from the unrounded ranking.
# ============================================================

top_relationships <- head(
  correlation_results_ranked,
  3
)

make_relationship_plot <- function(
    variable_1,
    variable_2
) {
  
  label_1 <- gsub(
    "_",
    " ",
    variable_1
  )
  
  label_2 <- gsub(
    "_",
    " ",
    variable_2
  )
  
  ggplot(
    heart_failure,
    aes(
      x = .data[[variable_1]],
      y = .data[[variable_2]]
    )
  ) +
    geom_point() +
    geom_smooth(
      method = "loess",
      se = FALSE
    ) +
    labs(
      title = paste(
        tools::toTitleCase(label_1),
        "vs",
        tools::toTitleCase(label_2)
      ),
      subtitle = "Exploratory relationship visualization",
      x = tools::toTitleCase(label_1),
      y = tools::toTitleCase(label_2)
    ) +
    theme_minimal()
}


relationship_plots <- lapply(
  seq_len(
    nrow(top_relationships)
  ),
  function(i) {
    
    make_relationship_plot(
      top_relationships$Variable_1[i],
      top_relationships$Variable_2[i]
    )
  }
)

names(
  relationship_plots
) <- paste(
  top_relationships$Variable_1,
  top_relationships$Variable_2,
  sep = "_vs_"
)


# ============================================================
# 10. Consolidate correlation results
# ============================================================

correlation_analysis <- list(
  
  Correlation_Matrix =
    correlation_matrix,
  
  Pairwise_Results =
    correlation_results,
  
  Ranked_Results =
    correlation_results_ranked,
  
  Correlation_Matrix_Plot =
    correlation_matrix_plot,
  
  Strongest_Relationship_Plots =
    relationship_plots
)


# ============================================================
# 11. Display exploratory results
# ============================================================

cat(
  "\n",
  "============================================================\n",
  "CORRELATION ANALYSIS\n",
  "============================================================\n",
  sep = ""
)

cat(
  "\nSPEARMAN CORRELATION MATRIX\n"
)

print(
  correlation_matrix_display
)

cat(
  "\nPAIRWISE CORRELATIONS RANKED BY ABSOLUTE MAGNITUDE\n"
)

print(
  correlation_results_ranked_display
)

print(
  correlation_matrix_plot
)

invisible(
  lapply(
    relationship_plots,
    print
  )
)


# ============================================================
# 12. Final interpretation note
# ============================================================

cat(
  "\nINTERPRETATION NOTE\n",
  "The correlation analysis is exploratory.\n",
  "Pairwise p-values are retained for context but are not used ",
  "as the primary inferential evidence of the project.\n",
  "Correlation strength does not establish causality or ",
  "clinical importance.\n",
  "Mortality associations are modeled separately in ",
  "08_regression_analysis.R.\n",
  sep = ""
)


# ============================================================
# 13. Return complete correlation analysis object
# ============================================================

correlation_analysis

