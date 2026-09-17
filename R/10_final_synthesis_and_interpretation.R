# ============================================================
# Project: Representation Sensitivity Analysis
#          in Heart Failure with R
# File: 10_final_synthesis_and_interpretation.R
# Purpose: Integrate the analytical results from scripts
#          01-09, summarize representation sensitivity,
#          and define the supported interpretation boundaries
#          of the project.
#
# Important:
# This script performs synthesis only.
#
# It does NOT:
# - fit new statistical models
# - perform new hypothesis tests
# - create new inferential evidence
# - assign clinical validity
# - calculate a representation-quality score
# - calculate a representation-gap metric
# ============================================================


# ============================================================
# 1. Confirm required analytical objects
# ============================================================

required_objects <- c(
  "baseline_variables",
  "outcome_variable",
  "outcome_labels",
  "patient_representation_and_quality",
  "descriptive_statistics",
  "outcome_group_comparisons",
  "hypothesis_testing",
  "correlation_analysis",
  "regression_analysis",
  "representation_sensitivity_analysis"
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
      "Final synthesis failed. Run scripts 01-09 first. ",
      "Missing object(s): ",
      paste(
        missing_objects,
        collapse = ", "
      )
    )
  )
}


# ============================================================
# 2. Define integration-audit helper
# ============================================================
#
# Script 10 depends on the documented object structures
# created by previous scripts.
#
# This helper ensures that upstream analytical objects remain
# synchronized with the v1.0 workflow.
# ============================================================

assert_list_elements <- function(
    object,
    object_name,
    required_elements
) {
  
  missing_elements <- setdiff(
    required_elements,
    names(object)
  )
  
  
  if (length(missing_elements) > 0) {
    
    stop(
      paste0(
        "Final synthesis failed. Object '",
        object_name,
        "' is missing required element(s): ",
        paste(
          missing_elements,
          collapse = ", "
        )
      )
    )
  }
}


assert_list_elements(
  patient_representation_and_quality,
  "patient_representation_and_quality",
  c(
    "Representation_Map",
    "Representation_Limitations",
    "Unrepresented_Dimensions",
    "Observation_And_Outcome_Context",
    "Data_Quality_Overview"
  )
)


assert_list_elements(
  descriptive_statistics,
  "descriptive_statistics",
  c(
    "Sample_Overview",
    "Outcome_Summary_Raw"
  )
)


assert_list_elements(
  outcome_group_comparisons,
  "outcome_group_comparisons",
  c(
    "Outcome_Data_Overview",
    "Outcome_Group_Summary",
    "Baseline_Numerical_Differences_Raw",
    "Follow_Up_Summary_Raw"
  )
)


assert_list_elements(
  hypothesis_testing,
  "hypothesis_testing",
  c(
    "Primary_Test_Summary",
    "BH_Supported_Group_Differences"
  )
)


assert_list_elements(
  correlation_analysis,
  "correlation_analysis",
  c(
    "Ranked_Results",
    "Strongest_Observed_Relationships"
  )
)


assert_list_elements(
  regression_analysis,
  "regression_analysis",
  c(
    "Outcome_Definition",
    "Univariable_Results",
    "Nominal_Univariable_Results_Below_Alpha",
    "Multivariable_Results",
    "Nominal_Multivariable_Results_Below_Alpha",
    "Model_Fit",
    "Diagnostic_Summary"
  )
)


assert_list_elements(
  representation_sensitivity_analysis,
  "representation_sensitivity_analysis",
  c(
    "Layer_Overview",
    "Common_Sample_Overview",
    "Model_Comparison",
    "Sequential_Information_Addition_Tests",
    "Coefficient_Stability",
    "Fitted_Probability_Sensitivity",
    "Classification_Sensitivity",
    "Ejection_Fraction_Simplification_Cutoff",
    "Ejection_Fraction_Model_Comparison",
    "Ejection_Fraction_Fitted_Probability_Sensitivity",
    "Ejection_Fraction_Classification_Sensitivity"
  )
)


# ============================================================
# 3. Define presentation helpers
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


