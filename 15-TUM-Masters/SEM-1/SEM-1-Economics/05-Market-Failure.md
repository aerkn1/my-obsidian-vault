
# Market Failure

#economics #microeconomics #market-failure #monopoly #externalities #public-goods

**Topic:** Exercise 5 - When Markets Fail  
**Difficulty:** Advanced Level

---

## 🎯 What is Market Failure?

**Definition:** Market failure occurs when free markets fail to allocate resources efficiently, resulting in a loss of economic welfare.

**Main Types:**

1. **Monopoly** - Market power leads to underproduction
2. **Externalities** - Spillover effects not reflected in prices
3. **Public goods** - Non-excludable and non-rival goods
4. **Information asymmetry** - Unequal information between parties

---

## 📊 PART 1: MONOPOLY

### 1. Monopoly Fundamentals

**Key Characteristics:**

- **Single seller** in the market
- **Barrier to entry** prevents competition
- **Price maker** (not price taker)
- Faces **downward-sloping demand** curve

**Critical Difference from Perfect Competition:**

|Feature|Perfect Competition|Monopoly|
|---|---|---|
|Number of firms|Many|One|
|Price setting|Price taker ($p$ given)|Price maker (chooses $p$ or $Q$)|
|Demand curve|Horizontal (perfectly elastic)|Downward sloping|
|Condition|$p = MC$|$MR = MC$|
|Efficiency|Efficient ($p = MC$)|Inefficient ($p > MC$)|
|Profit (long run)|Zero|Positive (barrier to entry)|

---

### 2. Monopoly Optimization

**Monopolist's Problem:** $$\max_Q \pi = p(Q) \cdot Q - C(Q)$$

Where $p(Q)$ is **inverse demand** (price as function of quantity).

**First-Order Condition:** $$\frac{d\pi}{dQ} = 0$$ $$MR(Q) = MC(Q)$$

**Key Insight:** Monopolist equates **marginal revenue** to marginal cost, NOT price to marginal cost.

---

### 3. Marginal Revenue

**Why MR ≠ p for monopolist?**

When monopolist sells one more unit:

- **Gain:** Revenue from that unit = $p$
- **Loss:** Must lower price on ALL previous units

**For linear demand $p = a - bQ$:**

**Revenue:** $$R = pQ = (a - bQ)Q = aQ - bQ^2$$

**Marginal revenue:** $$MR = \frac{dR}{dQ} = a - 2bQ$$

**Key property:** MR curve is **twice as steep** as demand curve!

**Visual:**

```
Price
  │
a │\
  │ \  Demand: p = a - bQ
  │  \
  │   \
  │    \___MR = a - 2bQ (twice as steep!)
  │        
  └────────── Quantity
```

---

### 4. Finding Monopoly Equilibrium

**Step-by-step procedure:**

**Step 1:** Write inverse demand $p(Q)$

**Step 2:** Calculate revenue $R = p(Q) \cdot Q$

**Step 3:** Find marginal revenue $MR = \frac{dR}{dQ}$

**Step 4:** Calculate marginal cost $MC = \frac{dC}{dQ}$

**Step 5:** Set $MR = MC$, solve for $Q^*$

**Step 6:** Find price from demand: $p^* = p(Q^*)$

**Step 7:** Calculate profit: $\pi = p^_Q^_ - C(Q^*)$

---

### 5. Monopoly Inefficiency

**Why monopoly is inefficient:**

- Monopolist produces where $MR = MC$
- But $MR < p$ (demand)
- Therefore $p > MC$
- **Underproduce** relative to efficient level

**Efficient level (competitive):** $p = MC$

**Monopoly level:** $p > MC$ (produces less)

**Deadweight Loss:**

- Triangle between demand and MC curve
- From $Q^*$ (monopoly) to $Q_c$ (competitive)
- Represents lost trades that would benefit society

$$DWL = \frac{1}{2}(Q_c - Q^_)(p^_ - MC(Q_c))$$

---

### 6. Reservation Price

**Definition:** Maximum amount willing to pay for something.

**For exclusive right to be monopolist:**

**Reservation price = Expected monopoly profit**

**Why?**

- If pay more than profit, make losses
- If pay exactly profit, break even
- Maximum willingness to pay = profit

**Calculation:**

1. Find monopoly equilibrium ($Q^_$, $p^_$)
2. Calculate monopoly profit $\pi$
3. Reservation price = $\pi$

---

### 7. Taxes on Monopoly

