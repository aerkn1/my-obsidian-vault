# Interpreting Regression Output

## 🎯 Reading Statistical Output

Understanding regression tables is essential for exams and research.

---

## 📊 Standard Output Table

```
Coefficients:
             Estimate  Std. Error  t value  Pr(>|t|)
(Intercept)  50.000    2.500       20.000   < 0.001 ***
variable1     3.500    1.200        2.917   0.004 **
variable2    -2.100    0.800       -2.625   0.009 **

Residual standard error: 5.2 on 147 df
Multiple R-squared: 0.425
Adjusted R-squared: 0.417
F-statistic: 54.3 on 2 and 147 DF, p-value: < 0.001
```

---

## 🔍 Key Components

### 1. Estimate Column
**The coefficient value** (β̂)

**Intercept**: Predicted Y when all X's = 0
**Slopes**: Effect of X on Y

---

### 2. Std. Error Column
**Precision of estimate**

Smaller SE = more precise

---

### 3. t value
**t = Estimate / SE**

Tests H₀: β = 0

Large |t| = statistically significant

---

### 4. Pr(>|t|) Column
**p-value**

- *** : p < 0.001
- ** : p < 0.01
- * : p < 0.05
- (blank) : not significant

---

### 5. R-squared
**Goodness of fit**

0.425 = 42.5% of variance explained

---

### 6. F-statistic
**Overall model significance**

Tests if ANY predictors matter

---

## 🎓 Common Exam Tasks

### Calculate Missing Value

**Given**: Estimate = 0.045, t = 3.0
**Find**: SE = ?

**Solution**: SE = Estimate / t = 0.045 / 3.0 = 0.015

---

### Assess Significance

**Check p-value** (Pr(>|t|) column)
- p < 0.05 → significant
- p ≥ 0.05 → not significant

---

## 🔑 Key Takeaways

1. **Estimate** = coefficient value
2. **SE** = precision (smaller is better)
3. **t-value** = Estimate/SE
4. **p-value** = significance
5. **R²** = variance explained
6. **F-test** = overall significance

---

*Part of: [[00-Index|Business Research Methods Course Notes]]*
