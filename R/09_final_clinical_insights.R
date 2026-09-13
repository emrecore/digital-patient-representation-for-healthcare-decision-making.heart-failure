# ============================================================
# Project: Heart Failure Clinical Statistical Analysis with R
# File: 09_final_clinical_insights.R
# Purpose: Consolidate the main descriptive, inferential,
# correlation, and regression findings into a structured
# final analytical summary.
# Language: R
# ============================================================


# ============================================================
# 1. Define significance level
# Use the same significance threshold applied throughout
# the statistical analysis.
# ============================================================

alpha <- 0.05


# ============================================================
# 2. Define helper for p-value formatting
# Raw p-values remain unchanged internally.
# Formatting is applied only when results are displayed.
# ============================================================

format_p_value <- function(p) {
  
  format.pval(
    p,
    digits = 4,
    eps = 0.0001
  )
}


# ============================================================
# 3. Summarize mortality outcome
# Retain the overall mortality distribution as the primary
# outcome overview.
# ============================================================

final_mortality_summary <- mortality_summary

row.names(
  final_mortality_summary
) <- NULL


# ============================================================
# 4. Identify significant group-level findings
# Use Benjamini-Hochberg-adjusted results from the hypothesis
# testing stage to identify variables associated with
# mortality after correction for multiple testing.
# ============================================================

significant_group_results <-
  hypothesis_test_summary[
    hypothesis_test_summary$Significant_BH == "Yes",
    ,
    drop = FALSE
  ]

if (nrow(significant_group_results) > 0) {
  
  significant_group_results <-
    significant_group_results[
      order(
        significant_group_results$P_Adjusted_BH
      ),
      ,
      drop = FALSE
    ]
}

row.names(
  significant_group_results
) <- NULL


# ============================================================
# 5. Rank strongest continuous-variable correlations
# Correlations are ranked by absolute Spearman correlation
# magnitude.
#
# These results describe relationships between clinical
# variables and are not interpreted as causal effects.
# ============================================================

strongest_correlations <-
  correlation_results_ranked[
    order(
      -correlation_results_ranked$Absolute_Correlation
    ),
    ,
    drop = FALSE
  ]

strongest_correlations <- head(
  strongest_correlations,
  5
)

row.names(
  strongest_correlations
) <- NULL


# ============================================================
# 6. Re-extract multivariable regression estimates
# Extract coefficients directly from the fitted model to
# preserve full numerical precision.
#
# This avoids relying on any previously rounded presentation
# tables.
# ============================================================

final_regression_coefficients <- summary(
  mortality_model
)$coefficients

final_regression_coefficients <-
  final_regression_coefficients[
    rownames(final_regression_coefficients) != "(Intercept)",
    ,
    drop = FALSE
  ]


final_regression_results <- data.frame(
  
  Term = rownames(
    final_regression_coefficients
  ),
  
  Coefficient =
    final_regression_coefficients[
      ,
      "Estimate"
    ],
  
  Standard_Error =
    final_regression_coefficients[
      ,
      "Std. Error"
    ],
  
  Adjusted_Odds_Ratio = exp(
    final_regression_coefficients[
      ,
      "Estimate"
    ]
  ),
  
  CI_Lower = exp(
    final_regression_coefficients[
      ,
      "Estimate"
    ] -
      1.96 *
      final_regression_coefficients[
        ,
        "Std. Error"
      ]
  ),
  
  CI_Upper = exp(
    final_regression_coefficients[
      ,
      "Estimate"
    ] +
      1.96 *
      final_regression_coefficients[
        ,
        "Std. Error"
      ]
  ),
  
  P_Value =
    final_regression_coefficients[
      ,
      "Pr(>|z|)"
    ]
)

row.names(
  final_regression_results
) <- NULL


# ============================================================
# 7. Add readable regression labels
# Convert model terms into clearer clinical descriptions for
# final reporting.
# ============================================================