#### Per-Unit Tax ($t$ per unit sold)

**Effect:** Increases marginal cost

**New MC:** $MC_{\text{new}} = MC + t$

**New optimization:** $MR = MC + t$

**Results:**

- Output **decreases** (higher MC)
- Price **increases** (but less than $t$)
- Profit **decreases**
- Tax revenue: $T = t \times Q_{\text{new}}$

**Key insight:** Per-unit tax affects marginal decisions → changes output

---

#### Profit Tax ($\tau$ as fraction of profit)

**Effect:** Takes portion of profit

**Firm's problem:** $$\max_Q (1 - \tau)\pi = (1 - \tau)[pQ - C(Q)]$$

**Key insight:** Multiplying by $(1 - \tau)$ doesn't change the $Q$ that maximizes profit!

**Results:**

- Output **unchanged**
- Price **unchanged**
- Profit **decreases** to $(1 - \tau)\pi$

**Why different from per-unit tax?**

- Profit tax: Not in FOC, doesn't affect marginal decision
- Per-unit tax: In FOC, affects marginal decision

**Reservation price with profit tax:** $$\text{Res. price} = (1 - \tau) \times \pi_{\text{original}}$$

---

### 8. Price Ceiling on Monopoly

**Price ceiling $\bar{p}$:** Maximum price monopolist can charge

**Effect depends on ceiling level:**

#### Case 1: Non-binding ($\bar{p} \geq p^*$)

- No effect
- Monopolist already charges $p^* < \bar{p}$

#### Case 2: Binding but above MC ($MC < \bar{p} < p^*$)

- Monopolist faces horizontal demand at $\bar{p}$ up to kink
- Acts like **price taker** in that region
- $MR = \bar{p}$ (constant) until kink
- Produces where $\bar{p} = MC$ (if feasible)
- **Increases output** (good!)
- **Increases consumer surplus** (good!)

#### Case 3: Below min AC ($\bar{p} < \min AC$)

- Monopolist **cannot cover costs**
- **Shuts down** (like perfect competition)
- Market failure becomes complete

---

### 9. Monopoly Welfare Analysis

**Consumer Surplus:** $$CS = \int_0^{Q^_} [p(q) - p^_] dq$$

For linear demand: $$CS = \frac{1}{2} \times Q^* \times (p_{\max} - p^*)$$

**Producer Surplus (Monopoly Profit):** $$PS = \pi = p^_Q^_ - C(Q^*)$$

**Total Surplus:** $$TS = CS + PS$$

**Deadweight Loss (vs competitive):** $$DWL = TS_{\text{competitive}} - TS_{\text{monopoly}}$$

---

## 🔄 PART 2: EXTERNALITIES

### 1. Externality Fundamentals

**Definition:** External effect - action by one party affects another party not involved in the transaction.

**Types:**

**Positive Externality:**

- Benefits others
- Examples: Education, vaccination, R&D, beekeeping
- **Result:** Underproduction (market produces too little)

**Negative Externality:**

- Harms others
- Examples: Pollution, noise, congestion, secondhand smoke
- **Result:** Overproduction (market produces too much)

---

### 2. Private vs Social Costs

**Key Distinction:**

**Private Cost:** Cost borne by decision-maker

- What firm considers when choosing output
- Example: Labor, materials, rent

**External Cost:** Cost imposed on others

- NOT considered by decision-maker
- Example: Pollution cleanup, health costs

**Social Cost:** Total cost to society $$\text{Social Cost} = \text{Private Cost} + \text{External Cost}$$

---

### 3. Externality in Cost Function

**Typical form (negative externality):** $$C_i(q_i, q_j) = f(q_i) + g(q_j)$$

Where:

