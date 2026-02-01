
# Exercise 4: Perfect Competition - Solutions

#economics #solutions #perfect-competition #practice

**Source:** Exercise 4, Principles of Economics WT 21/22  
**Related Theory:** [[04-Perfect-Competition]]

---

## Problem 1: Competitive Equilibrium

### Given Information

- Demand: $Q^D(p) = a - p$
- $n$ identical firms
- Cost: $C(q) = c_f + q^2$ for $q > 0$; $C(0) = 0$
- Long-run equilibrium

---

### Part (a): Equilibrium Number of Firms

#### Step 1: Calculate Cost Functions

**Marginal cost:** $$MC(q) = \frac{dC}{dq} = 2q$$

**Average cost:** $$AC(q) = \frac{C(q)}{q} = \frac{c_f + q^2}{q} = \frac{c_f}{q} + q$$

---

#### Step 2: Find Efficient Scale

**Long-run equilibrium condition:** $MC = AC$ (zero profit)

$$2q = \frac{c_f}{q} + q$$ $$q = \frac{c_f}{q}$$ $$q^2 = c_f$$ $$q^* = \sqrt{c_f}$$

---

#### Step 3: Find Equilibrium Price

$$p^* = MC(q^*) = 2\sqrt{c_f}$$

**Verification:** $AC(q^*) = \frac{c_f}{\sqrt{c_f}} + \sqrt{c_f} = \sqrt{c_f} + \sqrt{c_f} = 2\sqrt{c_f}$ ✓

---

#### Step 4: Find Total Quantity

$$Q^* = Q^D(p^*) = a - 2\sqrt{c_f}$$

---

#### Step 5: Find Number of Firms

$$\boxed{n^* = \frac{Q^_}{q^_} = \frac{a - 2\sqrt{c_f}}{\sqrt{c_f}} = \frac{a}{\sqrt{c_f}} - 2}$$

---

### Part (b): Numerical Examples

#### (i) $a = 120$, $c_f = 100$

$$n^* = \frac{120}{\sqrt{100}} - 2 = \frac{120}{10} - 2 = 12 - 2 = 10$$

**Per-firm output:** $q^* = 10$  
**Price:** $p^* = 20$  
**Profit per firm:** $\pi = 0$ (long-run equilibrium)

---

#### (ii) $a = 120$, $c_f = 64$

$$n^* = \frac{120}{\sqrt{64}} - 2 = \frac{120}{8} - 2 = 15 - 2 = 13$$

**Per-firm output:** $q^* = 8$  
**Price:** $p^* = 16$  
**Profit per firm:** $\pi = 0$

---

#### (iii) $a = 126$, $c_f = 100$

$$n^* = \frac{126}{10} - 2 = 12.6 - 2 = 10.6$$

**Issue:** Number of firms must be integer!

**With $n = 10$:**

- Per-firm output: $q^* = 10$
- Total quantity: $Q = 100$
- Price from demand: $p = 126 - 100 = 26$
- Cost per firm: $C(10) = 100 + 100 = 200$
- Profit: $\pi = 26(10) - 200 = 260 - 200 = 60 > 0$ ⚠️ (attracts entry)

**With $n = 11$:**

- Per-firm output: $q^* = 10$ (still efficient scale)
- Total quantity: $Q = 110$
- Price from demand: $p = 126 - 110 = 16$
- Profit: $\pi = 16(10) - 200 = 160 - 200 = -40 < 0$ (causes exit)

**Integer constraint creates instability!** Market oscillates or settles with $n = 10$ earning small positive profit.

**Answer:** $n = 10$ firms, profit per firm ≈ $60$ (or $n = 11$ with slight losses)

---

### Part (c): Equilibrium with Tax $t$

**Tax effect:** Firm's effective cost includes tax on output

**New optimization:** $$\max_q pq - C(q) - tq$$

**FOC:** $p = MC(q) + t$

**Cost functions remain:**

- $MC(q) = 2q$
- $AC(q) = \frac{c_f}{q} + q$

**But firm acts as if facing price $p - t$:**