format_p_value_columns <- function(
    data
) {
  
  display <- data
  
  p_value_columns <- names(display)[
    grepl(
      "^P_Value|P_Adjusted",
      names(display)
    )
  ]
  
  for (
    column in p_value_columns
  ) {
    
    display[[column]] <- format.pval(
      data[[column]],
      digits = 4,
      eps = 0.0001
    )
  }
  
  display
}


collapse_or_none <- function(
    values
) {
  
  values <- unique(
    values[
      !is.na(values) &
        nzchar(values)
    ]
  )
  
  
  if (length(values) == 0) {
    return("none")
  }
  
  
  paste(
    values,
    collapse = ", "
  )
}


format_variable_name <- function(
    variable
) {
  
  variable_labels <- c(
    
    age =
      "age",
    
    anaemia =
      "anaemia",
    
    creatinine_phosphokinase =
      "creatinine phosphokinase",
    
    diabetes =
      "diabetes",
    
    ejection_fraction =
      "ejection fraction",
    
    high_blood_pressure =
      "high blood pressure",
    
    platelets =
      "platelets",
    
    serum_creatinine =
      "serum creatinine",
    
    serum_sodium =
      "serum sodium",
    
    sex =
      "sex",
    
    smoking =
      "smoking"
  )
  
  
  if (
    variable %in%
    names(variable_labels)
  ) {
    
    return(
      unname(
        variable_labels[
          [variable]
        ]
      )
    )
  }
  
  
  gsub(
    "_",
    " ",
    variable
  )
}


format_variable_list <- function(
    variables
) {
  
  if (
    length(variables) == 0
  ) {
    return("none")
  }
  
  
  formatted <- vapply(
    variables,
    format_variable_name,
    character(1)
  )
  
  
  paste(
    unique(formatted),
    collapse = ", "
  )
}


# ============================================================
# 4. Summarize observed analytical sample and outcome
# ============================================================
#
# The recorded death-event proportion is a property of this
# dataset and its follow-up structure.
#
# It must NOT be interpreted as:
#
# - fixed-horizon mortality risk
# - population-level heart-failure mortality
# ============================================================

sample_overview <-
  descriptive_statistics$
  Sample_Overview


outcome_summary_raw <-
  descriptive_statistics$
  Outcome_Summary_Raw


event_row <- outcome_summary_raw[
  outcome_summary_raw$Category ==
    outcome_labels[2],
  ,
  drop = FALSE
]


if (
  nrow(event_row) != 1
) {
  stop(
    paste0(
      "Final synthesis failed. Unable to identify exactly ",
      "one recorded death-event outcome row."
    )
  )
}


observed_sample_and_outcome <- data.frame(
  
  Analytical_Sample_N =
    sample_overview$
    Analytical_Sample_N,
  
  Recorded_Death_Event_N =
    event_row$Count,
  
  Recorded_Death_Event_Percentage =
    event_row$Percentage,
  
  Missing_Outcome_N =
    event_row$Missing_N,
  
  stringsAsFactors = FALSE
)


observed_sample_and_outcome_display <-
  round_numeric_columns(
    observed_sample_and_outcome,
    digits = 2
  )


# ============================================================
# 5. Retain digital patient-representation description
# ============================================================
#
# Representation domains remain qualitative.
#
# No representation score, completeness percentage, or
# representation-gap metric is calculated.
# ============================================================

representation_map_final <-
  patient_representation_and_quality$
  Representation_Map


representation_limitations_final <-
  patient_representation_and_quality$
  Representation_Limitations


unrepresented_dimensions_final <-
  patient_representation_and_quality$
  Unrepresented_Dimensions


observation_and_outcome_context_final <-
  patient_representation_and_quality$
  Observation_And_Outcome_Context


technical_data_quality_final <-
  patient_representation_and_quality$
  Data_Quality_Overview


# ============================================================
# 6. Retain descriptive outcome-group differences
# ============================================================
#
# These are descriptive results from script 05.
#
# They do not provide formal inferential evidence.
# ============================================================

descriptive_outcome_differences <-
  outcome_group_comparisons$
  Baseline_Numerical_Differences_Raw


descriptive_outcome_differences_display <-
  round_numeric_columns(
    descriptive_outcome_differences,
    digits = 2
  )


follow_up_by_outcome <-
  outcome_group_comparisons$
  Follow_Up_Summary_Raw


