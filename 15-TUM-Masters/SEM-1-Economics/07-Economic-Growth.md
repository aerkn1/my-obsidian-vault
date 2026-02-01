# Economic Growth

#economics #macroeconomics #solow-model #growth #capital-accumulation

**Topic:** Block 7 - Long-Run Economic Growth  
**Difficulty:** Advanced Level

---

## 🎯 What is Economic Growth?

**Economic growth** studies how economies increase output per person over long periods through capital accumulation, labor force growth, and technological progress.

**Key Question:** Why are some countries rich and others poor?

---

## 📈 PART 1: THE SOLOW GROWTH MODEL

### 1. Production Function

**Aggregate production:**
$$Y = F(L, K) = L^{\alpha} K^{1-\alpha}$$

Where:
- $Y$ = Total output (GDP)
- $L$ = Labor force (number of workers)
- $K$ = Capital stock (machines, buildings, equipment)
- $\alpha \in (0,1)$ = Labor's share of income

**This is Cobb-Douglas with Constant Returns to Scale (CRS)**
- Exponents sum to 1: $\alpha + (1-\alpha) = 1$
- Doubling both inputs doubles output

---

### 2. Per-Worker Terms ⭐

**Key transformation:** Divide everything by $L$ (per-worker basis)

**Lowercase = per worker:**
- $y = \frac{Y}{L}$ = output per worker
- $k = \frac{K}{L}$ = capital per worker
- $c = \frac{C}{L}$ = consumption per worker
- $i = \frac{I}{L}$ = investment per worker

**Production function per worker:**
$$y = k^{1-\alpha}$$

**Derivation:**
$$\frac{Y}{L} = \frac{L^{\alpha}K^{1-\alpha}}{L} = L^{\alpha-1}K^{1-\alpha} = \left(\frac{K}{L}\right)^{1-\alpha} = k^{1-\alpha}$$

---

### 3. Key Properties

**Marginal Product of Capital (MPK):**
$$MPK = \frac{\partial y}{\partial k} = (1-\alpha)k^{-\alpha}$$

**Properties:**
- $MPK > 0$ (more capital → more output)
- $MPK$ is diminishing (decreasing in $k$)
- As $k \to \infty$, $MPK \to 0$

**Interpretation:** Each additional unit of capital adds less output than the previous one.

---

### 4. Capital Accumulation

**Savings = Investment:**
$$I = sY$$

where $s \in [0,1]$ is the **saving rate** (fraction of income saved).

**Capital accumulation:**
$$K_{t+1} = I_t + (1-\delta)K_t$$
$$K_{t+1} = sY_t + (1-\delta)K_t$$

Where $\delta \in [0,1]$ is the **depreciation rate** (fraction of capital that wears out).

**Change in capital:**
$$\Delta K = sY - \delta K$$

**Per worker:**
$$\Delta k = sy - (\delta + n)k$$

Where $n$ is **population/labor force growth rate**.

**Why $(n+\delta)k$?**
- $\delta k$: Capital depreciation
- $nk$: Need to equip new workers with capital to maintain $k = K/L$

---

## 🔄 PART 2: STEADY STATE

### 1. Definition

**Steady state:** Capital per worker stops changing ($\Delta k = 0$)

**Condition:**
$$sy = (n + \delta)k$$

**Interpretation:**
- LHS: Investment per worker ($sy$)
- RHS: "Break-even investment" needed to maintain $k$

---

### 2. Finding Steady State

**For production $y = k^{1-\alpha}$:**

$$sk^{1-\alpha} = (n+\delta)k$$

$$sk^{1-\alpha} = (n+\delta)k$$

$$s = (n+\delta)k^{\alpha}$$

$$k^{\alpha} = \frac{s}{n+\delta}$$

$$k^* = \left(\frac{s}{n+\delta}\right)^{\frac{1}{\alpha}}$$

**Output per worker:**
$$y^* = (k^*)^{1-\alpha} = \left(\frac{s}{n+\delta}\right)^{\frac{1-\alpha}{\alpha}}$$

**Consumption per worker:**
$$c^* = (1-s)y^* = (1-s)\left(\frac{s}{n+\delta}\right)^{\frac{1-\alpha}{\alpha}}$$

