# ============================================================
# Project: Representation Sensitivity Analysis 
#          in Heart Failure with R
# File: 04_data_visualization.R
# Purpose: Visualize overall distributions, categorical
#          characteristics, and selected mortality-group
#          patterns.
# ============================================================


# ============================================================
# 1. Confirm required objects from script 01
# ============================================================

required_objects <- c(
  "heart_failure",
  "numerical_variables",
  "categorical_variables",
  "baseline_numerical_variables",
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
# 2. Load visualization package
# ============================================================

library(ggplot2)


# ============================================================
# 3. Define plotting labels
# Used only for graphical presentation.
# ============================================================

plot_labels <- c(
  age = "Age (years)",
  creatinine_phosphokinase = "Creatinine Phosphokinase (mcg/L)",
  ejection_fraction = "Ejection Fraction (%)",
  platelets = "Platelets (kiloplatelets/mL)",
  serum_creatinine = "Serum Creatinine (mg/dL)",
  serum_sodium = "Serum Sodium (mEq/L)",
  time = "Follow-up Duration (days)",
  anaemia = "Anaemia",
  diabetes = "Diabetes",
  high_blood_pressure = "High Blood Pressure",
  sex = "Sex",
  smoking = "Smoking Status",
  DEATH_EVENT = "Mortality Outcome"
)

get_plot_label <- function(variable) {
  unname(
    plot_labels[
      variable
    ]
  )
}


# ============================================================
# 4. Define reusable plotting functions
# ============================================================

make_histogram <- function(variable) {
  
  ggplot(
    heart_failure,
    aes(
      x = .data[[variable]]
    )
  ) +
    geom_histogram(
      bins = 25
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


make_boxplot <- function(variable) {
  
  ggplot(
    heart_failure,
    aes(
      y = .data[[variable]]
    )
  ) +
    geom_boxplot() +
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


make_barplot <- function(variable) {
  
  ggplot(
    heart_failure,
    aes(
      x = .data[[variable]]
    )
  ) +
    geom_bar() +
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


make_outcome_boxplot <- function(variable) {
  
  ggplot(
    heart_failure,
    aes(
      x = .data[[outcome_variable]],
      y = .data[[variable]]
    )
  ) +
    geom_boxplot() +
    labs(
      title = paste(
        get_plot_label(variable),
        "by Mortality Outcome"
      ),
      x = "Mortality Outcome",
      y = get_plot_label(variable)
    ) +
    theme_minimal()
}


# ============================================================
# 5. Create numerical distribution plots
# Histograms visualize distributional shape.
# Boxplots complement them by highlighting spread and unusual
# observations.
# ============================================================

numerical_histograms <- setNames(
  lapply(
    numerical_variables,
    make_histogram
  ),
  numerical_variables
)

numerical_boxplots <- setNames(
  lapply(
    numerical_variables,
    make_boxplot
  ),
  numerical_variables
)


# ============================================================
# 6. Create categorical distribution plots
# Includes baseline categorical characteristics and mortality
# outcome for the complete observed population.
# ============================================================

categorical_barplots <- setNames(
  lapply(
    categorical_variables,
    make_barplot
  ),
  categorical_variables
)


# ============================================================
# 7. Visualize baseline numerical variables by mortality group
# These plots are descriptive only.
#
# Follow-up time is excluded because it represents observation
# duration rather than baseline patient information.
# Formal group comparison is performed later in scripts 05–06.
# ============================================================

mortality_group_boxplots <- setNames(
  lapply(
    baseline_numerical_variables,
    make_outcome_boxplot
  ),
  baseline_numerical_variables
)


# ============================================================
# 8. Consolidate visualization objects
# ============================================================

data_visualizations <- list(
  
  Numerical_Histograms =
    numerical_histograms,
  
  Numerical_Boxplots =
    numerical_boxplots,
  
  Categorical_Barplots =
    categorical_barplots,
  
  Mortality_Group_Boxplots =
    mortality_group_boxplots
)


# ============================================================
# 9. Display plots
# ============================================================

invisible(
  lapply(
    numerical_histograms,
    print
  )
)

invisible(
  lapply(
    numerical_boxplots,
    print
  )
)

invisible(
  lapply(
    categorical_barplots,
    print
  )
)

invisible(
  lapply(
    mortality_group_boxplots,
    print
  )
)


# ============================================================
# 10. Return complete visualization object
# ============================================================

data_visualizations