follow_up_by_outcome_display <-
  round_numeric_columns(
    follow_up_by_outcome,
    digits = 2
  )


# ============================================================
# 7. Retain primary BH-adjusted group-level inference
# ============================================================
#
# Script 06 defines the primary formal baseline testing family.
#
# Benjamini-Hochberg-adjusted p-values provide the primary
# inferential criterion for those group-level comparisons.
# ============================================================

primary_group_tests <-
  hypothesis_testing$
  Primary_Test_Summary


bh_supported_group_differences <-
  hypothesis_testing$
  BH_Supported_Group_Differences


if (
  nrow(
    bh_supported_group_differences
  ) > 0
) {
  
  bh_supported_group_differences <-
    bh_supported_group_differences[
      order(
        bh_supported_group_differences$
          P_Adjusted_BH
      ),
      ,
      drop = FALSE
    ]
}


row.names(
  bh_supported_group_differences
) <- NULL


primary_group_tests_display <-
  format_p_value_columns(
    primary_group_tests
  )


bh_supported_group_differences_display <-
  format_p_value_columns(
    bh_supported_group_differences
  )


# ============================================================
# 8. Retain logistic-regression results
# ============================================================
#
# Regression p-values are nominal.
#
# They are NOT combined with the BH-adjusted group tests into
# a single evidence score.
# ============================================================

univariable_results_final <-
  regression_analysis$
  Univariable_Results


nominal_univariable_results_below_alpha <-
  regression_analysis$
  Nominal_Univariable_Results_Below_Alpha


multivariable_results_final <-
  regression_analysis$
  Multivariable_Results


nominal_multivariable_results_below_alpha <-
  regression_analysis$
  Nominal_Multivariable_Results_Below_Alpha


model_fit_final <-
  regression_analysis$
  Model_Fit


diagnostic_summary_final <-
  regression_analysis$
  Diagnostic_Summary


multivariable_results_display <-
  round_numeric_columns(
    multivariable_results_final,
    digits = 4
  )


multivariable_results_display <-
  format_p_value_columns(
    multivariable_results_display
  )


nominal_multivariable_results_display <-
  round_numeric_columns(
    nominal_multivariable_results_below_alpha,
    digits = 4
  )


nominal_multivariable_results_display <-
  format_p_value_columns(
    nominal_multivariable_results_display
  )


model_fit_display <-
  round_numeric_columns(
    model_fit_final,
    digits = 4
  )


# ============================================================
# 9. Retain exploratory correlation structure
# ============================================================
#
# The strongest observed correlations were selected
# descriptively in script 07.
#
# They are not treated as confirmatory findings or variable-
# selection evidence.
# ============================================================

strongest_observed_correlations <-
  correlation_analysis$
  Strongest_Observed_Relationships


strongest_observed_correlations_display <-
  round_numeric_columns(
    strongest_observed_correlations,
    digits = 3
  )


strongest_observed_correlations_display <-
  format_p_value_columns(
    strongest_observed_correlations_display
  )


# ============================================================
# 10. Retain representation-model comparison
# ============================================================

representation_layer_overview <-
  representation_sensitivity_analysis$
  Layer_Overview


representation_common_sample <-
  representation_sensitivity_analysis$
  Common_Sample_Overview


representation_model_comparison <-
  representation_sensitivity_analysis$
  Model_Comparison


representation_model_comparison_display <-
  round_numeric_columns(
    representation_model_comparison,
    digits = 4
  )


# ============================================================
# 11. Retain sequential information-addition results
# ============================================================
#
# These tests use nominal exploratory p-values.
#
# Statistical model-fit changes do not establish that added
# information is clinically necessary or that an expanded
# representation is clinically superior.
# ============================================================

sequential_information_addition <-
  representation_sensitivity_analysis$
  Sequential_Information_Addition_Tests


sequential_information_addition_display <-
  round_numeric_columns(
    sequential_information_addition,
    digits = 4
  )


sequential_information_addition_display <-
  format_p_value_columns(
    sequential_information_addition_display
  )


# ============================================================
# 12. Retain coefficient-stability results
# ============================================================

coefficient_stability_final <-
  representation_sensitivity_analysis$
  Coefficient_Stability


