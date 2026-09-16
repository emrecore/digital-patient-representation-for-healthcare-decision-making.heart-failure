# ============================================================
# Project: Heart Failure Clinical Statistical Analysis with R
# File: 09_representation_sensitivity_analysis.R
# Purpose: Examine how statistical conclusions and patient-level
# estimates change when the amount or structure of digitally
# represented patient information is modified.
# Language: R
# ============================================================


# ============================================================
# 1. Define analytical outcome
# Convert the mortality factor into a numerical 0/1 outcome for
# model diagnostics such as the Brier score.
#
# The original DEATH_EVENT factor remains unchanged.
# ============================================================

mortality_numeric <- ifelse(
  heart_failure$DEATH_EVENT == "Death event",
  1,
  0
)


# ============================================================
# 2. Define increasingly informative patient representations
# Patient information is divided into four nested layers.
#
# Each successive layer adds additional digitally available
# information about the patient.
#
# Follow-up time is deliberately excluded because it represents
# observation duration rather than baseline patient information.
# ============================================================

representation_layer_1 <- c(
  "age",
  "sex"
)

representation_layer_2 <- c(
  representation_layer_1,
  "anaemia",
  "diabetes",
  "high_blood_pressure",
  "smoking"
)

representation_layer_3 <- c(
  representation_layer_2,
  "ejection_fraction",
  "serum_creatinine",
  "serum_sodium"
)

representation_layer_4 <- c(
  representation_layer_3,
  "creatinine_phosphokinase",
  "platelets"
)


# ============================================================
# 3. Create representation-layer overview
# Document which patient-information dimensions are introduced
# at each stage of the sensitivity analysis.
# ============================================================

representation_layer_overview <- data.frame(
  
  Representation = c(
    "Layer 1",
    "Layer 2",
    "Layer 3",
    "Layer 4"
  ),
  
  Description = c(
    "Basic demographic representation",
    "Demographics, comorbidities, and risk factors",
    "Expanded clinical and laboratory representation",
    "Full available baseline representation"
  ),
  
  Number_of_Variables = c(
    length(
      representation_layer_1
    ),
    length(
      representation_layer_2
    ),
    length(
      representation_layer_3
    ),
    length(
      representation_layer_4
    )
  ),
  
  Variables = c(
    paste(
      representation_layer_1,
      collapse = ", "
    ),
    paste(
      representation_layer_2,
      collapse = ", "
    ),
    paste(
      representation_layer_3,
      collapse = ", "
    ),
    paste(
      representation_layer_4,
      collapse = ", "
    )
  ),
  
  stringsAsFactors = FALSE
)

representation_layer_overview


# ============================================================
# 4. Confirm that required variables are available
# Verify that every variable required for the representation
# sensitivity analysis exists in the configured dataset.
# ============================================================

required_representation_variables <- unique(
  c(
    representation_layer_4,
    "DEATH_EVENT"
  )
)

missing_representation_variables <- setdiff(
  required_representation_variables,
  names(heart_failure)
)

missing_representation_variables

if (
  length(
    missing_representation_variables
  ) > 0
) {
  
  stop(
    paste(
      "The following variables required for the representation",
      "sensitivity analysis are missing:",
      paste(
        missing_representation_variables,
        collapse = ", "
      )
    )
  )
}


# ============================================================
# 5. Fit Layer 1 mortality model
# Estimate mortality using only basic demographic patient
# information.
# ============================================================

representation_model_1 <- glm(
  reformulate(
    representation_layer_1,
    response = "DEATH_EVENT"
  ),
  data = heart_failure,
  family = binomial(
    link = "logit"
  )
)

summary(
  representation_model_1
)


# ============================================================
# 6. Fit Layer 2 mortality model
# Add digitally represented comorbidities and behavioral risk
# information to the demographic representation.
# ============================================================

representation_model_2 <- glm(
  reformulate(
    representation_layer_2,
    response = "DEATH_EVENT"
  ),
  data = heart_failure,
  family = binomial(
    link = "logit"
  )
)

summary(
  representation_model_2
)


# ============================================================
# 7. Fit Layer 3 mortality model
# Add selected cardiac, renal, and biochemical information to
# create a clinically richer digital patient representation.
# ============================================================