---

### 3. Effects of Parameters

**Higher saving rate ($s \uparrow$):**
- $k^* \uparrow$ (more capital per worker)
- $y^* \uparrow$ (more output per worker)
- Effect on $c^*$: Ambiguous! (save more but have more income)

**Higher depreciation ($\delta \uparrow$):**
- $k^* \downarrow$ (capital wears out faster)
- $y^* \downarrow$, $c^* \downarrow$

**Higher population growth ($n \uparrow$):**
- $k^* \downarrow$ (harder to maintain capital per worker)
- $y^* \downarrow$, $c^* \downarrow$

---

## 🏆 PART 3: GOLDEN RULE

### 1. The Question

**What saving rate maximizes consumption per worker in steady state?**

Not obvious because:
- Higher $s$ → more $k$ → more $y$ ✓
- But higher $s$ → less consumption from given $y$ ✗

**Trade-off:** Save more → richer in steady state, but consume less of that income.

---

### 2. Golden Rule Condition

**Maximum consumption** when:
$$MPK = n + \delta$$

**Derivation:**
$$c = y - (n+\delta)k$$

Maximize $c$ by choosing $k$:
$$\frac{dc}{dk} = \frac{dy}{dk} - (n+\delta) = 0$$
$$MPK = n+\delta$$

**For Cobb-Douglas:**
$$MPK = (1-\alpha)k^{-\alpha}$$

Setting equal:
$$(1-\alpha)k_{gold}^{-\alpha} = n+\delta$$

$$k_{gold}^* = \left(\frac{1-\alpha}{n+\delta}\right)^{\frac{1}{\alpha}}$$

---

### 3. Golden Rule Saving Rate

**From steady state condition:**
$$s_{gold} \cdot (k_{gold}^*)^{1-\alpha} = (n+\delta)k_{gold}^*$$

**Solving:**
$$s_{gold} = (n+\delta)(k_{gold}^*)^{\alpha}$$

**For Cobb-Douglas, this simplifies to:**
$$s_{gold} = 1 - \alpha$$

**Example:** If $\alpha = 0.5$, golden rule saving rate = 0.5 (save 50% of income).

---

## 📊 PART 4: GROWTH RATES IN STEADY STATE

### 1. With Population Growth

**In steady state:**

| Variable | Growth Rate | Reasoning |
|----------|-------------|-----------|
| Capital per worker ($k$) | 0 | By definition of steady state |
| Output per worker ($y$) | 0 | $y = k^{1-\alpha}$, if $k$ constant |
| Consumption per worker ($c$) | 0 | $(1-s)y$ |
| Total capital ($K$) | $n$ | Must grow with population |
| Total output ($Y$) | $n$ | $Y = yL$, $L$ grows at rate $n$ |

**Key insight:** In steady state, per-worker variables are constant, but total variables grow at population growth rate.

---

### 2. Why Growth Stops

**Diminishing returns to capital:**
- As $k$ increases, $MPK$ decreases
- Eventually $MPK$ falls to level where investment just covers depreciation + population growth
- No more net capital accumulation per worker

**Sustained growth requires:**
- Technological progress (not in basic Solow model)
- Increasing returns (violates standard assumptions)

---

## 🎯 PART 5: DYNAMIC EFFICIENCY

### 1. Definition

**Dynamically efficient:** Economy saves less than golden rule ($k^* < k_{gold}^*$)
- Can increase consumption by saving more
- Should accumulate more capital

**Dynamically inefficient:** Economy saves more than golden rule ($k^* > k_{gold}^*$)
- "Over-saving"
- Can increase consumption by saving less
- Should decumulate some capital

---

### 2. Testing Efficiency

**Method 1: Compare MPK to $n + \delta$**
- If $MPK > n+\delta$: Efficient (below golden rule)
- If $MPK < n+\delta$: Inefficient (above golden rule)

**Method 2: Compare saving rates**
- If $s < s_{gold}$: Efficient
- If $s > s_{gold}$: Inefficient

**For Cobb-Douglas:** $s_{gold} = 1-\alpha$
- If $\alpha = 0.5$: $s_{gold} = 0.5$
- If $s = 0.3 < 0.5$: Efficient (under-saving)
- If $s = 0.7 > 0.5$: Inefficient (over-saving)

