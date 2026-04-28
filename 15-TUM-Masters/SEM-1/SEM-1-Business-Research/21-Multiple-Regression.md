# Multiple Regression Analysis

## 🎯 Multiple Predictors

Extending simple regression to multiple independent variables.

---

## 📐 The Model

**Y = β₀ + β₁X₁ + β₂X₂ + ... + βₖXₖ + ε**

Where:
- Y = dependent variable
- X₁, X₂, ..., Xₖ = independent variables
- β₀ = intercept
- β₁, β₂, ..., βₖ = slopes
- ε = error term

---

## 🔍 Interpretation

### Slope Coefficients

**βⱼ** = change in Y for 1-unit change in Xⱼ, **holding other X's constant**

**Also called**:
- Partial effect
- Marginal effect
- Ceteris paribus effect

### Example
**Wage = β₀ + β₁(Education) + β₂(Experience) + ε**

**β₁** = effect of education, **controlling for** experience

---

## 📊 R² in Multiple Regression

**R²** = proportion of variance in Y explained by ALL X's

**Adjusted R²** = R² - [(k/(n-k-1)) × (1-R²)]
- Penalizes adding variables
- Use when comparing models with different k

---

## 🎯 F-Test for Overall Significance

**Tests**: H₀: β₁ = β₂ = ... = βₖ = 0

**Formula**: F = [R²/k] / [(1-R²)/(n-k-1)]

**Interpretation**: Does model explain significant variance?

---

## 🔑 Key Takeaways

1. **Multiple X's** predict single Y
2. **Coefficients** are partial effects
3. **Control** for confounds by including them
4. **R²** shows total variance explained
5. **F-test** for overall model significance

---

*Part of: [[15-TUM-Masters/SEM-1/SEM-1-Business-Research/00-Index|Business Research Methods Course Notes]]*