representation_model_3 <- glm(
  reformulate(
    representation_layer_3,
    response = "DEATH_EVENT"
  ),
  data = heart_failure,
  family = binomial(
    link = "logit"
  )
)

summary(
  representation_model_3
)


# ============================================================
# 8. Fit Layer 4 mortality model
# Use all available baseline patient characteristics.
#
# This model reproduces the complete baseline representation
# used in the multivariable regression stage.
# ============================================================

representation_model_4 <- glm(
  reformulate(
    representation_layer_4,
    response = "DEATH_EVENT"
  ),
  data = heart_failure,
  family = binomial(
    link = "logit"
  )
)

summary(
  representation_model_4
)


# ============================================================
# 9. Store representation models
# Combine the four nested models into one structured object for
# subsequent comparison.
# ============================================================

representation_models <- list(
  
  Layer_1_Demographics =
    representation_model_1,
  
  Layer_2_Comorbidities =
    representation_model_2,
  
  Layer_3_Clinical =
    representation_model_3,
  
  Layer_4_Full =
    representation_model_4
)


# ============================================================
# 10. Define model-evaluation function
# Calculate descriptive model-fit and probability-based
# statistics for each representation layer.
#
# AIC:
# Lower values indicate better relative fit after accounting
# for model complexity.
#
# McFadden pseudo-R2:
# Describes improvement relative to an intercept-only model.
#
# Brier score:
# Mean squared difference between predicted probabilities and
# observed binary outcomes. Lower values indicate smaller
# probability error within the analyzed sample.
#
# These are in-sample diagnostics and must not be interpreted
# as externally validated predictive performance.
# ============================================================

evaluate_representation_model <- function(
    model,
    model_name,
    number_of_variables
) {
  
  predicted_probability <- predict(
    model,
    type = "response"
  )
  
  null_model <- glm(
    DEATH_EVENT ~ 1,
    data = heart_failure,
    family = binomial(
      link = "logit"
    )
  )
  
  mcfadden_r2 <- 1 -
    (
      as.numeric(
        logLik(
          model
        )
      ) /
        as.numeric(
          logLik(
            null_model
          )
        )
    )
  
  brier_score <- mean(
    (
      predicted_probability -
        mortality_numeric
    )^2
  )
  
  data.frame(
    
    Representation =
      model_name,
    
    Number_of_Variables =
      number_of_variables,
    
    AIC = AIC(
      model
    ),
    
    Residual_Deviance =
      deviance(
        model
      ),
    
    McFadden_Pseudo_R2 =
      mcfadden_r2,
    
    Brier_Score =
      brier_score,
    
    Mean_Predicted_Probability =
      mean(
        predicted_probability
      ),
    
    stringsAsFactors = FALSE
  )
}


# ============================================================
# 11. Compare model diagnostics across representations
# Evaluate how model characteristics change as additional
# patient information becomes digitally available.
# ============================================================

representation_model_comparison <- rbind(
  
  evaluate_representation_model(
    representation_model_1,
    "Layer 1",
    length(
      representation_layer_1
    )
  ),
  
  evaluate_representation_model(
    representation_model_2,
    "Layer 2",
    length(
      representation_layer_2
    )
  ),
  
  evaluate_representation_model(
    representation_model_3,
    "Layer 3",
    length(
      representation_layer_3
    )
  ),
  
  evaluate_representation_model(
    representation_model_4,
    "Layer 4",
    length(
      representation_layer_4
    )
  )
)

representation_model_comparison[
  ,
  c(
    "AIC",
    "Residual_Deviance",
    "McFadden_Pseudo_R2",
    "Brier_Score",
    "Mean_Predicted_Probability"
  )
] <- round(
  representation_model_comparison[
    ,
    c(
      "AIC",
      "Residual_Deviance",
      "McFadden_Pseudo_R2",
      "Brier_Score",
      "Mean_Predicted_Probability"
    )
  ],
  4
)

row.names(
  representation_model_comparison
) <- NULL

representation_model_comparison


