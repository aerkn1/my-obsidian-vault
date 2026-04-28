# Economics Formula Sheet

#economics #formulas #reference #quick-reference

**Quick Reference for Principles of Economics Exam**

---

## 📐 Specialization and Trade

### Opportunity Cost
$$\text{OC of Good A} = \frac{\text{Units of B given up}}{\text{Units of A produced}}$$

**Key property:** OC are reciprocals
- If OC(fish) = 0.25 rum, then OC(rum) = 4 fish

---

### Production Possibilities
$$\text{Max production} = \frac{\text{Total time available}}{\text{Time per unit}}$$

**PPF slope:** $-\text{OC of horizontal axis good}$

---

### Comparative Advantage
- **Absolute advantage:** Who produces MORE per hour
- **Comparative advantage:** Who has LOWER opportunity cost
- **Specialization rule:** Produce where you have comparative advantage

---

### Feasible Terms of Trade
Must lie between the two opportunity costs:
$$\text{OC}_{\text{person 1}} < \text{Trade ratio} < \text{OC}_{\text{person 2}}$$

---

## 💰 Consumer Theory

### Budget Constraint
$$p_1 q_1 + p_2 q_2 = y$$

**Budget line:**
$$q_2 = \frac{y}{p_2} - \frac{p_1}{p_2}q_1$$

**Properties:**
- Slope: $-\frac{p_1}{p_2}$
- Vertical intercept: $\frac{y}{p_2}$
- Horizontal intercept: $\frac{y}{p_1}$

---

### Labor-Leisure Budget
$$pq + wF = wZ$$

Where:
- $Z$ = total time available
- $F$ = free time (leisure)
- $L$ = labor = $Z - F$
- $w$ = wage rate
- $wZ$ = potential income

---

### Marginal Rate of Substitution (MRS)
$$MRS = \frac{MU_1}{MU_2} = -\frac{dq_2}{dq_1}\bigg|_{U=\text{const}}$$

**Interpretation:** Rate willing to trade good 2 for good 1

---

### Optimization Condition
**Interior solution:**
$$MRS = \frac{p_1}{p_2}$$

**Or equivalently:**
$$\frac{MU_1}{MU_2} = \frac{p_1}{p_2}$$

$$\frac{MU_1}{p_1} = \frac{MU_2}{p_2}$$

---

### Lagrangian Method
$$\mathcal{L} = U(q_1, q_2) + \lambda(y - p_1q_1 - p_2q_2)$$

**FOCs:**
$$\frac{\partial \mathcal{L}}{\partial q_1} = MU_1 - \lambda p_1 = 0$$
$$\frac{\partial \mathcal{L}}{\partial q_2} = MU_2 - \lambda p_2 = 0$$
$$\frac{\partial \mathcal{L}}{\partial \lambda} = y - p_1q_1 - p_2q_2 = 0$$

---

### Slutsky Decomposition
$$\text{Total Effect (TE)} = \text{Substitution Effect (SE)} + \text{Income Effect (IE)}$$

**Substitution Effect:**
- Always opposes price change
- For $p_1$ ↑: SE on $q_1$ < 0

**Income Effect:**
- Normal good: same direction as SE
- Inferior good: opposite direction to SE

---

## 🔢 Common Utility Functions

### Cobb-Douglas: $U = q_1^a q_2^b$

**Demand functions:**
$$q_1^* = \frac{a}{a+b} \cdot \frac{y}{p_1}$$
$$q_2^* = \frac{b}{a+b} \cdot \frac{y}{p_2}$$

**Expenditure shares (constant!):**
$$\frac{p_1 q_1^*}{y} = \frac{a}{a+b}$$
$$\frac{p_2 q_2^*}{y} = \frac{b}{a+b}$$

**Special case:** $U = q_1^{1/2} q_2^{1/2}$
- Spend half income on each good
- $q_1^* = \frac{y}{2p_1}$, $q_2^* = \frac{y}{2p_2}$

---

### Perfect Substitutes: $U = aq_1 + bq_2$

**MRS:** Constant = $\frac{a}{b}$

**Decision rule (bang per buck):**
- If $\frac{a}{p_1} > \frac{b}{p_2}$: Buy only good 1
- If $\frac{a}{p_1} < \frac{b}{p_2}$: Buy only good 2
- If $\frac{a}{p_1} = \frac{b}{p_2}$: Indifferent

**Optimal demand (corner solution):**
$$q_1^* = \frac{y}{p_1}, q_2^* = 0 \quad \text{or} \quad q_1^* = 0, q_2^* = \frac{y}{p_2}$$

---

### Perfect Complements: $U = \min\{aq_1, bq_2\}$

**Consumption ratio (fixed):**
$$\frac{q_1}{q_2} = \frac{b}{a}$$

**At optimum:** $aq_1 = bq_2$

---

## 🏭 Production Theory

### Production Function

