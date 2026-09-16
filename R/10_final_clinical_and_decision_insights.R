# ============================================================
# Project: Heart Failure Clinical Statistical Analysis with R
# File: 10_final_clinical_and_decision_insights.R
# Purpose: Integrate descriptive, inferential, regression, and
# digital patient representation findings into a structured
# final analysis of statistical reliability, potential
# healthcare decision implications, and clinical limitations.
# Language: R
# ============================================================


# ============================================================
# 1. Define significance level
# Use the same significance threshold applied throughout the
# statistical analysis.
# ============================================================

alpha <- 0.05


# ============================================================
# 2. Check required analytical objects
# Confirm that the preceding project scripts have been executed
# and that the principal analytical objects required for the
# final synthesis are available.
# ============================================================

required_objects <- c(
  "heart_failure",
  "patient_representation_map",
  "representation_gaps",
  "hypothesis_test_summary",
  "correlation_results_ranked",
  "regression_variables",
  "univariable_results",
  "mortality_model",
  "model_fit",
  "representation_layer_overview",
  "representation_model_comparison",
  "representation_model_changes",
  "sequential_model_comparison",
  "representation_coefficient_summary",
  "prediction_sensitivity_summary",
  "representation_reclassification_summary",
  "dichotomization_model_comparison",
  "dichotomization_probability_sensitivity",
  "dichotomization_reclassification"
)

missing_required_objects <- required_objects[
  !sapply(
    required_objects,
    exists,
    inherits = TRUE
  )
]

if (
  length(
    missing_required_objects
  ) > 0
) {
  
  stop(
    paste(
      "The following required analytical objects are missing:",
      paste(
        missing_required_objects,
        collapse = ", "
      ),
      "\nRun the preceding analysis scripts before executing",
      "10_final_clinical_and_decision_insights.R."
    )
  )
}


# ============================================================
# 3. Define p-value formatting helper
# Raw p-values remain unchanged internally.
# Formatting is applied only for presentation.
# ============================================================

format_p_value <- function(p) {
  
  format.pval(
    p,
    digits = 4,
    eps = 0.0001
  )
}


# ============================================================
# 4. Define model-term mapping helper
# Convert regression terms such as anaemiaYes or sexMale back
# to their underlying patient variables.
# ============================================================

