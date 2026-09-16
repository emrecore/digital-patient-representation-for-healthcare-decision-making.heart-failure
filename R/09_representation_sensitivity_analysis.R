# ============================================================
# Project: Digital Patient Representation for
#          Healthcare Decision-Making: Heart Failure
# File: 09_representation_sensitivity_analysis.R
# Purpose: Evaluate how statistical model outputs change when
#          the digital patient representation is modified.
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
# 2. Define nested patient-representation layers
# Each layer contains all information from the previous layer
# plus additional patient-information domains.
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

if (!identical(
  sort(representation_layers$Layer_4),
  sort(baseline_variables)
)) {
  stop(
    "Layer 4 does not match the full available baseline representation."
  )
}


representation_layer_overview <- data.frame(
  
  Layer = names(
    representation_layers
  ),
  
  Number_of_Variables = vapply(
    representation_layers,
    length,
    numeric(1)
  ),
  
  Variables = vapply(
    representation_layers,
    paste,
    collapse = ", ",
    FUN.VALUE = character(1)
  ),
  
  stringsAsFactors = FALSE
)


# ============================================================
# 3. Create common analytical sample
# All representation models use the same patients so that model
# differences reflect information changes rather than changes
# in the analyzed sample.
# ============================================================

representation_data <- heart_failure[
  complete.cases(
    heart_failure[
      c(
        baseline_variables,
        outcome_variable
      )
    ]
  ),
  ,
  drop = FALSE
]

mortality_numeric <- as.integer(
  representation_data[[outcome_variable]]
) - 1


# ============================================================
# 4. Fit representation models
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

if (any(
  !vapply(
    representation_models,
    function(model) model$converged,
    logical(1)
  )
)) {
  warning(
    "At least one representation model did not converge."
  )
}


# ============================================================
# 5. Define model-evaluation helper
# Measures describe in-sample model behavior only.
# ============================================================

representation_null_model <- glm(
  reformulate(
    character(0),
    response = outcome_variable
  ),
  data = representation_data,
  family = binomial()
)


evaluate_model <- function(model) {
  
  probabilities <- predict(
    model,
    type = "response"
  )
  
  data.frame(
    
    N =
      nobs(model),
    
    Predictor_Parameters =
      length(coef(model)) - 1,
    
    AIC =
      AIC(model),
    
    Residual_Deviance =
      model$deviance,
    
    McFadden_Pseudo_R2 =
      1 -
      (
        as.numeric(logLik(model)) /
          as.numeric(
            logLik(
              representation_null_model
            )
          )
      ),
    
    Brier_Score =
      mean(
        (
          probabilities -
            mortality_numeric
        )^2
      ),
    
    Converged =
      model$converged,
    
    stringsAsFactors = FALSE
  )
}


# ============================================================
# 6. Compare representation-model fit
# ============================================================

