# ============================================================
# DATA ANALYSIS PROJECT: INSURANCE CHARGES
# Part A: Categorical and Group Comparison Analysis
# ============================================================



# ============================================================
# 1. LOAD AND INSPECT THE DATASET
# ============================================================

# Load the dataset
insurance <- read.csv(file.choose())

# Look at the first few rows
head(insurance)

# Check variable names
names(insurance)

# Check structure of the dataset
str(insurance)

# Check for missing values
colSums(is.na(insurance))



# ============================================================
# 2. PREPARE VARIABLES
# ============================================================

# Convert categorical variables to factors
insurance$sex <- factor(insurance$sex)
insurance$smoker <- factor(insurance$smoker)
insurance$region <- factor(insurance$region)
insurance$children <- factor(insurance$children)

# Check structure again after converting variables
str(insurance)



# ============================================================
# 3. DESCRIPTIVE STATISTICS
# ============================================================

# ------------------------------------------------------------
# 3A. Descriptive Statistics for Continuous Variables
# ------------------------------------------------------------

# Summary statistics for continuous variables
summary(insurance$age)
summary(insurance$bmi)
summary(insurance$charges)

# Standard deviations
sd(insurance$age)
sd(insurance$bmi)
sd(insurance$charges)

# Means
mean(insurance$age)
mean(insurance$bmi)
mean(insurance$charges)

# Medians
median(insurance$age)
median(insurance$bmi)
median(insurance$charges)

# Minimum and maximum for response variable
min(insurance$charges)
max(insurance$charges)


# ------------------------------------------------------------
# 3B. Descriptive Statistics for Categorical Variables
# ------------------------------------------------------------

# Frequency tables
table(insurance$sex)
table(insurance$smoker)
table(insurance$region)
table(insurance$children)

# Percent tables
prop.table(table(insurance$sex)) * 100
prop.table(table(insurance$smoker)) * 100
prop.table(table(insurance$region)) * 100
prop.table(table(insurance$children)) * 100



# ============================================================
# 4. VISUALIZATIONS
# ============================================================

# ------------------------------------------------------------
# 4A. Histogram of Response Variable: Charges
# ------------------------------------------------------------

hist(
  insurance$charges,
  main = "Distribution of Insurance Charges",
  xlab = "Insurance Charges",
  col = "lightblue",
  border = "black"
)


# ------------------------------------------------------------
# 4B. Bar Chart for Smoker
# ------------------------------------------------------------

barplot(
  table(insurance$smoker),
  main = "Number of Smokers and Non-Smokers",
  xlab = "Smoker Status",
  ylab = "Count",
  col = "lightblue"
)


# ------------------------------------------------------------
# 4C. Pie Chart for Sex
# ------------------------------------------------------------

pie(
  table(insurance$sex),
  main = "Distribution by Sex",
  col = c("lightblue", "lightgreen")
)


# ------------------------------------------------------------
# 4D. Boxplot: Charges by Smoker
# ------------------------------------------------------------

boxplot(
  charges ~ smoker,
  data = insurance,
  main = "Insurance Charges by Smoking Status",
  xlab = "Smoker Status",
  ylab = "Insurance Charges",
  col = "lightblue"
)



# ============================================================
# 5. t-TEST: CHARGES BY SMOKER STATUS
# ============================================================

# Hypotheses:
# H0: Mean insurance charges are equal for smokers and non-smokers.
# Ha: Mean insurance charges are different for smokers and non-smokers.

# Make sure smoker is categorical
insurance$smoker <- factor(insurance$smoker)

# Group means
tapply(insurance$charges, insurance$smoker, mean)

# Group standard deviations
tapply(insurance$charges, insurance$smoker, sd)

# Boxplot
boxplot(
  charges ~ smoker,
  data = insurance,
  main = "Charges by Smoking Status",
  xlab = "Smoker Status",
  ylab = "Insurance Charges",
  col = "lightblue"
)