# ============================================================
# 12. Calculate changes in model diagnostics
# Quantify how much each additional representation layer
# changes AIC, pseudo-R2, and Brier score.
#
# Positive AIC improvement represents a reduction in AIC.
# Positive Brier improvement represents a reduction in
# probability error.
# ============================================================

representation_model_changes <-
  representation_model_comparison

representation_model_changes$AIC_Improvement <-
  c(
    NA,
    head(
      representation_model_comparison$AIC,
      -1
    ) -
      tail(
        representation_model_comparison$AIC,
        -1
      )
  )

representation_model_changes$Pseudo_R2_Change <-
  c(
    NA,
    diff(
      representation_model_comparison$McFadden_Pseudo_R2
    )
  )

representation_model_changes$Brier_Improvement <-
  c(
    NA,
    head(
      representation_model_comparison$Brier_Score,
      -1
    ) -
      tail(
        representation_model_comparison$Brier_Score,
        -1
      )
  )

representation_model_changes[
  ,
  c(
    "AIC_Improvement",
    "Pseudo_R2_Change",
    "Brier_Improvement"
  )
] <- round(
  representation_model_changes[
    ,
    c(
      "AIC_Improvement",
      "Pseudo_R2_Change",
      "Brier_Improvement"
    )
  ],
  4
)

representation_model_changes


# ============================================================
# 13. Perform sequential likelihood-ratio comparisons
# Compare nested representation models to determine whether the
# newly introduced information improves model fit relative to
# the preceding representation.
#
# These tests evaluate statistical model fit only.
# They do not establish clinical necessity or causal relevance
# of the added information.
# ============================================================

layer_1_vs_2_test <- anova(
  representation_model_1,
  representation_model_2,
  test = "Chisq"
)

layer_2_vs_3_test <- anova(
  representation_model_2,
  representation_model_3,
  test = "Chisq"
)

layer_3_vs_4_test <- anova(
  representation_model_3,
  representation_model_4,
  test = "Chisq"
)

layer_1_vs_2_test

layer_2_vs_3_test

layer_3_vs_4_test


# ============================================================
# 14. Create sequential model-comparison summary
# Extract the principal likelihood-ratio statistics into one
# interpretable table.
# ============================================================

sequential_model_comparison <- data.frame(
  
  Comparison = c(
    "Layer 1 vs Layer 2",
    "Layer 2 vs Layer 3",
    "Layer 3 vs Layer 4"
  ),
  
  Added_Information = c(
    "Comorbidities and risk factors",
    "Cardiac, renal, and biochemical information",
    "Additional laboratory information"
  ),
  
  Degrees_of_Freedom = c(
    layer_1_vs_2_test$Df[2],
    layer_2_vs_3_test$Df[2],
    layer_3_vs_4_test$Df[2]
  ),
  
  Deviance_Change = c(
    layer_1_vs_2_test$Deviance[2],
    layer_2_vs_3_test$Deviance[2],
    layer_3_vs_4_test$Deviance[2]
  ),
  
  P_Value = c(
    layer_1_vs_2_test[
      ["Pr(>Chi)"]
    ][2],
    
    layer_2_vs_3_test[
      ["Pr(>Chi)"]
    ][2],
    
    layer_3_vs_4_test[
      ["Pr(>Chi)"]
    ][2]
  ),
  
  stringsAsFactors = FALSE
)

sequential_model_comparison[
  ,
  c(
    "Deviance_Change",
    "P_Value"
  )
] <- round(
  sequential_model_comparison[
    ,
    c(
      "Deviance_Change",
      "P_Value"
    )
  ],
  4
)

sequential_model_comparison


# ============================================================
# 15. Extract coefficient estimates across representations
# Examine whether the estimated associations of patient
# characteristics change as additional patient information is
# added to the model.
#
# This allows model dependence of individual associations to
# be evaluated explicitly.
# ============================================================