- $f(q_i)$: Own cost (firm $i$ controls)
- $g(q_j)$: External cost (from firm $j$'s output)

**Example:** $C_i = 15 + \frac{q_i^2}{100} + \frac{q_j}{5}$

**Interpretation:**

- Firm $i$ bears cost $\frac{q_j}{5}$ from firm $j$'s production
- Firm $i$ imposes cost $\frac{q_i}{5}$ on firm $j$
- But firm $i$ **ignores** effect on firm $j$ when choosing $q_i$
- This is the externality!

---

### 4. Market Equilibrium with Externality

**Private Optimization (Nash Equilibrium):**

Each firm maximizes own profit, taking other's output as given.

**Firm $i$'s problem:** $$\max_{q_i} \pi_i = p(Q) \cdot q_i - C_i(q_i, q_j)$$

**FOC:** $$\frac{\partial \pi_i}{\partial q_i} = 0$$

Get **reaction function:** $q_i^*(q_j)$

**Symmetric equilibrium:** $q_i = q_j = q^*$

**Problem:** Firms ignore external cost they impose!

---

### 5. Social Optimum

**Social planner internalizes externality.**

**Total social cost:** $$SC = C_A(q_A, q_B) + C_B(q_B, q_A)$$

For symmetric case with $C_i = f(q_i) + g(q_j)$: $$SC = 2f(q) + 2g(q)$$

**Social welfare:** $$W = \text{Total Benefit} - \text{Social Cost}$$

**Optimal condition:** $$p = MC_{\text{social}}$$

Where social MC includes external cost.

**Key:** Social optimum has **less output** than private equilibrium (negative externality).

---

### 6. Pigouvian Tax

**Solution to negative externality:** Tax equal to marginal external cost.

**For cost $C_i = f(q_i) + g(q_j)$:**

If marginal external cost = $g'(q_j)$, set: $$t = g'(q_j)$$

**Effect:**

- Firm now faces cost: $C_i + t \cdot q_i$
- Effective cost = private cost + external cost
- **Internalizes** externality
- Produces at social optimum!

**Example:** If external cost = $\frac{q_j}{5}$, set $t = \frac{1}{5}$

---

### 7. Welfare Loss from Externality

**Inefficiency:**

- Private equilibrium: $Q_{\text{private}}$ (too high)
- Social optimum: $Q_{\text{social}}$ (efficient)

**Deadweight Loss:**

- Area between social MC and demand
- From $Q_{\text{social}}$ to $Q_{\text{private}}$

$$DWL = \int_{Q_{\text{social}}}^{Q_{\text{private}}} [MC_{\text{social}}(Q) - p(Q)] dQ$$

Triangle approximation: $$DWL \approx \frac{1}{2}(Q_{\text{private}} - Q_{\text{social}}) \times \Delta p$$

---

## 🏛️ PART 3: PUBLIC GOODS

### 1. Public Good Characteristics

**Two defining properties:**

**1. Non-Excludable:**

- Cannot prevent people from using it
- Once provided, available to all
- Example: National defense, lighthouse

**2. Non-Rival:**

- One person's use doesn't reduce availability for others
- Marginal cost of additional user = 0
- Example: Clean air, broadcast TV

**Contrast with Private Goods:**

|Property|Private Good|Public Good|
|---|---|---|
|Excludable?|Yes (can charge)|No (can't prevent use)|
|Rival?|Yes (your use prevents mine)|No (simultaneous use)|
|Market provision|Efficient|Underprovided|

---

### 2. Free Rider Problem

**The Problem:**

- People benefit without paying
- Rational to wait for others to provide
- Everyone tries to free ride
- **Result:** Underprovision or no provision

**Example:** National defense

- Benefits everyone equally
- Can't exclude non-payers
- Individuals won't voluntarily pay
- Need government provision

---

### 3. Efficient Provision

**Key Difference from Private Goods:**

**Private goods:**

- Each person consumes different quantity
- Sum demands **horizontally** (same price, different quantities)
- Efficient: $\sum Q_i = Q$ where $p = MC$

**Public goods:**

- Everyone consumes **same quantity**
- Sum demands **vertically** (same quantity, different prices)
- Efficient: $\sum MB_i(Q) = MC(Q)$

**Why vertical summation?**

- Everyone gets to "consume" the entire quantity
- Total value = sum of everyone's valuations
- Like multiple people watching same fireworks show

---

### 4. Finding Efficient Quantity

**Setup:**

- $n$ individuals
- Individual marginal benefit: $MB_i(Q)$
- Cost: $C(Q)$

**Efficiency condition:** $$\sum_{i=1}^n MB_i(Q) = MC(Q)$$

**For identical individuals:** $$n \times MB(Q) = MC(Q)$$

**Solve for $Q^*$:**

**Example:** 5 individuals, $MB = 4 - \frac{Q}{10}$, $MC = 10 + \frac{Q}{2}$

$$5\left(4 - \frac{Q}{10}\right) = 10 + \frac{Q}{2}$$ $$20 - \frac{Q}{2} = 10 + \frac{Q}{2}$$ $$Q^* = 10$$

---

### 5. Individual Provision

**What happens without coordination?**

**If each person decides independently:**

- Considers only **own** marginal benefit
- Ignores benefit to others
- Sets: $MB_{\text{individual}} = MC_{\text{individual}}$

**If cost is shared equally:** $$MB_i(Q) = \frac{MC(Q)}{n}$$

**If individual bears full cost:** $$MB_i(Q) = MC(Q)$$

**Result:**

- With full cost: Likely $Q = 0$ (complete free riding)
- With shared cost: Still underprovision

---

### 6. Welfare Loss from Underprovision

**Efficient welfare:** $$W^* = \int_0^{Q^_} \left[\sum_{i=1}^n MB_i(q)\right] dq - C(Q^_)$$

**Actual welfare (underprovision at $Q < Q^*$):** $$W = \int_0^Q \left[\sum_{i=1}^n MB_i(q)\right] dq - C(Q)$$

**Deadweight Loss:** $$DWL = W^* - W$$

**For complete free riding ($Q = 0$):** $$DWL = W^* - 0 = W^*$$ (entire potential surplus lost!)

---

## 🔧 PROBLEM-SOLVING FRAMEWORKS

### Framework 1: Monopoly Problems

```
1. Identify inverse demand p(Q)
2. Calculate MR = d(pQ)/dQ
3. Calculate MC = dC/dQ
4. Set MR = MC → solve for Q*
5. Find p* from demand
6. Calculate π = p*Q* - C(Q*)
```

**For reservation price:** Reservation price = π

**For tax problems:**

- Per-unit: Adjust MC by +t
- Profit tax: Multiply π by (1-τ)

---

### Framework 2: Externality Problems

```
1. Write each firm's profit function
2. Take FOC: ∂πᵢ/∂qᵢ = 0
3. Get reaction functions
4. Solve system (Nash equilibrium)
5. For social optimum:
   - Calculate total social cost
   - Set p = MC_social
6. Compare: DWL = difference
```

**For Pigouvian tax:** Set $t = $ marginal external cost

---

### Framework 3: Public Good Problems

```
1. Sum individual MBs (vertical!)
2. Calculate MC
3. Efficient: Σ MBᵢ(Q) = MC(Q)
4. Individual provision:
   - MBᵢ(Q) = MC(Q)/n (shared)
   - Or MBᵢ(Q) = MC(Q) (full cost)
5. Compare: DWL = W* - W_actual
```

---

## 💡 Common Mistakes to Avoid

❌ **Monopoly: Using p = MC instead of MR = MC**

- Monopolist is NOT price taker
- Must use marginal revenue

❌ **Thinking profit tax affects output**

- Profit tax: Doesn't change optimal Q
- Per-unit tax: Does change optimal Q

❌ **Adding public good demands horizontally**

- Public goods: Vertical summation (sum MBs)
- Private goods: Horizontal summation

❌ **Forgetting externality goes both ways**

- Firm A imposes cost on B
- Firm B imposes cost on A
- Both must be accounted for in social optimum

❌ **Assuming monopoly profit is always positive**

- If fixed costs too high, monopolist shuts down
- Check: π ≥ 0 for production

---

## 🎓 Key Insights

### Monopoly

1. **Produces less than competitive level** (p > MC)
2. **Can have positive profit in long run** (barrier to entry)
3. **Profit tax doesn't distort** (not in marginal decision)
4. **Price ceiling can improve welfare** (if above MC, below p*)

### Externalities

1. **Negative externality → overproduction** (ignore external cost)
2. **Pigouvian tax = marginal external cost** (internalizes)
3. **Social optimum: p = MC_social** (include external cost)
4. **Can use tax + subsidy** to achieve efficiency with zero profit

### Public Goods

1. **Free rider problem → underprovision** (can't exclude)
2. **Sum marginal benefits vertically** (everyone consumes same Q)
3. **Private markets fail completely** (often Q = 0)
4. **Need government provision** or coordination mechanism

---

## 📋 Formula Quick Reference

**Monopoly:**

- Linear demand $p = a - bQ$ → $MR = a - 2bQ$
- Condition: $MR = MC$
- DWL: Triangle from Q* to Q_c

**Externality:**

- Social cost = Private cost + External cost
- Pigouvian tax = Marginal external cost
- Nash equilibrium: Reaction functions

**Public Goods:**

- Efficiency: $\sum MB_i = MC$
- Individual: $MB_i = MC/n$ or $MC$
- Usually complete free riding

---

See [[Exercise-5-Solutions]] for detailed problem solutions.

[[Economics-Formula-Sheet|Formula Reference]]