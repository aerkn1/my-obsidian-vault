# Consumption and Demand

#economics #microeconomics #consumer-theory #utility #demand

**Topic:** Exercise 2 - Consumer Choice Theory  
**Difficulty:** Intermediate Level

---

## 🎯 Core Concepts

### 1. Budget Constraint

**Definition:** The limitation on consumption choices imposed by income and prices.

**Standard Form (Two Goods):**
$$y = p_1q_1 + p_2q_2$$

Where:
- $y$ = income
- $p_1, p_2$ = prices of goods 1 and 2
- $q_1, q_2$ = quantities consumed

**Budget Line (Rearranged):**
$$q_2 = \frac{y}{p_2} - \frac{p_1}{p_2}q_1$$

**Key Properties:**
- **Slope:** $-\frac{p_1}{p_2}$ (opportunity cost in market)
- **Vertical intercept:** $\frac{y}{p_2}$ (max of good 2 if buy nothing else)
- **Horizontal intercept:** $\frac{y}{p_1}$ (max of good 1 if buy nothing else)

---

#### Budget Line Shifts

**Income Changes:**
- Income ↑ → Parallel shift **outward** (more consumption possible)
- Income ↓ → Parallel shift **inward** (less consumption possible)
- Slope unchanged (relative prices same)

**Price Changes:**
- $p_1$ ↑ → Budget line **rotates inward**, pivoting on vertical axis
- $p_1$ ↓ → Budget line **rotates outward**, pivoting on vertical axis
- $p_2$ ↑ → Budget line **rotates inward**, pivoting on horizontal axis

**Visual:**
```
Price increase of good 1:
- Horizontal intercept moves left (can afford less)
- Vertical intercept stays same (doesn't affect max of good 2)
- Budget line becomes steeper
```

---

#### Special Case: Labor-Leisure Budget

**Setup:**
- Total time: $Z = L + F$ (labor + free time)
- Wage rate: $w$ per hour
- Income from labor: $y = wL = w(Z - F)$
- Consumption good price: $p$

**Budget Constraint:**
$$pq = w(Z - F)$$
$$pq + wF = wZ$$

**Interpretation:**
- $wZ$ = **potential income** (if worked all available time)
- Spending on consumption + "cost" of free time = potential income
- Opportunity cost of leisure = wage rate

**Budget Line:**
$$q = \frac{wZ}{p} - \frac{w}{p}F$$

- Slope: $-\frac{w}{p}$ (real wage)
- Trade-off: each hour of free time costs $w/p$ units of consumption

---

### 2. Preferences and Utility

#### Four Fundamental Assumptions

**1. Completeness**
- Can always compare any two bundles
- Either $A \succ B$ (prefer A), $B \succ A$ (prefer B), or $A \sim B$ (indifferent)

**2. Transitivity**
- If $A \succ B$ and $B \succ C$, then $A \succ C$
- Ensures consistent preferences

**3. Monotonicity**
- More is better (or at least not worse)
- If bundle A has at least as much of every good and more of some good, then $A \succeq B$
- "Non-satiation"

**4. Convexity**
- Prefer averages to extremes
- If $A \sim B$, then any mixture $\lambda A + (1-\lambda)B \succeq A$ (and $\succeq B$)
- Leads to diminishing marginal rate of substitution

---

#### Utility Functions

**Definition:** Mathematical representation of preferences: $U(q_1, q_2)$

**Properties:**
- Higher utility = preferred bundle
- Ordinal (only ranking matters, not absolute numbers)
- Not unique (any monotonic transformation represents same preferences)

**Marginal Utility:**
$$MU_1 = \frac{\partial U}{\partial q_1}$$

- Additional utility from one more unit of good 1
- Typically diminishing (each extra unit adds less utility)

---

#### Indifference Curves

**Definition:** Curve showing all bundles giving the same utility level.

**Properties:**
- Downward sloping (if more of one good, need less of other to maintain utility)
- Cannot cross (would violate transitivity)
- Higher curves = higher utility
- Typically convex to origin (due to convexity assumption)

