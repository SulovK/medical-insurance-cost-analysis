# Medical Insurance Cost Drivers: Statistical Analysis in R

An analysis of medical insurance charges that uses statistical testing and regression-based methods to examine how smoking status, BMI, and geographic region relate to healthcare costs.

## Project overview

Medical insurance charges vary widely across individuals. This project analyzes 1,338 beneficiary records to identify meaningful cost differences between demographic and health-related groups, with a particular focus on smoking status, BMI, and region.

The analysis addresses four questions:

1. Do smokers and non-smokers have different average insurance charges?
2. Do average charges differ across U.S. regions?
3. Does smoking status remain significant after accounting for BMI?
4. Are smoking status and region associated with one another?

## Dataset

The dataset contains 1,338 observations and seven variables. No missing values were identified.

| Variable | Description | Type |
|---|---|---|
| `age` | Age of the primary beneficiary | Numeric |
| `sex` | Beneficiary sex | Categorical |
| `bmi` | Body mass index | Numeric |
| `children` | Number of covered dependents | Numeric |
| `smoker` | Smoking status | Categorical |
| `region` | U.S. residential region | Categorical |
| `charges` | Medical costs billed by insurance | Numeric |

## Analytical methods

- Descriptive statistics and exploratory visualizations
- Welch two-sample t-test
- One-way analysis of variance (ANOVA)
- Tukey multiple-comparison test
- Analysis of covariance (ANCOVA)
- Smoker-by-BMI interaction analysis
- Pearson chi-square test of independence
- Residual, normality, and equal-variance diagnostics

## Key findings

### Smoking status

Smoking status showed the largest difference in insurance charges. Smokers had average charges of **$32,050**, compared with **$8,434** for non-smokers. A Welch t-test found that this difference was statistically significant (`p < 2.2e-16`).

### Geographic region

Mean charges ranged from **$12,347** in the Southwest to **$14,735** in the Southeast. The overall ANOVA was statistically significant (`p = 0.0309`), but the Tukey test found only one significant pairwise difference: Southeast versus Southwest (`adjusted p = 0.0477`). Because the variance and normality assumptions were not fully satisfied, this regional result should be interpreted cautiously.

### BMI and smoking

Both BMI and smoking status were statistically significant in the ANCOVA model. The smoker-by-BMI interaction was also significant (`p < 2e-16`), indicating that the relationship between BMI and insurance charges differs between smokers and non-smokers. This interaction means a simple common-slope interpretation is not appropriate.

### Smoking status and region

The chi-square test did not find a statistically significant relationship between smoking status and region at the 5% level (`p = 0.0617`). This suggests that the observed regional cost differences are not explained simply by an uneven regional distribution of smokers.

## Selected results

| Analysis | Result | Interpretation |
|---|---:|---|
| Welch t-test | `p < 2.2e-16` | Mean charges differed significantly by smoking status |
| One-way ANOVA | `p = 0.0309` | At least one regional mean differed |
| Tukey comparison | `p = 0.0477` | Southeast charges exceeded Southwest charges |
| ANCOVA: smoker | `p < 2e-16` | Smoking remained significant after accounting for BMI |
| ANCOVA: BMI | `p < 2e-16` | BMI was significantly related to charges |
| Smoker × BMI | `p < 2e-16` | The effect of BMI differed by smoking status |
| Chi-square test | `p = 0.0617` | Smoking status and region were not significantly associated |

## Business implications

- Smoking status should be treated as a major risk factor in insurance cost analysis and predictive modeling.
- BMI is relevant to charges, but its effect should be modeled in combination with smoking status rather than assumed to be identical for both groups.
- Region may add useful information, although its effect appears smaller and less consistent than smoking status or BMI.
- Cost models may benefit from a transformed response variable, robust methods, or other approaches that better handle skewness and unequal variance.

## Tools and skills demonstrated

- R
- Base R statistical functions and visualizations
- Data cleaning and validation
- Exploratory data analysis
- Statistical hypothesis testing
- ANOVA and post-hoc comparisons
- Covariate and interaction modeling
- Assumption diagnostics
- Interpretation of statistical results for business decisions

## Repository contents

```text
.
├── insuranceanalysis.R
├── insurance.csv
├── insurance_report.docx
└── README.md
```

## How to run the analysis

1. Download or clone this repository.
2. Open `insuranceanalysis.R` in RStudio or another R environment.
3. Run the script.
4. When `file.choose()` opens, select `insurance.csv`.

The analysis uses only base R, so no additional packages are required. It produces descriptive summaries, statistical test results, assumption checks, and 11 exploratory and diagnostic visualizations.

## Limitations

This analysis identifies associations rather than causal effects. Insurance charges are strongly right-skewed, and several parametric-test assumptions were not fully met. The dataset also contains one duplicated row that should be reviewed before future modeling. Additional work could compare robust or nonparametric tests, transform the response variable, and build a validated predictive model using train/test data.

## Possible next steps

- Fit a multiple regression model using all available predictors.
- Compare models with raw and log-transformed insurance charges.
- Evaluate predictive performance using a holdout set or cross-validation.
- Investigate nonlinear relationships and interactions beyond smoking status and BMI.
- Document whether the duplicated record is valid or should be removed.