coefficient_stability_display <-
  round_numeric_columns(
    coefficient_stability_final,
    digits = 4
  )


# ============================================================
# 13. Retain patient-level fitted-probability sensitivity
# ============================================================
#
# Layer 4 is an analytical reference containing the full
# available baseline variable set.
#
# It is NOT clinical ground truth.
# ============================================================

fitted_probability_sensitivity <-
  representation_sensitivity_analysis$
  Fitted_Probability_Sensitivity


fitted_probability_sensitivity_display <-
  round_numeric_columns(
    fitted_probability_sensitivity,
    digits = 4
  )


# ============================================================
# 14. Retain illustrative classification sensitivity
# ============================================================
#
# The fixed 0.50 threshold is methodological only.
# ============================================================

classification_sensitivity <-
  representation_sensitivity_analysis$
  Classification_Sensitivity


classification_sensitivity_display <-
  round_numeric_columns(
    classification_sensitivity,
    digits = 2
  )


# ============================================================
# 15. Retain ejection-fraction simplification experiment
# ============================================================

ejection_fraction_cutoff <-
  representation_sensitivity_analysis$
  Ejection_Fraction_Simplification_Cutoff


ejection_fraction_model_comparison <-
  representation_sensitivity_analysis$
  Ejection_Fraction_Model_Comparison


ejection_fraction_probability_sensitivity <-
  representation_sensitivity_analysis$
  Ejection_Fraction_Fitted_Probability_Sensitivity


ejection_fraction_classification_sensitivity <-
  representation_sensitivity_analysis$
  Ejection_Fraction_Classification_Sensitivity


ejection_fraction_model_comparison_display <-
  round_numeric_columns(
    ejection_fraction_model_comparison,
    digits = 4
  )


ejection_fraction_probability_sensitivity_display <-
  round_numeric_columns(
    ejection_fraction_probability_sensitivity,
    digits = 4
  )


ejection_fraction_classification_sensitivity_display <-
  round_numeric_columns(
    ejection_fraction_classification_sensitivity,
    digits = 2
  )


# ============================================================
# 16. Define supported analytical scope
# ============================================================
#
# These statements summarize what the current project can
# reasonably evaluate.
#
# They do not expand the evidence beyond scripts 01-09.
# ============================================================

supported_analytical_scope <- c(
  
  "Describe the observed analytical sample",
  
  paste0(
    "Describe baseline patient characteristics according ",
    "to recorded death-event status during observed follow-up"
  ),
  
  paste0(
    "Perform formal baseline group-level comparisons with ",
    "Benjamini-Hochberg adjustment"
  ),
  
  paste0(
    "Describe exploratory relationships among continuous ",
    "baseline patient characteristics"
  ),
  
  paste0(
    "Estimate univariable associations between available ",
    "baseline characteristics and the recorded binary outcome"
  ),
  
  paste0(
    "Estimate multivariable associations conditional on the ",
    "available baseline representation"
  ),
  
  "Describe in-sample logistic-model behavior",
  
  paste0(
    "Evaluate representation sensitivity across nested ",
    "project-defined baseline representations"
  ),
  
  paste0(
    "Evaluate output sensitivity to reducing the amount of ",
    "patient information supplied to the model"
  ),
  
  paste0(
    "Evaluate output sensitivity to simplifying an available ",
    "continuous patient characteristic"
  )
)


# ============================================================
# 17. Define unsupported conclusions
# ============================================================

unsupported_conclusions <- c(
  
  "Establish causal effects",
  
  "Estimate individual treatment effects",
  
  "Recommend patient treatment",
  
  "Define validated clinical thresholds",
  
  "Provide validated fixed-horizon mortality-risk estimates",
  
  "Provide validated survival predictions",
  
  "Demonstrate external predictive performance",
  
  "Establish complete clinical adequacy of a representation",
  
  paste0(
    "Determine whether an omitted patient characteristic is ",
    "necessary for every healthcare question"
  ),
  
  "Calculate a validated representation-quality score",
  
  "Calculate a validated representation-gap metric",
  
  "Identify a universally optimal digital patient representation",
  
  "Validate healthcare-management decisions",
  
  "Determine optimal healthcare resource allocation",
  
  paste0(
    "Demonstrate that use of the statistical models improves ",
    "patient outcomes"
  )
)


