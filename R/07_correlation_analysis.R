# ============================================================
# Project: Representation Sensitivity Analysis
#          in Heart Failure with R
# File: 07_correlation_analysis.R
# Purpose: Explore monotonic relationships among continuous
#          baseline patient characteristics using Spearman
#          rank correlation.
# ============================================================


# ============================================================
# 1. Confirm required setup objects from script 01
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
    paste0(
      "Run 01_data_import_and_setup.R first. Missing object(s): ",
      paste(missing_objects, collapse = ", ")
    )
  )
}


# ============================================================
# 2. Confirm visualization package
# ============================================================

if (!requireNamespace("ggplot2", quietly = TRUE)) {
  stop(
    paste0(
      "Package 'ggplot2' is required for script 07. ",
      "Install it before running this script."
    )
  )
}


# ============================================================
# 3. Verify correlation variables
# ============================================================

if (length(baseline_numerical_variables) < 2) {
  stop(
    paste0(
      "Correlation analysis requires at least two ",
      "continuous baseline variables."
    )
  )
}


missing_correlation_variables <- setdiff(
  baseline_numerical_variables,
  names(heart_failure)
)

if (length(missing_correlation_variables) > 0) {
  stop(
    paste0(
      "Correlation analysis failed. Missing variable(s): ",
      paste(
        missing_correlation_variables,
        collapse = ", "
      )
    )
  )
}


numerical_class_check <- vapply(
  heart_failure[
    baseline_numerical_variables
  ],
  is.numeric,
  logical(1)
)

if (!all(numerical_class_check)) {
  stop(
    paste0(
      "Correlation analysis failed. Non-numeric baseline ",
      "variable(s) detected: ",
      paste(
        names(numerical_class_check)[
          !numerical_class_check
        ],
        collapse = ", "
      )
    )
  )
}


unique_value_check <- vapply(
  heart_failure[
    baseline_numerical_variables
  ],
  function(x) {
    length(
      unique(
        x[
          !is.na(x) &
            is.finite(x)
        ]
      )
    )
  },
  numeric(1)
)

if (any(unique_value_check <= 1)) {
  stop(
    paste0(
      "Correlation analysis failed. Constant or ",
      "non-informative baseline numerical variable(s): ",
      paste(
        names(unique_value_check)[
          unique_value_check <= 1
        ],
        collapse = ", "
      )
    )
  )
}


# ============================================================
# 4. Create baseline correlation dataset
# ============================================================
#
# Only continuous baseline patient characteristics are
# included.
#
# Follow-up duration is excluded because it represents
# observation information rather than baseline patient
# information.
#
# The recorded death-event outcome is also excluded because
# this stage evaluates relationships among baseline numerical
# characteristics only.
# ============================================================

correlation_data <- heart_failure[
  baseline_numerical_variables
]


# ============================================================
# 5. Calculate Spearman correlation matrix
# ============================================================
#
# Pairwise complete observations are used so that each
# coefficient is based on all observations available for the
# corresponding variable pair.
#
# The current dataset has no documented missing values, but
# this specification makes the analytical rule explicit and
# robust to future reuse.
# ============================================================

correlation_matrix <- cor(
  correlation_data,
  method = "spearman",
  use = "pairwise.complete.obs"
)


correlation_matrix_display <- round(
  correlation_matrix,
  digits = 3
)


# ============================================================
# 6. Define all unique variable pairs
# ============================================================

correlation_pairs <- combn(
  baseline_numerical_variables,
  2,
  simplify = FALSE
)


# ============================================================
# 7. Calculate pairwise Spearman correlations
# ============================================================
#
# Pairwise p-values are retained for exploratory context only.
#
# They are not treated as the primary inferential evidence of
# the project and are not used to select variables for later
# regression models.
# ============================================================

correlation_results <- do.call(
  rbind,
  lapply(
    correlation_pairs,
    function(pair) {
      
      pair_data <- heart_failure[
        ,
        pair,
        drop = FALSE
      ]
      
      complete_finite <- (
        complete.cases(pair_data) &
          is.finite(pair_data[[pair[1]]]) &
          is.finite(pair_data[[pair[2]]])
      )
      
      x <- pair_data[
        complete_finite,
        pair[1]
      ]
      
      y <- pair_data[
        complete_finite,
        pair[2]
      ]
      
      if (length(x) < 3) {
        stop(
          paste0(
            "Correlation analysis failed for '",
            pair[1],
            "' and '",
            pair[2],
            "'. At least three complete finite pairs ",
            "are required."
          )
        )
      }
      
      if (
        length(unique(x)) <= 1 ||
        length(unique(y)) <= 1
      ) {
        stop(
          paste0(
            "Correlation analysis failed for '",
            pair[1],
            "' and '",
            pair[2],
            "'. Both variables require more than one ",
            "observed value."
          )
        )
      }
      
      test <- suppressWarnings(
        cor.test(
          x = x,
          y = y,
          method = "spearman",
          exact = FALSE
        )
      )
      
      rho <- unname(
        test$estimate
      )
      
      data.frame(
        
        Variable_1 =
          pair[1],
        
        Variable_2 =
          pair[2],
        
        Complete_Pairs_N =
          length(x),
        
        Spearman_Rho =
          rho,
        
        Absolute_Correlation =
          abs(rho),
        
        P_Value =
          test$p.value,
        
        stringsAsFactors = FALSE
      )
    }
  )
)

