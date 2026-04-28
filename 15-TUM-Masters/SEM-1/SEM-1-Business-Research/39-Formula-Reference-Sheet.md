# Formula Reference Sheet

## 🎯 Quick Reference for Business Research Methods Exam

This sheet contains ALL formulas you need to know for calculations.

---

## 📊 DESCRIPTIVE STATISTICS

### Mean (Average)
**Sample Mean**: x̄ = (Σxᵢ) / n = (x₁ + x₂ + ... + xₙ) / n

**Population Mean**: μ = (ΣXᵢ) / N

### Variance
**Sample Variance**: s² = Σ(xᵢ - x̄)² / (n-1)

**Population Variance**: σ² = Σ(Xᵢ - μ)² / N

### Standard Deviation
**Sample SD**: s = √[Σ(xᵢ - x̄)² / (n-1)]

**Population SD**: σ = √[Σ(Xᵢ - μ)² / N]

---

## 📐 SAMPLING AND INFERENCE

### Standard Error
**Standard Error of Mean**: SE = σ / √n  
(Or use s/√n when σ unknown)

**Interpretation**: Smaller SE = more precise estimate

### Confidence Interval
**95% CI for Mean**: x̄ ± 1.96 × (σ/√n)  
**99% CI for Mean**: x̄ ± 2.576 × (σ/√n)

**General Form**: x̄ ± (critical value) × SE

**Critical Values**:
- 90% CI: ±1.645
- 95% CI: ±1.96
- 99% CI: ±2.576

---

## 🔗 CORRELATION AND COVARIANCE

### Covariance
**Sample Covariance**: Cov(X,Y) = Σ[(xᵢ - x̄)(yᵢ - ȳ)] / (n-1)

**Alternative**: Cov(X,Y) = r × sₓ × sᵧ

### Correlation
**Pearson Correlation**: r = Cov(X,Y) / (sₓ × sᵧ)

**Range**: -1 ≤ r ≤ 1
- r = 1: Perfect positive
- r = 0: No linear relationship
- r = -1: Perfect negative

### Key Relationship
r = Cov(X,Y) / (sₓ × sᵧ)  
Cov(X,Y) = r × sₓ × sᵧ

---

## 📈 SIMPLE LINEAR REGRESSION

### Model
Y = β₀ + β₁X + ε

### OLS Estimators
**Slope**: β₁ = Cov(X,Y) / Var(X) = Σ[(xᵢ-x̄)(yᵢ-ȳ)] / Σ(xᵢ-x̄)²

**Alternative**: β₁ = r × (sᵧ/sₓ)

**Intercept**: β₀ = ȳ - β₁x̄

**Key**: Regression line passes through (x̄, ȳ)

### Residuals
**Residual**: eᵢ = yᵢ - ŷᵢ = yᵢ - (β₀ + β₁xᵢ)

**Predicted Value**: ŷᵢ = β₀ + β₁xᵢ

### Sum of Squares
**Total Sum of Squares**: SST = Σ(yᵢ - ȳ)²  
(Total variation in Y)

**Explained Sum of Squares**: SSE = Σ(ŷᵢ - ȳ)²  
(Variation explained by model)

**Residual Sum of Squares**: SSR = Σ(yᵢ - ŷᵢ)² = Σeᵢ²  
(Unexplained variation)

**Relationship**: SST = SSE + SSR

### R-Squared
**R²** = SSE / SST = 1 - (SSR / SST)

**Interpretation**: Proportion of variance in Y explained by X

**Range**: 0 ≤ R² ≤ 1

