# ============================================================
# Project: Heart Failure Clinical Statistical Analysis with R
# File: 08_regression_analysis.R
# Purpose: Analyze univariable and multivariable associations
# between baseline patient characteristics and recorded
# mortality using logistic regression.
# Language: R
# ============================================================


# ============================================================
# 1. Define significance level
# The conventional nominal significance threshold is used for
# exploratory regression interpretation.
#
# Regression p-values are not treated as the primary
# multiple-testing-adjusted inferential evidence of the project.
# The primary multiple-testing-adjusted group comparisons are
# performed separately in 06_hypothesis_testing.R.
# ============================================================

alpha <- 0.05


# ============================================================
# 2. Define regression variables
# Select all available baseline demographic and clinical
# patient characteristics.
#
# Follow-up time is deliberately excluded because it represents
# observation duration rather than baseline patient information.
# ============================================================

regression_variables <- c(
  "age",
  "anaemia",
  "creatinine_phosphokinase",
  "diabetes",
  "ejection_fraction",
  "high_blood_pressure",
  "platelets",
  "serum_creatinine",
  "serum_sodium",
  "sex",
  "smoking"
)

outcome_variable <- "DEATH_EVENT"


# ============================================================
# 3. Confirm required variables
# Verify that all baseline predictors and the mortality outcome
# are available in the configured dataset.
# ============================================================

required_regression_variables <- c(
  regression_variables,
  outcome_variable
)

missing_regression_variables <- setdiff(
  required_regression_variables,
  names(
    heart_failure
  )
)

if (
  length(
    missing_regression_variables
  ) > 0
) {
  
  stop(
    paste(
      "The following variables required for regression",
      "analysis are missing:",
      paste(
        missing_regression_variables,
        collapse = ", "
      )
    )
  )
}


# ============================================================
# 4. Confirm mortality outcome structure
# Logistic regression with a two-level factor models the
# probability of the second factor level.
#
# The expected ordering is:
#
# 1. No death event
# 2. Death event
# ============================================================

expected_outcome_levels <- c(
  "No death event",
  "Death event"
)

actual_outcome_levels <- levels(
  heart_failure$DEATH_EVENT
)

if (
  !identical(
    actual_outcome_levels,
    expected_outcome_levels
  )
) {
  
  stop(
    paste(
      "DEATH_EVENT does not have the expected factor levels",
      "or level ordering.",
      "Expected:",
      paste(
        expected_outcome_levels,
        collapse = " -> "
      ),
      "| Observed:",
      paste(
        actual_outcome_levels,
        collapse = " -> "
      )
    )
  )
}

actual_outcome_levels


# ============================================================
# 5. Summarize regression data availability
# Count available and missing observations for all variables
# used in the regression stage.
# ============================================================

