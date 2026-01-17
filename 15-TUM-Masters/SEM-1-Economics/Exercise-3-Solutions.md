
# Exercise 3: Production and Supply - Solutions

#economics #solutions #production #supply #practice

**Source:** Exercise 3, Principles of Economics WT 21/22  
**Related Theory:** [[03-Production-and-Supply]]

---

## Problem 1: Production Function $q = L^a K^b$

### Part (a): Show Positive and Decreasing Marginal Products

**Marginal Products:**

- $MP_L = aL^{a-1}K^b$
- $MP_K = bL^a K^{b-1}$

**Positive:** Since $a, b \in (0,1)$ and $L, K > 0$, both MPs are positive ✓

**Decreasing:**

- $\frac{\partial^2 F}{\partial L^2} = a(a-1)L^{a-2}K^b < 0$ (since $a-1 < 0$)
- $\frac{\partial^2 F}{\partial K^2} = b(b-1)L^a K^{b-2} < 0$ (since $b-1 < 0$)

Both marginal products are diminishing ✓

---

### Part (b): Returns to Scale

**Test:** $F(\lambda L, \lambda K) = (\lambda L)^a(\lambda K)^b = \lambda^{a+b}L^aK^b = \lambda^{a+b}F(L,K)$

**Results:**

- **IRS** if $a + b > 1$: $\lambda^{a+b} > \lambda$
- **CRS** if $a + b = 1$: $\lambda^{a+b} = \lambda$
- **DRS** if $a + b < 1$: $\lambda^{a+b} < \lambda$

---

### Part (c): Strictly Convex Isoquants

**MRTS:** $MRTS = \frac{MP_L}{MP_K} = \frac{aK}{bL}$

**Show diminishing:** Along isoquant, $\frac{dK}{dL} = -MRTS$

After differentiation: $$\frac{\partial MRTS}{\partial L} = -\frac{aK}{bL^2}\left(\frac{a+b}{b}\right) < 0$$

Since all terms positive, MRTS diminishes → isoquants strictly convex ✓

---

## Problem 2: Cost Minimization $q = L^{1/2}K^{1/2}$

**Initial:** $w = 2.5, r = 2.5, q = 100$  
**New:** $w' = 10, r = 2.5, q = 100$

### Part (a): Initial Bundle

**MRTS = w/r:** $\frac{K}{L} = 1$ → $K = L$

**Production constraint:** $L^{1/2}K^{1/2} = 100$ → $L = 100, K = 100$

**Cost:** $C = 2.5(100) + 2.5(100) = 500$

---

### Part (b): Effects of Wage Increase

**(i) Same bundle:** $C' = 10(100) + 2.5(100) = 1,250$ (+750)

**(ii) Re-optimize:**

- New condition: $\frac{K}{L} = \frac{10}{2.5} = 4$ → $K = 4L$
- Production: $L^{1/2}(4L)^{1/2} = 100$ → $2L = 100$ → $L = 50, K = 200$
- Cost: $C' = 10(50) + 2.5(200) = 1,000$ (+500)

**Insight:** Re-optimizing saves 250 vs keeping same inputs!

---

## Problem 3: Returns to Scale for $q = L^{1/4}K^{1/4}$

**Test:** $F(4L, 4K) = (4L)^{1/4}(4K)^{1/4} = 4^{1/2} \cdot L^{1/4}K^{1/4} = 2 \cdot F(L,K)$

Quadrupling inputs doubles output.

**Answer: (B)** 2

---

## Problem 4: Cost Function with $w = 16, r = 4$

**Optimization:** $\frac{K}{L} = \frac{16}{4} = 4$ → $K = 4L$

**Substitute:** $q = L^{1/4}(4L)^{1/4} = \sqrt{2} \cdot L^{1/2}$

**Solve for L:** $L = \frac{q^2}{2}$ and $K = 2q^2$

**Cost:** $C(q) = 16 \cdot \frac{q^2}{2} + 4 \cdot 2q^2 = 8q^2 + 8q^2 = 16q^2$

**Answer: (D)** $c(q) = 16q^2$

---

## Problem 5: Cost Function with $w = 18, r = 1/2$

**Optimization:** $\frac{K}{L} = \frac{18}{0.5} = 36$ → $K = 36L$

**Substitute:** $q = L^{1/4}(36L)^{1/4} = \sqrt{6} \cdot L^{1/2}$

**Solve for L:** $L = \frac{q^2}{6}$ and $K = 6q^2$

**Cost:** $C(q) = 18 \cdot \frac{q^2}{6} + 0.5 \cdot 6q^2 = 3q^2 + 3q^2 = 6q^2$

**Answer: (C)** $c(q) = 6q^2$

---

## Problems 6-8: Profit Maximization

**Given:**

- Short-run: $C(q) = 200 + 2q^2$ for $q \geq 0$
- Long-run: $C(q) = 200 + 2q^2$ for $q > 0$; $C(0) = 0$

**Cost functions:**

- $FC = 200$
- $VC(q) = 2q^2$
- $MC(q) = 4q$
- $AVC(q) = 2q$
- $AC(q) = \frac{200}{q} + 2q$

---

### Problem 6: At $q = 20$

**Calculate:**

- $MC(20) = 80$
- $AVC(20) = 40$
- $AC(20) = 10 + 40 = 50$

**Comparison:** $MC = 80 > AC = 50$

**Answer: (B)** Marginal costs are higher than average total costs

---

### Problem 7: Supply at $p = 20$

**Find q where $p = MC$:** $20 = 4q$ → $q = 5$

**Short run:** $p = 20 > AVC(5) = 10$ → Produce 5 units ✓

**Long run:** $AC(5) = \frac{200}{5} + 10 = 50$

- $p = 20 < AC(5) = 50$ → Making losses → Exit

**Answer: (B)** is 5 in the short run and 0 in the long run

---

### Problem 8: Long-Run Threshold Price

**Find min AC:** Set $MC = AC$

$$4q = \frac{200}{q} + 2q$$ $$2q = \frac{200}{q}$$ $$q = 10$$

**At $q = 10$:** $AC(10) = 20 + 20 = 40$

**Long-run threshold:** $p \geq 40$

**Answer: (D)** $p = 40$

---

## Key Takeaways

### Production Functions

1. **Cobb-Douglas:** $a + b$ determines returns to scale
2. **MRTS = (a/b)(K/L)** - useful shortcut
3. **Marginal products positive but diminishing** when exponents ∈ (0,1)

### Cost Minimization

1. **Optimal condition:** $MRTS = w/r$
2. **Input price changes** cause substitution toward cheaper inputs
3. **Not re-optimizing is costly** (Problem 2 example)

### Profit Maximization

1. **Supply rule:** $p = MC$ if above threshold
2. **Short-run:** Check $p \geq \min AVC$
3. **Long-run:** Check $p \geq \min AC$
4. **Finding thresholds:** Set $MC = AC$ or $MC = AVC$
5. **MC = AC at minimum AC** - useful for finding exit price

---

[[03-Production-and-Supply|← Back to Theory]]