evidence_boundary <- list(
  
  Supported_Analytical_Scope =
    supported_analytical_scope,
  
  Unsupported_Conclusions =
    unsupported_conclusions
)


# ============================================================
# 18. Define decision-support interpretation boundary
# ============================================================
#
# The project does not evaluate actual healthcare-management
# actions.
#
# Its decision-support relevance is methodological:
# statistical evidence used downstream is generated from the
# digital patient representation available to the model.
# ============================================================

decision_support_boundary <- data.frame(
  
  Level = c(
    "Digital patient representation",
    "Statistical model",
    "Statistical evidence",
    "Potential decision support",
    "Actual decision validity"
  ),
  
  Current_Project_Status = c(
    "Directly examined through representation mapping and sensitivity analysis",
    "Directly examined through logistic regression models",
    "Directly examined within the available analytical framework",
    "Conceptually relevant but not directly evaluated",
    "Not evaluated"
  ),
  
  stringsAsFactors = FALSE
)


# ============================================================
# 19. Define final interpretation principles
# ============================================================

final_interpretation_principles <- c(
  
  "Association does not establish causation.",
  
  paste0(
    "Statistical significance does not establish clinical ",
    "importance."
  ),
  
  paste0(
    "Adjusted associations remain conditional on the patient ",
    "information represented in the dataset."
  ),
  
  paste0(
    "Digital patient data represent selected information ",
    "about the patient, not the complete real-world patient."
  ),
  
  paste0(
    "Technical data quality and patient representation are ",
    "different analytical concepts."
  ),
  
  paste0(
    "More available variables do not automatically imply a ",
    "clinically superior patient representation."
  ),
  
  paste0(
    "Layer 4 is the full available baseline representation ",
    "within this dataset, not clinical ground truth."
  ),
  
  paste0(
    "Representation sensitivity demonstrates dependence of ",
    "statistical output on representation; it does not ",
    "establish representation validity."
  ),
  
  paste0(
    "In-sample model behavior does not constitute external ",
    "or clinical validation."
  ),
  
  paste0(
    "Binary logistic modeling of the recorded death-event ",
    "outcome does not replace time-to-event analysis."
  ),
  
  paste0(
    "Statistical evidence does not automatically establish ",
    "valid healthcare decision support."
  )
)


# ============================================================
# 20. Extract variable sets for narrative synthesis
# ============================================================

bh_supported_variable_names <-
  bh_supported_group_differences$
  Variable


nominal_multivariable_variable_names <-
  unique(
    nominal_multivariable_results_below_alpha$
      Variable
  )


unrepresented_domain_names <-
  unrepresented_dimensions_final$
  Patient_Information_Domain


# ============================================================
# 21. Create final project synthesis
# ============================================================
#
# The synthesis summarizes previously generated evidence only.
#
# No new inferential conclusion is created here.
# ============================================================

final_synthesis <- c(
  
  paste0(
    "The analytical dataset contains ",
    observed_sample_and_outcome$
      Analytical_Sample_N,
    " patient records. A death event was recorded for ",
    observed_sample_and_outcome$
      Recorded_Death_Event_N,
    " patients (",
    round(
      observed_sample_and_outcome$
        Recorded_Death_Event_Percentage,
      1
    ),
    "%) during variable observed follow-up."
  ),
  
  
  paste0(
    "Within the predefined baseline group-comparison family, ",
    "Benjamini-Hochberg-adjusted differences were observed ",
    "for: ",
    format_variable_list(
      bh_supported_variable_names
    ),
    "."
  ),
  
  
  paste0(
    "In the full multivariable logistic model, nominal ",
    "p-values below the project alpha level were observed ",
    "for: ",
    format_variable_list(
      nominal_multivariable_variable_names
    ),
    ". These regression p-values are nominal and are not ",
    "combined with the adjusted group tests into a single ",
    "evidence score."
  ),
  
  
  paste0(
    "The qualitative patient-representation map documents ",
    "multiple information domains that are absent from the ",
    "available dataset, including: ",
    collapse_or_none(
      unrepresented_domain_names
    ),
    ". These classifications describe representation ",
    "limitations and are not a quantitative representation-",
    "quality or representation-gap metric."
  ),
  
  
  paste0(
    "The representation-sensitivity analysis holds the ",
    "analytical patient sample constant while changing the ",
    "amount of baseline patient information supplied to the ",
    "logistic model."
  ),
  
  
  paste0(
    "Across the project-defined nested representations, ",
    "model fit, coefficient estimates, and patient-level ",
    "in-sample fitted probabilities can change as the ",
    "available patient information changes."
  ),
  
  
  paste0(
    "Layer 4 serves only as an analytical reference because ",
    "it contains the full available baseline variable set. ",
    "It is not treated as the real patient, clinical ground ",
    "truth, or a validated optimal representation."
  ),
  
  
  paste0(
    "The ejection-fraction simplification experiment further ",
    "examines representation sensitivity by replacing a ",
    "continuous measurement with an arbitrary median-based ",
    "binary representation."
  ),
  
  
  paste0(
    "The project therefore demonstrates that statistical ",
    "output can be sensitive to the digital representation ",
    "supplied to the model, while remaining unable to ",
    "determine which representation is clinically sufficient ",
    "for a particular healthcare decision."
  )
)


