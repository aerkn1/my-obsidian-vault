
# Production and Supply

#economics #microeconomics #production #supply #firm-theory

**Topic:** Exercise 3 - Production Theory and Firm Behavior  
**Difficulty:** Advanced Level

---

## 🎯 Core Concepts

### 1. Production Function

**Definition:** Relationship between inputs and output.

**General Form:** $$q = F(L, K)$$

Where:

- $q$ = output (quantity produced)
- $L$ = labor input
- $K$ = capital input

**Key Properties:**

1. Shows technically efficient production
2. Typically assumes monotonicity (more inputs → more output)
3. Usually exhibits diminishing marginal returns

---

#### Marginal Product

**Definition:** Additional output from one more unit of input, holding other inputs constant.

**Marginal Product of Labor:** $$MP_L = \frac{\partial F(L, K)}{\partial L}$$

**Marginal Product of Capital:** $$MP_K = \frac{\partial F(L, K)}{\partial K}$$

**Diminishing Marginal Product:** $$\frac{\partial^2 F}{\partial L^2} < 0 \quad \text{and} \quad \frac{\partial^2 F}{\partial K^2} < 0$$

Each additional unit of input adds less output than the previous unit.

---

### 2. Returns to Scale

**Question:** What happens to output when ALL inputs are scaled proportionally?

**Mathematically:** For $\lambda > 1$, compare $F(\lambda L, \lambda K)$ to $\lambda F(L, K)$

**Types:**

**Increasing Returns (IRS):** $F(\lambda L, \lambda K) > \lambda F(L, K)$

- Doubling inputs MORE than doubles output
- Example: $q = L^{0.6} K^{0.6}$ (exponents sum > 1)

**Constant Returns (CRS):** $F(\lambda L, \lambda K) = \lambda F(L, K)$

- Doubling inputs exactly doubles output
- Example: $q = L^{0.5} K^{0.5}$ (exponents sum = 1)

**Decreasing Returns (DRS):** $F(\lambda L, \lambda K) < \lambda F(L, K)$

- Doubling inputs less than doubles output
- Example: $q = L^{0.2} K^{0.2}$ (exponents sum < 1)

---

### 3. Cobb-Douglas Production Function ⭐

**Form:** $q = L^a K^b$ where $a, b > 0$

**Key Properties:**

**Marginal Products:**

- $MP_L = aL^{a-1}K^b = a \cdot \frac{q}{L}$
- $MP_K = bL^a K^{b-1} = b \cdot \frac{q}{K}$

**MRTS (Marginal Rate of Technical Substitution):** $$MRTS = \frac{MP_L}{MP_K} = \frac{a}{b} \cdot \frac{K}{L}$$

**Returns to Scale:**

- $a + b > 1$: Increasing returns
- $a + b = 1$: Constant returns
- $a + b < 1$: Decreasing returns

---

### 4. Cost Minimization

**Problem:** Given output $\bar{q}$, input prices $w$ (wage) and $r$ (rental rate):

$$\min_{L, K} \quad C = wL + rK$$ $$\text{subject to: } \quad F(L, K) = \bar{q}$$

**Optimal Condition:** $$MRTS = \frac{w}{r}$$

Or equivalently: $$\frac{MP_L}{MP_K} = \frac{w}{r} \quad \text{or} \quad \frac{MP_L}{w} = \frac{MP_K}{r}$$

**Interpretation:** Marginal product per dollar must be equal across all inputs ("bang per buck" equalized). Isoquant tangent to isocost line.

---

### 5. Cost Functions

**Total Cost:** $C(q) = FC + VC(q)$

**Fixed Cost (FC):** Costs that don't vary with output

- Examples: rent, insurance
- Only in short run

**Variable Cost (VC):** Costs that vary with output

- Examples: labor, materials

**Marginal Cost:** $$MC(q) = \frac{dC(q)}{dq} = \frac{dVC(q)}{dq}$$

**Average Costs:**

- $AC(q) = \frac{C(q)}{q}$ (Average Total Cost)
- $AVC(q) = \frac{VC(q)}{q}$ (Average Variable Cost)
- $AFC(q) = \frac{FC}{q}$ (Average Fixed Cost)

**Key Relationship:** MC crosses AC at AC's minimum

- When $MC < AC$: AC falling
- When $MC = AC$: AC at minimum
- When $MC > AC$: AC rising

---

### 6. Profit Maximization

**Profit:** $\pi = pq - C(q)$

**First-Order Condition:** $$p = MC(q)$$

Produce where price equals marginal cost.

---

### 7. Firm Supply Decision

**Short Run (some fixed costs):**

- If $p < \min AVC$: **Shut down** ($q = 0$)
- If $p \geq \min AVC$: **Produce** where $p = MC(q)$

**Long Run (all costs variable):**

- If $p < \min AC$: **Exit** ($q = 0$)
- If $p \geq \min AC$: **Produce** where $p = MC(q)$

**Why the difference?**

- Short run: Fixed costs already sunk, only need to cover variable costs
- Long run: Must cover ALL costs to stay in business

**Finding thresholds:**

- Set $MC = AVC$ to find short-run shutdown price
- Set $MC = AC$ to find long-run exit price

---

## 📊 Example: Quadratic Costs

**Given:** $C(q) = 200 + 2q^2$

**Components:**

- $FC = 200$
- $VC(q) = 2q^2$
- $MC(q) = 4q$
- $AVC(q) = 2q$
- $AC(q) = \frac{200}{q} + 2q$

**Finding minimum AC:** Set $MC = AC$: $$4q = \frac{200}{q} + 2q$$ $$2q = \frac{200}{q}$$ $$q = 10$$

At $q = 10$: $AC(10) = 20 + 20 = 40$

**Long-run threshold price:** $p \geq 40$

---

## 🎓 Key Insights

1. **Cost minimization ≠ Profit maximization**
    
    - Cost min: cheapest way to produce GIVEN quantity
    - Profit max: find optimal quantity to produce
2. **Shutdown vs Exit**
    
    - Short run: compare to AVC (fixed costs sunk)
    - Long run: compare to AC (all costs avoidable)
3. **MC curve IS the supply curve** (above relevant threshold)
    
4. **Returns to scale affect cost structure**
    
    - IRS → AC decreasing (economies of scale)
    - CRS → AC constant
    - DRS → AC increasing (diseconomies of scale)
5. **For Cobb-Douglas:** Sum of exponents determines returns to scale
    

---

See [[Exercise-3-Solutions]] for detailed problem solutions.