# Assumption check 1: normality within each group
shapiro.test(insurance$charges[insurance$smoker == "no"])
shapiro.test(insurance$charges[insurance$smoker == "yes"])

# Assumption check 2: equal variance
var.test(charges ~ smoker, data = insurance)

# Welch two-sample t-test
# Welch is appropriate if variances are unequal
t.test(charges ~ smoker, data = insurance)



# ============================================================
# 6. ANOVA: CHARGES BY REGION
# ============================================================

# Hypotheses:
# H0: Mean insurance charges are equal across all regions.
# Ha: At least one region has a different mean insurance charge.

# Make sure region is categorical
insurance$region <- factor(insurance$region)

# Group means
tapply(insurance$charges, insurance$region, mean)

# Group standard deviations
tapply(insurance$charges, insurance$region, sd)

# Boxplot
boxplot(
  charges ~ region,
  data = insurance,
  main = "Charges by Region",
  xlab = "Region",
  ylab = "Insurance Charges",
  col = "lightblue"
)

# ANOVA model
anova_region <- aov(charges ~ region, data = insurance)

# ANOVA table
summary(anova_region)

# Assumption check 1: residuals vs fitted plot
plot(anova_region, which = 1)

# Assumption check 2: normal Q-Q plot
plot(anova_region, which = 2)

# Assumption check 3: normality of residuals
shapiro.test(residuals(anova_region))

# Assumption check 4: equal variance across groups
bartlett.test(charges ~ region, data = insurance)

# Tukey post-hoc test
# Use this if ANOVA is significant
TukeyHSD(anova_region)



# ============================================================
# 7. ANCOVA: CHARGES BY SMOKER STATUS, CONTROLLING FOR BMI
# ============================================================

# Make sure smoker is categorical
insurance$smoker <- factor(insurance$smoker)

# Check group counts
table(insurance$smoker)

# Scatterplot with groups
plot(
  insurance$bmi,
  insurance$charges,
  col = insurance$smoker,
  pch = 19,
  main = "ANCOVA: Charges by BMI and Smoking Status",
  xlab = "BMI",
  ylab = "Insurance Charges"
)

legend(
  "topleft",
  legend = levels(insurance$smoker),
  col = 1:length(levels(insurance$smoker)),
  pch = 19,
  title = "Smoker"
)

# Check homogeneity of slopes assumption
ancova_interaction <- aov(charges ~ smoker * bmi, data = insurance)
summary(ancova_interaction)

# ANCOVA model
ancova_model <- aov(charges ~ smoker + bmi, data = insurance)
summary(ancova_model)

# Assumption check 1: residuals vs fitted plot
plot(ancova_model, which = 1)

# Assumption check 2: normal Q-Q plot
plot(ancova_model, which = 2)

# Assumption check 3: normality of residuals
shapiro.test(residuals(ancova_model))

# Add regression lines by smoker group
abline(
  lm(charges ~ bmi, data = insurance, subset = smoker == "no"),
  col = 1,
  lwd = 2
)

abline(
  lm(charges ~ bmi, data = insurance, subset = smoker == "yes"),
  col = 2,
  lwd = 2
)



# ============================================================
# 8. CHI-SQUARE TEST OF INDEPENDENCE: SMOKER AND REGION
# ============================================================

# Make sure variables are categorical
insurance$smoker <- factor(insurance$smoker)
insurance$region <- factor(insurance$region)

# Create contingency table
smoker_region_table <- table(insurance$smoker, insurance$region)

# View observed counts
smoker_region_table

# Run chi-square test
chi_smoker_region <- chisq.test(smoker_region_table)

# View chi-square test results
chi_smoker_region

# Assumption check: expected counts should generally be 5 or greater
chi_smoker_region$expected

# Check whether all expected counts are at least 5
all(chi_smoker_region$expected >= 5)

# Bar chart for smoker status by region
barplot(
  smoker_region_table,
  beside = TRUE,
  legend = TRUE,
  main = "Smoking Status by Region",
  xlab = "Region",
  ylab = "Count",
  col = c("lightblue", "lightgreen")
)