# ============================================================
# Project: Representation Sensitivity Analysis
#          in Heart Failure with R
# File: 04_data_visualization.R
# Purpose: Visualize baseline patient characteristics,
#          observation information, the recorded death-event
#          outcome, and descriptive outcome-group patterns.
# ============================================================


# ============================================================
# 1. Confirm required setup objects from script 01
# ============================================================

required_objects <- c(
  "heart_failure",
  "baseline_numerical_variables",
  "baseline_categorical_variables",
  "observation_variables",
  "follow_up_variable",
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
# 2. Confirm visualization package
# ============================================================

if (!requireNamespace("ggplot2", quietly = TRUE)) {
  stop(
    paste0(
      "Package 'ggplot2' is required for script 04. ",
      "Install it before running this script."
    )
  )
}

library(ggplot2)


# ============================================================
# 3. Define plotting labels
# ============================================================
#
# Labels are used only for graphical presentation.
# Variable names in the analytical dataset remain unchanged.
# ============================================================

plot_labels <- c(
  age =
    "Age (years)",
  
  creatinine_phosphokinase =
    "Creatinine Phosphokinase (mcg/L)",
  
  ejection_fraction =
    "Ejection Fraction (%)",
  
  platelets =
    "Platelets (kiloplatelets/mL)",
  
  serum_creatinine =
    "Serum Creatinine (mg/dL)",
  
  serum_sodium =
    "Serum Sodium (mEq/L)",
  
  time =
    "Observed Follow-up Duration (days)",
  
  anaemia =
    "Anaemia",
  
  diabetes =
    "Diabetes",
  
  high_blood_pressure =
    "High Blood Pressure",
  
  sex =
    "Sex",
  
  smoking =
    "Smoking Status",
  
  DEATH_EVENT =
    "Recorded Death-Event Outcome"
)


get_plot_label <- function(variable) {
  
  if (!(variable %in% names(plot_labels))) {
    stop(
      paste0(
        "No plotting label defined for variable: ",
        variable
      )
    )
  }
  
  unname(
    plot_labels[[variable]]
  )
}


# ============================================================
# 4. Verify plotting variables
# ============================================================

plotting_variables <- unique(
  c(
    baseline_numerical_variables,
    baseline_categorical_variables,
    observation_variables,
    outcome_variable
  )
)

missing_plot_variables <- setdiff(
  plotting_variables,
  names(heart_failure)
)

if (length(missing_plot_variables) > 0) {
  stop(
    paste0(
      "Visualization setup failed. Missing variable(s): ",
      paste(
        missing_plot_variables,
        collapse = ", "
      )
    )
  )
}

missing_plot_labels <- setdiff(
  plotting_variables,
  names(plot_labels)
)

if (length(missing_plot_labels) > 0) {
  stop(
    paste0(
      "Visualization setup failed. Missing plotting label(s): ",
      paste(
        missing_plot_labels,
        collapse = ", "
      )
    )
  )
}


# ============================================================
# 5. Define reusable plotting functions
# ============================================================

make_histogram <- function(
    data,
    variable
) {
  
  ggplot(
    data = data,
    aes(
      x = .data[[variable]]
    )
  ) +
    geom_histogram(
      bins = 25,
      na.rm = TRUE
    ) +
    labs(
      title = paste(
        "Distribution of",
        get_plot_label(variable)
      ),
      x = get_plot_label(variable),
      y = "Number of Patients"
    ) +
    theme_minimal()
}


make_boxplot <- function(
    data,
    variable
) {
  
  ggplot(
    data = data,
    aes(
      y = .data[[variable]]
    )
  ) +
    geom_boxplot(
      na.rm = TRUE
    ) +
    labs(
      title = paste(
        "Distribution of",
        get_plot_label(variable)
      ),
      x = NULL,
      y = get_plot_label(variable)
    ) +
    theme_minimal()
}


make_barplot <- function(
    data,
    variable
) {
  
  ggplot(
    data = data,
    aes(
      x = .data[[variable]]
    )
  ) +
    geom_bar(
      na.rm = TRUE
    ) +
    labs(
      title = paste(
        get_plot_label(variable),
        "Distribution"
      ),
      x = get_plot_label(variable),
      y = "Number of Patients"
    ) +
    theme_minimal()
}


make_outcome_boxplot <- function(
    data,
    variable
) {
  
  ggplot(
    data = data,
    aes(
      x = .data[[outcome_variable]],
      y = .data[[variable]]
    )
  ) +
    geom_boxplot(
      na.rm = TRUE
    ) +
    labs(
      title = paste(
        get_plot_label(variable),
        "by Recorded Death-Event Status"
      ),
      x = "Recorded Death-Event Status",
      y = get_plot_label(variable)
    ) +
    theme_minimal()
}


# ============================================================
# 6. Visualize baseline numerical characteristics
# ============================================================
#
# Histograms describe distributional shape.
# Boxplots complement them by showing central distribution,
# spread, and observations beyond the boxplot whiskers.
#
# Such observations are not automatically treated as errors.
# ============================================================

baseline_numerical_histograms <- setNames(
  lapply(
    baseline_numerical_variables,
    function(variable) {
      make_histogram(
        heart_failure,
        variable
      )
    }
  ),
  baseline_numerical_variables
)


baseline_numerical_boxplots <- setNames(
  lapply(
    baseline_numerical_variables,
    function(variable) {
      make_boxplot(
        heart_failure,
        variable
      )
    }
  ),
  baseline_numerical_variables
)


# ============================================================
# 7. Visualize baseline categorical characteristics
# ============================================================

baseline_categorical_barplots <- setNames(
  lapply(
    baseline_categorical_variables,
    function(variable) {
      make_barplot(
        heart_failure,
        variable
      )
    }
  ),
  baseline_categorical_variables
)


# ============================================================
# 8. Visualize observation information
# ============================================================
#
# Follow-up duration is visualized separately because it
# describes observation time rather than a baseline patient
# characteristic.
# ============================================================

observation_histograms <- setNames(
  lapply(
    observation_variables,
    function(variable) {
      make_histogram(
        heart_failure,
        variable
      )
    }
  ),
  observation_variables
)


observation_boxplots <- setNames(
  lapply(
    observation_variables,
    function(variable) {
      make_boxplot(
        heart_failure,
        variable
      )
    }
  ),
  observation_variables
)


# ============================================================
# 9. Visualize recorded death-event outcome
# ============================================================
#
# The outcome is visualized separately from baseline patient
# characteristics.
# ============================================================

outcome_barplot <- make_barplot(
  heart_failure,
  outcome_variable
)


# ============================================================
# 10. Visualize baseline numerical characteristics
#     by recorded death-event status
# ============================================================
#
# These plots are descriptive only.
#
# They visualize observed distributions according to whether
# a death event was recorded during each patient's observed
# follow-up period.
#
# Follow-up duration is intentionally excluded because it is
# observation information rather than a baseline patient
# characteristic.
#
# Descriptive group summaries are performed in script 05.
# Formal group-level inference is performed in script 06.
# ============================================================

outcome_group_boxplots <- setNames(
  lapply(
    baseline_numerical_variables,
    function(variable) {
      make_outcome_boxplot(
        heart_failure,
        variable
      )
    }
  ),
  baseline_numerical_variables
)


# ============================================================
# 11. Consolidate visualization objects
# ============================================================

data_visualizations <- list(
  
  Baseline_Numerical_Histograms =
    baseline_numerical_histograms,
  
  Baseline_Numerical_Boxplots =
    baseline_numerical_boxplots,
  
  Baseline_Categorical_Barplots =
    baseline_categorical_barplots,
  
  Observation_Histograms =
    observation_histograms,
  
  Observation_Boxplots =
    observation_boxplots,
  
  Outcome_Barplot =
    outcome_barplot,
  
  Outcome_Group_Boxplots =
    outcome_group_boxplots
)


# ============================================================
# 12. Display baseline numerical plots
# ============================================================

invisible(
  lapply(
    baseline_numerical_histograms,
    print
  )
)

invisible(
  lapply(
    baseline_numerical_boxplots,
    print
  )
)


# ============================================================
# 13. Display baseline categorical plots
# ============================================================

invisible(
  lapply(
    baseline_categorical_barplots,
    print
  )
)


# ============================================================
# 14. Display observation-information plots
# ============================================================

invisible(
  lapply(
    observation_histograms,
    print
  )
)

invisible(
  lapply(
    observation_boxplots,
    print
  )
)


# ============================================================
# 15. Display outcome plot
# ============================================================

print(
  outcome_barplot
)


# ============================================================
# 16. Display descriptive outcome-group plots
# ============================================================

invisible(
  lapply(
    outcome_group_boxplots,
    print
  )
)


# ============================================================
# 17. Interpretation note
# ============================================================

cat(
  "\n",
  "============================================================\n",
  "DATA VISUALIZATION\n",
  "============================================================\n",
  sep = ""
)

cat(
  "\nINTERPRETATION NOTE\n",
  "\n",
  "These visualizations are descriptive only.\n",
  "\n",
  "Baseline patient characteristics, observation information, ",
  "and the recorded death-event outcome are visualized ",
  "separately.\n",
  "\n",
  "Outcome-group boxplots describe observed differences in ",
  "baseline numerical distributions according to recorded ",
  "death-event status during observed follow-up.\n",
  "\n",
  "Visual patterns alone do not establish statistical ",
  "significance, causality, prognostic importance, or ",
  "clinical relevance.\n",
  "\n",
  "Observations beyond boxplot whiskers are not automatically ",
  "treated as data errors or removed from the analysis.\n",
  "\n",
  "These figures are exploratory project visualizations and ",
  "are not intended as publication-formatted figures.\n",
  sep = ""
)


# ============================================================
# 18. Return complete visualization object
# ============================================================

data_visualizations