**Adjusted R²**: R̄² = 1 - [(1-R²)(n-1)/(n-k-1)]  
(Penalizes adding variables; k = # predictors)

### Standard Error of Regression
**SER** = √[SSR / (n-2)] = √[Σeᵢ² / (n-2)]

**Relationship with R²**:
- SER ↑ → SSR ↑ → R² ↓
- SER ↓ → SSR ↓ → R² ↑

---

## 🎓 HYPOTHESIS TESTING

### t-Statistic
**For Regression Coefficient**: t = β̂ / SE(β̂)

**For Mean Difference**: t = (x̄₁ - x̄₂) / SE(difference)

**Degrees of Freedom**:
- Simple regression: df = n - 2
- Multiple regression: df = n - k - 1 (k = # predictors)

### p-Value Interpretation
- p < 0.01: *** (highly significant)
- p < 0.05: ** (significant)
- p < 0.10: * (marginally significant)
- p ≥ 0.10: not significant (n.s.)

### Confidence Interval for Coefficient
**95% CI**: β̂ ± 1.96 × SE(β̂)  
(Use t-critical value for small samples)

---

## 📊 MULTIPLE REGRESSION

### Model
Y = β₀ + β₁X₁ + β₂X₂ + ... + βₖXₖ + ε

### F-Test for Overall Significance
**F-statistic**: F = [SSE/k] / [SSR/(n-k-1)]

**Alternative**: F = [R²/k] / [(1-R²)/(n-k-1)]

**Tests**: H₀: β₁ = β₂ = ... = βₖ = 0

**Decision**: Reject H₀ if p-value < α (typically 0.05)

---

## 🔄 LOG TRANSFORMATIONS

### Interpretation Rules

**Level-Level**: Y = β₀ + β₁X + ε  
→ 1 unit ↑ in X → β₁ units ↑ in Y

**Log-Level**: log(Y) = β₀ + β₁X + ε  
→ 1 unit ↑ in X → β₁ × 100% ↑ in Y

**Level-Log**: Y = β₀ + β₁log(X) + ε  
→ 1% ↑ in X → β₁/100 units ↑ in Y

**Log-Log**: log(Y) = β₀ + β₁log(X) + ε  
→ 1% ↑ in X → β₁% ↑ in Y (elasticity)

---

## 🎯 BINARY/DUMMY VARIABLES

### Model with Dummy
Y = β₀ + β₁D + ε  
where D ∈ {0,1}

**Interpretation**:
- β₀ = E(Y|D=0) = Mean for reference group
- β₁ = E(Y|D=1) - E(Y|D=0) = Difference between groups

### Dummy Variable Rule
**k categories → k-1 dummies**  
(Avoid dummy variable trap/perfect multicollinearity)

---

## 🔗 INTERACTION EFFECTS

### Model
Y = β₀ + β₁X + β₂Z + β₃(X×Z) + ε

**Interpretation of β₃**:
- How effect of X on Y changes as Z changes
- Or: How effect of Z on Y changes as X changes

### Marginal Effect of X
∂Y/∂X = β₁ + β₃Z

**Interpretation**: Effect of X depends on level of Z

---

## 📏 FACTOR ANALYSIS

### Eigenvalue
**Measure of variance** explained by a factor

**Kaiser Criterion**: Retain factors with eigenvalue > 1

### Factor Loading
**Correlation** between variable and factor

**Guidelines**:
- |loading| > 0.70: Excellent
- |loading| > 0.60: Good
- |loading| > 0.50: Acceptable
- |loading| > 0.40: Borderline
- |loading| < 0.40: Poor

---

## 📐 RELIABILITY MEASURES

### Cronbach's Alpha
**α** = (k/(k-1)) × [1 - (Σσᵢ²/σₜₒₜₐₗ²)]

Where:
- k = number of items
- σᵢ² = variance of item i
- σₜₒₜₐₗ² = variance of total score

**Interpretation**:
- α < 0.60: Unacceptable
- α 0.60-0.70: Questionable
- α 0.70-0.80: Acceptable
- α 0.80-0.90: Good
- α > 0.90: Excellent

---

## 🎲 PROBABILITY AND DISTRIBUTIONS

### Normal Distribution Properties
- Mean = Median = Mode
- Symmetric around mean
- 68% within ±1σ
- 95% within ±1.96σ
- 99% within ±2.576σ

### Z-Score
z = (x - μ) / σ

**Interpretation**: Number of standard deviations from mean

---

## 🧮 COMMON CALCULATIONS FROM EXAM

### Given r, sₓ, sᵧ → Find β₁
β₁ = r × (sᵧ/sₓ)

**Example**: r=0.25, sᵧ=7, sₓ=3  
β₁ = 0.25 × (7/3) = 0.583

### Given β₁, x̄, ȳ → Find β₀
β₀ = ȳ - β₁x̄

**Example**: β₁=0.7, x̄=60, ȳ=70  
β₀ = 70 - 0.7(60) = 28

### Given Cov(X,Y), Var(X) → Find β₁
β₁ = Cov(X,Y) / Var(X)

**Example**: Cov=5.25, Var(X)=9  
β₁ = 5.25/9 = 0.583

### Given Estimate, t-value → Find SE
SE = Estimate / t-value

**Example**: β̂=3.100e-04, t=9.958  
SE = 0.0003100 / 9.958 = 3.11e-05

### Given r, sₓ, sᵧ → Find Cov
Cov(X,Y) = r × sₓ × sᵧ

**Example**: r=0.25, sₓ=3, sᵧ=7  
Cov = 0.25 × 3 × 7 = 5.25

---

## 📊 QUICK REFERENCE TABLE

| Need to Find | Given | Formula |
|--------------|-------|---------|
| β₁ (slope) | Cov, Var(X) | β₁ = Cov/Var(X) |
| β₁ (slope) | r, sₓ, sᵧ | β₁ = r(sᵧ/sₓ) |
| β₀ (intercept) | β₁, x̄, ȳ | β₀ = ȳ - β₁x̄ |
| SE | β̂, t-value | SE = β̂/t |
| Cov | r, sₓ, sᵧ | Cov = r·sₓ·sᵧ |
| r | Cov, sₓ, sᵧ | r = Cov/(sₓ·sᵧ) |
| R² | SSE, SST | R² = SSE/SST |
| R² | SSR, SST | R² = 1 - SSR/SST |

---

## 🚨 COMMON TRAPS

### Trap 1: Correlation vs. Covariance
**Remember**: r is **standardized** (unitless, -1 to 1)  
Cov is **unstandardized** (has units, -∞ to +∞)

### Trap 2: Sample vs. Population
**Sample**: x̄, s, n  
**Population**: μ, σ, N

### Trap 3: SST = SSE + SSR
**Not** SST = SSE + SSE (common mistake!)

### Trap 4: SE Formula
SE = σ/√n  
**NOT** SE = σ × √n

### Trap 5: Dummy Variables
k categories → k-1 dummies  
**NOT** k dummies (creates perfect multicollinearity)

---

## 🎯 EXAM STRATEGY CHECKLIST

When solving calculation problems:

**Step 1**: Identify what you're asked to find
- [ ] β₁? β₀? SE? R²? 

**Step 2**: List what you're given
- [ ] Write down all numbers
- [ ] Note which are sample vs. population

**Step 3**: Find the right formula
- [ ] Check this reference sheet
- [ ] Make sure you have all needed inputs

**Step 4**: Calculate carefully
- [ ] Show your work
- [ ] Check units
- [ ] Verify answer makes sense

**Step 5**: Interpret (if asked)
- [ ] What does the number mean?
- [ ] In context of the problem

---

## 🔑 MEMORIZATION AIDS

### The "3 S's" of Regression
**SST** = **S**um of **S**quares **T**otal (total variation)  
**SSE** = **S**um of **S**quares **E**xplained (by model)  
**SSR** = **S**um of **S**quares **R**esidual (unexplained)

**Relationship**: SST = SSE + SSR  
**R²**: SSE/SST = 1 - SSR/SST

### The "3 SE's"
**SE** = **S**tandard **E**rror (of mean or estimate)  
**SER** = **S**tandard **E**rror of **R**egression  
**SD** = **S**tandard **D**eviation (of data)

**Relationship**: SE = SD/√n

### Regression Line Rule
**Always passes through (x̄, ȳ)**

That's why: β₀ = ȳ - β₁x̄

---

## 📱 QUICK LOOKUP

**Need SE?** → σ/√n  
**Need β₁?** → Cov/Var or r(sᵧ/sₓ)  
**Need β₀?** → ȳ - β₁x̄  
**Need R²?** → SSE/SST or 1-SSR/SST  
**Need Cov?** → r·sₓ·sᵧ  
**Need r?** → Cov/(sₓ·sᵧ)  

---

## ✅ PRACTICE PROBLEMS

### Problem 1
Given: r = 0.4, sₓ = 5, sᵧ = 10, x̄ = 20, ȳ = 50  
Find: β₁ and β₀

**Solution**:
β₁ = r × (sᵧ/sₓ) = 0.4 × (10/5) = 0.8  
β₀ = ȳ - β₁x̄ = 50 - 0.8(20) = 34

---

### Problem 2
Given: Cov(X,Y) = 12, Var(X) = 16  
Find: β₁

**Solution**:
β₁ = Cov/Var(X) = 12/16 = 0.75

---

### Problem 3
Given: σ = 15, n = 225  
Find: SE

**Solution**:
SE = σ/√n = 15/√225 = 15/15 = 1

---

### Problem 4
Given: β̂ = 0.045, t = 3.5  
Find: SE(β̂)

**Solution**:
SE = β̂/t = 0.045/3.5 = 0.0129

---

## 🎓 FINAL TIPS

1. **Always check units** - do they make sense?
2. **Verify ranges** - is r between -1 and 1? Is R² between 0 and 1?
3. **Use given information** - exam gives you exactly what you need
4. **Show work** - partial credit often given
5. **Double-check arithmetic** - calculator mistakes are common

---

*Part of: [[15-TUM-Masters/SEM-1/SEM-1-Business-Research/00-Index|Business Research Methods Course Notes]]*  
*See also: [[23-Interpreting-Regression-Output|Interpreting Regression Output]]*