extract_representation_coefficients <- function(
    model,
    representation_name
) {
  
  coefficient_table <- summary(
    model
  )$coefficients
  
  coefficient_table <- coefficient_table[
    row.names(
      coefficient_table
    ) != "(Intercept)",
    ,
    drop = FALSE
  ]
  
  data.frame(
    
    Representation =
      representation_name,
    
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


# ============================================================
# 16. Build coefficient-stability table
# Combine estimates from all four representation layers.
# ============================================================

representation_coefficient_summary <- rbind(
  
  extract_representation_coefficients(
    representation_model_1,
    "Layer 1"
  ),
  
  extract_representation_coefficients(
    representation_model_2,
    "Layer 2"
  ),
  
  extract_representation_coefficients(
    representation_model_3,
    "Layer 3"
  ),
  
  extract_representation_coefficients(
    representation_model_4,
    "Layer 4"
  )
)

representation_coefficient_summary[
  ,
  c(
    "Coefficient",
    "Standard_Error",
    "Odds_Ratio",
    "CI_Lower",
    "CI_Upper",
    "P_Value"
  )
] <- round(
  representation_coefficient_summary[
    ,
    c(
      "Coefficient",
      "Standard_Error",
      "Odds_Ratio",
      "CI_Lower",
      "CI_Upper",
      "P_Value"
    )
  ],
  4
)

row.names(
  representation_coefficient_summary
) <- NULL

representation_coefficient_summary


# ============================================================
# 17. Compare age association across all representations
# Age is available in every representation layer and therefore
# provides a direct example of how an estimated association may
# change as additional patient information becomes available.
# ============================================================

age_coefficient_stability <-
  representation_coefficient_summary[
    representation_coefficient_summary$Term ==
      "age",
    ,
    drop = FALSE
  ]

row.names(
  age_coefficient_stability
) <- NULL

age_coefficient_stability


# ============================================================
# 18. Compare sex association across all representations
# Sex is also represented in every layer and can therefore be
# examined for coefficient stability across progressively richer
# digital patient representations.
# ============================================================

sex_coefficient_stability <-
  representation_coefficient_summary[
    grepl(
      "^sex",
      representation_coefficient_summary$Term
    ),
    ,
    drop = FALSE
  ]

row.names(
  sex_coefficient_stability
) <- NULL

sex_coefficient_stability


# ============================================================
# 19. Calculate patient-level predicted probabilities
# Estimate mortality probabilities for every patient under each
# digital representation.
#
# These probabilities are analytical model outputs only.
# They are not clinically validated patient-risk estimates.
# ============================================================

representation_predictions <- data.frame(
  
  Patient_ID =
    seq_len(
      nrow(
        heart_failure
      )
    ),
  
  Observed_Outcome =
    heart_failure$DEATH_EVENT,
  
  Layer_1_Probability = predict(
    representation_model_1,
    type = "response"
  ),
  
  Layer_2_Probability = predict(
    representation_model_2,
    type = "response"
  ),
  
  Layer_3_Probability = predict(
    representation_model_3,
    type = "response"
  ),
  
  Layer_4_Probability = predict(
    representation_model_4,
    type = "response"
  )
)

representation_predictions[
  ,
  c(
    "Layer_1_Probability",
    "Layer_2_Probability",
    "Layer_3_Probability",
    "Layer_4_Probability"
  )
] <- round(
  representation_predictions[
    ,
    c(
      "Layer_1_Probability",
      "Layer_2_Probability",
      "Layer_3_Probability",
      "Layer_4_Probability"
    )
  ],
  4
)

head(
  representation_predictions
)


# ============================================================
# 20. Measure patient-level information sensitivity
# Compare probabilities from reduced patient representations
# with probabilities from the full available baseline model.
#
# Mean absolute probability difference describes the average
# change in patient-level model output caused by information
# reduction.
# ============================================================

full_representation_probability <- predict(
  representation_model_4,
  type = "response"
)

prediction_sensitivity_summary <- data.frame(
  
  Representation = c(
    "Layer 1",
    "Layer 2",
    "Layer 3"
  ),
  
  Mean_Absolute_Probability_Difference = c(
    
    mean(
      abs(
        predict(
          representation_model_1,
          type = "response"
        ) -
          full_representation_probability
      )
    ),
    
    mean(
      abs(
        predict(
          representation_model_2,
          type = "response"
        ) -
          full_representation_probability
      )
    ),
    
    mean(
      abs(
        predict(
          representation_model_3,
          type = "response"
        ) -
          full_representation_probability
      )
    )
  ),
  
  Root_Mean_Squared_Probability_Difference = c(
    
    sqrt(
      mean(
        (
          predict(
            representation_model_1,
            type = "response"
          ) -
            full_representation_probability
        )^2
      )
    ),
    
    sqrt(
      mean(
        (
          predict(
            representation_model_2,
            type = "response"
          ) -
            full_representation_probability
        )^2
      )
    ),
    
    sqrt(
      mean(
        (
          predict(
            representation_model_3,
            type = "response"
          ) -
            full_representation_probability
        )^2
      )
    )
  ),
  
  Maximum_Absolute_Probability_Difference = c(
    
    max(
      abs(
        predict(
          representation_model_1,
          type = "response"
        ) -
          full_representation_probability
      )
    ),
    
    max(
      abs(
        predict(
          representation_model_2,
          type = "response"
        ) -
          full_representation_probability
      )
    ),
    
    max(
      abs(
        predict(
          representation_model_3,
          type = "response"
        ) -
          full_representation_probability
      )
    )
  ),
  
  Probability_Correlation_With_Full_Model = c(
    
    cor(
      predict(
        representation_model_1,
        type = "response"
      ),
      full_representation_probability,
      method = "spearman"
    ),
    
    cor(
      predict(
        representation_model_2,
        type = "response"
      ),
      full_representation_probability,
      method = "spearman"
    ),
    
    cor(
      predict(
        representation_model_3,
        type = "response"
      ),
      full_representation_probability,
      method = "spearman"
    )
  ),
  
  stringsAsFactors = FALSE
)

prediction_sensitivity_summary[
  ,
  -1
] <- round(
  prediction_sensitivity_summary[
    ,
    -1
  ],
  4
)

prediction_sensitivity_summary


# ============================================================
# 21. Define an illustrative probability threshold
# Use 0.50 only as a methodological example to examine whether
# reduced patient information can change a binary model output.
#
# This threshold is NOT a clinical treatment threshold,
# triage rule, or validated decision threshold.
# ============================================================

illustrative_probability_threshold <- 0.50


# ============================================================
# 22. Calculate illustrative model classifications
# Convert model probabilities into binary analytical categories
# using the predefined illustrative threshold.
# ============================================================

layer_1_classification <- ifelse(
  predict(
    representation_model_1,
    type = "response"
  ) >=
    illustrative_probability_threshold,
  "Higher model probability",
  "Lower model probability"
)

layer_2_classification <- ifelse(
  predict(
    representation_model_2,
    type = "response"
  ) >=
    illustrative_probability_threshold,
  "Higher model probability",
  "Lower model probability"
)

layer_3_classification <- ifelse(
  predict(
    representation_model_3,
    type = "response"
  ) >=
    illustrative_probability_threshold,
  "Higher model probability",
  "Lower model probability"
)

layer_4_classification <- ifelse(
  predict(
    representation_model_4,
    type = "response"
  ) >=
    illustrative_probability_threshold,
  "Higher model probability",
  "Lower model probability"
)


# ============================================================
# 23. Evaluate representation-based reclassification
# Count how many patient-level model classifications differ
# from those generated by the full available representation.
#
# This demonstrates how information reduction can alter a model
# output even when the underlying patient has not changed.
# ============================================================

representation_reclassification_summary <- data.frame(
  
  Representation = c(
    "Layer 1",
    "Layer 2",
    "Layer 3"
  ),
  
  Different_from_Full_Model = c(
    
    sum(
      layer_1_classification !=
        layer_4_classification
    ),
    
    sum(
      layer_2_classification !=
        layer_4_classification
    ),
    
    sum(
      layer_3_classification !=
        layer_4_classification
    )
  ),
  
  stringsAsFactors = FALSE
)

representation_reclassification_summary$Percentage_Different <-
  round(
    (
      representation_reclassification_summary$
        Different_from_Full_Model /
        nrow(
          heart_failure
        )
    ) * 100,
    2
  )

representation_reclassification_summary


# ============================================================
# 24. Identify individual reclassified patients
# Document which patient-level analytical classifications change
# when reduced representations are compared with the full model.
# ============================================================

patient_reclassification <- data.frame(
  
  Patient_ID =
    seq_len(
      nrow(
        heart_failure
      )
    ),
  
  Layer_1 =
    layer_1_classification,
  
  Layer_2 =
    layer_2_classification,
  
  Layer_3 =
    layer_3_classification,
  
  Layer_4_Full =
    layer_4_classification,
  
  Layer_1_Changed =
    layer_1_classification !=
    layer_4_classification,
  
  Layer_2_Changed =
    layer_2_classification !=
    layer_4_classification,
  
  Layer_3_Changed =
    layer_3_classification !=
    layer_4_classification,
  
  stringsAsFactors = FALSE
)

reclassified_patients <-
  patient_reclassification[
    patient_reclassification$Layer_1_Changed |
      patient_reclassification$Layer_2_Changed |
      patient_reclassification$Layer_3_Changed,
    ,
    drop = FALSE
  ]

row.names(
  reclassified_patients
) <- NULL

reclassified_patients


# ============================================================
# 25. Examine information loss through dichotomization
# Create a deliberately simplified representation of ejection
# fraction by converting the original continuous measurement
# into two categories.
#
# The sample median is used only as a neutral methodological
# cutoff for demonstrating information loss.
#
# It is NOT interpreted as a clinical threshold.
# ============================================================

ejection_fraction_cutoff <- median(
  heart_failure$ejection_fraction,
  na.rm = TRUE
)

ejection_fraction_cutoff


# ============================================================
# 26. Create dichotomized ejection-fraction representation
# Preserve the original dataset and create a separate analytical
# copy containing the simplified representation.
# ============================================================

heart_failure_dichotomized <- heart_failure

heart_failure_dichotomized$ejection_fraction_group <- factor(
  ifelse(
    heart_failure_dichotomized$ejection_fraction <=
      ejection_fraction_cutoff,
    "Lower or equal to median",
    "Higher than median"
  ),
  levels = c(
    "Higher than median",
    "Lower or equal to median"
  )
)

table(
  heart_failure_dichotomized$ejection_fraction_group
)


# ============================================================
# 27. Fit continuous-information model
# Use the complete available baseline representation while
# retaining ejection fraction as a continuous variable.
# ============================================================

continuous_information_model <- glm(
  DEATH_EVENT ~
    age +
    anaemia +
    creatinine_phosphokinase +
    diabetes +
    ejection_fraction +
    high_blood_pressure +
    platelets +
    serum_creatinine +
    serum_sodium +
    sex +
    smoking,
  data = heart_failure,
  family = binomial(
    link = "logit"
  )
)


# ============================================================
# 28. Fit dichotomized-information model
# Replace continuous ejection fraction with the simplified
# binary representation while keeping the remaining available
# patient information unchanged.
# ============================================================

dichotomized_information_model <- glm(
  DEATH_EVENT ~
    age +
    anaemia +
    creatinine_phosphokinase +
    diabetes +
    ejection_fraction_group +
    high_blood_pressure +
    platelets +
    serum_creatinine +
    serum_sodium +
    sex +
    smoking,
  data = heart_failure_dichotomized,
  family = binomial(
    link = "logit"
  )
)


# ============================================================
# 29. Compare continuous and dichotomized representations
# Evaluate whether simplification of one continuous patient
# measurement changes overall model characteristics.
# ============================================================

continuous_probability <- predict(
  continuous_information_model,
  type = "response"
)

dichotomized_probability <- predict(
  dichotomized_information_model,
  type = "response"
)

continuous_brier_score <- mean(
  (
    continuous_probability -
      mortality_numeric
  )^2
)

dichotomized_brier_score <- mean(
  (
    dichotomized_probability -
      mortality_numeric
  )^2
)

null_model <- glm(
  DEATH_EVENT ~ 1,
  data = heart_failure,
  family = binomial(
    link = "logit"
  )
)

continuous_mcfadden_r2 <- 1 -
  (
    as.numeric(
      logLik(
        continuous_information_model
      )
    ) /
      as.numeric(
        logLik(
          null_model
        )
      )
  )

dichotomized_mcfadden_r2 <- 1 -
  (
    as.numeric(
      logLik(
        dichotomized_information_model
      )
    ) /
      as.numeric(
        logLik(
          null_model
        )
      )
  )

dichotomization_model_comparison <- data.frame(
  
  Representation = c(
    "Continuous ejection fraction",
    "Dichotomized ejection fraction"
  ),
  
  AIC = c(
    AIC(
      continuous_information_model
    ),
    AIC(
      dichotomized_information_model
    )
  ),
  
  Residual_Deviance = c(
    deviance(
      continuous_information_model
    ),
    deviance(
      dichotomized_information_model
    )
  ),
  
  McFadden_Pseudo_R2 = c(
    continuous_mcfadden_r2,
    dichotomized_mcfadden_r2
  ),
  
  Brier_Score = c(
    continuous_brier_score,
    dichotomized_brier_score
  ),
  
  stringsAsFactors = FALSE
)

dichotomization_model_comparison[
  ,
  -1
] <- round(
  dichotomization_model_comparison[
    ,
    -1
  ],
  4
)

dichotomization_model_comparison


# ============================================================
# 30. Measure probability changes caused by dichotomization
# Quantify how much patient-level model outputs change when a
# continuous clinical measurement is reduced to two categories.
# ============================================================

dichotomization_probability_sensitivity <- data.frame(
  
  Mean_Absolute_Probability_Difference =
    mean(
      abs(
        continuous_probability -
          dichotomized_probability
      )
    ),
  
  Root_Mean_Squared_Probability_Difference =
    sqrt(
      mean(
        (
          continuous_probability -
            dichotomized_probability
        )^2
      )
    ),
  
  Maximum_Absolute_Probability_Difference =
    max(
      abs(
        continuous_probability -
          dichotomized_probability
      )
    ),
  
  Probability_Correlation =
    cor(
      continuous_probability,
      dichotomized_probability,
      method = "spearman"
    )
)

dichotomization_probability_sensitivity[] <- round(
  dichotomization_probability_sensitivity,
  4
)

dichotomization_probability_sensitivity


# ============================================================
# 31. Evaluate dichotomization-based reclassification
# Apply the same illustrative threshold to determine whether
# simplifying ejection fraction changes binary model output.
#
# Again, the threshold has no clinical meaning.
# ============================================================

continuous_classification <- ifelse(
  continuous_probability >=
    illustrative_probability_threshold,
  "Higher model probability",
  "Lower model probability"
)

dichotomized_classification <- ifelse(
  dichotomized_probability >=
    illustrative_probability_threshold,
  "Higher model probability",
  "Lower model probability"
)

dichotomization_reclassification <- data.frame(
  
  Number_Reclassified = sum(
    continuous_classification !=
      dichotomized_classification
  ),
  
  Percentage_Reclassified = (
    sum(
      continuous_classification !=
        dichotomized_classification
    ) /
      nrow(
        heart_failure
      )
  ) * 100
)

dichotomization_reclassification[] <- round(
  dichotomization_reclassification,
  2
)

dichotomization_reclassification


# ============================================================
# 32. Create patient-level dichotomization comparison
# Retain patient-level probability differences so individual
# sensitivity to information simplification can be inspected.
# ============================================================

dichotomization_patient_comparison <- data.frame(
  
  Patient_ID =
    seq_len(
      nrow(
        heart_failure
      )
    ),
  
  Ejection_Fraction =
    heart_failure$ejection_fraction,
  
  Ejection_Fraction_Group =
    heart_failure_dichotomized$
    ejection_fraction_group,
  
  Continuous_Probability =
    continuous_probability,
  
  Dichotomized_Probability =
    dichotomized_probability,
  
  Absolute_Probability_Difference =
    abs(
      continuous_probability -
        dichotomized_probability
    ),
  
  Classification_Changed =
    continuous_classification !=
    dichotomized_classification,
  
  stringsAsFactors = FALSE
)

dichotomization_patient_comparison[
  ,
  c(
    "Continuous_Probability",
    "Dichotomized_Probability",
    "Absolute_Probability_Difference"
  )
] <- round(
  dichotomization_patient_comparison[
    ,
    c(
      "Continuous_Probability",
      "Dichotomized_Probability",
      "Absolute_Probability_Difference"
    )
  ],
  4
)

dichotomization_patient_comparison <-
  dichotomization_patient_comparison[
    order(
      dichotomization_patient_comparison$
        Absolute_Probability_Difference,
      decreasing = TRUE
    ),
    ,
    drop = FALSE
  ]

row.names(
  dichotomization_patient_comparison
) <- NULL

head(
  dichotomization_patient_comparison,
  20
)


# ============================================================
# 33. Create representation sensitivity summary object
# Consolidate all results from the representation sensitivity
# stage for later interpretation.
# ============================================================

representation_sensitivity_analysis <- list(
  
  Representation_Layers =
    representation_layer_overview,
  
  Model_Comparison =
    representation_model_comparison,
  
  Model_Changes =
    representation_model_changes,
  
  Sequential_Model_Comparison =
    sequential_model_comparison,
  
  Coefficient_Stability =
    representation_coefficient_summary,
  
  Age_Stability =
    age_coefficient_stability,
  
  Sex_Stability =
    sex_coefficient_stability,
  
  Patient_Probabilities =
    representation_predictions,
  
  Probability_Sensitivity =
    prediction_sensitivity_summary,
  
  Representation_Reclassification =
    representation_reclassification_summary,
  
  Reclassified_Patients =
    reclassified_patients,
  
  Ejection_Fraction_Dichotomization_Cutoff =
    ejection_fraction_cutoff,
  
  Dichotomization_Model_Comparison =
    dichotomization_model_comparison,
  
  Dichotomization_Probability_Sensitivity =
    dichotomization_probability_sensitivity,
  
  Dichotomization_Reclassification =
    dichotomization_reclassification,
  
  Dichotomization_Patient_Comparison =
    dichotomization_patient_comparison
)


# ============================================================
# 34. Display final representation sensitivity overview
# Summarize how the amount and structure of digitally available
# patient information influence statistical model outputs.
# ============================================================

cat(
  "\n",
  "============================================================\n",
  "DIGITAL PATIENT REPRESENTATION SENSITIVITY ANALYSIS\n",
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
  "\nMODEL COMPARISON ACROSS REPRESENTATION LAYERS\n"
)

print(
  representation_model_comparison
)


cat(
  "\nSEQUENTIAL INFORMATION ADDITION\n"
)

print(
  sequential_model_comparison
)


cat(
  "\nPATIENT-LEVEL PROBABILITY SENSITIVITY\n"
)

print(
  prediction_sensitivity_summary
)


cat(
  "\nILLUSTRATIVE RECLASSIFICATION UNDER REDUCED INFORMATION\n"
)

print(
  representation_reclassification_summary
)


cat(
  "\nDICHOTOMIZATION OF EJECTION FRACTION\n"
)

cat(
  "Methodological cutoff:",
  round(
    ejection_fraction_cutoff,
    2
  ),
  "\n"
)

print(
  dichotomization_model_comparison
)


cat(
  "\nDICHOTOMIZATION PROBABILITY SENSITIVITY\n"
)

print(
  dichotomization_probability_sensitivity
)


cat(
  "\nDICHOTOMIZATION RECLASSIFICATION\n"
)

print(
  dichotomization_reclassification
)


cat(
  "\nIMPORTANT INTERPRETATION NOTE\n",
  "This analysis examines how statistical model outputs depend ",
  "on the amount and structure of digitally represented ",
  "patient information.\n",
  "Differences between representation layers demonstrate model ",
  "sensitivity to information availability but do not establish ",
  "that omitted variables are clinically necessary, causally ",
  "related to mortality, or sufficient for real-world ",
  "decision-making.\n",
  "Predicted probabilities are in-sample analytical estimates ",
  "and have not been externally validated.\n",
  "The 0.50 probability threshold is used only to illustrate ",
  "how information reduction can change a binary model output ",
  "and must not be interpreted as a clinical threshold.\n",
  "The median-based dichotomization of ejection fraction is ",
  "also a methodological demonstration rather than a clinical ",
  "classification rule.\n",
  "The central analytical question is therefore not whether a ",
  "reduced representation is clinically acceptable, but how ",
  "strongly the statistical evidence changes when information ",
  "about the same patient is represented differently.\n",
  sep = ""
)



