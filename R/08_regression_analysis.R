# ============================================================
# Project: Digital Patient Representation for
#          Healthcare Decision-Making: Heart Failure
# File: 08_regression_analysis.R
# Purpose: Evaluate mortality associations using univariable
#          and multivariable logistic regression.
# ============================================================


# ============================================================
# 1. Confirm required objects
# ============================================================

required_objects <- c(
  "heart_failure",
  "baseline_variables",
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
# 2. Define regression setup
# All available baseline characteristics are included.
# Follow-up time is excluded because it represents observation
# duration rather than baseline patient information.
# ============================================================

regression_variables <- baseline_variables
regression_alpha <- 0.05

expected_outcome_levels <- c(
  "No death event",
  "Death event"
)

if (!identical(
  levels(heart_failure[[outcome_variable]]),
  expected_outcome_levels
)) {
  stop(
    "Unexpected DEATH_EVENT factor levels. Check script 01."
  )
}


# ============================================================
# 3. Fit univariable logistic regression models
# ============================================================

fit_univariable_model <- function(variable) {
  
  model <- glm(
    reformulate(
      variable,
      response = outcome_variable
    ),
    data = heart_failure,
    family = binomial()
  )
  
  coefficients <- summary(model)$coefficients
  
  coefficients <- coefficients[
    row.names(coefficients) != "(Intercept)",
    ,
    drop = FALSE
  ]
  
  data.frame(
    Variable = variable,
    Term = row.names(coefficients),
    N = nobs(model),
    Coefficient = coefficients[, "Estimate"],
    Standard_Error = coefficients[, "Std. Error"],
    Odds_Ratio = exp(
      coefficients[, "Estimate"]
    ),
    CI_Lower = exp(
      coefficients[, "Estimate"] -
        1.96 * coefficients[, "Std. Error"]
    ),
    CI_Upper = exp(
      coefficients[, "Estimate"] +
        1.96 * coefficients[, "Std. Error"]
    ),
    P_Value = coefficients[, "Pr(>|z|)"],
    stringsAsFactors = FALSE
  )
}


univariable_results <- do.call(
  rbind,
  lapply(
    regression_variables,
    fit_univariable_model
  )
)

row.names(univariable_results) <- NULL

univariable_results$Significant <- ifelse(
  univariable_results$P_Value <
    regression_alpha,
  "Yes",
  "No"
)

significant_univariable_results <-
  univariable_results[
    univariable_results$Significant == "Yes",
    ,
    drop = FALSE
  ]


# ============================================================
# 4. Fit full multivariable logistic regression
# ============================================================

mortality_model <- glm(
  reformulate(
    regression_variables,
    response = outcome_variable
  ),
  data = heart_failure,
  family = binomial()
)

if (!mortality_model$converged) {
  warning(
    "The multivariable logistic regression model did not converge."
  )
}


# ============================================================
# 5. Extract multivariable regression results
# ============================================================

multivariable_coefficients <- summary(
  mortality_model
)$coefficients

multivariable_coefficients <-
  multivariable_coefficients[
    row.names(multivariable_coefficients) !=
      "(Intercept)",
    ,
    drop = FALSE
  ]


map_term_to_variable <- function(term) {
  
  matches <- regression_variables[
    term == regression_variables |
      startsWith(
        term,
        regression_variables
      )
  ]
  
  if (length(matches) == 0) {
    return(NA_character_)
  }
  
  matches[
    which.max(
      nchar(matches)
    )
  ]
}


multivariable_results <- data.frame(
  
  Variable = vapply(
    row.names(multivariable_coefficients),
    map_term_to_variable,
    character(1)
  ),
  
  Term =
    row.names(multivariable_coefficients),
  
  Coefficient =
    multivariable_coefficients[, "Estimate"],
  
  Standard_Error =
    multivariable_coefficients[, "Std. Error"],
  
  Adjusted_Odds_Ratio = exp(
    multivariable_coefficients[, "Estimate"]
  ),
  
  CI_Lower = exp(
    multivariable_coefficients[, "Estimate"] -
      1.96 *
      multivariable_coefficients[, "Std. Error"]
  ),
  
  CI_Upper = exp(
    multivariable_coefficients[, "Estimate"] +
      1.96 *
      multivariable_coefficients[, "Std. Error"]
  ),
  
  P_Value =
    multivariable_coefficients[, "Pr(>|z|)"],
  
  stringsAsFactors = FALSE
)

row.names(multivariable_results) <- NULL

multivariable_results$Significant <- ifelse(
  multivariable_results$P_Value <
    regression_alpha,
  "Yes",
  "No"
)

significant_multivariable_results <-
  multivariable_results[
    multivariable_results$Significant == "Yes",
    ,
    drop = FALSE
  ]


# ============================================================
# 6. Evaluate model fit
# These measures describe in-sample model behavior only.
# ============================================================

model_frame <- model.frame(
  mortality_model
)

observed_mortality <- as.integer(
  model_frame[[outcome_variable]]
) - 1

predicted_probability <- predict(
  mortality_model,
  type = "response"
)

null_model <- glm(
  reformulate(
    character(0),
    response = outcome_variable
  ),
  data = model_frame,
  family = binomial()
)

mcfadden_r2 <- 1 -
  (
    as.numeric(
      logLik(mortality_model)
    ) /
      as.numeric(
        logLik(null_model)
      )
  )

brier_score <- mean(
  (
    predicted_probability -
      observed_mortality
  )^2
)


model_fit <- data.frame(
  N = nobs(mortality_model),
  Death_Events = sum(observed_mortality),
  Null_Deviance = mortality_model$null.deviance,
  Residual_Deviance = mortality_model$deviance,
  AIC = AIC(mortality_model),
  Log_Likelihood = as.numeric(
    logLik(mortality_model)
  ),
  McFadden_Pseudo_R2 = mcfadden_r2,
  Brier_Score = brier_score,
  Converged = mortality_model$converged,
  stringsAsFactors = FALSE
)


# ============================================================
# 7. Basic influence diagnostics
# Flags identify observations for inspection only.
# They are not automatic exclusion criteria.
# ============================================================

model_n <- nobs(
  mortality_model
)

model_parameters <- length(
  coef(mortality_model)
)

cook_threshold <- 4 / model_n

leverage_threshold <-
  2 * model_parameters / model_n

residual_threshold <- 3


regression_diagnostics <- data.frame(
  
  Observation =
    row.names(model_frame),
  
  Predicted_Probability =
    predicted_probability,
  
  Cooks_Distance =
    cooks.distance(
      mortality_model
    ),
  
  Leverage =
    hatvalues(
      mortality_model
    ),
  
  Standardized_Deviance_Residual =
    rstandard(
      mortality_model,
      type = "deviance"
    ),
  
  stringsAsFactors = FALSE
)

regression_diagnostics$High_Cooks_Distance <-
  regression_diagnostics$Cooks_Distance >
  cook_threshold

regression_diagnostics$High_Leverage <-
  regression_diagnostics$Leverage >
  leverage_threshold

regression_diagnostics$Large_Residual <-
  abs(
    regression_diagnostics$
      Standardized_Deviance_Residual
  ) > residual_threshold

regression_diagnostics$Any_Flag <-
  regression_diagnostics$High_Cooks_Distance |
  regression_diagnostics$High_Leverage |
  regression_diagnostics$Large_Residual


regression_diagnostic_summary <- data.frame(
  Diagnostic = c(
    "Cook's distance",
    "Leverage",
    "Standardized deviance residual",
    "Any diagnostic flag"
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
        Large_Residual
    ),
    sum(
      regression_diagnostics$
        Any_Flag
    )
  ),
  stringsAsFactors = FALSE
)


