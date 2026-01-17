# Mediation Analysis

## 🎯 Understanding "How" and "Why"

Mediation tests the mechanism through which X affects Y.

---

## 🔗 Basic Mediation Model

```
       c'
X ――――――→ Y

    a      b
X ―→ M ―→ Y
```

Where:
- **X** = Independent variable
- **M** = Mediator
- **Y** = Dependent variable
- **c'** = Direct effect
- **ab** = Indirect effect (mediation)
- **c** = Total effect = c' + ab

---

## 📊 Testing Mediation

### Baron & Kenny Steps

**Step 1**: X → Y (c significant)
**Step 2**: X → M (a significant)
**Step 3**: M → Y controlling X (b significant)
**Step 4**: X → Y controlling M (c' smaller)

### Types of Mediation
- **Full mediation**: c' = 0 (X → Y only through M)
- **Partial mediation**: c' ≠ 0 (both direct and indirect)

---

## 💼 Example

**Training (X) → Performance (Y)**

**Mediator**: Skills (M)

**Logic**:
- Training increases skills (a)
- Skills increase performance (b)
- Training → Performance through skills (indirect effect)

---

## 🔑 Key Takeaways

1. **Mediation**: Tests mechanism (how/why)
2. **M**: Transmits X's effect to Y
3. **Indirect effect**: a×b
4. **Direct effect**: c' (X → Y controlling M)
5. **Total effect**: Direct + Indirect

---

*Part of: [[00-Index|Business Research Methods Course Notes]]*