regression_data_availability <- data.frame(
  
  Variable =
    required_regression_variables,
  
  Available_N =
    vapply(
      heart_failure[
        required_regression_variables
      ],
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
      heart_failure[
        required_regression_variables
      ],
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

regression_data_availability$Missing_Percentage <-
  round(
    (
      regression_data_availability$Missing_N /
        nrow(
          heart_failure
        )
    ) * 100,
    2
  )

row.names(
  regression_data_availability
) <- NULL

regression_data_availability


# ============================================================
# 6. Count complete cases for the full baseline model
# Logistic regression uses observations with complete
# information for every variable included in the model.
# ============================================================

complete_regression_cases <- complete.cases(
  heart_failure[
    required_regression_variables
  ]
)

complete_regression_n <- sum(
  complete_regression_cases
)

excluded_regression_n <- sum(
  !complete_regression_cases
)

complete_regression_n

excluded_regression_n


# ============================================================
# 7. Create readable variable labels
# These labels are used only for presentation and interpretation.
# ============================================================

regression_variable_labels <- c(
  
  age =
    "Age",
  
  anaemia =
    "Anaemia",
  
  creatinine_phosphokinase =
    "Creatinine phosphokinase",
  
  diabetes =
    "Diabetes",
  
  ejection_fraction =
    "Ejection fraction",
  
  high_blood_pressure =
    "High blood pressure",
  
  platelets =
    "Platelet count",
  
  serum_creatinine =
    "Serum creatinine",
  
  serum_sodium =
    "Serum sodium",
  
  sex =
    "Sex",
  
  smoking =
    "Smoking status"
)


# ============================================================
# 8. Perform univariable logistic regression
# Estimate the individual association between each baseline
# patient characteristic and recorded mortality.
#
# Each model has the structure:
#
# DEATH_EVENT ~ X
#
# These are unadjusted associations.
# ============================================================

univariable_results <- do.call(
  rbind,
  lapply(
    regression_variables,
    function(variable) {
      
      model <- glm(
        reformulate(
          variable,
          response = outcome_variable
        ),
        data = heart_failure,
        family = binomial(
          link = "logit"
        )
      )
      
      coefficient_table <- summary(
        model
      )$coefficients
      
      coefficient_table <- coefficient_table[
        row.names(
          coefficient_table
        ) !=
          "(Intercept)",
        ,
        drop = FALSE
      ]
      
      data.frame(
        
        Variable =
          variable,
        
        Term =
          row.names(
            coefficient_table
          ),
        
        N =
          nobs(
            model
          ),
        
        Coefficient =
          coefficient_table[
            ,
            "Estimate"
          ],
        
        Standard_Error =
          coefficient_table[
            ,
            "Std. Error"
          ],
        
        Odds_Ratio = exp(
          coefficient_table[
            ,
            "Estimate"
          ]
        ),
        
        CI_Lower = exp(
          coefficient_table[
            ,
            "Estimate"
          ] -
            1.96 *
            coefficient_table[
              ,
              "Std. Error"
            ]
        ),
        
        CI_Upper = exp(
          coefficient_table[
            ,
            "Estimate"
          ] +
            1.96 *
            coefficient_table[
              ,
              "Std. Error"
            ]
        ),
        
        P_Value =
          coefficient_table[
            ,
            "Pr(>|z|)"
          ],
        
        stringsAsFactors = FALSE
      )
    }
  )
)

row.names(
  univariable_results
) <- NULL

univariable_results


# ============================================================
# 9. Add nominal univariable significance classification
# Statistical decisions are based on the original unrounded
# p-values.
#
# These nominal p-values are exploratory and are not used as the
# primary multiple-testing-adjusted evidence of the project.
# ============================================================

univariable_results$Nominal_Significance <- ifelse(
  univariable_results$P_Value <
    alpha,
  "Yes",
  "No"
)


# ============================================================
# 10. Add readable univariable labels
# ============================================================

univariable_results$Variable_Label <- unname(
  regression_variable_labels[
    univariable_results$Variable
  ]
)


# ============================================================
# 11. Create display version of univariable results
# Preserve full numerical precision in univariable_results.
#
# Rounding and p-value formatting are applied only to the
# presentation object.
# ============================================================

univariable_results_display <-
  univariable_results

univariable_results_display$Coefficient <- round(
  univariable_results_display$Coefficient,
  4
)

univariable_results_display$Standard_Error <- round(
  univariable_results_display$Standard_Error,
  4
)

univariable_results_display$Odds_Ratio <- round(
  univariable_results_display$Odds_Ratio,
  4
)

univariable_results_display$CI_Lower <- round(
  univariable_results_display$CI_Lower,
  4
)

univariable_results_display$CI_Upper <- round(
  univariable_results_display$CI_Upper,
  4
)

univariable_results_display$P_Value <- format.pval(
  univariable_results_display$P_Value,
  digits = 4,
  eps = 0.0001
)

univariable_results_display


# ============================================================
# 12. Identify nominally supported univariable associations
# Retain variables with raw p-values below the nominal
# significance threshold.
#
# This is exploratory evidence only.
# ============================================================

significant_univariable_results <-
  univariable_results[
    univariable_results$P_Value <
      alpha,
    ,
    drop = FALSE
  ]

if (
  nrow(
    significant_univariable_results
  ) > 0
) {
  
  significant_univariable_results <-
    significant_univariable_results[
      order(
        significant_univariable_results$
          P_Value
      ),
      ,
      drop = FALSE
    ]
}

row.names(
  significant_univariable_results
) <- NULL

significant_univariable_results


# ============================================================
# 13. Fit multivariable logistic regression
# Estimate mortality associations while simultaneously
# accounting for all other available baseline patient
# characteristics.
#
# Follow-up time is deliberately excluded.
# ============================================================

mortality_model <- glm(
  reformulate(
    regression_variables,
    response = outcome_variable
  ),
  data = heart_failure,
  family = binomial(
    link = "logit"
  )
)

summary(
  mortality_model
)


# ============================================================
# 14. Confirm model convergence
# A converged model indicates that the fitting algorithm
# completed successfully.
#
# Convergence alone does not establish model validity.
# ============================================================

model_converged <- mortality_model$converged

model_converged

if (
  !model_converged
) {
  
  warning(
    paste(
      "The multivariable logistic regression model did not",
      "converge. Regression estimates should not be interpreted",
      "until the fitting problem has been investigated."
    )
  )
}


# ============================================================
# 15. Extract multivariable coefficients
# Remove the model intercept and retain the individual patient
# characteristic coefficients.
# ============================================================

multivariable_coefficients <- summary(
  mortality_model
)$coefficients

multivariable_coefficients <-
  multivariable_coefficients[
    row.names(
      multivariable_coefficients
    ) !=
      "(Intercept)",
    ,
    drop = FALSE
  ]


# ============================================================
# 16. Map model terms to underlying patient variables
# Factor variables appear in the regression output using terms
# such as anaemiaYes or sexMale.
#
# This helper maps each model term back to the original patient
# characteristic.
# ============================================================

map_regression_term_to_variable <- function(
    term,
    variables
) {
  
  possible_matches <- variables[
    vapply(
      variables,
      function(variable) {
        
        term == variable ||
          startsWith(
            term,
            variable
          )
      },
      logical(1)
    )
  ]
  
  if (
    length(
      possible_matches
    ) == 0
  ) {
    
    return(
      NA_character_
    )
  }
  
  possible_matches[
    which.max(
      nchar(
        possible_matches
      )
    )
  ]
}


# ============================================================
# 17. Create raw multivariable results
# Calculate adjusted odds ratios and approximate 95% Wald
# confidence intervals.
#
# All values remain unrounded.
# ============================================================

multivariable_results <- data.frame(
  
  Term =
    row.names(
      multivariable_coefficients
    ),
  
  Coefficient =
    multivariable_coefficients[
      ,
      "Estimate"
    ],
  
  Standard_Error =
    multivariable_coefficients[
      ,
      "Std. Error"
    ],
  
  Adjusted_Odds_Ratio = exp(
    multivariable_coefficients[
      ,
      "Estimate"
    ]
  ),
  
  CI_Lower = exp(
    multivariable_coefficients[
      ,
      "Estimate"
    ] -
      1.96 *
      multivariable_coefficients[
        ,
        "Std. Error"
      ]
  ),
  
  CI_Upper = exp(
    multivariable_coefficients[
      ,
      "Estimate"
    ] +
      1.96 *
      multivariable_coefficients[
        ,
        "Std. Error"
      ]
  ),
  
  P_Value =
    multivariable_coefficients[
      ,
      "Pr(>|z|)"
    ],
  
  stringsAsFactors = FALSE
)

row.names(
  multivariable_results
) <- NULL


# ============================================================
# 18. Add underlying variable information
# ============================================================

multivariable_results$Variable <- vapply(
  multivariable_results$Term,
  map_regression_term_to_variable,
  character(1),
  variables = regression_variables
)

multivariable_results$Variable_Label <- unname(
  regression_variable_labels[
    multivariable_results$Variable
  ]
)


# ============================================================
# 19. Add readable model-term labels
# Explicitly describe factor comparisons relative to their
# reference categories.
# ============================================================

regression_term_labels <- c(
  
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

multivariable_results$Clinical_Label <- ifelse(
  multivariable_results$Term %in%
    names(
      regression_term_labels
    ),
  unname(
    regression_term_labels[
      multivariable_results$Term
    ]
  ),
  multivariable_results$Term
)


# ============================================================
# 20. Identify nominally significant adjusted associations
# The significance classification is based on the ORIGINAL
# unrounded p-values.
#
# These associations remain observational and should not be
# interpreted as causal effects.
# ============================================================

multivariable_results$Significant <- ifelse(
  multivariable_results$P_Value <
    alpha,
  "Yes",
  "No"
)

significant_multivariable_results <-
  multivariable_results[
    multivariable_results$Significant ==
      "Yes",
    ,
    drop = FALSE
  ]

if (
  nrow(
    significant_multivariable_results
  ) > 0
) {
  
  significant_multivariable_results <-
    significant_multivariable_results[
      order(
        significant_multivariable_results$
          P_Value
      ),
      ,
      drop = FALSE
    ]
}

row.names(
  significant_multivariable_results
) <- NULL

significant_multivariable_results


# ============================================================
# 21. Create display version of multivariable results
# Rounding occurs only after all statistical classifications
# have been performed on the raw results.
# ============================================================

multivariable_results_display <-
  multivariable_results

multivariable_results_display$Coefficient <- round(
  multivariable_results_display$Coefficient,
  4
)

multivariable_results_display$Standard_Error <- round(
  multivariable_results_display$Standard_Error,
  4
)

multivariable_results_display$Adjusted_Odds_Ratio <- round(
  multivariable_results_display$Adjusted_Odds_Ratio,
  4
)

multivariable_results_display$CI_Lower <- round(
  multivariable_results_display$CI_Lower,
  4
)

multivariable_results_display$CI_Upper <- round(
  multivariable_results_display$CI_Upper,
  4
)

multivariable_results_display$P_Value <- format.pval(
  multivariable_results_display$P_Value,
  digits = 4,
  eps = 0.0001
)

multivariable_results_display


# ============================================================
# 22. Calculate model-level outcome information
# Determine the number of observations and recorded death
# events actually used by the fitted multivariable model.
# ============================================================

mortality_model_frame <- model.frame(
  mortality_model
)

model_sample_n <- nrow(
  mortality_model_frame
)

model_death_events <- sum(
  mortality_model_frame$DEATH_EVENT ==
    "Death event"
)

model_no_death_events <- sum(
  mortality_model_frame$DEATH_EVENT ==
    "No death event"
)

model_sample_n

model_death_events

model_no_death_events


# ============================================================
# 23. Calculate descriptive events-per-parameter information
# Count the number of estimated predictor coefficients,
# excluding the intercept.
#
# The resulting ratio is reported only as descriptive model
# context and is not treated as a universal model-quality rule.
# ============================================================

number_predictor_parameters <- length(
  coef(
    mortality_model
  )
) - 1

events_per_predictor_parameter <-
  model_death_events /
  number_predictor_parameters

model_parameter_context <- data.frame(
  
  Model_N =
    model_sample_n,
  
  Death_Events =
    model_death_events,
  
  No_Death_Events =
    model_no_death_events,
  
  Predictor_Parameters =
    number_predictor_parameters,
  
  Events_Per_Predictor_Parameter =
    events_per_predictor_parameter,
  
  stringsAsFactors = FALSE
)

model_parameter_context


# ============================================================
# 24. Calculate in-sample predicted probabilities
# These probabilities are used for descriptive model
# diagnostics only.
#
# They are not externally validated patient-risk estimates.
# ============================================================

mortality_model_probability <- predict(
  mortality_model,
  type = "response"
)

observed_mortality_numeric <- ifelse(
  mortality_model_frame$DEATH_EVENT ==
    "Death event",
  1,
  0
)


# ============================================================
# 25. Calculate in-sample Brier score
# The Brier score is the mean squared difference between
# predicted probabilities and observed binary outcomes.
#
# Lower values indicate smaller probability error within this
# analyzed sample.
#
# Because the model is evaluated in the same data in which it
# was fitted, this is NOT an externally validated performance
# estimate.
# ============================================================

mortality_model_brier_score <- mean(
  (
    mortality_model_probability -
      observed_mortality_numeric
  )^2
)

mortality_model_brier_score


# ============================================================
# 26. Calculate McFadden pseudo-R2
# Compare the fitted model likelihood with an intercept-only
# model.
#
# McFadden pseudo-R2 should not be interpreted in the same way
# as ordinary linear-regression R2.
# ============================================================

mortality_null_model <- glm(
  DEATH_EVENT ~ 1,
  data = mortality_model_frame,
  family = binomial(
    link = "logit"
  )
)

mcfadden_pseudo_r2 <- 1 -
  (
    as.numeric(
      logLik(
        mortality_model
      )
    ) /
      as.numeric(
        logLik(
          mortality_null_model
        )
      )
  )

mcfadden_pseudo_r2


# ============================================================
# 27. Create model-fit summary
# Report complementary descriptive measures of model fit.
#
# These statistics describe in-sample model behavior.
# ============================================================

model_fit <- data.frame(
  
  N =
    model_sample_n,
  
  Death_Events =
    model_death_events,
  
  Null_Deviance =
    mortality_model$null.deviance,
  
  Residual_Deviance =
    mortality_model$deviance,
  
  AIC = AIC(
    mortality_model
  ),
  
  Log_Likelihood =
    as.numeric(
      logLik(
        mortality_model
      )
    ),
  
  McFadden_Pseudo_R2 =
    mcfadden_pseudo_r2,
  
  Brier_Score =
    mortality_model_brier_score,
  
  Converged =
    model_converged,
  
  stringsAsFactors = FALSE
)

model_fit


# ============================================================
# 28. Create model-fit display version
# ============================================================

model_fit_display <-
  model_fit

model_fit_display[
  ,
  c(
    "Null_Deviance",
    "Residual_Deviance",
    "AIC",
    "Log_Likelihood",
    "McFadden_Pseudo_R2",
    "Brier_Score"
  )
] <- round(
  model_fit_display[
    ,
    c(
      "Null_Deviance",
      "Residual_Deviance",
      "AIC",
      "Log_Likelihood",
      "McFadden_Pseudo_R2",
      "Brier_Score"
    )
  ],
  4
)

model_fit_display


# ============================================================
# 29. Calculate basic influence diagnostics
# Examine whether individual observations have unusually large
# influence on the fitted multivariable model.
#
# Diagnostics are used as screening tools only.
# No patient is automatically removed because of a diagnostic
# flag.
# ============================================================

model_cooks_distance <- cooks.distance(
  mortality_model
)

model_leverage <- hatvalues(
  mortality_model
)

model_standardized_deviance_residuals <- rstandard(
  mortality_model,
  type = "deviance"
)


# ============================================================
# 30. Define descriptive diagnostic screening thresholds
# These thresholds are used only to identify observations that
# may deserve closer inspection.
#
# They are not automatic exclusion rules.
# ============================================================

cook_threshold <- 4 /
  model_sample_n

leverage_threshold <- (
  2 *
    length(
      coef(
        mortality_model
      )
    )
) /
  model_sample_n

standardized_residual_threshold <- 3


# ============================================================
# 31. Create observation-level diagnostic table
# ============================================================

regression_diagnostics <- data.frame(
  
  Observation =
    as.numeric(
      row.names(
        mortality_model_frame
      )
    ),
  
  Predicted_Probability =
    mortality_model_probability,
  
  Cooks_Distance =
    model_cooks_distance,
  
  Leverage =
    model_leverage,
  
  Standardized_Deviance_Residual =
    model_standardized_deviance_residuals,
  
  High_Cooks_Distance =
    model_cooks_distance >
    cook_threshold,
  
  High_Leverage =
    model_leverage >
    leverage_threshold,
  
  Large_Standardized_Residual =
    abs(
      model_standardized_deviance_residuals
    ) >
    standardized_residual_threshold,
  
  stringsAsFactors = FALSE
)

regression_diagnostics$Any_Diagnostic_Flag <-
  regression_diagnostics$High_Cooks_Distance |
  regression_diagnostics$High_Leverage |
  regression_diagnostics$Large_Standardized_Residual

regression_diagnostics


# ============================================================
# 32. Summarize diagnostic flags
# Count observations that exceed the descriptive screening
# thresholds.
# ============================================================

regression_diagnostic_summary <- data.frame(
  
  Diagnostic = c(
    "Cook's distance",
    "Leverage",
    "Standardized deviance residual",
    "Any diagnostic flag"
  ),
  
  Screening_Threshold = c(
    cook_threshold,
    leverage_threshold,
    standardized_residual_threshold,
    NA_real_
  ),
  
  Number_Flagged = c(
    sum(
      regression_diagnostics$
        High_Cooks_Distance
    ),
    
    sum(
      regression_diagnostics$
        High_Leverage
    ),
    
    sum(
      regression_diagnostics$
        Large_Standardized_Residual
    ),
    
    sum(
      regression_diagnostics$
        Any_Diagnostic_Flag
    )
  ),
  
  stringsAsFactors = FALSE
)

regression_diagnostic_summary


# ============================================================
# 33. Retain observations with at least one diagnostic flag
# These observations may be inspected further but remain part
# of the analysis unless substantive evidence indicates that
# they are erroneous or analytically inappropriate.
# ============================================================

flagged_regression_observations <-
  regression_diagnostics[
    regression_diagnostics$
      Any_Diagnostic_Flag,
    ,
    drop = FALSE
  ]

if (
  nrow(
    flagged_regression_observations
  ) > 0
) {
  
  flagged_regression_observations <-
    flagged_regression_observations[
      order(
        flagged_regression_observations$
          Cooks_Distance,
        decreasing = TRUE
      ),
      ,
      drop = FALSE
    ]
}

row.names(
  flagged_regression_observations
) <- NULL

flagged_regression_observations


# ============================================================
# 34. Create display version of regression diagnostics
# ============================================================

regression_diagnostic_summary_display <-
  regression_diagnostic_summary

regression_diagnostic_summary_display$
  Screening_Threshold <- round(
    regression_diagnostic_summary_display$
      Screening_Threshold,
    4
  )

regression_diagnostic_summary_display


# ============================================================
# 35. Create complete regression analysis object
# Consolidate all primary regression results and diagnostics for
# later interpretation and reuse.
# ============================================================

regression_analysis <- list(
  
  Significance_Level =
    alpha,
  
  Regression_Variables =
    regression_variables,
  
  Data_Availability =
    regression_data_availability,
  
  Complete_Model_N =
    complete_regression_n,
  
  Excluded_From_Complete_Model_N =
    excluded_regression_n,
  
  Univariable_Results_Raw =
    univariable_results,
  
  Univariable_Results_Display =
    univariable_results_display,
  
  Significant_Univariable_Results =
    significant_univariable_results,
  
  Mortality_Model =
    mortality_model,
  
  Multivariable_Results_Raw =
    multivariable_results,
  
  Multivariable_Results_Display =
    multivariable_results_display,
  
  Significant_Multivariable_Results =
    significant_multivariable_results,
  
  Model_Parameter_Context =
    model_parameter_context,
  
  Model_Fit_Raw =
    model_fit,
  
  Model_Fit_Display =
    model_fit_display,
  
  Observation_Diagnostics =
    regression_diagnostics,
  
  Diagnostic_Summary =
    regression_diagnostic_summary,
  
  Flagged_Observations =
    flagged_regression_observations
)


# ============================================================
# 36. Display final regression overview
# ============================================================

cat(
  "\n",
  "============================================================\n",
  "LOGISTIC REGRESSION ANALYSIS\n",
  "============================================================\n",
  sep = ""
)


cat(
  "\nREGRESSION DATA AVAILABILITY\n"
)

print(
  regression_data_availability
)


cat(
  "\nUNIVARIABLE LOGISTIC REGRESSION\n"
)

print(
  univariable_results_display
)


cat(
  "\nNOMINALLY SUPPORTED UNIVARIABLE ASSOCIATIONS\n"
)

if (
  nrow(
    significant_univariable_results
  ) > 0
) {
  
  significant_univariable_display <-
    univariable_results_display[
      univariable_results$P_Value <
        alpha,
      ,
      drop = FALSE
    ]
  
  print(
    significant_univariable_display
  )
  
} else {
  
  cat(
    "No univariable association reached the nominal ",
    "p < 0.05 threshold.\n",
    sep = ""
  )
}


cat(
  "\nMULTIVARIABLE LOGISTIC REGRESSION\n"
)

print(
  multivariable_results_display
)


cat(
  "\nNOMINALLY SUPPORTED ADJUSTED ASSOCIATIONS\n"
)

if (
  nrow(
    significant_multivariable_results
  ) > 0
) {
  
  significant_multivariable_display <-
    multivariable_results_display[
      multivariable_results$P_Value <
        alpha,
      ,
      drop = FALSE
    ]
  
  print(
    significant_multivariable_display[
      ,
      c(
        "Clinical_Label",
        "Adjusted_Odds_Ratio",
        "CI_Lower",
        "CI_Upper",
        "P_Value",
        "Significant"
      ),
      drop = FALSE
    ]
  )
  
} else {
  
  cat(
    "No adjusted association reached the nominal ",
    "p < 0.05 threshold.\n",
    sep = ""
  )
}


cat(
  "\nMODEL PARAMETER CONTEXT\n"
)

model_parameter_context_display <-
  model_parameter_context

model_parameter_context_display$
  Events_Per_Predictor_Parameter <- round(
    model_parameter_context_display$
      Events_Per_Predictor_Parameter,
    2
  )

print(
  model_parameter_context_display
)


cat(
  "\nMODEL FIT\n"
)

print(
  model_fit_display
)


cat(
  "\nBASIC INFLUENCE DIAGNOSTICS\n"
)

print(
  regression_diagnostic_summary_display
)


# ============================================================
# 37. Final interpretation note
# Explicitly define what the logistic regression stage can and
# cannot establish.
# ============================================================

cat(
  "\nIMPORTANT INTERPRETATION NOTE\n",
  
  "The logistic regression models estimate statistical ",
  "associations between digitally available baseline patient ",
  "characteristics and whether a death event was recorded ",
  "during follow-up.\n",
  
  "Univariable models describe unadjusted associations. ",
  "Multivariable coefficients describe associations conditional ",
  "on the other AVAILABLE baseline characteristics included in ",
  "the model.\n",
  
  "Adjustment for available variables does not eliminate ",
  "possible unmeasured confounding and does not establish ",
  "causality.\n",
  
  "Regression significance classifications are based on ",
  "unrounded p-values. Rounding is used only for presentation.\n",
  
  "The regression p-values are treated as exploratory evidence. ",
  "The primary multiple-testing-adjusted mortality-group ",
  "evidence is evaluated separately in ",
  "06_hypothesis_testing.R.\n",
  
  "Odds ratios must be interpreted relative to the measurement ",
  "unit of each predictor. An odds ratio close to 1 per single ",
  "unit does not automatically imply that the variable is ",
  "clinically unimportant.\n",
  
  "Follow-up time is not included as a baseline predictor ",
  "because it represents the observation process rather than ",
  "the patient's baseline state.\n",
  
  "The binary logistic model therefore evaluates whether a ",
  "death event was recorded but does not explicitly model ",
  "time-to-event information.\n",
  
  "The Brier score and predicted probabilities are calculated ",
  "in sample and must not be interpreted as externally ",
  "validated predictive performance or clinical risk ",
  "estimates.\n",
  
  "The influence diagnostics are descriptive screening tools. ",
  "Diagnostic flags do not automatically indicate erroneous ",
  "patients and are not used as automatic exclusion criteria.\n",
  
  "The current model does not comprehensively evaluate ",
  "non-linear predictor relationships, interactions, or ",
  "external generalizability.\n",
  
  "The model is therefore used as an explanatory and ",
  "methodological component of the project rather than as a ",
  "clinical prediction or treatment-decision system.\n",
  
  sep = ""
)


# ============================================================
# 38. Return complete regression analysis object
# ============================================================

regression_analysis