map_term_to_variable <- function(
    term,
    variables
) {
  
  possible_matches <- variables[
    sapply(
      variables,
      function(variable) {
        
        term == variable ||
          startsWith(
            term,
            variable
          )
      }
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
# 5. Define readable variable labels
# Create consistent patient-variable labels for final reporting.
# ============================================================

variable_labels <- c(
  
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
# 6. Summarize mortality outcome
# Calculate the observed mortality distribution directly from
# the configured patient dataset.
# ============================================================

mortality_counts <- table(
  heart_failure$DEATH_EVENT
)

final_mortality_summary <- data.frame(
  
  Mortality_Outcome =
    names(
      mortality_counts
    ),
  
  N =
    as.vector(
      mortality_counts
    ),
  
  Percentage = round(
    as.vector(
      prop.table(
        mortality_counts
      )
    ) * 100,
    2
  ),
  
  stringsAsFactors = FALSE
)

row.names(
  final_mortality_summary
) <- NULL

final_mortality_summary


# ============================================================
# 7. Calculate overall observed mortality proportion
# Retain the sample mortality proportion for the final
# analytical overview.
# ============================================================

death_count <- sum(
  heart_failure$DEATH_EVENT ==
    "Death event"
)

total_patient_count <- nrow(
  heart_failure
)

observed_mortality_percentage <- (
  death_count /
    total_patient_count
) * 100

observed_mortality_percentage <- round(
  observed_mortality_percentage,
  2
)


# ============================================================
# 8. Identify BH-adjusted group-level findings
# Use the Benjamini-Hochberg-adjusted hypothesis-test results
# as the primary group-level inferential evidence.
# ============================================================

significant_group_results <-
  hypothesis_test_summary[
    hypothesis_test_summary$Significant_BH ==
      "Yes",
    ,
    drop = FALSE
  ]

if (
  nrow(
    significant_group_results
  ) > 0
) {
  
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

significant_group_results


# ============================================================
# 9. Identify univariable mortality associations
# Retain patient characteristics that showed statistical
# evidence of association in individual logistic models.
#
# These are unadjusted associations and should not be
# interpreted as independent effects.
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
        significant_univariable_results$P_Value
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
# 10. Re-extract multivariable regression estimates
# Extract coefficients directly from the fitted mortality model
# to preserve full numerical precision for the final synthesis.
# ============================================================

final_regression_coefficients <- summary(
  mortality_model
)$coefficients

final_regression_coefficients <-
  final_regression_coefficients[
    row.names(
      final_regression_coefficients
    ) !=
      "(Intercept)",
    ,
    drop = FALSE
  ]


# ============================================================
# 11. Create final multivariable regression table
# Calculate adjusted odds ratios and confidence intervals using
# the original full-precision regression coefficients.
# ============================================================

final_regression_results <- data.frame(
  
  Term =
    row.names(
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
    ],
  
  stringsAsFactors = FALSE
)

row.names(
  final_regression_results
) <- NULL


# ============================================================
# 12. Map regression terms to underlying patient variables
# This allows results from different analytical stages to be
# compared at the patient-variable level.
# ============================================================

final_regression_results$Variable <- vapply(
  final_regression_results$Term,
  map_term_to_variable,
  character(1),
  variables = regression_variables
)


# ============================================================
# 13. Add readable multivariable labels
# Convert technical model terms into more interpretable labels.
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

final_regression_results$Clinical_Label <- ifelse(
  final_regression_results$Term %in%
    names(
      term_labels
    ),
  unname(
    term_labels[
      final_regression_results$Term
    ]
  ),
  final_regression_results$Term
)


# ============================================================
# 14. Identify adjusted mortality associations
# Flag coefficients with p-values below the predefined
# significance threshold.
#
# These remain adjusted statistical associations rather than
# causal or clinically validated effects.
# ============================================================

final_regression_results$Significant <- ifelse(
  final_regression_results$P_Value <
    alpha,
  "Yes",
  "No"
)

significant_regression_results <-
  final_regression_results[
    final_regression_results$Significant ==
      "Yes",
    ,
    drop = FALSE
  ]

if (
  nrow(
    significant_regression_results
  ) > 0
) {
  
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

significant_regression_results


# ============================================================
# 15. Create adjusted-association interpretations
# Translate significant adjusted associations into concise
# statistical statements.
#
# Wording deliberately refers to association rather than
# causation or clinical prediction.
# ============================================================

if (
  nrow(
    significant_regression_results
  ) > 0
) {
  
  adjusted_association_interpretations <- sapply(
    seq_len(
      nrow(
        significant_regression_results
      )
    ),
    function(i) {
      
      result <-
        significant_regression_results[
          i,
          ,
          drop = FALSE
        ]
      
      direction <- ifelse(
        result$Adjusted_Odds_Ratio >
          1,
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
          result$P_Value <
            0.0001,
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
  
  adjusted_association_interpretations <-
    "No patient characteristics remained statistically significant in the adjusted logistic regression model."
}


# ============================================================
# 16. Create cross-method evidence summary
# Compare evidence across:
#
# 1. BH-adjusted mortality-group testing
# 2. Univariable logistic regression
# 3. Multivariable logistic regression
#
# Agreement across methods is treated as consistency of
# statistical evidence rather than proof of clinical importance.
# ============================================================

group_supported_variables <- unique(
  significant_group_results$Variable
)

univariable_supported_variables <- unique(
  significant_univariable_results$Variable
)

multivariable_supported_variables <- unique(
  significant_regression_results$Variable
)

cross_method_evidence_summary <- data.frame(
  
  Variable =
    regression_variables,
  
  Clinical_Label =
    unname(
      variable_labels[
        regression_variables
      ]
    ),
  
  BH_Adjusted_Group_Evidence =
    ifelse(
      regression_variables %in%
        group_supported_variables,
      "Yes",
      "No"
    ),
  
  Univariable_Regression_Evidence =
    ifelse(
      regression_variables %in%
        univariable_supported_variables,
      "Yes",
      "No"
    ),
  
  Multivariable_Regression_Evidence =
    ifelse(
      regression_variables %in%
        multivariable_supported_variables,
      "Yes",
      "No"
    ),
  
  stringsAsFactors = FALSE
)


# ============================================================
# 17. Count evidence across analytical methods
# The count represents the number of the three analytical
# approaches that statistically supported each variable.
#
# It is not a clinical importance score.
# ============================================================

cross_method_evidence_summary$Supported_Methods <-
  rowSums(
    cross_method_evidence_summary[
      ,
      c(
        "BH_Adjusted_Group_Evidence",
        "Univariable_Regression_Evidence",
        "Multivariable_Regression_Evidence"
      )
    ] ==
      "Yes"
  )

cross_method_evidence_summary$Consistent_Across_All_Three <-
  ifelse(
    cross_method_evidence_summary$Supported_Methods ==
      3,
    "Yes",
    "No"
  )

cross_method_evidence_summary


# ============================================================
# 18. Identify consistently supported patient characteristics
# Retain variables supported by all three primary analytical
# approaches.
#
# This represents statistical consistency within this dataset,
# not proof of causality or clinical sufficiency.
# ============================================================

consistent_patient_characteristics <-
  cross_method_evidence_summary[
    cross_method_evidence_summary$
      Consistent_Across_All_Three ==
      "Yes",
    ,
    drop = FALSE
  ]

row.names(
  consistent_patient_characteristics
) <- NULL

consistent_patient_characteristics


# ============================================================
# 19. Rank strongest continuous-variable correlations
# Retain the five strongest pairwise Spearman correlations by
# absolute magnitude.
#
# Correlation strength is not interpreted as clinical
# importance or causal evidence.
# ============================================================

strongest_correlations <-
  correlation_results_ranked[
    order(
      -correlation_results_ranked$
        Absolute_Correlation
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

strongest_correlations


# ============================================================
# 20. Retain regression model-fit summary
# Preserve the overall fit statistics from the complete
# multivariable mortality model.
# ============================================================

final_model_fit <- model_fit

final_model_fit_display <- round(
  final_model_fit,
  2
)

final_model_fit_display


# ============================================================
# 21. Summarize digital patient representation
# Count how many predefined patient-information dimensions are
# fully, partially, weakly, or not represented.
# ============================================================

final_representation_status_summary <- as.data.frame(
  table(
    patient_representation_map$
      Representation_Status
  )
)

names(
  final_representation_status_summary
) <- c(
  "Representation_Status",
  "Number_of_Dimensions"
)

row.names(
  final_representation_status_summary
) <- NULL

final_representation_status_summary


# ============================================================
# 22. Quantify major representation gaps
# Count patient-information dimensions explicitly classified
# as not represented in the available dataset.
# ============================================================

number_unrepresented_dimensions <- sum(
  patient_representation_map$
    Representation_Status ==
    "Not represented"
)

number_limited_dimensions <- sum(
  patient_representation_map$
    Representation_Status %in%
    c(
      "Limited",
      "Very limited"
    )
)

representation_boundary_summary <- data.frame(
  
  Total_Assessed_Patient_Dimensions =
    nrow(
      patient_representation_map
    ),
  
  Not_Represented =
    number_unrepresented_dimensions,
  
  Limited_or_Very_Limited =
    number_limited_dimensions,
  
  stringsAsFactors = FALSE
)

representation_boundary_summary


# ============================================================
# 23. Create complete representation reliability table
# Combine model-level diagnostics with patient-level sensitivity
# to the amount of digitally available patient information.
# ============================================================

representation_reliability_summary <-
  representation_model_comparison

representation_reliability_summary$
  Mean_Absolute_Probability_Difference_From_Full <-
  NA_real_

representation_reliability_summary$
  Percentage_Classification_Different_From_Full <-
  NA_real_

for (
  i in seq_len(
    nrow(
      prediction_sensitivity_summary
    )
  )
) {
  
  representation_name <-
    prediction_sensitivity_summary$
    Representation[i]
  
  match_index <- match(
    representation_name,
    representation_reliability_summary$
      Representation
  )
  
  representation_reliability_summary$
    Mean_Absolute_Probability_Difference_From_Full[
      match_index
    ] <-
    prediction_sensitivity_summary$
    Mean_Absolute_Probability_Difference[i]
}

for (
  i in seq_len(
    nrow(
      representation_reclassification_summary
    )
  )
) {
  
  representation_name <-
    representation_reclassification_summary$
    Representation[i]
  
  match_index <- match(
    representation_name,
    representation_reliability_summary$
      Representation
  )
  
  representation_reliability_summary$
    Percentage_Classification_Different_From_Full[
      match_index
    ] <-
    representation_reclassification_summary$
    Percentage_Different[i]
}

full_layer_index <- match(
  "Layer 4",
  representation_reliability_summary$
    Representation
)

representation_reliability_summary$
  Mean_Absolute_Probability_Difference_From_Full[
    full_layer_index
  ] <- 0

representation_reliability_summary$
  Percentage_Classification_Different_From_Full[
    full_layer_index
  ] <- 0

representation_reliability_summary


# ============================================================
# 24. Identify change from reduced to full representation
# Retain the patient-level sensitivity metrics for each reduced
# digital representation relative to Layer 4.
# ============================================================

final_probability_sensitivity <-
  prediction_sensitivity_summary

row.names(
  final_probability_sensitivity
) <- NULL

final_probability_sensitivity


# ============================================================
# 25. Retain representation-based reclassification results
# Summarize how frequently the illustrative binary model output
# changes when less patient information is available.
#
# The classifications are methodological examples only and must
# not be interpreted as clinical risk categories.
# ============================================================

final_representation_reclassification <-
  representation_reclassification_summary

row.names(
  final_representation_reclassification
) <- NULL

final_representation_reclassification


# ============================================================
# 26. Summarize sequential information addition
# Evaluate whether adding new groups of patient information
# statistically changes model fit relative to the preceding
# representation.
#
# These likelihood-ratio comparisons assess statistical model
# fit only and do not establish clinical necessity.
# ============================================================

final_sequential_information_summary <-
  sequential_model_comparison

row.names(
  final_sequential_information_summary
) <- NULL

final_sequential_information_summary


# ============================================================
# 27. Create coefficient-stability summary
# Examine patient characteristics represented across multiple
# model layers and evaluate whether their estimated associations
# depend on the amount of available patient information.
# ============================================================

coefficient_stability_counts <- aggregate(
  
  representation_coefficient_summary$
    Odds_Ratio,
  
  by = list(
    Term =
      representation_coefficient_summary$
      Term
  ),
  
  FUN = length
)

names(
  coefficient_stability_counts
)[2] <- "Number_of_Representations"

repeated_coefficient_terms <-
  coefficient_stability_counts[
    coefficient_stability_counts$
      Number_of_Representations >
      1,
    "Term"
  ]

final_coefficient_stability <-
  representation_coefficient_summary[
    representation_coefficient_summary$Term %in%
      repeated_coefficient_terms,
    ,
    drop = FALSE
  ]

row.names(
  final_coefficient_stability
) <- NULL

final_coefficient_stability


# ============================================================
# 28. Summarize dichotomization experiment
# Retain the comparison between continuous ejection fraction
# and its deliberately simplified median-based binary
# representation.
#
# The median cutoff is methodological and not clinical.
# ============================================================

final_dichotomization_model_comparison <-
  dichotomization_model_comparison

row.names(
  final_dichotomization_model_comparison
) <- NULL

final_dichotomization_model_comparison


# ============================================================
# 29. Quantify model changes after dichotomization
# Express how the simplified representation differs from the
# continuous representation in model diagnostics.
#
# Positive AIC change means the dichotomized model has a higher
# AIC.
#
# Positive Brier-score change means the dichotomized model has
# greater in-sample probability error.
# ============================================================

continuous_row <-
  final_dichotomization_model_comparison[
    final_dichotomization_model_comparison$
      Representation ==
      "Continuous ejection fraction",
    ,
    drop = FALSE
  ]

dichotomized_row <-
  final_dichotomization_model_comparison[
    final_dichotomization_model_comparison$
      Representation ==
      "Dichotomized ejection fraction",
    ,
    drop = FALSE
  ]

dichotomization_change_summary <- data.frame(
  
  AIC_Change =
    dichotomized_row$AIC -
    continuous_row$AIC,
  
  Residual_Deviance_Change =
    dichotomized_row$Residual_Deviance -
    continuous_row$Residual_Deviance,
  
  McFadden_Pseudo_R2_Change =
    dichotomized_row$McFadden_Pseudo_R2 -
    continuous_row$McFadden_Pseudo_R2,
  
  Brier_Score_Change =
    dichotomized_row$Brier_Score -
    continuous_row$Brier_Score,
  
  stringsAsFactors = FALSE
)

dichotomization_change_summary[] <- round(
  dichotomization_change_summary,
  4
)

dichotomization_change_summary


# ============================================================
# 30. Retain patient-level dichotomization sensitivity
# Summarize changes in model probabilities caused only by
# simplifying the representation of ejection fraction.
# ============================================================

final_dichotomization_probability_sensitivity <-
  dichotomization_probability_sensitivity

final_dichotomization_probability_sensitivity


# ============================================================
# 31. Retain dichotomization reclassification result
# Record the proportion of patient-level analytical categories
# that changed after replacing continuous ejection fraction
# with a binary representation.
# ============================================================

final_dichotomization_reclassification <-
  dichotomization_reclassification

final_dichotomization_reclassification


# ============================================================
# 32. Create statistical evidence interpretation framework
# Explicitly distinguish what each analytical stage supports
# from what it cannot establish.
# ============================================================

statistical_interpretation_framework <- data.frame(
  
  Analytical_Stage = c(
    "Descriptive statistics",
    "Group comparisons",
    "Correlation analysis",
    "Logistic regression",
    "Representation sensitivity",
    "Dichotomization experiment"
  ),
  
  Supports = c(
    "Description of the digitally observed patient sample",
    "Identification of statistical differences between mortality groups",
    "Description of monotonic relationships between continuous variables",
    "Estimation of unadjusted and adjusted mortality associations",
    "Assessment of model dependence on available patient information",
    "Assessment of model sensitivity to simplification of one clinical variable"
  ),
  
  Does_Not_Establish = c(
    "Population-level clinical prevalence or causality",
    "Causality or clinical importance",
    "Causal relationships or clinical importance",
    "Causality, treatment effects, or validated prediction",
    "Clinical necessity of omitted information or real-world decision validity",
    "A clinically valid ejection-fraction threshold or treatment rule"
  ),
  
  stringsAsFactors = FALSE
)

statistical_interpretation_framework


# ============================================================
# 33. Create potential decision-context framework
# Describe possible healthcare decision contexts to which this
# type of analysis may be relevant while clearly separating
# methodological relevance from validated decision support.
# ============================================================

decision_context_framework <- data.frame(
  
  Decision_Context = c(
    "Population characterization",
    "Risk-oriented service planning",
    "Resource planning",
    "Quality management",
    "Data-driven management models"
  ),
  
  Potential_Relevance = c(
    "Digital patient data can describe the characteristics of an observed patient population",
    "Statistical patterns may help identify patient dimensions associated with different observed outcomes",
    "Patient-level risk structure may influence future estimates of healthcare demand",
    "Outcome-associated patient characteristics may contribute to analytical quality monitoring",
    "Statistical models can demonstrate how management-relevant information changes when the underlying patient representation changes"
  ),
  
  Current_Project_Limit = c(
    "The dataset is not population representative",
    "The models are not externally validated risk tools",
    "No direct resource-use or capacity variables are available",
    "No causal quality intervention is evaluated",
    "No actual management intervention or management outcome is observed"
  ),
  
  stringsAsFactors = FALSE
)

decision_context_framework


# ============================================================
# 34. Define clinical boundary framework
# State explicitly which questions cannot be answered from the
# current statistical analysis alone.
# ============================================================

clinical_boundary_framework <- data.frame(
  
  Question = c(
    "Is a statistical association clinically important?",
    "Is the observed association causal?",
    "Should a treatment be changed?",
    "Is a missing patient variable medically essential?",
    "Is the model sufficient for an individual patient decision?",
    "Is the illustrative probability threshold clinically valid?",
    "Is the ejection-fraction dichotomization clinically valid?"
  ),
  
  Answer_From_Current_Analysis = c(
    "Cannot be established from statistical significance alone",
    "No",
    "No",
    "Cannot be established from this dataset alone",
    "No",
    "No",
    "No"
  ),
  
  Additional_Requirement = c(
    "Clinical interpretation and external evidence",
    "Appropriate causal study design and assumptions",
    "Medical evaluation and treatment evidence",
    "Clinical knowledge and decision-specific evidence",
    "External validation, richer clinical information, and medical assessment",
    "Clinical validation and a defined decision context",
    "Clinically justified thresholds and medical evidence"
  ),
  
  stringsAsFactors = FALSE
)

clinical_boundary_framework


# ============================================================
# 35. Create representation principle summary
# Summarize the central methodological interpretation of the
# project.
# ============================================================

representation_principles <- data.frame(
  
  Principle = c(
    "The dataset represents selected aspects of the patient",
    "Statistical models operate on digital representations",
    "More information can change model outputs",
    "Simplification can change model outputs",
    "Statistical validity and clinical validity are different",
    "Decision quality depends partly on representation quality"
  ),
  
  Interpretation = c(
    "The available variables do not constitute a complete patient state",
    "A model analyzes recorded variables rather than the real patient directly",
    "Adding patient-information domains may alter fit, coefficients, and patient-level probabilities",
    "Reducing continuous information to categories may alter statistical evidence",
    "A statistically supported model is not automatically clinically sufficient",
    "Missing, simplified, or poorly represented patient information may propagate into downstream analyses"
  ),
  
  stringsAsFactors = FALSE
)

representation_principles


# ============================================================
# 36. Create presentation version of group findings
# Preserve full analytical precision while formatting p-values
# only for final display.
# ============================================================

significant_group_results_display <-
  significant_group_results

if (
  nrow(
    significant_group_results_display
  ) > 0
) {
  
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
# 37. Create presentation version of adjusted regression
# findings
# ============================================================

significant_regression_results_display <-
  significant_regression_results

if (
  nrow(
    significant_regression_results_display
  ) > 0
) {
  
  significant_regression_results_display$
    Coefficient <- round(
      significant_regression_results$
        Coefficient,
      3
    )
  
  significant_regression_results_display$
    Standard_Error <- round(
      significant_regression_results$
        Standard_Error,
      3
    )
  
  significant_regression_results_display$
    Adjusted_Odds_Ratio <- round(
      significant_regression_results$
        Adjusted_Odds_Ratio,
      3
    )
  
  significant_regression_results_display$
    CI_Lower <- round(
      significant_regression_results$
        CI_Lower,
      3
    )
  
  significant_regression_results_display$
    CI_Upper <- round(
      significant_regression_results$
        CI_Upper,
      3
    )
  
  significant_regression_results_display$
    P_Value <- format_p_value(
      significant_regression_results$
        P_Value
    )
}


# ============================================================
# 38. Create readable list of group-supported variables
# ============================================================

if (
  length(
    group_supported_variables
  ) > 0
) {
  
  group_supported_labels <- unname(
    variable_labels[
      group_supported_variables
    ]
  )
  
  group_supported_text <- paste(
    group_supported_labels,
    collapse = ", "
  )
  
} else {
  
  group_supported_text <-
    "No variables"
}


# ============================================================
# 39. Create readable list of consistently supported variables
# ============================================================

if (
  nrow(
    consistent_patient_characteristics
  ) > 0
) {
  
  consistent_variable_text <- paste(
    consistent_patient_characteristics$
      Clinical_Label,
    collapse = ", "
  )
  
} else {
  
  consistent_variable_text <-
    "No variables"
}


# ============================================================
# 40. Summarize strongest representation sensitivity
# Identify the reduced representation showing the largest mean
# absolute probability difference relative to the full model.
#
# This is a descriptive model-sensitivity result.
# ============================================================

largest_probability_difference_index <- which.max(
  final_probability_sensitivity$
    Mean_Absolute_Probability_Difference
)

largest_probability_difference_layer <-
  final_probability_sensitivity$
  Representation[
    largest_probability_difference_index
  ]

largest_probability_difference_value <-
  final_probability_sensitivity$
  Mean_Absolute_Probability_Difference[
    largest_probability_difference_index
  ]


# ============================================================
# 41. Extract dichotomization reclassification percentage
# ============================================================

dichotomization_reclassification_percentage <-
  final_dichotomization_reclassification$
  Percentage_Reclassified[1]


# ============================================================
# 42. Create final analytical conclusion statements
# Produce a concise, data-driven summary of the project without
# making causal, treatment, or clinical recommendation claims.
# ============================================================

final_analytical_conclusions <- c(
  
  paste0(
    "The analyzed dataset contained ",
    total_patient_count,
    " patients, of whom ",
    death_count,
    " experienced a recorded death event during follow-up ",
    "(",
    observed_mortality_percentage,
    "% of the analyzed sample)."
  ),
  
  paste0(
    "After Benjamini-Hochberg adjustment, the group-level ",
    "analysis statistically supported mortality differences ",
    "for: ",
    group_supported_text,
    "."
  ),
  
  paste0(
    "The patient characteristics supported across BH-adjusted ",
    "group testing, univariable regression, and multivariable ",
    "regression were: ",
    consistent_variable_text,
    "."
  ),
  
  paste0(
    "The representation sensitivity analysis showed that ",
    "patient-level model outputs changed when less baseline ",
    "patient information was digitally available. The largest ",
    "mean absolute probability difference relative to the full ",
    "available representation occurred for ",
    largest_probability_difference_layer,
    " (",
    round(
      largest_probability_difference_value,
      4
    ),
    ")."
  ),
  
  paste0(
    "Replacing continuous ejection fraction with a deliberately ",
    "simplified median-based binary representation changed the ",
    "illustrative model classification for ",
    round(
      dichotomization_reclassification_percentage,
      2
    ),
    "% of patients."
  ),
  
  paste0(
    "Of the ",
    nrow(
      patient_representation_map
    ),
    " predefined patient-information dimensions assessed in ",
    "the representation map, ",
    number_unrepresented_dimensions,
    " were not directly represented and ",
    number_limited_dimensions,
    " were classified as limited or very limited."
  ),
  
  paste0(
    "The results therefore demonstrate that statistical ",
    "conclusions are conditional on both the quality and the ",
    "structure of the available digital patient representation."
  ),
  
  paste0(
    "The analysis does not establish that the available ",
    "representation is clinically sufficient for treatment, ",
    "patient-level prediction, or healthcare management ",
    "decisions."
  )
)

final_analytical_conclusions


# ============================================================
# 43. Create final research-framework summary
# Express the complete analytical logic that can be reused in
# future digital patient data projects.
# ============================================================

final_research_framework <- data.frame(
  
  Stage = c(
    "1. Patient",
    "2. Digital representation",
    "3. Statistical analysis",
    "4. Reliability assessment",
    "5. Decision implications",
    "6. Clinical boundary"
  ),
  
  Central_Question = c(
    "What real patient population is being studied?",
    "Which patient dimensions are digitally represented and which are missing or simplified?",
    "What statistical patterns are supported by the available data?",
    "How stable are results when the digital representation changes?",
    "What type of healthcare decision could potentially use this information?",
    "Which conclusions require additional clinical information, validation, or medical expertise?"
  ),
  
  stringsAsFactors = FALSE
)

final_research_framework


# ============================================================
# 44. Create complete final analytical object
# Consolidate all major project outputs into one structured
# object for documentation and future reuse.
# ============================================================

final_clinical_and_decision_insights <- list(
  
  Mortality_Outcome =
    final_mortality_summary,
  
  BH_Adjusted_Group_Findings =
    significant_group_results,
  
  Significant_Univariable_Associations =
    significant_univariable_results,
  
  Significant_Adjusted_Associations =
    significant_regression_results,
  
  Adjusted_Association_Interpretations =
    adjusted_association_interpretations,
  
  Cross_Method_Evidence =
    cross_method_evidence_summary,
  
  Consistent_Patient_Characteristics =
    consistent_patient_characteristics,
  
  Strongest_Continuous_Correlations =
    strongest_correlations,
  
  Regression_Model_Fit =
    final_model_fit,
  
  Patient_Representation_Status =
    final_representation_status_summary,
  
  Representation_Boundary =
    representation_boundary_summary,
  
  Representation_Gaps =
    representation_gaps,
  
  Representation_Layers =
    representation_layer_overview,
  
  Representation_Reliability =
    representation_reliability_summary,
  
  Sequential_Information_Addition =
    final_sequential_information_summary,
  
  Coefficient_Stability =
    final_coefficient_stability,
  
  Patient_Level_Probability_Sensitivity =
    final_probability_sensitivity,
  
  Representation_Reclassification =
    final_representation_reclassification,
  
  Dichotomization_Model_Comparison =
    final_dichotomization_model_comparison,
  
  Dichotomization_Change =
    dichotomization_change_summary,
  
  Dichotomization_Probability_Sensitivity =
    final_dichotomization_probability_sensitivity,
  
  Dichotomization_Reclassification =
    final_dichotomization_reclassification,
  
  Statistical_Interpretation_Framework =
    statistical_interpretation_framework,
  
  Decision_Context =
    decision_context_framework,
  
  Clinical_Boundary =
    clinical_boundary_framework,
  
  Representation_Principles =
    representation_principles,
  
  Final_Analytical_Conclusions =
    final_analytical_conclusions,
  
  Research_Framework =
    final_research_framework
)


# ============================================================
# 45. Display final analytical overview
# ============================================================

cat(
  "\n",
  "============================================================\n",
  "FINAL CLINICAL AND DECISION INSIGHTS\n",
  "============================================================\n",
  sep = ""
)


# ============================================================
# 46. Display mortality outcome
# ============================================================

cat(
  "\nMORTALITY OUTCOME\n"
)

print(
  final_mortality_summary
)


# ============================================================
# 47. Display BH-adjusted group findings
# ============================================================

cat(
  "\nBH-ADJUSTED GROUP-LEVEL FINDINGS\n"
)

if (
  nrow(
    significant_group_results_display
  ) > 0
) {
  
  print(
    significant_group_results_display
  )
  
} else {
  
  cat(
    "No group-level findings remained statistically ",
    "significant after Benjamini-Hochberg adjustment.\n",
    sep = ""
  )
}


# ============================================================
# 48. Display significant adjusted associations
# ============================================================

cat(
  "\nSIGNIFICANT ADJUSTED MORTALITY ASSOCIATIONS\n"
)

if (
  nrow(
    significant_regression_results_display
  ) > 0
) {
  
  print(
    significant_regression_results_display[
      ,
      c(
        "Clinical_Label",
        "Adjusted_Odds_Ratio",
        "CI_Lower",
        "CI_Upper",
        "P_Value"
      ),
      drop = FALSE
    ]
  )
  
} else {
  
  cat(
    "No statistically significant adjusted mortality ",
    "associations were identified.\n",
    sep = ""
  )
}


# ============================================================
# 49. Display adjusted-association interpretations
# ============================================================

cat(
  "\nINTERPRETATION OF ADJUSTED ASSOCIATIONS\n"
)

for (
  interpretation in
  adjusted_association_interpretations
) {
  
  cat(
    "- ",
    interpretation,
    "\n",
    sep = ""
  )
}


# ============================================================
# 50. Display cross-method evidence
# ============================================================

cat(
  "\nCROSS-METHOD STATISTICAL EVIDENCE\n"
)

print(
  cross_method_evidence_summary
)


# ============================================================
# 51. Display consistently supported characteristics
# ============================================================

cat(
  "\nCONSISTENTLY SUPPORTED PATIENT CHARACTERISTICS\n"
)

if (
  nrow(
    consistent_patient_characteristics
  ) > 0
) {
  
  print(
    consistent_patient_characteristics
  )
  
} else {
  
  cat(
    "No patient characteristic was statistically supported ",
    "across all three analytical approaches.\n",
    sep = ""
  )
}


# ============================================================
# 52. Display strongest correlations
# ============================================================

cat(
  "\nSTRONGEST CONTINUOUS-VARIABLE CORRELATIONS\n"
)

print(
  strongest_correlations
)


# ============================================================
# 53. Display multivariable model fit
# ============================================================

cat(
  "\nMULTIVARIABLE REGRESSION MODEL FIT\n"
)

print(
  final_model_fit_display
)


# ============================================================
# 54. Display digital patient representation status
# ============================================================

cat(
  "\nDIGITAL PATIENT REPRESENTATION STATUS\n"
)

print(
  final_representation_status_summary
)


# ============================================================
# 55. Display representation boundary
# ============================================================

cat(
  "\nPATIENT REPRESENTATION BOUNDARY\n"
)

print(
  representation_boundary_summary
)


# ============================================================
# 56. Display representation reliability
# ============================================================

cat(
  "\nREPRESENTATION RELIABILITY\n"
)

print(
  representation_reliability_summary
)


# ============================================================
# 57. Display sequential information addition
# ============================================================

cat(
  "\nSEQUENTIAL INFORMATION ADDITION\n"
)

print(
  final_sequential_information_summary
)


# ============================================================
# 58. Display patient-level probability sensitivity
# ============================================================

cat(
  "\nPATIENT-LEVEL PROBABILITY SENSITIVITY\n"
)

print(
  final_probability_sensitivity
)


# ============================================================
# 59. Display representation-based reclassification
# ============================================================

cat(
  "\nILLUSTRATIVE RECLASSIFICATION UNDER REDUCED INFORMATION\n"
)

print(
  final_representation_reclassification
)


# ============================================================
# 60. Display dichotomization analysis
# ============================================================

cat(
  "\nCONTINUOUS VS DICHOTOMIZED PATIENT INFORMATION\n"
)

print(
  final_dichotomization_model_comparison
)

cat(
  "\nCHANGE AFTER DICHOTOMIZATION\n"
)

print(
  dichotomization_change_summary
)

cat(
  "\nPATIENT-LEVEL PROBABILITY CHANGE AFTER DICHOTOMIZATION\n"
)

print(
  final_dichotomization_probability_sensitivity
)

cat(
  "\nILLUSTRATIVE RECLASSIFICATION AFTER DICHOTOMIZATION\n"
)

print(
  final_dichotomization_reclassification
)


# ============================================================
# 61. Display decision-context framework
# ============================================================

cat(
  "\nPOTENTIAL HEALTHCARE DECISION CONTEXT\n"
)

print(
  decision_context_framework
)


# ============================================================
# 62. Display clinical boundary
# ============================================================

cat(
  "\nCLINICAL INTERPRETATION BOUNDARY\n"
)

print(
  clinical_boundary_framework
)


# ============================================================
# 63. Display final analytical conclusions
# ============================================================

cat(
  "\nFINAL ANALYTICAL CONCLUSIONS\n"
)

for (
  conclusion in
  final_analytical_conclusions
) {
  
  cat(
    "- ",
    conclusion,
    "\n",
    sep = ""
  )
}


# ============================================================
# 64. Display reusable research framework
# ============================================================

cat(
  "\nREUSABLE DIGITAL PATIENT ANALYSIS FRAMEWORK\n"
)

print(
  final_research_framework
)


# ============================================================
# 65. Report final interpretation and limitations
# Explicitly distinguish statistical evidence, model
# reliability, healthcare decision relevance, and clinical
# validity.
# ============================================================

cat(
  "\nINTERPRETATION AND LIMITATIONS\n",
  "\n",
  
  "- The dataset represents selected dimensions of real ",
  "patients rather than complete patient states.\n",
  
  "- Statistical associations do not establish causation.\n",
  
  "- Group-level hypothesis tests were adjusted using the ",
  "Benjamini-Hochberg procedure to account for multiple ",
  "testing.\n",
  
  "- Adjusted odds ratios describe associations conditional ",
  "on the other variables included in the logistic regression ",
  "model.\n",
  
  "- Correlations describe monotonic relationships and should ",
  "not be interpreted as causal relationships.\n",
  
  "- The dataset contains a relatively small patient sample, ",
  "so estimates may be unstable and should be interpreted ",
  "with appropriate caution.\n",
  
  "- Follow-up duration differs between patients. Logistic ",
  "regression models whether a death event was recorded but ",
  "does not explicitly model time-to-event information.\n",
  
  "- A dedicated mortality-time analysis would require ",
  "appropriate survival-analysis methods.\n",
  
  "- Representation-layer comparisons demonstrate dependence ",
  "of statistical outputs on information availability but do ",
  "not establish that any individual omitted variable is ",
  "clinically necessary.\n",
  
  "- Patient-level probabilities are in-sample analytical ",
  "outputs and have not been externally validated.\n",
  
  "- The illustrative 0.50 probability threshold used in the ",
  "representation sensitivity analysis is not a clinical ",
  "decision threshold.\n",
  
  "- The median-based dichotomization of ejection fraction is ",
  "a methodological experiment and not a clinically validated ",
  "classification rule.\n",
  
  "- The project contains no direct healthcare resource-use, ",
  "capacity, staffing, treatment-allocation, or management ",
  "intervention variables.\n",
  
  "- Consequently, the analysis can demonstrate principles ",
  "relevant to data-driven healthcare management but cannot ",
  "evaluate the effectiveness of an actual management ",
  "decision.\n",
  
  "- Statistical reliability is not equivalent to clinical ",
  "validity.\n",
  
  "- A statistically supported result may remain clinically ",
  "incomplete when important patient information is absent.\n",
  
  "- Clinical treatment recommendations cannot be derived ",
  "from this project.\n",
  
  "- The models have not been externally validated and should ",
  "not be interpreted as clinical prediction tools.\n",
  
  "- Clinical conclusions require appropriate medical ",
  "knowledge, additional patient information, external ",
  "evidence, and validation in independent populations.\n",
  
  sep = ""
)


# ============================================================
# 66. Return complete final analytical object
# ============================================================

final_clinical_and_decision_insights