term_labels <- c(
  
  age =
    "Age",
  
  anaemiaYes =
    "Anaemia: Yes vs No",
  
  creatinine_phosphokinase =
    "Creatinine phosphokinase",
  
  diabetesYes =
    "Diabetes: Yes vs No",
  
  ejection_fraction =
    "Ejection fraction",
  
  high_blood_pressureYes =
    "High blood pressure: Yes vs No",
  
  platelets =
    "Platelet count",
  
  serum_creatinine =
    "Serum creatinine",
  
  serum_sodium =
    "Serum sodium",
  
  sexMale =
    "Sex: Male vs Female",
  
  smokingYes =
    "Smoking: Yes vs No"
)


final_regression_results$Clinical_Label <-
  ifelse(
    final_regression_results$Term %in%
      names(term_labels),
    
    term_labels[
      final_regression_results$Term
    ],
    
    final_regression_results$Term
  )


# ============================================================
# 8. Identify significant adjusted mortality associations
# Statistical significance is evaluated using the original,
# unrounded regression p-values.
#
# These results represent adjusted associations rather than
# causal effects.
# ============================================================

final_regression_results$Significant <- ifelse(
  final_regression_results$P_Value < alpha,
  "Yes",
  "No"
)


significant_regression_results <-
  final_regression_results[
    final_regression_results$Significant == "Yes",
    ,
    drop = FALSE
  ]


if (nrow(significant_regression_results) > 0) {
  
  significant_regression_results <-
    significant_regression_results[
      order(
        significant_regression_results$P_Value
      ),
      ,
      drop = FALSE
    ]
}

row.names(
  significant_regression_results
) <- NULL


# ============================================================
# 9. Create regression interpretation statements
# Translate statistically significant adjusted associations
# into concise and cautious analytical statements.
#
# Odds ratios above 1 indicate higher odds of a recorded
# death event, whereas values below 1 indicate lower odds.
# ============================================================

if (nrow(significant_regression_results) > 0) {
  
  regression_interpretations <- sapply(
    seq_len(
      nrow(significant_regression_results)
    ),
    function(i) {
      
      result <-
        significant_regression_results[i, ]
      
      direction <- ifelse(
        result$Adjusted_Odds_Ratio > 1,
        "higher",
        "lower"
      )
      
      paste0(
        result$Clinical_Label,
        " was associated with ",
        direction,
        " adjusted odds of a recorded death event ",
        "(OR = ",
        round(
          result$Adjusted_Odds_Ratio,
          2
        ),
        ", 95% CI ",
        round(
          result$CI_Lower,
          2
        ),
        "-",
        round(
          result$CI_Upper,
          2
        ),
        ", p ",
        ifelse(
          result$P_Value < 0.0001,
          "< 0.0001",
          paste0(
            "= ",
            format_p_value(
              result$P_Value
            )
          )
        ),
        ")."
      )
    }
  )
  
} else {
  
  regression_interpretations <-
    "No variables remained statistically significant in the adjusted logistic regression model."
}


# ============================================================
# 10. Summarize regression model fit
# Retain the original model-fit statistics and create a
# separate rounded version for presentation.
# ============================================================

final_model_fit <- model_fit

final_model_fit_display <- round(
  final_model_fit,
  2
)


# ============================================================
# 11. Create presentation version of group findings
# Numerical precision is retained in the analytical object.
# Formatting is applied only to the display copy.
# ============================================================

significant_group_results_display <-
  significant_group_results


if (nrow(significant_group_results_display) > 0) {
  
  significant_group_results_display$P_Value <-
    format_p_value(
      significant_group_results$P_Value
    )
  
  significant_group_results_display$P_Adjusted_BH <-
    format_p_value(
      significant_group_results$P_Adjusted_BH
    )
}


# ============================================================
# 12. Create presentation version of regression findings
# Keep full-precision model results unchanged and round only
# the final display table.
# ============================================================

significant_regression_results_display <-
  significant_regression_results


