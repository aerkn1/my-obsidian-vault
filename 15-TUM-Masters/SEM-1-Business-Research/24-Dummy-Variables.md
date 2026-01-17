# Dummy Variables and Categorical Predictors

## 🎯 Including Categories in Regression

How to include non-numeric predictors like gender, region, or treatment group.

---

## 📐 Binary Dummy Variable

**Model**: Y = β₀ + β₁D + ε

Where D ∈ {0, 1}

### Interpretation

**β₀** = E(Y|D=0) = mean for reference group
**β₁** = E(Y|D=1) - E(Y|D=0) = group difference

### Example
**Wage = 50,000 + 10,000(Female)**

Where Female = 1 if female, 0 if male

- Male wage (Female=0): 50,000
- Female wage (Female=1): 50,000 + 10,000 = 60,000
- Difference: 10,000

---

## 🔄 Transforming Dummy Variables

**Original**: Y = β₀ + β₁D + ε

**If replace D with (1-D)**:

**New**: Y = (β₀+β₁) + (-β₁)(1-D) + ε

**Result**: 
- Intercept changes to β₀+β₁
- Slope changes sign to -β₁

**Only slope changes** in practice!

---

## 🎨 Multiple Categories

**k categories → k-1 dummies**

### Example: Education Level
- High School
- Bachelor
- Master
- PhD

**Create 3 dummies** (leave out High School as reference):
- Bachelor dummy (1 if Bachelor, 0 otherwise)
- Master dummy (1 if Master, 0 otherwise)
- PhD dummy (1 if PhD, 0 otherwise)

**Model**: Y = β₀ + β₁(Bachelor) + β₂(Master) + β₃(PhD) + ε

**Interpretation**:
- β₀ = mean for High School (reference)
- β₁ = Bachelor - High School difference
- β₂ = Master - High School difference
- β₃ = PhD - High School difference

---

## ⚠️ Dummy Variable Trap

**DON'T** include dummy for ALL categories!

**Why?** Creates perfect multicollinearity

**Example**: If include Female AND Male dummies:
- Female + Male = 1 (always!)
- Perfect collinearity → can't estimate

**Solution**: Always omit one category (reference group)

---

## 🔑 Key Takeaways

1. **Dummy variable**: 0/1 for category membership
2. **β₀**: Reference group mean
3. **β₁**: Difference from reference
4. **k categories** → k-1 dummies
5. **Avoid trap**: Don't include all categories
6. **Transformation**: Only slope changes sign

---

*Part of: [[00-Index|Business Research Methods Course Notes]]*