# ============================================================
# 22. Consolidate final project synthesis
# ============================================================

final_synthesis_and_interpretation <- list(
  
  Observed_Sample_And_Outcome =
    observed_sample_and_outcome,
  
  Technical_Data_Quality =
    technical_data_quality_final,
  
  Patient_Representation_Map =
    representation_map_final,
  
  Representation_Limitations =
    representation_limitations_final,
  
  Unrepresented_Patient_Information_Domains =
    unrepresented_dimensions_final,
  
  Observation_And_Outcome_Context =
    observation_and_outcome_context_final,
  
  Descriptive_Outcome_Group_Differences =
    descriptive_outcome_differences,
  
  Follow_Up_By_Outcome =
    follow_up_by_outcome,
  
  Primary_Group_Tests =
    primary_group_tests,
  
  BH_Supported_Group_Differences =
    bh_supported_group_differences,
  
  Univariable_Regression_Results =
    univariable_results_final,
  
  Nominal_Univariable_Results_Below_Alpha =
    nominal_univariable_results_below_alpha,
  
  Multivariable_Regression_Results =
    multivariable_results_final,
  
  Nominal_Multivariable_Results_Below_Alpha =
    nominal_multivariable_results_below_alpha,
  
  Regression_Model_Fit =
    model_fit_final,
  
  Regression_Diagnostic_Summary =
    diagnostic_summary_final,
  
  Strongest_Observed_Correlations =
    strongest_observed_correlations,
  
  Representation_Layer_Overview =
    representation_layer_overview,
  
  Representation_Common_Sample =
    representation_common_sample,
  
  Representation_Model_Comparison =
    representation_model_comparison,
  
  Sequential_Information_Addition =
    sequential_information_addition,
  
  Coefficient_Stability =
    coefficient_stability_final,
  
  Fitted_Probability_Sensitivity =
    fitted_probability_sensitivity,
  
  Illustrative_Classification_Sensitivity =
    classification_sensitivity,
  
  Ejection_Fraction_Simplification_Cutoff =
    ejection_fraction_cutoff,
  
  Ejection_Fraction_Model_Comparison =
    ejection_fraction_model_comparison,
  
  Ejection_Fraction_Fitted_Probability_Sensitivity =
    ejection_fraction_probability_sensitivity,
  
  Ejection_Fraction_Classification_Sensitivity =
    ejection_fraction_classification_sensitivity,
  
  Evidence_Boundary =
    evidence_boundary,
  
  Decision_Support_Boundary =
    decision_support_boundary,
  
  Interpretation_Principles =
    final_interpretation_principles,
  
  Final_Synthesis =
    final_synthesis
)


# ============================================================
# 23. Display final analytical synthesis
# ============================================================

cat(
  "\n",
  "============================================================\n",
  "FINAL SYNTHESIS AND INTERPRETATION\n",
  "============================================================\n",
  sep = ""
)


cat(
  "\nOBSERVED SAMPLE AND RECORDED OUTCOME\n"
)

print(
  observed_sample_and_outcome_display,
  row.names = FALSE
)


cat(
  "\nTECHNICAL DATA QUALITY\n"
)