row.names(
  correlation_results
) <- NULL


# ============================================================
# 8. Verify pairwise-analysis completeness
# ============================================================

expected_pair_count <- choose(
  length(baseline_numerical_variables),
  2
)

if (
  nrow(correlation_results) !=
  expected_pair_count
) {
  stop(
    paste0(
      "Correlation-analysis audit failed. Expected ",
      expected_pair_count,
      " unique variable pairs but obtained ",
      nrow(correlation_results),
      "."
    )
  )
}


pair_keys <- paste(
  correlation_results$Variable_1,
  correlation_results$Variable_2,
  sep = "::"
)

if (anyDuplicated(pair_keys) > 0) {
  stop(
    paste0(
      "Correlation-analysis audit failed. ",
      "Duplicate variable pair detected."
    )
  )
}


# ============================================================
# 9. Create pairwise sample-size matrix
# ============================================================
#
# This documents the number of complete finite observations
# contributing to each pairwise coefficient.
# ============================================================

pairwise_n_matrix <- matrix(
  NA_integer_,
  nrow = length(
    baseline_numerical_variables
  ),
  ncol = length(
    baseline_numerical_variables
  ),
  dimnames = list(
    baseline_numerical_variables,
    baseline_numerical_variables
  )
)


for (variable in baseline_numerical_variables) {
  
  pairwise_n_matrix[
    variable,
    variable
  ] <- sum(
    !is.na(
      heart_failure[[variable]]
    ) &
      is.finite(
        heart_failure[[variable]]
      )
  )
}


for (
  i in seq_len(
    nrow(correlation_results)
  )
) {
  
  variable_1 <-
    correlation_results$Variable_1[i]
  
  variable_2 <-
    correlation_results$Variable_2[i]
  
  pair_n <-
    correlation_results$Complete_Pairs_N[i]
  
  pairwise_n_matrix[
    variable_1,
    variable_2
  ] <- pair_n
  
  pairwise_n_matrix[
    variable_2,
    variable_1
  ] <- pair_n
}


# ============================================================
# 10. Rank correlations by absolute magnitude
# ============================================================
#
# Ranking uses the unrounded Spearman coefficients.
#
# It ranks observed statistical correlation magnitude only.
# It does not represent:
#
# - clinical importance
# - prognostic importance
# - causal importance
# - variable-selection priority
# ============================================================

correlation_results_ranked <-
  correlation_results[
    order(
      -correlation_results$
        Absolute_Correlation,
      correlation_results$Variable_1,
      correlation_results$Variable_2
    ),
    ,
    drop = FALSE
  ]

row.names(
  correlation_results_ranked
) <- NULL


# ============================================================
# 11. Create presentation versions
# ============================================================
#
# Raw values remain unchanged for later analytical use.
# ============================================================

correlation_results_display <-
  correlation_results

correlation_results_display$Spearman_Rho <-
  round(
    correlation_results$Spearman_Rho,
    digits = 3
  )

correlation_results_display$Absolute_Correlation <-
  round(
    correlation_results$
      Absolute_Correlation,
    digits = 3
  )

correlation_results_display$P_Value <-
  format.pval(
    correlation_results$P_Value,
    digits = 4,
    eps = 0.0001
  )


ranked_match_index <- match(
  paste(
    correlation_results_ranked$Variable_1,
    correlation_results_ranked$Variable_2,
    sep = "::"
  ),
  paste(
    correlation_results$Variable_1,
    correlation_results$Variable_2,
    sep = "::"
  )
)


if (any(is.na(ranked_match_index))) {
  stop(
    paste0(
      "Correlation-analysis audit failed. ",
      "Unable to construct ranked display table."
    )
  )
}


correlation_results_ranked_display <-
  correlation_results_display[
    ranked_match_index,
    ,
    drop = FALSE
  ]

row.names(
  correlation_results_ranked_display
) <- NULL


# ============================================================
# 12. Prepare correlation-matrix visualization
# ============================================================

correlation_long <- as.data.frame(
  as.table(
    correlation_matrix
  ),
  stringsAsFactors = FALSE
)

names(
  correlation_long
) <- c(
  "Variable_1",
  "Variable_2",
  "Spearman_Rho"
)


