# ============================================================
# Project: Heart Failure Clinical Statistical Analysis with R
# File: 09_final_clinical_insights.R
# Purpose: Consolidate the main descriptive, inferential,
# correlation, and regression findings into final insights.
# Language: R
# ============================================================


# ============================================================
# 1. Summarize mortality outcome
# Retain the overall mortality distribution as the primary
# outcome overview for the final analysis.
# ============================================================

final_mortality_summary <- mortality_summary

final_mortality_summary


# ============================================================
# 2. Identify significant group differences
# Extract variables showing statistically significant
# differences or associations with mortality.
# ============================================================

significant_group_results <- hypothesis_test_summary[
  hypothesis_test_summary$Significant == "Yes",
]

row.names(significant_group_results) <- NULL

significant_group_results


# ============================================================
# 3. Identify strongest clinical correlations
# Rank continuous-variable relationships by absolute
# correlation strength.
# ============================================================

strongest_correlations <- correlation_results_ranked[
  order(
    -correlation_results_ranked$Absolute_Correlation
  ),
]

strongest_correlations <- head(
  strongest_correlations,
  5
)

row.names(strongest_correlations) <- NULL

strongest_correlations


# ============================================================
# 4. Identify significant adjusted mortality associations
# Extract variables remaining statistically significant in
# the multivariable logistic regression model.
# ============================================================

significant_regression_results <- multivariable_results[
  multivariable_results$Significant == "Yes",
]

row.names(significant_regression_results) <- NULL

significant_regression_results


# ============================================================
# 5. Compare univariable and multivariable findings
# Review whether variables associated with mortality
# individually remain relevant after adjustment.
# ============================================================

significant_univariable_results <- univariable_results[
  univariable_results$P_Value < 0.05,
]

row.names(significant_univariable_results) <- NULL

significant_univariable_results

significant_regression_results


# ============================================================
# 6. Summarize regression model fit
# Include the previously calculated logistic regression
# model fit statistics in the final analytical overview.
# ============================================================

final_model_fit <- round(
  model_fit,
  2
)

final_model_fit


# ============================================================
# 7. Create final analytical summary
# Consolidate the primary statistical outputs into one
# structured object for final review and documentation.
# ============================================================

final_clinical_insights <- list(
  Mortality_Outcome = final_mortality_summary,
  Significant_Group_Results = significant_group_results,
  Strongest_Correlations = strongest_correlations,
  Significant_Univariable_Associations =
    significant_univariable_results,
  Significant_Adjusted_Associations =
    significant_regression_results,
  Regression_Model_Fit = final_model_fit
)

final_clinical_insights


# ============================================================
# 8. Report final interpretation notes
# Clarify the statistical scope and limitations of the
# findings before clinical interpretation.
# ============================================================

cat(
  "\nFINAL INTERPRETATION NOTES\n",
  "\n",
  "- Statistical significance does not imply causation.\n",
  "- Observed associations should be interpreted within the",
  " context of this dataset.\n",
  "- Adjusted regression estimates account for the other",
  " variables included in the model.\n",
  "- Correlation describes statistical association and does",
  " not establish a causal relationship.\n",
  "- Clinical conclusions require validation in additional",
  " patient populations and appropriate medical context.\n"
)