**General:** $q = F(L, K)$

**Marginal products:**
$$MP_L = \frac{\partial F}{\partial L}$$
$$MP_K = \frac{\partial F}{\partial K}$$

---

### Marginal Rate of Technical Substitution (MRTS)
$$MRTS = \frac{MP_L}{MP_K}$$

**Interpretation:** Rate at which can substitute capital for labor while maintaining output

---

### Returns to Scale
For $\lambda > 1$:
- $F(\lambda L, \lambda K) > \lambda F(L, K)$: **Increasing returns**
- $F(\lambda L, \lambda K) = \lambda F(L, K)$: **Constant returns**
- $F(\lambda L, \lambda K) < \lambda F(L, K)$: **Decreasing returns**

---

### Cobb-Douglas Production: $q = L^a K^b$

**Returns to scale:** Determined by $a + b$
- $a + b > 1$: Increasing returns
- $a + b = 1$: Constant returns
- $a + b < 1$: Decreasing returns

**Marginal products:**
$$MP_L = a \cdot \frac{q}{L}$$
$$MP_K = b \cdot \frac{q}{K}$$

---

### Cost Minimization

**Problem:**
$$\min_{L,K} wL + rK$$
$$\text{subject to: } F(L, K) = \bar{q}$$

**Optimality condition:**
$$MRTS = \frac{w}{r}$$

$$\frac{MP_L}{MP_K} = \frac{w}{r}$$

$$\frac{MP_L}{w} = \frac{MP_K}{r}$$

---

### Cost Functions

**Total Cost:**
$$C(q) = wL^*(q) + rK^*(q)$$

**Average Cost:**
$$AC(q) = \frac{C(q)}{q}$$

**Marginal Cost:**
$$MC(q) = \frac{dC(q)}{dq}$$

**Fixed Cost (FC):** Cost when $q = 0$

**Variable Cost (VC):** $C(q) - FC$

---

### Profit Maximization

**Profit:**
$$\pi = pq - C(q)$$

**FOC (price-taking firm):**
$$p = MC(q)$$

**Supply condition:**
- **Short run:** Produce if $p \geq AVC$
- **Long run:** Produce if $p \geq AC$

**Shutdown prices:**
- Short run: $p^{SR} = \min AVC$
- Long run: $p^{LR} = \min AC$

---

## 📊 Key Relationships

### At Cost Minimum
$$MC = AC \quad \Rightarrow \quad AC \text{ at minimum}$$

**If $MC < AC$:** AC is decreasing  
**If $MC > AC$:** AC is increasing

---

### Firm Supply (Price-Taking)
$$q^* = \begin{cases}
0 & \text{if } p < \text{threshold} \\
q : MC(q) = p & \text{if } p \geq \text{threshold}
\end{cases}$$

**Threshold:**
- Short run: $\min AVC$
- Long run: $\min AC$

---

## 🎯 Classification of Goods

### By Income Effect
- **Normal:** $\frac{\partial q}{\partial y} > 0$ (demand ↑ when income ↑)
- **Inferior:** $\frac{\partial q}{\partial y} < 0$ (demand ↓ when income ↑)

---

### By Price Effect
- **Ordinary:** $\frac{\partial q}{\partial p} < 0$ (demand ↓ when price ↑)
- **Giffen:** $\frac{\partial q}{\partial p} > 0$ (demand ↑ when price ↑, very rare!)

---

## 💡 Quick Decision Rules

### Consumer Choice
1. **Cobb-Douglas?** → Use expenditure share formulas
2. **Perfect substitutes?** → Compare bang per buck, corner solution
3. **Perfect complements?** → Fixed consumption ratio
4. **Other?** → Set MRS = price ratio or use Lagrangian

---

### Producer Choice
1. **Find cost-minimizing inputs:** MRTS = w/r
2. **Calculate costs:** C(q) = wL* + rK*
3. **Find MC:** Derivative of C(q)
4. **Determine supply:** Set p = MC (if above threshold)

---

### Comparative Advantage
1. **Calculate OC** for each person and good
2. **Compare OC** across people for each good
3. **Lowest OC** = comparative advantage
4. **Specialize** accordingly

---

## 🔑 Must-Memorize Formulas

**For Cobb-Douglas utility $U = q_1^a q_2^b$:**
$$q_i^* = \frac{\text{exponent}_i}{\sum \text{exponents}} \cdot \frac{y}{p_i}$$

**For Cobb-Douglas production $q = L^a K^b$:**
- Returns to scale: Check $a + b$
- Cost function depends on $a + b$

**Optimization conditions:**
- Consumer: $MRS = p_1/p_2$
- Producer: $MRTS = w/r$
- Firm supply: $p = MC$

**Effects decomposition:**
- SE always opposes price change
- IE depends on normal/inferior
- TE = SE + IE

---

[[00-Economics-Overview|← Back to Overview]]