if (nrow(significant_regression_results_display) > 0) {
  
  significant_regression_results_display$Coefficient <-
    round(
      significant_regression_results$Coefficient,
      3
    )
  
  significant_regression_results_display$Standard_Error <-
    round(
      significant_regression_results$Standard_Error,
      3
    )
  
  significant_regression_results_display$Adjusted_Odds_Ratio <-
    round(
      significant_regression_results$Adjusted_Odds_Ratio,
      3
    )
  
  significant_regression_results_display$CI_Lower <-
    round(
      significant_regression_results$CI_Lower,
      3
    )
  
  significant_regression_results_display$CI_Upper <-
    round(
      significant_regression_results$CI_Upper,
      3
    )
  
  significant_regression_results_display$P_Value <-
    format_p_value(
      significant_regression_results$P_Value
    )
}


# ============================================================
# 13. Create final analytical summary
# Consolidate the primary statistical outputs into one
# structured object for final review and documentation.
# ============================================================

final_clinical_insights <- list(
  
  Mortality_Outcome =
    final_mortality_summary,
  
  Significant_Group_Findings =
    significant_group_results,
  
  Strongest_Clinical_Correlations =
    strongest_correlations,
  
  Significant_Adjusted_Mortality_Associations =
    significant_regression_results,
  
  Adjusted_Association_Interpretations =
    regression_interpretations,
  
  Regression_Model_Fit =
    final_model_fit
)


# ============================================================
# 14. Display final analytical results
# ============================================================

cat(
  "\n",
  "============================================================\n",
  "FINAL CLINICAL STATISTICAL ANALYSIS\n",
  "============================================================\n"
)


cat(
  "\nMORTALITY OUTCOME\n"
)

print(
  final_mortality_summary
)


cat(
  "\nSIGNIFICANT GROUP-LEVEL FINDINGS ",
  "(BH-ADJUSTED)\n",
  sep = ""
)

if (nrow(significant_group_results_display) > 0) {
  
  print(
    significant_group_results_display
  )
  
} else {
  
  cat(
    "No group-level findings remained statistically ",
    "significant after BH adjustment.\n",
    sep = ""
  )
}


cat(
  "\nSTRONGEST CONTINUOUS-VARIABLE CORRELATIONS\n"
)

print(
  strongest_correlations
)


cat(
  "\nSIGNIFICANT ADJUSTED MORTALITY ASSOCIATIONS\n"
)

if (nrow(significant_regression_results_display) > 0) {
  
  print(
    significant_regression_results_display
  )
  
} else {
  
  cat(
    "No statistically significant adjusted associations ",
    "were identified.\n",
    sep = ""
  )
}


cat(
  "\nINTERPRETATION OF ADJUSTED ASSOCIATIONS\n"
)

for (
  interpretation in regression_interpretations
) {
  
  cat(
    "- ",
    interpretation,
    "\n",
    sep = ""
  )
}


cat(
  "\nREGRESSION MODEL FIT\n"
)

print(
  final_model_fit_display
)


# ============================================================
# 15. Report interpretation and limitation notes
# Explicitly distinguish statistical associations from causal
# or predictive conclusions.
# ============================================================

cat(
  "\nINTERPRETATION AND LIMITATIONS\n",
  "\n",
  
  "- Statistical associations do not establish causation.\n",
  
  "- Group-level hypothesis tests were adjusted using the ",
  "Benjamini-Hochberg procedure to account for multiple ",
  "testing.\n",
  
  "- Adjusted odds ratios represent associations conditional ",
  "on the other variables included in the logistic regression ",
  "model.\n",
  
  "- Correlations describe monotonic relationships between ",
  "continuous variables and should not be interpreted as ",
  "causal effects.\n",
  
  "- The dataset contains a relatively small patient sample, ",
  "so estimates may be unstable and should be interpreted ",
  "with appropriate caution.\n",
  
  "- Follow-up duration differs between patients. Logistic ",
  "regression models whether a death event was recorded but ",
  "does not explicitly model time-to-event information.\n",
  
  "- Survival analysis would be required for a dedicated ",
  "analysis of mortality risk over follow-up time.\n",
  
  "- The model has not been externally validated and should ",
  "not be interpreted as a clinical prediction tool.\n",
  
  "- Clinical conclusions require validation in independent ",
  "patient populations and appropriate medical context.\n"
)


# ============================================================
# 16. Return complete final analytical object
# ============================================================

final_clinical_insights

