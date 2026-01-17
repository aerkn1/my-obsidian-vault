# Hypothesis Testing Framework

## 🎯 Statistical Decision Making

How do we decide if results are "real" or just chance?

---

## 📋 The Process

### 1. State Hypotheses

**Null Hypothesis (H₀)**: No effect/difference
**Alternative Hypothesis (H₁)**: Effect exists

**Example**:
- H₀: μ₁ = μ₂ (training has no effect)
- H₁: μ₁ ≠ μ₂ (training has effect)

---

### 2. Choose Significance Level

**α = 0.05** (most common)

Means: 5% chance of Type I error

---

### 3. Calculate Test Statistic

**Example**: t = (x̄₁ - x̄₂) / SE

---

### 4. Find p-value

**p-value**: Probability of data (or more extreme) if H₀ true

---

### 5. Make Decision

**If p < α**: Reject H₀ (statistically significant)
**If p ≥ α**: Fail to reject H₀ (not significant)

---

## 🎯 Interpreting p-values

- p < 0.01: *** (highly significant)
- p < 0.05: ** (significant)
- p < 0.10: * (marginally significant)
- p ≥ 0.10: not significant

**p-value ≠ effect size!**

---

## ⚖️ Types of Tests

### One-Sample t-test
Compare sample mean to known value

### Independent t-test
Compare two independent groups

### Paired t-test
Compare two related measures (within-subjects)

### ANOVA
Compare 3+ groups

---

## 🔑 Key Takeaways

1. **H₀**: No effect (what we test against)
2. **H₁**: Effect exists (what we hope to show)
3. **p < α**: Reject H₀, results significant
4. **p-value**: Evidence against H₀
5. **Statistical ≠ practical** significance

---

*Part of: [[00-Index|Business Research Methods Course Notes]]*
