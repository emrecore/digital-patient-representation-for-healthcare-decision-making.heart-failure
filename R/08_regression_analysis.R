# ============================================================
# Project: Representation Sensitivity Analysis
#          in Heart Failure with R
# File: 08_regression_analysis.R
# Purpose: Explore univariable and multivariable associations
#          between available baseline patient characteristics
#          and the recorded binary death-event outcome using
#          logistic regression.
# ============================================================


# ============================================================
# 1. Confirm required setup objects from script 01
# ============================================================

required_objects <- c(
  "heart_failure",
  "baseline_variables",
  "baseline_numerical_variables",
  "baseline_categorical_variables",
  "outcome_variable",
  "outcome_labels"
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
# 2. Define regression setup
# ============================================================
#
# All available baseline characteristics are included.
#
# Follow-up duration is intentionally excluded because it
# represents observation information rather than a baseline
# patient characteristic.
#
# Variables are NOT selected based on:
#
# - group-comparison p-values from script 06
# - correlations from script 07
# - univariable regression p-values
#
# The full multivariable model therefore represents the full
# available baseline variable set defined in script 01.
# ============================================================

regression_variables <- baseline_variables

regression_alpha <- 0.05


# ============================================================
# 3. Verify outcome configuration
# ============================================================

if (!is.factor(
  heart_failure[[outcome_variable]]
)) {
  stop(
    paste0(
      "Regression analysis failed. '",
      outcome_variable,
      "' must be configured as a factor."
    )
  )
}


actual_outcome_levels <- levels(
  heart_failure[[outcome_variable]]
)

if (!identical(
  actual_outcome_levels,
  outcome_labels
)) {
  stop(
    paste0(
      "Regression analysis failed. Unexpected factor levels ",
      "for '",
      outcome_variable,
      "'. Check script 01."
    )
  )
}


no_event_label <- outcome_labels[1]
event_label <- outcome_labels[2]


# ============================================================
# 4. Verify regression variables
# ============================================================

missing_regression_variables <- setdiff(
  regression_variables,
  names(heart_failure)
)

if (length(missing_regression_variables) > 0) {
  stop(
    paste0(
      "Regression analysis failed. Missing baseline variable(s): ",
      paste(
        missing_regression_variables,
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
      "Regression analysis failed. Non-numeric baseline ",
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


categorical_class_check <- vapply(
  heart_failure[
    baseline_categorical_variables
  ],
  is.factor,
  logical(1)
)

if (!all(categorical_class_check)) {
  stop(
    paste0(
      "Regression analysis failed. Non-factor baseline ",
      "categorical variable(s) detected: ",
      paste(
        names(categorical_class_check)[
          !categorical_class_check
        ],
        collapse = ", "
      )
    )
  )
}


non_finite_numerical_values <- vapply(
  heart_failure[
    baseline_numerical_variables
  ],
  function(x) {
    sum(
      !is.na(x) &
        !is.finite(x)
    )
  },
  numeric(1)
)

if (any(non_finite_numerical_values > 0)) {
  stop(
    paste0(
      "Regression analysis failed. Non-finite value(s) ",
      "detected in: ",
      paste(
        names(non_finite_numerical_values)[
          non_finite_numerical_values > 0
        ],
        collapse = ", "
      )
    )
  )
}


# ============================================================
# 5. Document regression reference levels
# ============================================================
#
# For categorical predictors, odds ratios compare each
# displayed coefficient level with the factor reference level.
#
# The modeled outcome event is:
#
# "Death event recorded"
# ============================================================

categorical_reference_levels <- data.frame(
  
  Variable =
    baseline_categorical_variables,
  
  Reference_Level =
    vapply(
      heart_failure[
        baseline_categorical_variables
      ],
      function(x) {
        levels(x)[1]
      },
      character(1)
    ),
  
  stringsAsFactors = FALSE
)


regression_outcome_definition <- data.frame(
  
  Outcome =
    outcome_variable,
  
  Reference_Level =
    no_event_label,
  
  Modeled_Event =
    event_label,
  
  stringsAsFactors = FALSE
)


# ============================================================
# 6. Define regression-result extraction helper
# ============================================================

extract_logistic_results <- function(
    model,
    variable_map = NULL
) {
  
  coefficient_table <- summary(
    model
  )$coefficients
  
  coefficient_table <- coefficient_table[
    row.names(coefficient_table) !=
      "(Intercept)",
    ,
    drop = FALSE
  ]
  
  coefficient_terms <- row.names(
    coefficient_table
  )
  
  if (is.null(variable_map)) {
    
    variables <- coefficient_terms
    
  } else {
    
    variables <- variable_map[
      coefficient_terms
    ]
    
    if (
      any(is.na(variables))
    ) {
      stop(
        paste0(
          "Regression-result extraction failed. ",
          "Unable to map one or more model terms ",
          "to their source variables."
        )
      )
    }
  }
  
  
  estimates <- coefficient_table[
    ,
    "Estimate"
  ]
  
  standard_errors <- coefficient_table[
    ,
    "Std. Error"
  ]
  
  
  data.frame(
    
    Variable =
      unname(variables),
    
    Term =
      coefficient_terms,
    
    N =
      nobs(model),
    
    Coefficient =
      estimates,
    
    Standard_Error =
      standard_errors,
    
    Odds_Ratio =
      exp(
        estimates
      ),
    
    CI_Lower =
      exp(
        estimates -
          1.96 *
          standard_errors
      ),
    
    CI_Upper =
      exp(
        estimates +
          1.96 *
          standard_errors
      ),
    
    P_Value =
      coefficient_table[
        ,
        "Pr(>|z|)"
      ],
    
    stringsAsFactors = FALSE
  )
}


# ============================================================
# 7. Define model-term mapping helper
# ============================================================
#
# model.matrix() provides a robust mapping between generated
# coefficient terms and their originating model variables.
# ============================================================

create_term_variable_map <- function(
    model
) {
  
  model_matrix <- model.matrix(
    model
  )
  
  assignment <- attr(
    model_matrix,
    "assign"
  )
  
  term_labels <- attr(
    terms(model),
    "term.labels"
  )
  
  non_intercept <- assignment > 0
  
  mapped_terms <- colnames(
    model_matrix
  )[
    non_intercept
  ]
  
  mapped_variables <- term_labels[
    assignment[
      non_intercept
    ]
  ]
  
  setNames(
    mapped_variables,
    mapped_terms
  )
}


# ============================================================
# 8. Fit univariable logistic regression models
# ============================================================
#
# Each model contains one baseline patient characteristic.
#
# Univariable models are descriptive inferential analyses.
# Their p-values are nominal and are not used to determine
# inclusion in the full multivariable model.
# ============================================================

fit_univariable_model <- function(
    variable
) {
  
  model_variables <- c(
    outcome_variable,
    variable
  )
  
  complete_index <- complete.cases(
    heart_failure[
      model_variables
    ]
  )
  
  model_data <- droplevels(
    heart_failure[
      complete_index,
      model_variables,
      drop = FALSE
    ]
  )
  
  
  if (
    nrow(model_data) == 0
  ) {
    stop(
      paste0(
        "Univariable regression failed for '",
        variable,
        "'. No complete observations are available."
      )
    )
  }
  
  
  if (
    nlevels(
      model_data[[outcome_variable]]
    ) != 2
  ) {
    stop(
      paste0(
        "Univariable regression failed for '",
        variable,
        "'. Both outcome levels must be represented."
      )
    )
  }
  
  
  if (
    is.factor(
      model_data[[variable]]
    ) &&
    nlevels(
      model_data[[variable]]
    ) < 2
  ) {
    stop(
      paste0(
        "Univariable regression failed for '",
        variable,
        "'. At least two observed predictor levels ",
        "are required."
      )
    )
  }
  
  
  model <- glm(
    reformulate(
      variable,
      response = outcome_variable
    ),
    data = model_data,
    family = binomial()
  )
  
  
  if (!model$converged) {
    warning(
      paste0(
        "Univariable logistic regression did not converge ",
        "for variable '",
        variable,
        "'."
      )
    )
  }
  
  
  term_map <- create_term_variable_map(
    model
  )
  
  
  results <- extract_logistic_results(
    model = model,
    variable_map = term_map
  )
  
  
  list(
    Model =
      model,
    
    Results =
      results
  )
}


univariable_model_objects <- lapply(
  regression_variables,
  fit_univariable_model
)

names(
  univariable_model_objects
) <- regression_variables


univariable_models <- lapply(
  univariable_model_objects,
  function(x) {
    x$Model
  }
)


univariable_results <- do.call(
  rbind,
  lapply(
    univariable_model_objects,
    function(x) {
      x$Results
    }
  )
)

row.names(
  univariable_results
) <- NULL


univariable_results$Nominal_P_Below_Alpha <-
  univariable_results$P_Value <
  regression_alpha


nominal_univariable_results_below_alpha <-
  univariable_results[
    univariable_results$
      Nominal_P_Below_Alpha,
    ,
    drop = FALSE
  ]


# ============================================================
# 9. Prepare common analytical data for full model
# ============================================================
#
# The full model uses complete observations across all
# available baseline variables and the binary outcome.
#
# In the current UCI dataset this corresponds to the complete
# observed dataset, but the rule is made explicit for
# reproducibility and future reuse.
# ============================================================

full_model_variables <- c(
  outcome_variable,
  regression_variables
)


full_model_complete_index <- complete.cases(
  heart_failure[
    full_model_variables
  ]
)


full_model_data <- droplevels(
  heart_failure[
    full_model_complete_index,
    full_model_variables,
    drop = FALSE
  ]
)


if (
  nrow(full_model_data) == 0
) {
  stop(
    "Full logistic regression failed. No complete observations available."
  )
}


if (
  nlevels(
    full_model_data[[outcome_variable]]
  ) != 2
) {
  stop(
    paste0(
      "Full logistic regression failed. ",
      "Both outcome levels must be represented."
    )
  )
}


full_model_factor_level_check <- vapply(
  full_model_data[
    baseline_categorical_variables
  ],
  function(x) {
    nlevels(x) >= 2
  },
  logical(1)
)


if (!all(
  full_model_factor_level_check
)) {
  stop(
    paste0(
      "Full logistic regression failed. Baseline categorical ",
      "variable(s) with fewer than two observed levels: ",
      paste(
        names(full_model_factor_level_check)[
          !full_model_factor_level_check
        ],
        collapse = ", "
      )
    )
  )
}


# ============================================================
# 10. Fit full multivariable logistic regression
# ============================================================

binary_outcome_model <- glm(
  reformulate(
    regression_variables,
    response = outcome_variable
  ),
  data = full_model_data,
  family = binomial()
)


if (!binary_outcome_model$converged) {
  warning(
    paste0(
      "The full multivariable logistic regression model ",
      "did not converge."
    )
  )
}


# ============================================================
# 11. Extract multivariable regression results
# ============================================================

multivariable_term_map <- create_term_variable_map(
  binary_outcome_model
)


multivariable_results <- extract_logistic_results(
  model = binary_outcome_model,
  variable_map = multivariable_term_map
)


multivariable_results$Nominal_P_Below_Alpha <-
  multivariable_results$P_Value <
  regression_alpha


nominal_multivariable_results_below_alpha <-
  multivariable_results[
    multivariable_results$
      Nominal_P_Below_Alpha,
    ,
    drop = FALSE
  ]


# ============================================================
# 12. Verify regression coefficient estimates
# ============================================================

if (
  any(
    !is.finite(
      univariable_results$Coefficient
    )
  ) ||
  any(
    !is.finite(
      multivariable_results$Coefficient
    )
  )
) {
  warning(
    paste0(
      "One or more regression coefficient estimates are ",
      "non-finite. Inspect the fitted models for sparse data ",
      "or separation."
    )
  )
}


# ============================================================
# 13. Define full-model analytical outcome
# ============================================================

model_frame <- model.frame(
  binary_outcome_model
)


observed_binary_outcome <- as.integer(
  model_frame[[outcome_variable]] ==
    event_label
)


fitted_probabilities <- fitted(
  binary_outcome_model
)


if (
  length(observed_binary_outcome) !=
  length(fitted_probabilities)
) {
  stop(
    paste0(
      "Regression-analysis audit failed. Outcome and fitted-",
      "probability vectors have different lengths."
    )
  )
}


# ============================================================
# 14. Fit matching null model
# ============================================================
#
# The null model is fitted to the same analytical observations
# as the full model.
# ============================================================

null_model <- glm(
  reformulate(
    character(0),
    response = outcome_variable
  ),
  data = model_frame,
  family = binomial()
)


# ============================================================
# 15. Calculate in-sample model-fit measures
# ============================================================
#
# These measures describe model behavior in the analytical
# sample used to fit the model.
#
# They are NOT:
#
# - cross-validation
# - external validation
# - clinical validation
# - evidence of real-world predictive performance
# ============================================================

full_log_likelihood <- as.numeric(
  logLik(
    binary_outcome_model
  )
)

null_log_likelihood <- as.numeric(
  logLik(
    null_model
  )
)


mcfadden_r2 <- 1 -
  (
    full_log_likelihood /
      null_log_likelihood
  )


brier_score <- mean(
  (
    fitted_probabilities -
      observed_binary_outcome
  )^2
)


recorded_event_n <- sum(
  observed_binary_outcome
)

no_recorded_event_n <- sum(
  observed_binary_outcome == 0
)


model_parameter_n <- length(
  coef(
    binary_outcome_model
  )
)


model_fit <- data.frame(
  
  Analytical_Sample_N =
    nobs(
      binary_outcome_model
    ),
  
  Excluded_For_Missingness_N =
    nrow(heart_failure) -
    nobs(
      binary_outcome_model
    ),
  
  No_Recorded_Death_Event_N =
    no_recorded_event_n,
  
  Recorded_Death_Event_N =
    recorded_event_n,
  
  Model_Parameters_N =
    model_parameter_n,
  
  Null_Deviance =
    binary_outcome_model$
    null.deviance,
  
  Residual_Deviance =
    binary_outcome_model$
    deviance,
  
  AIC =
    AIC(
      binary_outcome_model
    ),
  
  Log_Likelihood =
    full_log_likelihood,
  
  McFadden_Pseudo_R2 =
    mcfadden_r2,
  
  In_Sample_Brier_Score =
    brier_score,
  
  Converged =
    binary_outcome_model$
    converged,
  
  stringsAsFactors = FALSE
)


# ============================================================
# 16. Basic influence diagnostics
# ============================================================
#
# These thresholds are descriptive screening rules.
#
# Diagnostic flags identify observations for inspection only.
# They are not automatic exclusion criteria and do not
# establish that an observation is erroneous.
# ============================================================

model_n <- nobs(
  binary_outcome_model
)


model_parameters <- length(
  coef(
    binary_outcome_model
  )
)


cook_threshold <- 4 /
  model_n


leverage_threshold <-
  2 *
  model_parameters /
  model_n


residual_threshold <- 3


regression_diagnostics <- data.frame(
  
  Observation =
    row.names(
      model_frame
    ),
  
  Observed_Binary_Outcome =
    observed_binary_outcome,
  
  In_Sample_Fitted_Probability =
    fitted_probabilities,
  
  Cooks_Distance =
    cooks.distance(
      binary_outcome_model
    ),
  
  Leverage =
    hatvalues(
      binary_outcome_model
    ),
  
  Standardized_Deviance_Residual =
    rstandard(
      binary_outcome_model,
      type = "deviance"
    ),
  
  stringsAsFactors = FALSE
)


regression_diagnostics$High_Cooks_Distance <-
  regression_diagnostics$
  Cooks_Distance >
  cook_threshold


regression_diagnostics$High_Leverage <-
  regression_diagnostics$
  Leverage >
  leverage_threshold


regression_diagnostics$Large_Residual <-
  abs(
    regression_diagnostics$
      Standardized_Deviance_Residual
  ) >
  residual_threshold


regression_diagnostics$Any_Flag <-
  regression_diagnostics$
  High_Cooks_Distance |
  regression_diagnostics$
  High_Leverage |
  regression_diagnostics$
  Large_Residual


regression_diagnostic_thresholds <- data.frame(
  
  Diagnostic = c(
    "Cook's distance",
    "Leverage",
    "Absolute standardized deviance residual"
  ),
  
  Screening_Threshold = c(
    cook_threshold,
    leverage_threshold,
    residual_threshold
  ),
  
  stringsAsFactors = FALSE
)


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
# 17. Create presentation versions
# ============================================================
#
# Statistical calculations and nominal p-value flags use
# unrounded values.
#
# Rounding is applied only for presentation.
# ============================================================

format_regression_results <- function(
    results,
    digits = 4
) {
  
  display <- results
  
  numeric_columns <- intersect(
    c(
      "Coefficient",
      "Standard_Error",
      "Odds_Ratio",
      "CI_Lower",
      "CI_Upper"
    ),
    names(display)
  )
  
  
  display[
    numeric_columns
  ] <- lapply(
    display[
      numeric_columns
    ],
    round,
    digits = digits
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
    univariable_results
  )


multivariable_results_display <-
  format_regression_results(
    multivariable_results
  )


model_fit_display <- model_fit


model_fit_numeric_columns <- c(
  "Null_Deviance",
  "Residual_Deviance",
  "AIC",
  "Log_Likelihood",
  "McFadden_Pseudo_R2",
  "In_Sample_Brier_Score"
)


model_fit_display[
  model_fit_numeric_columns
] <- lapply(
  model_fit_display[
    model_fit_numeric_columns
  ],
  round,
  digits = 4
)


diagnostic_thresholds_display <-
  regression_diagnostic_thresholds


diagnostic_thresholds_display$
  Screening_Threshold <- round(
    diagnostic_thresholds_display$
      Screening_Threshold,
    digits = 4
  )


# ============================================================
# 18. Consolidate regression results
# ============================================================

regression_analysis <- list(
  
  Outcome_Definition =
    regression_outcome_definition,
  
  Categorical_Reference_Levels =
    categorical_reference_levels,
  
  Regression_Variables =
    regression_variables,
  
  Univariable_Models =
    univariable_models,
  
  Univariable_Results =
    univariable_results,
  
  Nominal_Univariable_Results_Below_Alpha =
    nominal_univariable_results_below_alpha,
  
  Full_Binary_Outcome_Model =
    binary_outcome_model,
  
  Multivariable_Results =
    multivariable_results,
  
  Nominal_Multivariable_Results_Below_Alpha =
    nominal_multivariable_results_below_alpha,
  
  Model_Fit =
    model_fit,
  
  Diagnostic_Thresholds =
    regression_diagnostic_thresholds,
  
  Diagnostics =
    regression_diagnostics,
  
  Diagnostic_Summary =
    regression_diagnostic_summary
)


# ============================================================
# 19. Display regression results
# ============================================================

cat(
  "\n",
  "============================================================\n",
  "LOGISTIC REGRESSION ANALYSIS\n",
  "============================================================\n",
  sep = ""
)


cat(
  "\nMODELED OUTCOME\n"
)

print(
  regression_outcome_definition,
  row.names = FALSE
)


cat(
  "\nCATEGORICAL PREDICTOR REFERENCE LEVELS\n"
)

print(
  categorical_reference_levels,
  row.names = FALSE
)


cat(
  "\nUNIVARIABLE LOGISTIC REGRESSION\n"
)

print(
  univariable_results_display,
  row.names = FALSE
)


cat(
  "\nFULL MULTIVARIABLE LOGISTIC REGRESSION\n"
)

print(
  multivariable_results_display,
  row.names = FALSE
)


cat(
  "\nIN-SAMPLE MODEL BEHAVIOR\n"
)

print(
  model_fit_display,
  row.names = FALSE
)


cat(
  "\nINFLUENCE-DIAGNOSTIC SCREENING THRESHOLDS\n"
)

print(
  diagnostic_thresholds_display,
  row.names = FALSE
)


cat(
  "\nINFLUENCE-DIAGNOSTIC SUMMARY\n"
)

print(
  regression_diagnostic_summary,
  row.names = FALSE
)


# ============================================================
# 20. Interpretation note
# ============================================================

cat(
  "\nINTERPRETATION NOTE\n",
  "\n",
  "The logistic regressions model whether a death event was ",
  "recorded during each patient's observed follow-up period.\n",
  "\n",
  "Because follow-up duration varies between patients, these ",
  "models must not be interpreted as validated fixed-horizon ",
  "mortality-risk or survival models.\n",
  "\n",
  "All available baseline characteristics are included in the ",
  "full multivariable model. Variable inclusion is not based ",
  "on group-comparison p-values, exploratory correlations, or ",
  "univariable regression significance.\n",
  "\n",
  "For continuous predictors, odds ratios correspond to a ",
  "one-unit increase on the original measurement scale. For ",
  "categorical predictors, odds ratios compare the displayed ",
  "factor level with its documented reference level.\n",
  "\n",
  "Regression p-values are nominal. A p-value below alpha is ",
  "reported descriptively and must not be confused with the ",
  "Benjamini-Hochberg-adjusted group-level inference performed ",
  "in script 06.\n",
  "\n",
  "Adjusted associations are conditional on the baseline ",
  "information represented in this dataset and do not ",
  "establish causal effects.\n",
  "\n",
  "Model-fit measures and fitted probabilities are calculated ",
  "in the same sample used to fit the model. They describe ",
  "in-sample model behavior and do not constitute internal ",
  "resampling validation, external validation, clinical ",
  "validation, or evidence of real-world predictive ",
  "performance.\n",
  "\n",
  "Diagnostic flags identify observations for inspection only ",
  "and do not justify automatic exclusion.\n",
  "\n",
  "The project does not claim that this logistic model is a ",
  "clinically validated mortality-prediction system. Its main ",
  "role is to provide a transparent statistical framework for ",
  "the representation-sensitivity analysis performed in ",
  "09_representation_sensitivity_analysis.R.\n",
  sep = ""
)


# ============================================================
# 21. Return complete regression-analysis object
# ============================================================

regression_analysis