correlation_matrix_plot <- ggplot2::ggplot(
  correlation_long,
  ggplot2::aes(
    x = Variable_1,
    y = Variable_2,
    fill = Spearman_Rho
  )
) +
  ggplot2::geom_tile() +
  ggplot2::geom_text(
    ggplot2::aes(
      label = round(
        Spearman_Rho,
        digits = 2
      )
    )
  ) +
  ggplot2::labs(
    title =
      "Spearman Correlations Among Baseline Numerical Characteristics",
    x = NULL,
    y = NULL,
    fill = "Spearman\nrho"
  ) +
  ggplot2::theme_minimal() +
  ggplot2::theme(
    axis.text.x = ggplot2::element_text(
      angle = 45,
      hjust = 1
    )
  )


# ============================================================
# 13. Identify strongest observed relationships
# ============================================================
#
# The three largest absolute correlations are selected for
# descriptive visualization only.
#
# Selection is based on unrounded coefficients.
#
# These plots are not confirmatory analyses.
# ============================================================

top_relationships <- head(
  correlation_results_ranked,
  n = min(
    3,
    nrow(correlation_results_ranked)
  )
)


# ============================================================
# 14. Define relationship-plot helper
# ============================================================

format_variable_label <- function(
    variable
) {
  
  tools::toTitleCase(
    gsub(
      "_",
      " ",
      variable
    )
  )
}


make_relationship_plot <- function(
    data,
    variable_1,
    variable_2
) {
  
  ggplot2::ggplot(
    data = data,
    ggplot2::aes(
      x = .data[[variable_1]],
      y = .data[[variable_2]]
    )
  ) +
    ggplot2::geom_point(
      na.rm = TRUE
    ) +
    ggplot2::geom_smooth(
      method = "loess",
      se = FALSE,
      na.rm = TRUE
    ) +
    ggplot2::labs(
      title = paste(
        format_variable_label(
          variable_1
        ),
        "and",
        format_variable_label(
          variable_2
        )
      ),
      subtitle =
        "Exploratory visualization of an observed baseline relationship",
      x = format_variable_label(
        variable_1
      ),
      y = format_variable_label(
        variable_2
      )
    ) +
    ggplot2::theme_minimal()
}


# ============================================================
# 15. Create strongest-relationship plots
# ============================================================

relationship_plots <- lapply(
  seq_len(
    nrow(top_relationships)
  ),
  function(i) {
    
    make_relationship_plot(
      data = heart_failure,
      variable_1 =
        top_relationships$Variable_1[i],
      variable_2 =
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
# 16. Consolidate correlation results
# ============================================================

correlation_analysis <- list(
  
  Correlation_Matrix =
    correlation_matrix,
  
  Pairwise_Sample_Size_Matrix =
    pairwise_n_matrix,
  
  Pairwise_Results =
    correlation_results,
  
  Ranked_Results =
    correlation_results_ranked,
  
  Strongest_Observed_Relationships =
    top_relationships,
  
  Correlation_Matrix_Plot =
    correlation_matrix_plot,
  
  Strongest_Relationship_Plots =
    relationship_plots
)


# ============================================================
# 17. Display exploratory results
# ============================================================

cat(
  "\n",
  "============================================================\n",
  "EXPLORATORY BASELINE CORRELATION ANALYSIS\n",
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
  "\nPAIRWISE COMPLETE-OBSERVATION COUNTS\n"
)

print(
  pairwise_n_matrix
)


cat(
  "\nPAIRWISE CORRELATIONS RANKED BY ABSOLUTE MAGNITUDE\n"
)

print(
  correlation_results_ranked_display,
  row.names = FALSE
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
# 18. Interpretation note
# ============================================================

cat(
  "\nINTERPRETATION NOTE\n",
  "\n",
  "This correlation analysis is exploratory and is restricted ",
  "to continuous baseline patient characteristics.\n",
  "\n",
  "Follow-up duration is excluded because it represents ",
  "observation information rather than baseline patient ",
  "information. The recorded death-event outcome is also ",
  "excluded from this correlation stage.\n",
  "\n",
  "Spearman correlation measures the strength and direction ",
  "of monotonic association between two variables. It does ",
  "not establish causality.\n",
  "\n",
  "Pairwise p-values are retained for exploratory context ",
  "only. They are not used as the project's primary ",
  "inferential evidence and are not used to select variables ",
  "for the regression models.\n",
  "\n",
  "Ranking by absolute correlation magnitude describes the ",
  "observed statistical relationships in this sample only. ",
  "It does not rank clinical importance, prognostic value, ",
  "causal relevance, or representation importance.\n",
  "\n",
  "The three strongest observed relationships are visualized ",
  "descriptively after inspection of the full correlation ",
  "matrix and should not be interpreted as independently ",
  "pre-specified confirmatory findings.\n",
  "\n",
  "Associations between baseline patient characteristics and ",
  "the recorded binary death-event outcome are modeled ",
  "separately in 08_regression_analysis.R.\n",
  sep = ""
)


# ============================================================
# 19. Return complete correlation-analysis object
# ============================================================

correlation_analysis