**Slope of Indifference Curve:**
$$\text{Slope} = -MRS = -\frac{MU_1}{MU_2}$$

---

### 3. Marginal Rate of Substitution (MRS) ⭐

**Definition:** Rate at which consumer is willing to trade good 2 for good 1, holding utility constant.

**Formula:**
$$MRS = \frac{MU_1}{MU_2}$$

**Interpretation:**
- MRS = 2 means: willing to give up 2 units of good 2 for 1 unit of good 1
- Measures subjective trade-off (personal valuation)
- Compare to price ratio (market trade-off)

**Diminishing MRS:**
- As you get more of good 1, willing to give up less of good 2 for additional units
- Explains convex indifference curves
- Reflects "variety is valuable" principle

---

### 4. Utility Maximization

**The Consumer's Problem:**
$$\max_{q_1, q_2} U(q_1, q_2)$$
$$\text{subject to: } p_1q_1 + p_2q_2 = y$$

**Optimal Condition (Interior Solution):**
$$MRS = \frac{p_1}{p_2}$$

Or equivalently:
$$\frac{MU_1}{MU_2} = \frac{p_1}{p_2}$$

Or:
$$\frac{MU_1}{p_1} = \frac{MU_2}{p_2}$$

**Interpretation:**
- At optimum, indifference curve is **tangent** to budget line
- Subjective trade-off (MRS) = market trade-off (price ratio)
- "Bang per buck" equal across goods

---

#### Solution Methods

**Method 1: Lagrangian**
$$\mathcal{L} = U(q_1, q_2) + \lambda(y - p_1q_1 - p_2q_2)$$

**First-order conditions:**
$$\frac{\partial \mathcal{L}}{\partial q_1} = MU_1 - \lambda p_1 = 0$$
$$\frac{\partial \mathcal{L}}{\partial q_2} = MU_2 - \lambda p_2 = 0$$
$$\frac{\partial \mathcal{L}}{\partial \lambda} = y - p_1q_1 - p_2q_2 = 0$$

Solving gives: $q_1^*(p_1, p_2, y)$ and $q_2^*(p_1, p_2, y)$

**Method 2: Direct Substitution**
1. Set $MRS = \frac{p_1}{p_2}$ to find relationship between $q_1$ and $q_2$
2. Substitute into budget constraint
3. Solve for optimal quantities

---

#### Corner Solutions

**When:** MRS $\neq$ price ratio at all interior points

**Result:** Spend entire budget on one good

**Example:** Perfect substitutes with $\frac{MU_1}{MU_2} < \frac{p_1}{p_2}$
- Good 2 is better value
- Optimal: $q_1^* = 0, q_2^* = \frac{y}{p_2}$

---

### 5. Demand Functions

**Definition:** Optimal quantity as function of prices and income.

**Notation:** $q_i^*(p_1, p_2, y)$ or simply $q_i(p_1, p_2, y)$

**Properties to examine:**
1. **Own-price effect:** $\frac{\partial q_i}{\partial p_i}$
2. **Cross-price effect:** $\frac{\partial q_i}{\partial p_j}$
3. **Income effect:** $\frac{\partial q_i}{\partial y}$

---

### 6. Classification of Goods

#### By Income Effects

**Normal Good:** $\frac{\partial q}{\partial y} > 0$
- Demand increases when income increases
- Most goods are normal

**Inferior Good:** $\frac{\partial q}{\partial y} < 0$
- Demand decreases when income increases
- Examples: instant noodles, bus travel (vs car)

---

#### By Own-Price Effects

**Ordinary Good:** $\frac{\partial q}{\partial p} < 0$
- Demand decreases when own price increases
- Standard downward-sloping demand
- Almost all goods are ordinary

**Giffen Good:** $\frac{\partial q}{\partial p} > 0$
- Demand INCREASES when own price increases
- Extremely rare (theoretical curiosity)
- Must be inferior good with large income effect

---

### 7. Substitution and Income Effects (Slutsky Decomposition) ⭐⭐⭐

