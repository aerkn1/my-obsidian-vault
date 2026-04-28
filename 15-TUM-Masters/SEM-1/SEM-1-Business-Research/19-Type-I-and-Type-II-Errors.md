# Type I and Type II Errors

## 🎯 Two Ways to Be Wrong

Statistical testing involves uncertainty - we can make mistakes.

---

## 📊 The Error Matrix

|  | **H₀ True** | **H₀ False** |
|---|---|---|
| **Reject H₀** | **Type I Error (α)** | Correct (Power) |
| **Don't Reject H₀** | Correct | **Type II Error (β)** |

---

## ❌ Type I Error (False Positive)

### Definition
**Reject true null hypothesis**

### Probability
**α** (significance level) = P(Type I error)

### Example
- H₀: Drug has no effect (TRUE)
- Reject H₀: Conclude drug works (WRONG!)
- **False positive**

### Consequences
- Waste resources on ineffective treatment
- Implement useless policy
- False hope

### Control
Set **low α** (typically 0.05 or 0.01)

---

## ❌ Type II Error (False Negative)

### Definition
**Fail to reject false null hypothesis**

### Probability
**β** = P(Type II error)

**Power** = 1 - β

### Example
- H₀: Drug has no effect (FALSE - it actually works!)
- Fail to reject H₀: Conclude no effect (WRONG!)
- **False negative**

### Consequences
- Miss real effect
- Abandon effective treatment
- Missed opportunity

### Control
- Increase **sample size**
- Use more **powerful test**
- Increase **α** (but then more Type I errors!)

---

## ⚖️ The Trade-off

**Type I ↔ Type II are inversely related**

```
If α ↓ (stricter) → β ↑ (more Type II errors)
If α ↑ (lenient) → β ↓ (fewer Type II errors)
```

**Can't minimize both simultaneously** (for fixed n)

**Solution**: Increase sample size!

---

## 🎚️ Statistical Power

### Definition
**Power** = 1 - β = P(correctly rejecting false H₀)

### Factors Affecting Power
1. **Sample size** (↑ n → ↑ power)
2. **Effect size** (larger effect → ↑ power)
3. **Significance level** (↑ α → ↑ power)
4. **Variability** (↓ SD → ↑ power)

### Typical Target
**Power = 0.80** (80% chance of detecting real effect)

---

## 💡 Exam Tips

**Type I = α** (significance level)
- α ↑ → Type I errors ↑
- "Incorrectly rejecting" H₀

**Type II = β**  
- β = 1 - Power
- "Incorrectly accepting" H₀

---

## 🔑 Key Takeaways

1. **Type I**: False positive (reject true H₀)
2. **Type II**: False negative (accept false H₀)
3. **α** = P(Type I) = significance level
4. **β** = P(Type II) = 1 - Power
5. **Trade-off**: Can't minimize both
6. **Increase n**: Reduces both errors

---

*Part of: [[15-TUM-Masters/SEM-1/SEM-1-Business-Research/00-Index|Business Research Methods Course Notes]]*