**Alternative approach:** Tax adds to average cost: $$AC_{\text{effective}}(q) = \frac{c_f}{q} + q + t$$

**Long-run equilibrium:** Firm produces where $MC + t = AC + t$

This simplifies to: $MC = AC$ (same condition!)

So: $q^* = \sqrt{c_f}$ (unchanged)

**But equilibrium price includes tax:** $$p^* = MC(q^*) + t = 2\sqrt{c_f} + t$$

**Total quantity:** $$Q^* = a - p^* = a - 2\sqrt{c_f} - t$$

**Number of firms:** $$\boxed{n^* = \frac{a - 2\sqrt{c_f} - t}{\sqrt{c_f}}}$$

---

### Part (d): Calculate for $a = 126$, $c_f = 100$, $t = 6$

#### Number of Firms

$$n^* = \frac{126 - 20 - 6}{10} = \frac{100}{10} = 10$$

#### Per-firm Output

$$q^* = 10$$

#### Total Quantity

$$Q^* = 100$$

#### Equilibrium Price

$$p^* = 126 - 100 = 26$$

#### Profit per Firm

$$\pi = 26(10) - (100 + 100) - 6(10) = 260 - 200 - 60 = 0$$ ✓

#### Tax Revenue

$$T = t \times Q = 6 \times 100 = 600$$

---

#### Welfare Loss

**Without tax (from part b-iii):**

- Price: $p_0 = 20$
- Quantity: $Q_0 = 106$
- CS: $\frac{1}{2} \times 106 \times (126 - 20) = \frac{1}{2} \times 106 \times 106 = 5,618$
- PS: $0$ (long run)
- TS: $5,618$

**With tax:**

- Price: $p_1 = 26$ (to consumers)
- Price received by firms: $p_1 - t = 20$
- Quantity: $Q_1 = 100$
- CS: $\frac{1}{2} \times 100 \times (126 - 26) = \frac{1}{2} \times 100 \times 100 = 5,000$
- PS: $0$ (long run)
- Tax revenue: $600$
- TS: $5,000 + 600 = 5,600$

**Deadweight Loss:** $$DWL = TS_0 - TS_1 = 5,618 - 5,600 = 18$$

**Alternative calculation (triangle):** $$DWL = \frac{1}{2} \times (Q_0 - Q_1) \times t = \frac{1}{2} \times 6 \times 6 = 18$$ ✓

---

## Problems 2-6: Competitive Equilibrium

### Given Information

- Demand: $Q^D(p) = 125 - p$
- Cost: $C(q) = 25 + 20q + \frac{1}{4}q^2$ for $q > 0$

### Setup

**Marginal cost:** $$MC(q) = 20 + \frac{1}{2}q$$

**Average cost:** $$AC(q) = \frac{25}{q} + 20 + \frac{1}{4}q$$

---

### Problem 2: Equilibrium Number of Firms

**Long-run equilibrium:** $MC = AC$

$$20 + \frac{1}{2}q = \frac{25}{q} + 20 + \frac{1}{4}q$$ $$\frac{1}{2}q = \frac{25}{q} + \frac{1}{4}q$$ $$\frac{1}{4}q = \frac{25}{q}$$ $$q^2 = 100$$ $$q^* = 10$$

**Equilibrium price:** $$p^* = MC(10) = 20 + 5 = 25$$

**Verification:** $AC(10) = 2.5 + 20 + 2.5 = 25$ ✓

**Total quantity:** $$Q^* = 125 - 25 = 100$$

**Number of firms:** $$n^* = \frac{100}{10} = 10$$

**Answer: (B) 10**

---

### Problem 3: Consumer and Producer Surplus

**Consumer Surplus:**

- Demand intercept: $p = 125$ (when $Q = 0$)
- Equilibrium: $p^* = 25$, $Q^* = 100$

$$CS = \frac{1}{2} \times Q \times (P_{\max} - p^*)$$ $$CS = \frac{1}{2} \times 100 \times (125 - 25) = \frac{1}{2} \times 100 \times 100 = 5,000$$

**Producer Surplus:**

