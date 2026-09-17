# ============================================================
# Project: Representation Sensitivity Analysis
#          in Heart Failure with R
# File: 09_representation_sensitivity_analysis.R
# Purpose: Evaluate how in-sample statistical model outputs
#          change when the amount or granularity of patient
#          information supplied to the model changes while
#          the underlying analytical patient sample is held
#          constant.
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
# 2. Verify recorded death-event outcome configuration
# ============================================================

if (!is.factor(
  heart_failure[[outcome_variable]]
)) {
  stop(
    paste0(
      "Representation-sensitivity analysis failed. '",
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
      "Representation-sensitivity analysis failed. ",
      "Unexpected factor levels for '",
      outcome_variable,
      "'. Check script 01."
    )
  )
}

no_event_label <- outcome_labels[1]
event_label <- outcome_labels[2]

representation_alpha <- 0.05


# ============================================================
# 3. Define nested patient-representation layers
# ============================================================
#
# The layers are project-defined analytical constructions.
#
# They are NOT:
#
# - validated clinical representation levels
# - rankings of clinical importance
# - patient-completeness scores
# - measurements of representation quality
# - a progression toward a complete real-world patient
#
# Their purpose is to create controlled differences in the
# amount of baseline patient information available to the
# statistical model.
# ============================================================

representation_layers <- list(
  
  Layer_1 = c(
    "age",
    "sex"
  ),
  
  Layer_2 = c(
    "age",
    "sex",
    "anaemia",
    "diabetes",
    "high_blood_pressure",
    "smoking"
  ),
  
  Layer_3 = c(
    "age",
    "sex",
    "anaemia",
    "diabetes",
    "high_blood_pressure",
    "smoking",
    "ejection_fraction",
    "serum_creatinine",
    "serum_sodium"
  ),
  
  Layer_4 = c(
    "age",
    "sex",
    "anaemia",
    "diabetes",
    "high_blood_pressure",
    "smoking",
    "ejection_fraction",
    "serum_creatinine",
    "serum_sodium",
    "creatinine_phosphokinase",
    "platelets"
  )
)


representation_layer_descriptions <- c(
  
  Layer_1 =
    "Basic demographic representation",
  
  Layer_2 =
    "Demographics, comorbidities and risk factors",
  
  Layer_3 =
    "Expanded clinical representation",
  
  Layer_4 =
    "Full available baseline representation"
)


# ============================================================
# 4. Validate representation-layer structure
# ============================================================

all_layer_variables <- unique(
  unlist(
    representation_layers,
    use.names = FALSE
  )
)

missing_layer_variables <- setdiff(
  all_layer_variables,
  names(heart_failure)
)

if (length(missing_layer_variables) > 0) {
  stop(
    paste0(
      "Representation-layer validation failed. Missing ",
      "variable(s): ",
      paste(
        missing_layer_variables,
        collapse = ", "
      )
    )
  )
}


duplicate_variables_within_layers <- vapply(
  representation_layers,
  function(x) {
    anyDuplicated(x) > 0
  },
  logical(1)
)

if (any(
  duplicate_variables_within_layers
)) {
  stop(
    paste0(
      "Representation-layer validation failed. Duplicate ",
      "variable(s) detected within: ",
      paste(
        names(
          duplicate_variables_within_layers
        )[
          duplicate_variables_within_layers
        ],
        collapse = ", "
      )
    )
  )
}


layer_names <- names(
  representation_layers
)

for (
  i in seq_len(
    length(representation_layers) - 1
  )
) {
  
  reduced_layer <-
    representation_layers[
      [i]
    ]
  
  expanded_layer <-
    representation_layers[
      [i + 1]
    ]
  
  if (!all(
    reduced_layer %in%
    expanded_layer
  )) {
    stop(
      paste0(
        "Representation-layer validation failed. ",
        layer_names[i],
        " is not fully nested within ",
        layer_names[i + 1],
        "."
      )
    )
  }
}


