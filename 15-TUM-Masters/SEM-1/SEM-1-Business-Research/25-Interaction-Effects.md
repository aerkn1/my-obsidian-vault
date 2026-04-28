# Interaction Effects and Moderation

## 🎯 When Effects Depend on Other Variables

Sometimes X's effect on Y depends on another variable Z.

---

## 🔗 Moderation Model

**Y = β₀ + β₁X + β₂Z + β₃(X×Z) + ε**

Where **X×Z** is the interaction term

### Key Terms
- **X**: Focal predictor
- **Z**: Moderator
- **X×Z**: Interaction term
- **β₃**: Moderation effect

---

## 📊 Interpretation

**β₁** = effect of X when Z = 0
**β₂** = effect of Z when X = 0
**β₃** = how much X's effect changes for 1-unit increase in Z

### Marginal Effect of X
**∂Y/∂X = β₁ + β₃Z**

"Effect of X depends on level of Z"

---

## 💼 Example

**Sales = β₀ + β₁(Advertising) + β₂(Quality) + β₃(Advertising×Quality) + ε**

If **β₃ > 0**: Positive interaction
- Advertising more effective for high-quality products
- Quality and advertising are **complements**

If **β₃ < 0**: Negative interaction
- Advertising less effective for high-quality products
- Diminishing returns

---

## 📈 Plotting Interactions

**Simple Slopes Analysis**:

Plot relationship between X and Y at different levels of Z:
- Z = mean - 1 SD (low Z)
- Z = mean (average Z)
- Z = mean + 1 SD (high Z)

---

## 🎯 Moderation vs. Mediation

### Moderation (Interaction)
**WHEN** does X affect Y?
**Conditional effect**

```
      Z
      ↓
X ―――→ Y
```

### Mediation
**HOW** does X affect Y?
**Causal mechanism**

```
X ―→ M ―→ Y
```

---

## 🔑 Key Takeaways

1. **Moderation**: X's effect depends on Z
2. **Interaction term**: X×Z in model
3. **β₃**: Moderation coefficient
4. **Plot**: Simple slopes at different Z levels
5. **Moderation** answers "when"
6. **Mediation** answers "how/why"

---

*Part of: [[15-TUM-Masters/SEM-1/SEM-1-Business-Research/00-Index|Business Research Methods Course Notes]]*