# ============================================================
# 8. Create presentation versions
# Statistical decisions use unrounded values.
# Rounding is performed only for display.
# ============================================================

format_regression_results <- function(
    results,
    odds_ratio_column
) {
  
  display <- results
  
  numeric_columns <- c(
    "Coefficient",
    "Standard_Error",
    odds_ratio_column,
    "CI_Lower",
    "CI_Upper"
  )
  
  display[numeric_columns] <- round(
    display[numeric_columns],
    4
  )
  
  display$P_Value <- format.pval(
    results$P_Value,
    digits = 4,
    eps = 0.0001
  )
  
  display
}


univariable_results_display <-
  format_regression_results(
    univariable_results,
    "Odds_Ratio"
  )

multivariable_results_display <-
  format_regression_results(
    multivariable_results,
    "Adjusted_Odds_Ratio"
  )


model_fit_display <- model_fit

model_fit_numeric <- c(
  "Null_Deviance",
  "Residual_Deviance",
  "AIC",
  "Log_Likelihood",
  "McFadden_Pseudo_R2",
  "Brier_Score"
)

model_fit_display[model_fit_numeric] <- round(
  model_fit_display[model_fit_numeric],
  4
)


# ============================================================
# 9. Consolidate regression results
# ============================================================

regression_analysis <- list(
  
  Univariable_Results =
    univariable_results,
  
  Multivariable_Results =
    multivariable_results,
  
  Mortality_Model =
    mortality_model,
  
  Model_Fit =
    model_fit,
  
  Diagnostics =
    regression_diagnostics,
  
  Diagnostic_Summary =
    regression_diagnostic_summary
)


# ============================================================
# 10. Display regression results
# ============================================================

cat(
  "\n",
  "============================================================\n",
  "LOGISTIC REGRESSION ANALYSIS\n",
  "============================================================\n",
  sep = ""
)

cat(
  "\nUNIVARIABLE REGRESSION\n"
)

print(
  univariable_results_display
)

cat(
  "\nMULTIVARIABLE REGRESSION\n"
)

print(
  multivariable_results_display
)

cat(
  "\nMODEL FIT\n"
)

print(
  model_fit_display
)

cat(
  "\nINFLUENCE DIAGNOSTICS\n"
)

print(
  regression_diagnostic_summary
)


# ============================================================
# 11. Final interpretation note
# ============================================================

cat(
  "\nINTERPRETATION NOTE\n",
  "Regression coefficients represent observational associations ",
  "and do not establish causality.\n",
  "Adjusted associations are conditional only on the baseline ",
  "variables available in this dataset.\n",
  "Model-fit measures and predicted probabilities are in-sample ",
  "and do not represent externally validated prediction.\n",
  "Diagnostic flags identify observations for inspection and ",
  "do not justify automatic exclusion.\n",
  "Representation sensitivity is evaluated separately in ",
  "09_representation_sensitivity_analysis.R.\n",
  sep = ""
)


# ============================================================
# 12. Return complete regression analysis object
# ============================================================

regression_analysis