representation_model_comparison <- do.call(
  rbind,
  lapply(
    names(representation_models),
    function(layer) {
      
      data.frame(
        Layer = layer,
        Variables = length(
          representation_layers[[layer]]
        ),
        evaluate_model(
          representation_models[[layer]]
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
# 7. Compare sequential information additions
# Nested likelihood-ratio tests examine whether each additional
# representation layer improves statistical model fit.
# ============================================================

layer_pairs <- list(
  c("Layer_1", "Layer_2"),
  c("Layer_2", "Layer_3"),
  c("Layer_3", "Layer_4")
)


sequential_representation_tests <- do.call(
  rbind,
  lapply(
    layer_pairs,
    function(pair) {
      
      reduced_layer <- pair[1]
      expanded_layer <- pair[2]
      
      test <- anova(
        representation_models[[reduced_layer]],
        representation_models[[expanded_layer]],
        test = "LRT"
      )
      
      data.frame(
        
        Comparison = paste(
          reduced_layer,
          "->",
          expanded_layer
        ),
        
        Added_Variables = paste(
          setdiff(
            representation_layers[[expanded_layer]],
            representation_layers[[reduced_layer]]
          ),
          collapse = ", "
        ),
        
        Degrees_of_Freedom =
          test$Df[2],
        
        Deviance_Change =
          test$Deviance[2],
        
        P_Value =
          test$`Pr(>Chi)`[2],
        
        stringsAsFactors = FALSE
      )
    }
  )
)

row.names(
  sequential_representation_tests
) <- NULL


# ============================================================
# 8. Extract coefficients across representation layers
# This allows associations to be compared as additional patient
# information becomes available.
# ============================================================

representation_coefficient_summary <- do.call(
  rbind,
  lapply(
    names(representation_models),
    function(layer) {
      
      coefficients <- summary(
        representation_models[[layer]]
      )$coefficients
      
      coefficients <- coefficients[
        row.names(coefficients) != "(Intercept)",
        ,
        drop = FALSE
      ]
      
      data.frame(
        Layer = layer,
        Term = row.names(coefficients),
        Coefficient = coefficients[, "Estimate"],
        Odds_Ratio = exp(
          coefficients[, "Estimate"]
        ),
        stringsAsFactors = FALSE
      )
    }
  )
)

row.names(
  representation_coefficient_summary
) <- NULL


# ============================================================
# 9. Summarize coefficient stability
# Only terms appearing in at least two representation models
# are included.
# ============================================================

coefficient_stability_summary <- do.call(
  rbind,
  lapply(
    unique(
      representation_coefficient_summary$Term
    ),
    function(term) {
      
      results <- representation_coefficient_summary[
        representation_coefficient_summary$Term ==
          term,
        ,
        drop = FALSE
      ]
      
      if (nrow(results) < 2) {
        return(NULL)
      }
      
      data.frame(
        Term = term,
        Models = nrow(results),
        Minimum_Coefficient =
          min(results$Coefficient),
        Maximum_Coefficient =
          max(results$Coefficient),
        Coefficient_Range =
          max(results$Coefficient) -
          min(results$Coefficient),
        Minimum_Odds_Ratio =
          min(results$Odds_Ratio),
        Maximum_Odds_Ratio =
          max(results$Odds_Ratio),
        stringsAsFactors = FALSE
      )
    }
  )
)

row.names(
  coefficient_stability_summary
) <- NULL


# ============================================================
# 10. Generate patient-level probabilities
# ============================================================

representation_probabilities <- data.frame(
  Observation = row.names(
    representation_data
  ),
  check.names = FALSE
)

for (layer in names(representation_models)) {
  
  representation_probabilities[[layer]] <-
    predict(
      representation_models[[layer]],
      type = "response"
    )
}


# ============================================================
# 11. Evaluate probability sensitivity
# Reduced representations are compared with Layer 4, the full
# available baseline representation.
# ============================================================

prediction_sensitivity_summary <- do.call(
  rbind,
  lapply(
    names(representation_layers)[1:3],
    function(layer) {
      
      reduced_probability <-
        representation_probabilities[[layer]]
      
      full_probability <-
        representation_probabilities$Layer_4
      
      difference <-
        reduced_probability -
        full_probability
      
      data.frame(
        Comparison = paste(
          layer,
          "vs Layer_4"
        ),
        
        Mean_Absolute_Difference =
          mean(abs(difference)),
        
        RMSE =
          sqrt(
            mean(
              difference^2
            )
          ),
        
        Maximum_Absolute_Difference =
          max(
            abs(difference)
          ),
        
        Spearman_Correlation =
          cor(
            reduced_probability,
            full_probability,
            method = "spearman"
          ),
        
        stringsAsFactors = FALSE
      )
    }
  )
)

row.names(
  prediction_sensitivity_summary
) <- NULL


# ============================================================
# 12. Illustrative reclassification
# The 0.50 threshold is methodological only and has no clinical
# interpretation.
# ============================================================

illustrative_threshold <- 0.50

full_classification <-
  representation_probabilities$Layer_4 >=
  illustrative_threshold


representation_reclassification_summary <- do.call(
  rbind,
  lapply(
    names(representation_layers)[1:3],
    function(layer) {
      
      reduced_classification <-
        representation_probabilities[[layer]] >=
        illustrative_threshold
      
      changed <-
        reduced_classification !=
        full_classification
      
      data.frame(
        Comparison = paste(
          layer,
          "vs Layer_4"
        ),
        
        Reclassified_N =
          sum(changed),
        
        Reclassified_Percentage =
          mean(changed) * 100,
        
        stringsAsFactors = FALSE
      )
    }
  )
)

row.names(
  representation_reclassification_summary
) <- NULL


# ============================================================
# 13. Create dichotomized ejection-fraction representation
# The sample median is used only as a neutral methodological
# cutoff and is not a clinical threshold.
# ============================================================

dichotomization_cutoff <- median(
  representation_data$ejection_fraction,
  na.rm = TRUE
)

representation_data$ejection_fraction_binary <- factor(
  ifelse(
    representation_data$ejection_fraction <=
      dichotomization_cutoff,
    "Lower_or_equal_median",
    "Above_median"
  ),
  levels = c(
    "Lower_or_equal_median",
    "Above_median"
  )
)


dichotomized_variables <- c(
  setdiff(
    representation_layers$Layer_4,
    "ejection_fraction"
  ),
  "ejection_fraction_binary"
)


dichotomized_model <- glm(
  reformulate(
    dichotomized_variables,
    response = outcome_variable
  ),
  data = representation_data,
  family = binomial()
)


# ============================================================
# 14. Compare continuous and dichotomized representations
# ============================================================

dichotomization_model_comparison <- rbind(
  
  data.frame(
    Representation =
      "Continuous ejection fraction",
    evaluate_model(
      representation_models$Layer_4
    )
  ),
  
  data.frame(
    Representation =
      "Dichotomized ejection fraction",
    evaluate_model(
      dichotomized_model
    )
  )
)

row.names(
  dichotomization_model_comparison
) <- NULL


# ============================================================
# 15. Evaluate patient-level effects of dichotomization
# ============================================================

continuous_probability <- predict(
  representation_models$Layer_4,
  type = "response"
)

dichotomized_probability <- predict(
  dichotomized_model,
  type = "response"
)

dichotomization_difference <-
  dichotomized_probability -
  continuous_probability


dichotomization_probability_sensitivity <- data.frame(
  
  Mean_Absolute_Difference =
    mean(
      abs(
        dichotomization_difference
      )
    ),
  
  RMSE =
    sqrt(
      mean(
        dichotomization_difference^2
      )
    ),
  
  Maximum_Absolute_Difference =
    max(
      abs(
        dichotomization_difference
      )
    ),
  
  Spearman_Correlation =
    cor(
      dichotomized_probability,
      continuous_probability,
      method = "spearman"
    )
)


dichotomization_reclassification <- data.frame(
  
  Threshold =
    illustrative_threshold,
  
  Reclassified_N =
    sum(
      (
        dichotomized_probability >=
          illustrative_threshold
      ) !=
        (
          continuous_probability >=
            illustrative_threshold
        )
    )
)


dichotomization_reclassification$
  Reclassified_Percentage <-
  (
    dichotomization_reclassification$
      Reclassified_N /
      nrow(representation_data)
  ) * 100


# ============================================================
# 16. Create presentation versions
# Raw values remain unchanged for subsequent analysis.
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
  
  display[numeric_columns] <- lapply(
    display[numeric_columns],
    round,
    digits = digits
  )
  
  display
}


representation_model_comparison_display <-
  round_numeric_columns(
    representation_model_comparison
  )

sequential_representation_tests_display <-
  round_numeric_columns(
    sequential_representation_tests
  )

sequential_representation_tests_display$
  P_Value <- format.pval(
    sequential_representation_tests$P_Value,
    digits = 4,
    eps = 0.0001
  )

coefficient_stability_summary_display <-
  round_numeric_columns(
    coefficient_stability_summary
  )

prediction_sensitivity_summary_display <-
  round_numeric_columns(
    prediction_sensitivity_summary
  )

representation_reclassification_summary_display <-
  round_numeric_columns(
    representation_reclassification_summary
  )

dichotomization_model_comparison_display <-
  round_numeric_columns(
    dichotomization_model_comparison
  )

dichotomization_probability_sensitivity_display <-
  round_numeric_columns(
    dichotomization_probability_sensitivity
  )

dichotomization_reclassification_display <-
  round_numeric_columns(
    dichotomization_reclassification
  )


# ============================================================
# 17. Consolidate representation-sensitivity results
# ============================================================

representation_sensitivity_analysis <- list(
  
  Layers =
    representation_layers,
  
  Layer_Overview =
    representation_layer_overview,
  
  Models =
    representation_models,
  
  Model_Comparison =
    representation_model_comparison,
  
  Sequential_Tests =
    sequential_representation_tests,
  
  Coefficients =
    representation_coefficient_summary,
  
  Coefficient_Stability =
    coefficient_stability_summary,
  
  Patient_Probabilities =
    representation_probabilities,
  
  Probability_Sensitivity =
    prediction_sensitivity_summary,
  
  Reclassification =
    representation_reclassification_summary,
  
  Dichotomization_Cutoff =
    dichotomization_cutoff,
  
  Dichotomization_Model =
    dichotomized_model,
  
  Dichotomization_Model_Comparison =
    dichotomization_model_comparison,
  
  Dichotomization_Probability_Sensitivity =
    dichotomization_probability_sensitivity,
  
  Dichotomization_Reclassification =
    dichotomization_reclassification
)


# ============================================================
# 18. Display representation-sensitivity results
# ============================================================

cat(
  "\n",
  "============================================================\n",
  "REPRESENTATION SENSITIVITY ANALYSIS\n",
  "============================================================\n",
  sep = ""
)

cat(
  "\nREPRESENTATION LAYERS\n"
)

print(
  representation_layer_overview
)

cat(
  "\nMODEL COMPARISON\n"
)

print(
  representation_model_comparison_display
)

cat(
  "\nSEQUENTIAL INFORMATION ADDITION\n"
)

print(
  sequential_representation_tests_display
)

cat(
  "\nCOEFFICIENT STABILITY\n"
)

print(
  coefficient_stability_summary_display
)

cat(
  "\nPATIENT-LEVEL PROBABILITY SENSITIVITY\n"
)

print(
  prediction_sensitivity_summary_display
)

cat(
  "\nILLUSTRATIVE RECLASSIFICATION\n"
)

print(
  representation_reclassification_summary_display
)

cat(
  "\nDICHOTOMIZATION MODEL COMPARISON\n"
)

print(
  dichotomization_model_comparison_display
)

cat(
  "\nDICHOTOMIZATION PROBABILITY SENSITIVITY\n"
)

print(
  dichotomization_probability_sensitivity_display
)

cat(
  "\nDICHOTOMIZATION RECLASSIFICATION\n"
)

print(
  dichotomization_reclassification_display
)


# ============================================================
# 19. Final interpretation note
# ============================================================

cat(
  "\nINTERPRETATION NOTE\n",
  "This analysis evaluates statistical sensitivity to changes ",
  "in the available digital patient representation.\n",
  "All model-performance measures and predicted probabilities ",
  "are evaluated in sample and are not externally validated.\n",
  "The 0.50 classification threshold and median-based ",
  "ejection-fraction cutoff are methodological demonstrations ",
  "without clinical meaning.\n",
  "Changes in statistical model output do not by themselves ",
  "establish clinical importance or decision validity.\n",
  "Project-level clinical and decision interpretation is ",
  "performed separately in ",
  "10_final_clinical_and_decision_insights.R.\n",
  sep = ""
)


# ============================================================
# 20. Return complete representation-sensitivity object
# ============================================================

representation_sensitivity_analysis