**The Key Insight:** When a price changes, two things happen:
1. Relative prices change → substitution toward cheaper goods
2. Real income changes → purchasing power affected

**Total Effect (TE):**
$$TE = q_1(p_1', p_2, y) - q_1(p_1, p_2, y)$$

Change in quantity from initial to final prices.

---

#### Substitution Effect (SE)

**Definition:** Change in quantity due to relative price change ONLY, holding utility constant.

**Method (Hicksian Approach):**
1. Find hypothetical income $y'$ that allows original utility at new prices
2. SE = change from original to this compensated bundle

**Key Property:** Substitution effect ALWAYS moves opposite to price change
- If $p_1$ ↑, then SE on $q_1$ < 0
- Substitution always toward relatively cheaper good

---

#### Income Effect (IE)

**Definition:** Change in quantity due to real income change, holding relative prices constant.

**Calculation:**
$$IE = TE - SE$$

**Direction depends on good type:**
- **Normal good:** IE same direction as SE
  - Price ↑ → real income ↓ → demand ↓ (IE < 0)
- **Inferior good:** IE opposite direction to SE
  - Price ↑ → real income ↓ → demand ↑ (IE > 0)

---

#### Classification by Effects

**For price increase of good 1:**

| Good Type | SE | IE | TE | Result |
|-----------|----|----|----|----|
| **Normal** | - | - | - | Demand definitely decreases |
| **Inferior (ordinary)** | - | + | - | SE dominates, demand decreases |
| **Giffen** | - | + | + | IE dominates, demand increases! |

**Visual Summary:**
```
Price ↑
    ↓
┌─────────┬──────────────┐
│   SE    │      IE      │
│ Always  │  Depends on  │
│  < 0    │  good type   │
└─────────┴──────────────┘
    ↓           ↓
    └─────┬─────┘
          ↓
         TE
```

---

#### Graphical Decomposition

**Three-Point Method:**
1. **Point A:** Original equilibrium (before price change)
2. **Point B:** Compensated equilibrium (new prices, old utility)
   - Move A → B = **Substitution Effect**
3. **Point C:** New equilibrium (new prices, original income)
   - Move B → C = **Income Effect**

**Total Effect:** A → C = SE + IE

---

### 8. Compensating Variation

**Definition:** Additional income needed to restore original utility after a price change.

**Formula:** Find $y'$ such that:
$$U(q_1(p_1', p_2, y'), q_2(p_1', p_2, y')) = U(q_1(p_1, p_2, y), q_2(p_1, p_2, y))$$

**Interpretation:**
- How much would you pay to avoid the price increase?
- Measures consumer welfare loss from price change

---

## 📊 Common Utility Functions

### 1. Cobb-Douglas: $U = q_1^a q_2^b$

**Optimal Demand:**
$$q_1^* = \frac{a}{a+b} \cdot \frac{y}{p_1}$$
$$q_2^* = \frac{b}{a+b} \cdot \frac{y}{p_2}$$

**Key Properties:**
- **Constant expenditure shares:** $\frac{p_1q_1^*}{y} = \frac{a}{a+b}$
- Always interior solution (both goods consumed)
- Both goods are normal
- Income and substitution effects can cancel for cross-price changes

**Special Case:** $U = q_1^{1/2} q_2^{1/2}$
- Spend half income on each good
- $q_1^* = \frac{y}{2p_1}$, $q_2^* = \frac{y}{2p_2}$

---

### 2. Perfect Substitutes: $U = aq_1 + bq_2$

**MRS:** Constant = $\frac{a}{b}$

**Optimal Demand (Corner Solution):**
- If $\frac{a}{p_1} > \frac{b}{p_2}$: buy only good 1
- If $\frac{a}{p_1} < \frac{b}{p_2}$: buy only good 2
- If $\frac{a}{p_1} = \frac{b}{p_2}$: indifferent (any combination)

**Interpretation:** Goods are perfect substitutes in utility, buy whichever is cheaper per unit of utility ("bang per buck").

---

### 3. Perfect Complements: $U = \min\{aq_1, bq_2\}$

**Optimal Demand:**
- Consume in fixed ratio: $\frac{q_1}{q_2} = \frac{b}{a}$
- At optimum: $aq_1 = bq_2$ (both constrained)

**Budget constraint:**
$$p_1q_1 + p_2q_2 = y$$

**Solving:**
$$q_1^* = \frac{y}{p_1 + p_2 \frac{b}{a}}$$
$$q_2^* = \frac{y}{p_2 + p_1 \frac{a}{b}}$$

**Example:** Left and right shoes, coffee and cream (for some people)

---

### 4. CES (Constant Elasticity of Substitution)

$$U = (q_1^\rho + q_2^\rho)^{1/\rho}$$

**Nests other forms:**
- $\rho \to 0$: Cobb-Douglas
- $\rho = 1$: Perfect substitutes
- $\rho \to -\infty$: Perfect complements

---

## 🔧 Problem-Solving Framework

### Step 1: Identify Utility Function Type
- Cobb-Douglas? → Use expenditure share formula
- Perfect substitutes? → Corner solution, compare bang per buck
- Perfect complements? → Fixed ratio consumption
- Other? → Use general optimization

### Step 2: Set Up Optimization
- Write budget constraint
- Calculate MRS (for interior solutions)
- Set MRS = price ratio OR use Lagrangian

### Step 3: Solve for Demands
- Algebraically solve for $q_1^*$ and $q_2^*$
- Check feasibility (non-negative quantities)
- Verify budget exhausted

### Step 4: Analyze Changes
- Income changes → parallel shifts
- Price changes → decompose into SE and IE
- Check if goods are normal/inferior, ordinary/Giffen

---

## 💡 Common Mistakes to Avoid

❌ **Confusing MRS and price ratio**
- MRS = willingness to trade (preferences)
- Price ratio = market exchange rate
- At optimum they're equal, but they're conceptually different

❌ **Forgetting corner solutions**
- Not all optimal bundles are interior
- Check if MRS = price ratio is feasible

❌ **Wrong direction of income effect**
- Normal good: income ↑ → demand ↑
- Inferior good: income ↑ → demand ↓

❌ **Thinking Giffen goods are common**
- Giffen goods are extremely rare
- Most goods are ordinary (demand decreases with price)

❌ **Confusing substitution and income effects**
- SE always opposes price change
- IE direction depends on whether good is normal/inferior

❌ **Not using Cobb-Douglas shortcuts**
- With Cobb-Douglas, expenditure shares are constant
- Use $q_i^* = \frac{\text{exponent}_i}{\sum \text{exponents}} \cdot \frac{y}{p_i}$

---

## 🎓 Key Insights

1. **Consumer optimization is about equalizing trade-offs:** MRS = price ratio means you can't reallocate spending to increase utility

2. **Cobb-Douglas maintains constant budget shares** regardless of price changes—very useful property!

3. **Substitution effects always work against price changes**, income effects can go either way

4. **For normal goods, SE and IE reinforce** (both move same direction when price changes)

5. **Perfect substitutes lead to corner solutions**—buy only the cheaper good (per unit of utility)

6. **Indifference curves tangent to budget line** at interior optimum—powerful visual tool

---

## 📋 Practice Checklist

- [ ] Can draw and shift budget lines correctly
- [ ] Can calculate MRS from utility function
- [ ] Can solve Cobb-Douglas problems quickly
- [ ] Can identify corner vs interior solutions
- [ ] Can decompose total effect into SE and IE
- [ ] Can determine if goods are normal/inferior
- [ ] Can find compensating variation
- [ ] Understand why Giffen goods are rare

---

## 🔗 Related Topics

- [[Exercise-2-Solutions]] - Detailed problem solutions
- [[01-Specialization-and-Trade]] - Previous topic
- [[03-Production-and-Supply]] - Next topic
- [[Economics-Formula-Sheet]] - Quick reference

---

**Next:** [[03-Production-and-Supply]]