print(
  technical_data_quality_final,
  row.names = FALSE
)


cat(
  "\nDIGITAL PATIENT REPRESENTATION\n"
)

print(
  representation_map_final,
  row.names = FALSE
)


cat(
  "\nUNREPRESENTED PATIENT-INFORMATION DOMAINS\n"
)

print(
  unrepresented_dimensions_final,
  row.names = FALSE
)


cat(
  "\nDESCRIPTIVE BASELINE OUTCOME-GROUP DIFFERENCES\n"
)

print(
  descriptive_outcome_differences_display,
  row.names = FALSE
)


cat(
  "\nFOLLOW-UP DURATION BY RECORDED DEATH-EVENT STATUS\n"
)

print(
  follow_up_by_outcome_display,
  row.names = FALSE
)


cat(
  "\nBH-ADJUSTED BASELINE GROUP FINDINGS\n"
)

if (
  nrow(
    bh_supported_group_differences_display
  ) > 0
) {
  
  print(
    bh_supported_group_differences_display,
    row.names = FALSE
  )
  
} else {
  
  cat(
    "No baseline group comparison met the BH-adjusted ",
    "significance criterion.\n"
  )
}


cat(
  "\nFULL MULTIVARIABLE LOGISTIC REGRESSION\n"
)

print(
  multivariable_results_display,
  row.names = FALSE
)


cat(
  "\nNOMINAL MULTIVARIABLE P-VALUES BELOW ALPHA\n"
)

if (
  nrow(
    nominal_multivariable_results_display
  ) > 0
) {
  
  print(
    nominal_multivariable_results_display,
    row.names = FALSE
  )
  
} else {
  
  cat(
    "No multivariable regression term had a nominal ",
    "p-value below alpha.\n"
  )
}


cat(
  "\nIN-SAMPLE FULL-MODEL BEHAVIOR\n"
)

print(
  model_fit_display,
  row.names = FALSE
)


cat(
  "\nSTRONGEST OBSERVED EXPLORATORY CORRELATIONS\n"
)

print(
  strongest_observed_correlations_display,
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
  "\nCOMMON REPRESENTATION-ANALYSIS SAMPLE\n"
)

print(
  representation_common_sample,
  row.names = FALSE
)


cat(
  "\nREPRESENTATION MODEL COMPARISON\n"
)

print(
  representation_model_comparison_display,
  row.names = FALSE
)


cat(
  "\nSEQUENTIAL INFORMATION ADDITION\n"
)

print(
  sequential_information_addition_display,
  row.names = FALSE
)


cat(
  "\nCOEFFICIENT STABILITY\n"
)

print(
  coefficient_stability_display,
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
  classification_sensitivity_display,
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


cat(
  "\nDECISION-SUPPORT INTERPRETATION BOUNDARY\n"
)

print(
  decision_support_boundary,
  row.names = FALSE
)


# ============================================================
# 24. Display interpretation principles
# ============================================================

cat(
  "\nINTERPRETATION PRINCIPLES\n\n"
)


for (
  principle in
  final_interpretation_principles
) {
  
  cat(
    "- ",
    principle,
    "\n",
    sep = ""
  )
}


# ============================================================
# 25. Display final synthesis
# ============================================================

cat(
  "\nFINAL SYNTHESIS\n\n"
)


for (
  statement in
  final_synthesis
) {
  
  cat(
    "- ",
    statement,
    "\n",
    sep = ""
  )
}


# ============================================================
# 26. Display core project principle
# ============================================================

cat(
  "\nCORE PROJECT PRINCIPLE\n\n",
  
  "A statistical model does not analyze the complete real-world ",
  "patient directly. It analyzes the patient information that ",
  "has been digitally represented and supplied to the model.\n\n",
  
  "The same underlying patients can therefore generate different ",
  "statistical outputs when the amount or granularity of that ",
  "information changes.\n\n",
  
  "Representation sensitivity demonstrates this dependence. ",
  "It does not determine which digital representation is ",
  "clinically correct, sufficient, or valid for a particular ",
  "healthcare decision.\n",
  
  sep = ""
)


# ============================================================
# 27. Return complete final synthesis object
# ============================================================

final_synthesis_and_interpretation

