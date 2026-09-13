# ============================================================
# Project: Heart Failure Clinical Statistical Analysis with R
# File: 08_regression_analysis.R
# Purpose: Analyze associations between patient characteristics
# and mortality using logistic regression models.
# Language: R
# ============================================================


# ============================================================
# 1. Define regression variables
# Select baseline demographic and clinical characteristics
# for mortality outcome analysis.
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


# ============================================================
# 2. Confirm mortality outcome levels
# Logistic regression models the probability of the second
# factor level, which represents a recorded death event.
# ============================================================

levels(
  heart_failure$DEATH_EVENT
)


# ============================================================
# 3. Perform univariable logistic regression
# Estimate the individual association between each patient
# characteristic and mortality outcome.
# ============================================================

univariable_results <- do.call(
  rbind,
  lapply(
    regression_variables,
    function(variable) {
      
      model <- glm(
        reformulate(
          variable,
          response = "DEATH_EVENT"
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
        rownames(coefficient_table) != "(Intercept)",
        ,
        drop = FALSE
      ]
      
      data.frame(
        Variable = variable,
        Term = rownames(coefficient_table),
        Coefficient = coefficient_table[, "Estimate"],
        Standard_Error = coefficient_table[, "Std. Error"],
        Odds_Ratio = exp(
          coefficient_table[, "Estimate"]
        ),
        CI_Lower = exp(
          coefficient_table[, "Estimate"] -
            1.96 * coefficient_table[, "Std. Error"]
        ),
        CI_Upper = exp(
          coefficient_table[, "Estimate"] +
            1.96 * coefficient_table[, "Std. Error"]
        ),
        P_Value = coefficient_table[, "Pr(>|z|)"]
      )
    }
  )
)

row.names(univariable_results) <- NULL

univariable_results[
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
  univariable_results[
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

univariable_results


# ============================================================
# 4. Fit multivariable logistic regression
# Estimate associations with mortality while simultaneously
# accounting for the other baseline patient characteristics.
# ============================================================

mortality_model <- glm(
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

summary(
  mortality_model
)


# ============================================================
# 5. Calculate adjusted odds ratios
# Transform regression coefficients into adjusted odds ratios
# with 95% confidence intervals.
# ============================================================

multivariable_coefficients <- summary(
  mortality_model
)$coefficients

multivariable_coefficients <- multivariable_coefficients[
  rownames(multivariable_coefficients) != "(Intercept)",
  ,
  drop = FALSE
]

multivariable_results <- data.frame(
  Term = rownames(
    multivariable_coefficients
  ),
  
  Coefficient = multivariable_coefficients[
    ,
    "Estimate"
  ],
  
  Standard_Error = multivariable_coefficients[
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
  
  P_Value = multivariable_coefficients[
    ,
    "Pr(>|z|)"
  ]
)

row.names(multivariable_results) <- NULL

multivariable_results[, -1] <- round(
  multivariable_results[, -1],
  4
)

multivariable_results


# ============================================================
# 6. Identify statistically significant associations
# Flag model coefficients with p-values below the predefined
# significance level of 0.05.
# ============================================================

multivariable_results$Significant <- ifelse(
  multivariable_results$P_Value < 0.05,
  "Yes",
  "No"
)

multivariable_results


# ============================================================
# 7. Review logistic regression model fit
# Report basic model fit statistics without interpreting
# individual clinical findings.
# ============================================================

model_fit <- data.frame(
  Null_Deviance = mortality_model$null.deviance,
  Residual_Deviance = mortality_model$deviance,
  AIC = AIC(
    mortality_model
  )
)

round(
  model_fit,
  2
)