if (!setequal(
  representation_layers$Layer_4,
  baseline_variables
)) {
  stop(
    paste0(
      "Representation-layer validation failed. Layer 4 ",
      "must contain the complete available baseline ",
      "variable set defined in script 01."
    )
  )
}


representation_layer_overview <- data.frame(
  
  Layer =
    layer_names,
  
  Description =
    unname(
      representation_layer_descriptions[
        layer_names
      ]
    ),
  
  Number_of_Variables =
    vapply(
      representation_layers,
      length,
      numeric(1)
    ),
  
  Variables =
    vapply(
      representation_layers,
      paste,
      collapse = ", ",
      FUN.VALUE = character(1)
    ),
  
  stringsAsFactors = FALSE
)


# ============================================================
# 5. Create common analytical patient sample
# ============================================================
#
# Every representation model is fitted to the SAME patient
# records.
#
# This is essential because observed differences between
# models should reflect changes in the information supplied
# to the model rather than changes in the analyzed sample.
#
# Complete observations are required across:
#
# - all Layer 4 baseline variables
# - the recorded binary outcome
#
# Non-finite numerical baseline values are also excluded.
# ============================================================

common_sample_variables <- c(
  representation_layers$Layer_4,
  outcome_variable
)


complete_case_index <- complete.cases(
  heart_failure[
    common_sample_variables
  ]
)


finite_numerical_index <- Reduce(
  `&`,
  lapply(
    baseline_numerical_variables,
    function(variable) {
      is.finite(
        heart_failure[[variable]]
      )
    }
  )
)


representation_sample_index <-
  complete_case_index &
  finite_numerical_index


representation_data <- droplevels(
  heart_failure[
    representation_sample_index,
    ,
    drop = FALSE
  ]
)


if (
  nrow(representation_data) == 0
) {
  stop(
    paste0(
      "Representation-sensitivity analysis failed. ",
      "No complete finite analytical observations remain."
    )
  )
}


if (
  nlevels(
    representation_data[
      [outcome_variable]
    ]
  ) != 2
) {
  stop(
    paste0(
      "Representation-sensitivity analysis failed. ",
      "Both outcome levels must be represented in the ",
      "common analytical sample."
    )
  )
}


representation_sample_overview <- data.frame(
  
  Original_Sample_N =
    nrow(heart_failure),
  
  Common_Analytical_Sample_N =
    nrow(representation_data),
  
  Excluded_For_Missing_or_Nonfinite_Data_N =
    nrow(heart_failure) -
    nrow(representation_data),
  
  No_Recorded_Death_Event_N =
    sum(
      representation_data[
        [outcome_variable]
      ] ==
        no_event_label
    ),
  
  Recorded_Death_Event_N =
    sum(
      representation_data[
        [outcome_variable]
      ] ==
        event_label
    ),
  
  stringsAsFactors = FALSE
)


# ============================================================
# 6. Define observed binary outcome
# ============================================================
#
# The modeled event is:
#
# "Death event recorded"
#
# This binary outcome must not be interpreted as a validated
# fixed-horizon mortality-risk outcome because follow-up
# duration varies between patients.
# ============================================================

observed_binary_outcome <- as.integer(
  representation_data[
    [outcome_variable]
  ] ==
    event_label
)


# ============================================================
# 7. Fit nested representation models
# ============================================================

representation_models <- lapply(
  representation_layers,
  function(variables) {
    
    glm(
      reformulate(
        variables,
        response = outcome_variable
      ),
      data = representation_data,
      family = binomial()
    )
  }
)


model_convergence <- vapply(
  representation_models,
  function(model) {
    model$converged
  },
  logical(1)
)


if (any(!model_convergence)) {
  warning(
    paste0(
      "At least one representation model did not converge: ",
      paste(
        names(model_convergence)[
          !model_convergence
        ],
        collapse = ", "
      )
    )
  )
}


model_sample_sizes <- vapply(
  representation_models,
  nobs,
  numeric(1)
)


if (
  length(
    unique(
      model_sample_sizes
    )
  ) != 1 ||
  unique(
    model_sample_sizes
  ) !=
  nrow(representation_data)
) {
  stop(
    paste0(
      "Representation-sensitivity audit failed. ",
      "Representation models do not use the same ",
      "analytical patient sample."
    )
  )
}