---

## 🔧 PROBLEM-SOLVING FRAMEWORK

### Finding Steady State

**Given:** $y = k^{1-\alpha}$, $s$, $n$, $\delta$

**Step 1: Write steady state condition**
$$sy = (n+\delta)k$$

**Step 2: Substitute production function**
$$sk^{1-\alpha} = (n+\delta)k$$

**Step 3: Solve for $k^*$**
$$k^* = \left(\frac{s}{n+\delta}\right)^{\frac{1}{\alpha}}$$

**Step 4: Find $y^*$**
$$y^* = (k^*)^{1-\alpha}$$

**Step 5: Find $c^*$**
$$c^* = (1-s)y^*$$

---

### Golden Rule Calculations

**Step 1: Set $MPK = n + \delta$**

For $y = k^{1-\alpha}$:
$$MPK = (1-\alpha)k^{-\alpha}$$

$$(1-\alpha)k_{gold}^{-\alpha} = n+\delta$$

**Step 2: Solve for $k_{gold}^*$**
$$k_{gold}^* = \left(\frac{1-\alpha}{n+\delta}\right)^{\frac{1}{\alpha}}$$

**Step 3: Find golden rule saving rate**
$$s_{gold} = 1 - \alpha$$

---

### Checking Dynamic Efficiency

**Method 1:**
Calculate $MPK$ at current steady state and compare to $n+\delta$.

**Method 2:**
Compare actual $s$ to $s_{gold} = 1-\alpha$.

---

## 💡 Common Mistakes

❌ **Forgetting population growth in break-even investment**
- Wrong: $\Delta k = sy - \delta k$
- Correct: $\Delta k = sy - (n+\delta)k$

❌ **Confusing total vs per-worker variables**
- $Y$ grows at rate $n$ in steady state
- $y$ has growth rate 0 in steady state

❌ **Thinking higher saving always increases consumption**
- True below golden rule
- False above golden rule (over-saving)

❌ **Wrong exponent in steady state formula**
- Capital: $k^* = \left(\frac{s}{n+\delta}\right)^{\frac{1}{\alpha}}$
- Output: $y^* = \left(\frac{s}{n+\delta}\right)^{\frac{1-\alpha}{\alpha}}$

---

## 🎓 Key Insights

1. **Diminishing returns limit growth**
   - Can't grow forever by accumulating capital alone
   - Need technological progress for sustained growth

2. **Saving rate affects level, not growth rate**
   - Higher $s$ → higher steady state $y$
   - But doesn't change long-run growth rate (still 0)

3. **Golden rule is theoretical optimum**
   - Real economies usually below golden rule
   - Over-saving (dynamic inefficiency) rare
   - Most countries should save more

4. **Population growth reduces per-capita income**
   - Faster $n$ → lower $k^*$, $y^*$
   - Must "spread" capital among more workers

5. **Convergence prediction**
   - Poor countries (low $k$) should grow faster
   - High $MPK$ when $k$ is low
   - Predicts "catch-up" to rich countries

---

## 📋 Formula Quick Reference

**Production:**
- $y = k^{1-\alpha}$
- $MPK = (1-\alpha)k^{-\alpha}$

**Steady State:**
- Condition: $sy = (n+\delta)k$
- Capital: $k^* = \left(\frac{s}{n+\delta}\right)^{\frac{1}{\alpha}}$
- Output: $y^* = (k^*)^{1-\alpha}$
- Consumption: $c^* = (1-s)y^*$

**Golden Rule:**
- Condition: $MPK = n+\delta$
- Saving rate: $s_{gold} = 1-\alpha$
- Capital: $k_{gold}^* = \left(\frac{1-\alpha}{n+\delta}\right)^{\frac{1}{\alpha}}$

**Growth Rates (steady state):**
- Per worker ($k, y, c$): 0
- Total ($K, Y$): $n$

---

[[Exam-Block-7-Solutions|Practice Problems →]]

[[08-Economic-Fluctuations|Next Topic →]]

[[06-Macroeconomic-Indicators|← Previous Topic]]