In long-run perfect competition: **PS = 0**

Each firm produces at minimum AC where $p = AC$, so profit per unit is zero.

**Answer: (B) consumer surplus is 5,000**

---

### Problem 4: Price Ceiling at $p' = 20$

**Check if firms can operate at $p = 20$:**

Minimum AC occurs at $q = 10$ where $AC(10) = 25$

Since $p' = 20 < 25 = \min AC$, **no firm can cover costs!**

**Market shuts down completely:**

- Quantity supplied: $Q^S = 0$
- Quantity demanded: $Q^D = 125 - 20 = 105$
- Massive shortage of 105 units

**Welfare Analysis:**

**Without ceiling:**

- CS = 5,000
- PS = 0
- TS = 5,000

**With ceiling:**

- No trade occurs
- CS = 0
- PS = 0
- TS = 0

**Welfare loss:** $$DWL = 5,000 - 0 = 5,000$$

**Answer: (C) 5,000**

---

### Problem 5: Price Floor at $p'' = 20$

**Compare to equilibrium:**

- Equilibrium price: $p^* = 25$
- Price floor: $p'' = 20$

Since $p'' = 20 < 25 = p^*$, the price floor is **NON-BINDING**!

**Market operates at equilibrium:**

- Price: $p = 25$
- Quantity: $Q = 100$
- No distortion

**Welfare loss = 0**

**Answer: (A) 0**

**Key insight:** Price floors only matter if set ABOVE equilibrium price.

---

### Problem 6: Lump-Sum Subsidy $S = 24$

**New cost function:** $$C(q) = 25 - 24 + 20q + \frac{1}{4}q^2 = 1 + 20q + \frac{1}{4}q^2$$

**New average cost:** $$AC(q) = \frac{1}{q} + 20 + \frac{1}{4}q$$

**Marginal cost unchanged:** $$MC(q) = 20 + \frac{1}{2}q$$

**Long-run equilibrium:** $MC = AC$

$$20 + \frac{1}{2}q = \frac{1}{q} + 20 + \frac{1}{4}q$$ $$\frac{1}{4}q = \frac{1}{q}$$ $$q^2 = 4$$ $$q^* = 2$$

**Equilibrium price:** $$p^* = MC(2) = 20 + 1 = 21$$

**Verification:** $AC(2) = 0.5 + 20 + 0.5 = 21$ ✓

**Total quantity:** $$Q^* = 125 - 21 = 104$$

**Number of firms:** $$n^* = \frac{104}{2} = 52$$

**Answer: (D) 52**

**Key insight:** Subsidy reduces fixed costs → allows more firms to enter at smaller scale → more firms total, lower price, higher quantity.

---

## Summary of Key Results

|Problem|Condition|Result|
|---|---|---|
|2|Equilibrium|10 firms|
|3|Welfare|CS = 5,000, PS = 0|
|4|Price ceiling ($p = 20$)|Market shutdown, DWL = 5,000|
|5|Price floor ($p = 20$)|Non-binding, DWL = 0|
|6|Subsidy ($S = 24$)|52 firms|

---

## Key Insights

1. **Long-run equilibrium always at min AC**
    
    - Firms produce at efficient scale
    - Zero economic profit
2. **Producer surplus = 0 in long run**
    
    - All gains to consumers
    - Free entry ensures no excess profits
3. **Price ceiling below min AC kills market**
    
    - Firms can't cover costs
    - Complete market failure
4. **Non-binding constraints have no effect**
    
    - Price floor below equilibrium: no impact
    - Market finds natural level
5. **Lump-sum subsidies increase number of firms**
    
    - Reduce fixed costs
    - Allow smaller-scale operations
    - More firms, lower price, more quantity
6. **Per-unit taxes reduce output**
    
    - Fewer firms
    - Lower total quantity
    - Deadweight loss from reduced trade
7. **Integer constraints matter**
    
    - May not achieve exact zero profit
    - Creates slight instability

---

[[04-Perfect-Competition|← Back to Theory]]  
[[Economics-Formula-Sheet|Formula Reference]]