# ============================================================
# 8. Fit common null model
# ============================================================
#
# The null model uses the same common analytical sample and
# is used only to calculate comparable in-sample McFadden
# pseudo-R² values.
# ============================================================

representation_null_model <- glm(
  reformulate(
    character(0),
    response = outcome_variable
  ),
  data = representation_data,
  family = binomial()
)


# ============================================================
# 9. Define in-sample model-evaluation helper
# ============================================================
#
# All measures describe model behavior in the SAME sample
# used to fit the corresponding model.
#
# They do NOT constitute:
#
# - cross-validation
# - external validation
# - clinical validation
# - evidence of real-world predictive performance
# ============================================================

evaluate_representation_model <- function(
    model
) {
  
  fitted_probabilities <- fitted(
    model
  )
  
  full_log_likelihood <- as.numeric(
    logLik(
      model
    )
  )
  
  null_log_likelihood <- as.numeric(
    logLik(
      representation_null_model
    )
  )
  
  data.frame(
    
    Analytical_Sample_N =
      nobs(model),
    
    Predictor_Parameters_N =
      length(
        coef(model)
      ) - 1,
    
    AIC =
      AIC(model),
    
    Residual_Deviance =
      model$deviance,
    
    Log_Likelihood =
      full_log_likelihood,
    
    McFadden_Pseudo_R2 =
      1 -
      (
        full_log_likelihood /
          null_log_likelihood
      ),
    
    In_Sample_Brier_Score =
      mean(
        (
          fitted_probabilities -
            observed_binary_outcome
        )^2
      ),
    
    Converged =
      model$converged,
    
    stringsAsFactors = FALSE
  )
}


# ============================================================
# 10. Compare representation-model behavior
# ============================================================

representation_model_comparison <- do.call(
  rbind,
  lapply(
    layer_names,
    function(layer) {
      
      data.frame(
        
        Layer =
          layer,
        
        Description =
          representation_layer_descriptions[
            [layer]
          ],
        
        Variables_N =
          length(
            representation_layers[
              [layer]
            ]
          ),
        
        evaluate_representation_model(
          representation_models[
            [layer]
          ]
        ),
        
        stringsAsFactors = FALSE
      )
    }
  )
)

row.names(
  representation_model_comparison
) <- NULL


# ============================================================
# 11. Compare sequential information additions
# ============================================================
#
# Because the representation layers are nested and fitted to
# the same analytical patient sample, likelihood-ratio tests
# can compare each reduced model with the next expanded model.
#
# The p-values are exploratory and nominal.
#
# A statistically detectable improvement in model fit does
# NOT establish:
#
# - clinical necessity of the added information
# - superiority of the expanded representation
# - representation validity
# - decision validity
# ============================================================

layer_pairs <- list(
  c(
    "Layer_1",
    "Layer_2"
  ),
  c(
    "Layer_2",
    "Layer_3"
  ),
  c(
    "Layer_3",
    "Layer_4"
  )
)


sequential_representation_tests <- do.call(
  rbind,
  lapply(
    layer_pairs,
    function(pair) {
      
      reduced_layer <- pair[1]
      expanded_layer <- pair[2]
      
      reduced_model <-
        representation_models[
          [reduced_layer]
        ]
      
      expanded_model <-
        representation_models[
          [expanded_layer]
        ]
      
      
      if (
        nobs(reduced_model) !=
        nobs(expanded_model)
      ) {
        stop(
          paste0(
            "Sequential representation comparison failed. ",
            reduced_layer,
            " and ",
            expanded_layer,
            " use different sample sizes."
          )
        )
      }
      
      
      test <- anova(
        reduced_model,
        expanded_model,
        test = "LRT"
      )
      
      
      p_value <-
        test$`Pr(>Chi)`[2]
      
      
      data.frame(
        
        Comparison =
          paste(
            reduced_layer,
            "->",
            expanded_layer
          ),
        
        Added_Variables =
          paste(
            setdiff(
              representation_layers[
                [expanded_layer]
              ],
              representation_layers[
                [reduced_layer]
              ]
            ),
            collapse = ", "
          ),
        
        Degrees_of_Freedom =
          test$Df[2],
        
        Deviance_Change =
          test$Deviance[2],
        
        P_Value_Nominal =
          p_value,
        
        Nominal_P_Below_Alpha =
          p_value <
          representation_alpha,
        
        stringsAsFactors = FALSE
      )
    }
  )
)

row.names(
  sequential_representation_tests
) <- NULL


# ============================================================
# 12. Extract coefficients across representation layers
# ============================================================
#
# Coefficients are collected to evaluate whether estimated
# associations change when additional patient information
# becomes available to the model.
#
# Coefficient changes can reflect:
#
# - additional adjustment
# - correlations among predictors
# - model specification
# - differences in available information
#
# They are not interpreted causally.
# ============================================================

representation_coefficient_summary <- do.call(
  rbind,
  lapply(
    layer_names,
    function(layer) {
      
      coefficient_table <- summary(
        representation_models[
          [layer]
        ]
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
        
        Layer =
          layer,
        
        Term =
          row.names(
            coefficient_table
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
        
        Odds_Ratio =
          exp(
            coefficient_table[
              ,
              "Estimate"
            ]
          ),
        
        P_Value_Nominal =
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
  representation_coefficient_summary
) <- NULL


# ============================================================
# 13. Summarize coefficient stability
# ============================================================
#
# Only model terms appearing in at least two representation
# models are included.
#
# Coefficient range describes observed variation across the
# project-defined representation layers.
# ============================================================

shared_terms <- unique(
  representation_coefficient_summary$
    Term
)


coefficient_stability_list <- lapply(
  shared_terms,
  function(term) {
    
    term_results <-
      representation_coefficient_summary[
        representation_coefficient_summary$
          Term ==
          term,
        ,
        drop = FALSE
      ]
    
    
    if (
      nrow(term_results) < 2
    ) {
      return(
        NULL
      )
    }
    
    
    data.frame(
      
      Term =
        term,
      
      Models_N =
        nrow(
          term_results
        ),
      
      First_Layer =
        term_results$Layer[1],
      
      Last_Layer =
        term_results$Layer[
          nrow(
            term_results
          )
        ],
      
      First_Coefficient =
        term_results$Coefficient[1],
      
      Last_Coefficient =
        term_results$Coefficient[
          nrow(
            term_results
          )
        ],
      
      Minimum_Coefficient =
        min(
          term_results$Coefficient
        ),
      
      Maximum_Coefficient =
        max(
          term_results$Coefficient
        ),
      
      Coefficient_Range =
        max(
          term_results$Coefficient
        ) -
        min(
          term_results$Coefficient
        ),
      
      Sign_Change_Observed =
        min(
          term_results$Coefficient
        ) < 0 &&
        max(
          term_results$Coefficient
        ) > 0,
      
      stringsAsFactors = FALSE
    )
  }
)


coefficient_stability_list <-
  coefficient_stability_list[
    !vapply(
      coefficient_stability_list,
      is.null,
      logical(1)
    )
  ]


coefficient_stability_summary <- do.call(
  rbind,
  coefficient_stability_list
)

row.names(
  coefficient_stability_summary
) <- NULL


# ============================================================
# 14. Generate patient-level in-sample fitted probabilities
# ============================================================
#
# Each row refers to the same analytical patient record across
# all representation models.
# ============================================================

representation_fitted_probabilities <- data.frame(
  
  Observation =
    row.names(
      representation_data
    ),
  
  Recorded_Death_Event =
    observed_binary_outcome,
  
  check.names = FALSE
)


for (
  layer in layer_names
) {
  
  representation_fitted_probabilities[
    [layer]
  ] <- fitted(
    representation_models[
      [layer]
    ]
  )
}


# ============================================================
# 15. Verify fitted-probability alignment
# ============================================================

probability_lengths <- vapply(
  representation_fitted_probabilities[
    layer_names
  ],
  length,
  numeric(1)
)


if (
  any(
    probability_lengths !=
    nrow(
      representation_data
    )
  )
) {
  stop(
    paste0(
      "Representation-sensitivity audit failed. ",
      "Fitted-probability vectors are not aligned with ",
      "the common analytical sample."
    )
  )
}


# ============================================================
# 16. Evaluate fitted-probability sensitivity
# ============================================================
#
# Reduced representations are compared with Layer 4.
#
# Layer 4 is used only as the analytical reference because it
# contains the full available baseline variable set.
#
# Layer 4 is NOT:
#
# - ground truth
# - the real patient
# - a clinically validated representation
#
# Therefore, these quantities measure OUTPUT SENSITIVITY
# RELATIVE TO AN ANALYTICAL REFERENCE.
#
# They do not measure prediction error relative to a clinically
# correct patient representation.
# ============================================================

reduced_layers <- setdiff(
  layer_names,
  "Layer_4"
)


fitted_probability_sensitivity <- do.call(
  rbind,
  lapply(
    reduced_layers,
    function(layer) {
      
      reduced_probability <-
        representation_fitted_probabilities[
          [layer]
        ]
      
      reference_probability <-
        representation_fitted_probabilities$
        Layer_4
      
      probability_difference <-
        reduced_probability -
        reference_probability
      
      
      data.frame(
        
        Comparison =
          paste(
            layer,
            "vs Layer_4"
          ),
        
        Analytical_Reference =
          "Layer_4",
        
        Mean_Signed_Difference =
          mean(
            probability_difference
          ),
        
        Mean_Absolute_Difference =
          mean(
            abs(
              probability_difference
            )
          ),
        
        RMSE =
          sqrt(
            mean(
              probability_difference^2
            )
          ),
        
        Maximum_Absolute_Difference =
          max(
            abs(
              probability_difference
            )
          ),
        
        Spearman_Correlation =
          cor(
            reduced_probability,
            reference_probability,
            method = "spearman"
          ),
        
        stringsAsFactors = FALSE
      )
    }
  )
)

row.names(
  fitted_probability_sensitivity
) <- NULL


# ============================================================
# 17. Illustrative classification sensitivity
# ============================================================
#
# A fixed threshold of 0.50 is used only as a methodological
# demonstration.
#
# It is NOT:
#
# - a clinical threshold
# - a treatment threshold
# - a triage threshold
# - a management threshold
# - a validated risk threshold
#
# The purpose is only to show that representation changes can
# alter a downstream binary classification under a fixed
# analytical rule.
# ============================================================

illustrative_threshold <- 0.50


layer_4_classification <-
  representation_fitted_probabilities$
  Layer_4 >=
  illustrative_threshold


representation_classification_sensitivity <- do.call(
  rbind,
  lapply(
    reduced_layers,
    function(layer) {
      
      reduced_classification <-
        representation_fitted_probabilities[
          [layer]
        ] >=
        illustrative_threshold
      
      classification_changed <-
        reduced_classification !=
        layer_4_classification
      
      
      data.frame(
        
        Comparison =
          paste(
            layer,
            "vs Layer_4"
          ),
        
        Threshold =
          illustrative_threshold,
        
        Classification_Changed_N =
          sum(
            classification_changed
          ),
        
        Classification_Changed_Percentage =
          mean(
            classification_changed
          ) *
          100,
        
        stringsAsFactors = FALSE
      )
    }
  )
)

row.names(
  representation_classification_sensitivity
) <- NULL


# ============================================================
# 18. Create simplified ejection-fraction representation
# ============================================================
#
# Representation sensitivity can arise not only when patient
# variables are absent, but also when available information is
# represented with reduced granularity.
#
# Ejection fraction is therefore compared as:
#
# - its original continuous value
# - a median-based binary representation
#
# The sample median is an arbitrary, non-clinical
# methodological cutoff.
#
# It is NOT interpreted as a validated clinical threshold.
# ============================================================

ejection_fraction_cutoff <- median(
  representation_data$
    ejection_fraction
)


representation_data$
  ejection_fraction_binary <- factor(
    ifelse(
      representation_data$
        ejection_fraction <=
        ejection_fraction_cutoff,
      "At_or_below_sample_median",
      "Above_sample_median"
    ),
    levels = c(
      "At_or_below_sample_median",
      "Above_sample_median"
    )
  )


if (
  nlevels(
    droplevels(
      representation_data$
      ejection_fraction_binary
    )
  ) != 2
) {
  stop(
    paste0(
      "Ejection-fraction simplification failed. ",
      "Both binary representation levels must be ",
      "represented in the analytical sample."
    )
  )
}


simplified_representation_variables <- c(
  setdiff(
    representation_layers$
      Layer_4,
    "ejection_fraction"
  ),
  "ejection_fraction_binary"
)


# ============================================================
# 19. Fit simplified ejection-fraction model
# ============================================================

simplified_ejection_fraction_model <- glm(
  reformulate(
    simplified_representation_variables,
    response = outcome_variable
  ),
  data = representation_data,
  family = binomial()
)


if (
  !simplified_ejection_fraction_model$
  converged
) {
  warning(
    paste0(
      "The simplified ejection-fraction model did not ",
      "converge."
    )
  )
}


if (
  nobs(
    simplified_ejection_fraction_model
  ) !=
  nrow(
    representation_data
  )
) {
  stop(
    paste0(
      "Ejection-fraction simplification audit failed. ",
      "Continuous and simplified representations do not ",
      "use the same analytical patient sample."
    )
  )
}


# ============================================================
# 20. Compare continuous and simplified representations
# ============================================================
#
# This comparison evaluates information simplification.
#
# It does not claim that either representation is clinically
# superior.
# ============================================================

ejection_fraction_model_comparison <- rbind(
  
  data.frame(
    
    Representation =
      "Continuous ejection fraction",
    
    evaluate_representation_model(
      representation_models$
        Layer_4
    ),
    
    stringsAsFactors = FALSE
  ),
  
  data.frame(
    
    Representation =
      "Median-based binary ejection fraction",
    
    evaluate_representation_model(
      simplified_ejection_fraction_model
    ),
    
    stringsAsFactors = FALSE
  )
)

row.names(
  ejection_fraction_model_comparison
) <- NULL


# ============================================================
# 21. Evaluate fitted-probability sensitivity to
#     ejection-fraction simplification
# ============================================================

continuous_ef_probability <- fitted(
  representation_models$
    Layer_4
)


simplified_ef_probability <- fitted(
  simplified_ejection_fraction_model
)


ef_probability_difference <-
  simplified_ef_probability -
  continuous_ef_probability


ejection_fraction_probability_sensitivity <- data.frame(
  
  Comparison =
    "Median-based binary vs continuous ejection fraction",
  
  Mean_Signed_Difference =
    mean(
      ef_probability_difference
    ),
  
  Mean_Absolute_Difference =
    mean(
      abs(
        ef_probability_difference
      )
    ),
  
  RMSE =
    sqrt(
      mean(
        ef_probability_difference^2
      )
    ),
  
  Maximum_Absolute_Difference =
    max(
      abs(
        ef_probability_difference
      )
    ),
  
  Spearman_Correlation =
    cor(
      simplified_ef_probability,
      continuous_ef_probability,
      method = "spearman"
    ),
  
  stringsAsFactors = FALSE
)


# ============================================================
# 22. Evaluate illustrative classification sensitivity to
#     ejection-fraction simplification
# ============================================================

continuous_ef_classification <-
  continuous_ef_probability >=
  illustrative_threshold


simplified_ef_classification <-
  simplified_ef_probability >=
  illustrative_threshold


ef_classification_changed <-
  simplified_ef_classification !=
  continuous_ef_classification


ejection_fraction_classification_sensitivity <- data.frame(
  
  Comparison =
    "Median-based binary vs continuous ejection fraction",
  
  Threshold =
    illustrative_threshold,
  
  Classification_Changed_N =
    sum(
      ef_classification_changed
    ),
  
  Classification_Changed_Percentage =
    mean(
      ef_classification_changed
    ) *
    100,
  
  stringsAsFactors = FALSE
)


# ============================================================
# 23. Create presentation helper
# ============================================================

round_numeric_columns <- function(
    data,
    digits = 4
) {
  
  display <- data
  
  numeric_columns <- vapply(
    display,
    is.numeric,
    logical(1)
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
  
  display
}


# ============================================================
# 24. Create presentation versions
# ============================================================

representation_model_comparison_display <-
  round_numeric_columns(
    representation_model_comparison
  )


sequential_representation_tests_display <-
  round_numeric_columns(
    sequential_representation_tests
  )

sequential_representation_tests_display$
  P_Value_Nominal <- format.pval(
    sequential_representation_tests$
      P_Value_Nominal,
    digits = 4,
    eps = 0.0001
  )


representation_coefficient_summary_display <-
  round_numeric_columns(
    representation_coefficient_summary
  )

representation_coefficient_summary_display$
  P_Value_Nominal <- format.pval(
    representation_coefficient_summary$
      P_Value_Nominal,
    digits = 4,
    eps = 0.0001
  )


coefficient_stability_summary_display <-
  round_numeric_columns(
    coefficient_stability_summary
  )


fitted_probability_sensitivity_display <-
  round_numeric_columns(
    fitted_probability_sensitivity
  )


representation_classification_sensitivity_display <-
  round_numeric_columns(
    representation_classification_sensitivity
  )


ejection_fraction_model_comparison_display <-
  round_numeric_columns(
    ejection_fraction_model_comparison
  )


ejection_fraction_probability_sensitivity_display <-
  round_numeric_columns(
    ejection_fraction_probability_sensitivity
  )


ejection_fraction_classification_sensitivity_display <-
  round_numeric_columns(
    ejection_fraction_classification_sensitivity
  )


# ============================================================
# 25. Consolidate representation-sensitivity results
# ============================================================

representation_sensitivity_analysis <- list(
  
  Layer_Definitions =
    representation_layers,
  
  Layer_Overview =
    representation_layer_overview,
  
  Common_Sample_Overview =
    representation_sample_overview,
  
  Common_Analytical_Data =
    representation_data,
  
  Representation_Models =
    representation_models,
  
  Model_Comparison =
    representation_model_comparison,
  
  Sequential_Information_Addition_Tests =
    sequential_representation_tests,
  
  Coefficients_Across_Layers =
    representation_coefficient_summary,
  
  Coefficient_Stability =
    coefficient_stability_summary,
  
  Patient_Level_Fitted_Probabilities =
    representation_fitted_probabilities,
  
  Fitted_Probability_Sensitivity =
    fitted_probability_sensitivity,
  
  Illustrative_Classification_Threshold =
    illustrative_threshold,
  
  Classification_Sensitivity =
    representation_classification_sensitivity,
  
  Ejection_Fraction_Simplification_Cutoff =
    ejection_fraction_cutoff,
  
  Ejection_Fraction_Simplified_Model =
    simplified_ejection_fraction_model,
  
  Ejection_Fraction_Model_Comparison =
    ejection_fraction_model_comparison,
  
  Ejection_Fraction_Fitted_Probability_Sensitivity =
    ejection_fraction_probability_sensitivity,
  
  Ejection_Fraction_Classification_Sensitivity =
    ejection_fraction_classification_sensitivity
)


# ============================================================
# 26. Display representation-sensitivity results
# ============================================================

cat(
  "\n",
  "============================================================\n",
  "REPRESENTATION SENSITIVITY ANALYSIS\n",
  "============================================================\n",
  sep = ""
)


cat(
  "\nCOMMON ANALYTICAL SAMPLE\n"
)

print(
  representation_sample_overview,
  row.names = FALSE
)


cat(
  "\nREPRESENTATION LAYERS\n"
)

print(
  representation_layer_overview,
  row.names = FALSE
)


cat(
  "\nIN-SAMPLE MODEL COMPARISON\n"
)

print(
  representation_model_comparison_display,
  row.names = FALSE
)


cat(
  "\nSEQUENTIAL INFORMATION ADDITION\n"
)

print(
  sequential_representation_tests_display,
  row.names = FALSE
)


cat(
  "\nCOEFFICIENT STABILITY\n"
)

print(
  coefficient_stability_summary_display,
  row.names = FALSE
)


cat(
  "\nPATIENT-LEVEL FITTED-PROBABILITY SENSITIVITY\n"
)

print(
  fitted_probability_sensitivity_display,
  row.names = FALSE
)


cat(
  "\nILLUSTRATIVE CLASSIFICATION SENSITIVITY\n"
)

print(
  representation_classification_sensitivity_display,
  row.names = FALSE
)


cat(
  "\nEJECTION-FRACTION SIMPLIFICATION CUTOFF\n"
)

cat(
  "Sample median:",
  round(
    ejection_fraction_cutoff,
    digits = 4
  ),
  "\n"
)


cat(
  "\nEJECTION-FRACTION MODEL COMPARISON\n"
)

print(
  ejection_fraction_model_comparison_display,
  row.names = FALSE
)


cat(
  "\nEJECTION-FRACTION FITTED-PROBABILITY SENSITIVITY\n"
)

print(
  ejection_fraction_probability_sensitivity_display,
  row.names = FALSE
)


cat(
  "\nEJECTION-FRACTION CLASSIFICATION SENSITIVITY\n"
)

print(
  ejection_fraction_classification_sensitivity_display,
  row.names = FALSE
)


# ============================================================
# 27. Final interpretation note
# ============================================================

cat(
  "\nINTERPRETATION NOTE\n",
  "\n",
  "This analysis evaluates representation sensitivity: ",
  "whether statistical model outputs change when the amount ",
  "or granularity of patient information supplied to the ",
  "model changes while the underlying analytical patient ",
  "sample is held constant.\n",
  "\n",
  "The four representation layers are project-defined ",
  "analytical constructions. They are not validated clinical ",
  "representation levels or measures of patient completeness.\n",
  "\n",
  "Layer 4 contains the full available baseline variable set ",
  "in this dataset and is used as an analytical comparison ",
  "reference. It is not the real patient, clinical ground ",
  "truth, or a validated optimal representation.\n",
  "\n",
  "Differences in fitted probabilities relative to Layer 4 ",
  "therefore measure output sensitivity to information ",
  "reduction. They do not measure prediction error relative ",
  "to a clinically correct patient representation.\n",
  "\n",
  "Sequential likelihood-ratio tests use nominal exploratory ",
  "p-values. Improved statistical model fit does not establish ",
  "that added information is clinically necessary or that the ",
  "expanded representation is clinically superior.\n",
  "\n",
  "The 0.50 classification threshold is an illustrative ",
  "analytical rule without clinical, treatment, triage, or ",
  "management meaning.\n",
  "\n",
  "The median-based ejection-fraction representation is an ",
  "intentional information-simplification experiment. The ",
  "sample median is an arbitrary non-clinical cutoff and ",
  "should not be interpreted as a medically validated ",
  "ejection-fraction threshold.\n",
  "\n",
  "All model-fit measures and fitted probabilities are ",
  "evaluated in sample. They do not constitute external ",
  "validation, clinical validation, or evidence of real-world ",
  "predictive performance.\n",
  "\n",
  "Because the binary outcome is observed under variable ",
  "follow-up duration, none of the logistic models should be ",
  "interpreted as validated fixed-horizon mortality-risk or ",
  "survival models.\n",
  "\n",
  "Representation sensitivity demonstrates dependence of ",
  "statistical output on digital patient representation. It ",
  "does not determine which representation is clinically ",
  "correct, sufficient, or decision-valid.\n",
  "\n",
  "Project-level synthesis and interpretation are performed ",
  "in 10_final_synthesis_and_interpretation.R.\n",
  sep = ""
)


# ============================================================
# 28. Return complete representation-sensitivity object
# ============================================================

representation_sensitivity_analysis

