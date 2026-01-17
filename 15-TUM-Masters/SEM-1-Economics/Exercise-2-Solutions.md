# Exercise 2: Consumption and Demand - Solutions

#economics #solutions #consumer-theory #practice

**Source:** Exercise 2, Principles of Economics WT 21/22  
**Related Theory:** [[02-Consumption-and-Demand]]

---

## Problem 1: Budget Restriction

### Given Information
- Time endowment: Z = 24 hours
- Wage rate: w = 25 per hour
- Consumption good price: p = 1 per unit
- Labor (L) + Free time (F) = 24 hours

---

### Part (a): Initial Budget Restriction

#### Budget Constraint Derivation

**Income earned:** $wL = w(Z - F) = 25(24 - F)$
**Spending:** $pq = 1 \cdot q$
**Budget:** $q = 25(24 - F) = 600 - 25F$

**Alternative form:**
$$25F + q = 600$$

This is the **potential income constraint** (what could be earned if working all hours).

---

#### Budget Line Characteristics

**Intercepts:**
- Vertical (q-axis, F = 0): q = 600 (work all hours, no leisure)
- Horizontal (F-axis, q = 0): F = 24 (all leisure, no work)

**Slope:** -25
- Give up 25 units of consumption for each hour of free time
- Opportunity cost of leisure = wage rate

**Graph:**
```
q (consumption)
600 |•
    |  \
    |    \
    |      \
    |        \
  0 |__________•_____ F (free time)
    0         24
```

---

### Part (b): Policy Changes

#### (i) Income Tax: w → (1-t)w = 20

**New budget:**
$$q = 20(24 - F) = 480 - 20F$$

**Changes:**
- Vertical intercept: 600 → 480 (lower max consumption)
- Horizontal intercept: 24 (unchanged—can still have 24 hrs leisure)
- Slope: -25 → -20 (flatter, lower opportunity cost of leisure)

**Effect:** Budget line **rotates inward** around point (24, 0)

**Intuition:** Lower wage reduces opportunity cost of leisure, making free time relatively cheaper.

---

#### (ii) Consumption Tax: p → (1+τ)p = 1.25

**New budget:**
$$1.25q = 25(24 - F)$$
$$q = 20(24 - F) = 480 - 20F$$

**Result:** IDENTICAL to income tax!

**Key insight:** 
- Income tax of 20% reduces wage from 25 to 20
- Consumption tax of 25% raises effective price, reducing purchasing power
- **Same real effect on budget constraint**

---

#### (iii) Social Transfer: S = 200 - wL for wL < 200

**New budget (piecewise):**

**For wL ≥ 200** (working at least 8 hours, F ≤ 16):
- No subsidy applies
- $q = 25(24 - F) = 600 - 25F$ (original)

**For wL < 200** (working less than 8 hours, F > 16):
- Total income = $wL + S = wL + (200 - wL) = 200$
- $q = 200$ (constant!)

**Budget line:**
- For F ∈ [0, 16]: Original slope -25
- For F ∈ [16, 24]: **Horizontal line** at q = 200
- **Kink** at F = 16, q = 200

**Graph:**
```
q
600 |•
    |  \
    |    \
    |      \ 
200 |       •━━━━━━━━━•
    |                   
  0 |___________________
    0    16            24  F
```

**Economic implications:**
- **Poverty trap:** No incentive to work if earning less than 200
- Working 0-8 hours all yield same income (200)
- Discontinuity creates perverse incentives

---

## Problem 2: Assumptions on Preferences

### Given Information
- Bundle A: (8 apples, 2 oranges)
- Bundle B: (2 apples, 8 oranges)
- Bundle C: (6 apples, 6 oranges)
- Preferences: $A \sim B$ (indifferent) and $B \succ C$ (prefer B to C)

---

### Testing Each Assumption

#### 1. Completeness
Can compare all bundles? **YES** ✓
- We have rankings for A vs B, B vs C
- Completeness just requires ability to compare (given)

---

#### 2. Transitivity
If $A \sim B$ and $B \succ C$, then must have $A \succ C$

**Check:**
- $A \sim B$ means same utility level
- $B \succ C$ means B has higher utility than C
- Therefore: $A \succ C$ (A also higher utility than C)

**Consistent?** YES ✓ (implied by given preferences)

---

#### 3. Monotonicity
More of at least one good (without less of another) should be weakly preferred.

**Comparing B and C:**
- Bundle B: (2, 8)
- Bundle C: (6, 6)
- C has MORE apples (6 > 2) but FEWER oranges (6 < 8)

Neither bundle dominates the other, so monotonicity isn't directly violated by this comparison.

**However**, consider if monotonicity strictly holds...

---

#### 4. Convexity ⚠️
Prefer averages to extremes. If $A \sim B$, then any weighted average should be at least as good.

**Key observation:**
- Bundle C = (6, 6) = 0.5 × (8, 2) + 0.5 × (2, 8)
- **C is exactly the midpoint of A and B!**

**By convexity:** If $A \sim B$, then $C \succeq A$ and $C \succeq B$

**But we're told:** $B \succ C$ (strictly prefer B to C)

**CONTRADICTION!** This **violates convexity**.

---

### Conclusion

**Answer:** The four assumptions **CANNOT hold together**.

**Specifically violated:** **Convexity**

**Why it matters:** 
- These preferences exhibit "extremeness preference" (prefer corners)
- Suggests goods are complements in an unusual way
- Or perhaps the consumer values variety negatively
- Real-world analogy: Someone who strongly prefers specialization over balanced consumption

---

## Problem 3: Individual Demand

### Given Information
- $U(q_1, q_2) = q_1^{1/2} + q_2^{1/2}$
- Income: $y > 0$
- Prices: $p_1 > 0, p_2 > 0$

---

### Part (a): Demand Functions

#### Step 1: Calculate Marginal Utilities

$$MU_1 = \frac{\partial U}{\partial q_1} = \frac{1}{2}q_1^{-1/2} = \frac{1}{2\sqrt{q_1}}$$

$$MU_2 = \frac{\partial U}{\partial q_2} = \frac{1}{2}q_2^{-1/2} = \frac{1}{2\sqrt{q_2}}$$

---

#### Step 2: Calculate MRS

$$MRS = \frac{MU_1}{MU_2} = \frac{1/(2\sqrt{q_1})}{1/(2\sqrt{q_2})} = \frac{\sqrt{q_2}}{\sqrt{q_1}} = \sqrt{\frac{q_2}{q_1}}$$

**Note:** MRS depends on consumption ratio—not constant!

---

#### Step 3: Optimality Condition

At interior optimum: $MRS = \frac{p_1}{p_2}$

$$\sqrt{\frac{q_2}{q_1}} = \frac{p_1}{p_2}$$

Square both sides:
$$\frac{q_2}{q_1} = \left(\frac{p_1}{p_2}\right)^2$$

$$q_2 = q_1 \left(\frac{p_1}{p_2}\right)^2$$

---

#### Step 4: Apply Budget Constraint

$$p_1 q_1 + p_2 q_2 = y$$

Substitute $q_2$:
$$p_1 q_1 + p_2 \cdot q_1 \left(\frac{p_1}{p_2}\right)^2 = y$$

$$p_1 q_1 + q_1 \frac{p_1^2}{p_2} = y$$

$$q_1 \left(p_1 + \frac{p_1^2}{p_2}\right) = y$$

$$q_1 \cdot p_1 \left(1 + \frac{p_1}{p_2}\right) = y$$

$$q_1 \cdot p_1 \cdot \frac{p_2 + p_1}{p_2} = y$$

---

#### Step 5: Solve for Demands

**Demand for good 1:**
$$\boxed{q_1^* = \frac{yp_2}{p_1(p_1 + p_2)}}$$

**Demand for good 2:**
Substitute back:
$$q_2^* = q_1^* \left(\frac{p_1}{p_2}\right)^2 = \frac{yp_2}{p_1(p_1 + p_2)} \cdot \frac{p_1^2}{p_2^2}$$

$$\boxed{q_2^* = \frac{yp_1}{p_2(p_1 + p_2)}}$$

---

### Part (b): Characterizing the Goods

#### Income Effects

$$\frac{\partial q_1^*}{\partial y} = \frac{p_2}{p_1(p_1 + p_2)} > 0$$

$$\frac{\partial q_2^*}{\partial y} = \frac{p_1}{p_2(p_1 + p_2)} > 0$$

**Both goods are NORMAL** (demand increases with income) ✓

---

#### Own-Price Effects

**For good 1:**
$$q_1^* = \frac{yp_2}{p_1(p_1 + p_2)}$$

Using quotient rule:
$$\frac{\partial q_1^*}{\partial p_1} = yp_2 \cdot \frac{\partial}{\partial p_1}\left[\frac{1}{p_1(p_1 + p_2)}\right]$$

$$= yp_2 \cdot \frac{-(2p_1 + p_2)}{[p_1(p_1 + p_2)]^2} < 0$$

**Good 1 is ORDINARY** (demand decreases when price increases) ✓

Similarly, $\frac{\partial q_2^*}{\partial p_2} < 0$

**Good 2 is ORDINARY** ✓

---

### Summary

Both goods exhibit **standard behavior**:
- **Normal goods:** Demand increases with income
- **Ordinary goods:** Demand decreases with own price

This utility function represents goods that are substitutes (can trade off between them) but with diminishing marginal utility (concave transformation).

---

## Problem 4: Substitution and Income Effects

### Given Information
- $U(q_1, q_2) = (q_1 \cdot q_2)^{1/2} = \sqrt{q_1 q_2}$
- Income: $y = 600$
- Initial prices: $p_1 = 25, p_2 = 25$
- New price: $p_2' = 100$

**Note:** This is **Cobb-Douglas** with $a = b = 1/2$

---

### Part (a): Initial Optimal Bundle

#### Using Cobb-Douglas Formula

For $U = q_1^a q_2^b$ with $a = b = 1/2$:

$$q_1^* = \frac{a}{a+b} \cdot \frac{y}{p_1} = \frac{1/2}{1} \cdot \frac{600}{25} = \frac{600}{50} = 12$$

$$q_2^* = \frac{b}{a+b} \cdot \frac{y}{p_2} = \frac{1/2}{1} \cdot \frac{600}{25} = 12$$

**Initial bundle:** $(q_1^*, q_2^*) = (12, 12)$

**Initial utility:** $U_0 = \sqrt{12 \times 12} = 12$

**Verification:** $25(12) + 25(12) = 300 + 300 = 600$ ✓

---

#### Graphical Elements

**Budget line:** $25q_1 + 25q_2 = 600$
- Slope: -1
- Intercepts: (24, 0) and (0, 24)

**Indifference curve:** $q_1 \cdot q_2 = 144$
- Hyperbola tangent to budget line at (12, 12)
- MRS at (12, 12) = $q_2/q_1 = 1$ matches slope

---

### Part (b): Decomposition into SE and IE

#### Step 1: New Optimal Bundle

With $p_2' = 100$:

$$q_1' = \frac{600}{2 \times 25} = 12$$ (unchanged!)

$$q_2' = \frac{600}{2 \times 100} = 3$$

**New bundle:** $(12, 3)$

---

#### Step 2: Total Effects

**Good 1:** $TE_1 = 12 - 12 = 0$
**Good 2:** $TE_2 = 3 - 12 = -9$

---

#### Step 3: Substitution Effect (Compensated Bundle)

Need hypothetical income $y'$ to maintain $U_0 = 12$ at new prices.

With Cobb-Douglas, still spend half on each:
$$p_1 q_1 = p_2 q_2$$
$$25q_1 = 100q_2$$
$$q_1 = 4q_2$$

With utility constraint:
$$\sqrt{q_1 q_2} = 12$$
$$\sqrt{4q_2 \cdot q_2} = 12$$
$$2q_2 = 12$$
$$q_2 = 6$$

$$q_1 = 24$$

**Compensated bundle:** $(24, 6)$

**Hypothetical income:**
$$y' = 25(24) + 100(6) = 600 + 600 = 1200$$

---

#### Step 4: Calculate SE and IE

**Substitution Effects:**
- $SE_1 = 24 - 12 = +12$ (substitute toward good 1)
- $SE_2 = 6 - 12 = -6$ (substitute away from good 2)

**Income Effects:**
- $IE_1 = 12 - 24 = -12$ (real income fell, reduce normal good)
- $IE_2 = 3 - 6 = -3$ (real income fell, reduce normal good)

---

#### Verification

$$TE_1 = SE_1 + IE_1 = 12 + (-12) = 0$$ ✓
$$TE_2 = SE_2 + IE_2 = -6 + (-3) = -9$$ ✓

---

#### Interpretation

**Good 2 (price increased):**
- SE = -6: Substitute away due to higher relative price
- IE = -3: Real income fell, consume less (normal good)
- Both work in same direction → large total decrease

**Good 1 (price unchanged):**
- SE = +12: Substitute toward relatively cheaper good
- IE = -12: Real income fell, consume less (normal good)
- Effects exactly cancel → no net change!

**Key Cobb-Douglas property:** Constant expenditure shares mean good 1 consumption unchanged despite significant substitution effect.

---

#### Graphical Decomposition

```
Three points:
A = (12, 12): Original equilibrium
B = (24, 6): Compensated equilibrium (A→B = SE)
C = (12, 3): New equilibrium (B→C = IE)
```

**Budget lines:**
1. Original: slope = -1
2. Compensated: slope = -0.25, tangent to original IC
3. New: slope = -0.25, shifted inward parallel to compensated

---

### Part (c): Compensating Variation

**Question:** Income needed to restore $U_0 = 12$ after price change?

**Answer:** $y' = 1200$ (calculated in part b)

**Compensating variation:** $CV = 1200 - 600 = 600$

**Interpretation:** Consumer needs an extra 600 to be just as well off after the price increase from 25 to 100.

This is a **welfare measure**—how much the consumer would pay to avoid the price increase.

---

## Problem 5: Corner Solution with Perfect Substitutes

### Given Information
- $U(q_1, q_2) = q_1 + 2q_2$
- Income: $y = 100$
- Prices: $p_1 = 4, p_2 = 5$

---

### Solution Approach

#### Step 1: Identify Utility Type

This is **perfect substitutes** utility.
- MRS = constant
- Indifference curves are straight lines

---

#### Step 2: Calculate MRS

$$MU_1 = 1$$
$$MU_2 = 2$$
$$MRS = \frac{MU_1}{MU_2} = \frac{1}{2}$$

**Interpretation:** Willing to trade 1 unit of good 2 for 0.5 units of good 1 (or 2 units of good 1 for 1 unit of good 2).

---

#### Step 3: Compare to Price Ratio

$$\frac{p_1}{p_2} = \frac{4}{5} = 0.8$$

**Comparison:**
- MRS = 0.5 < 0.8 = price ratio
- Consumer values good 2 relatively MORE than market does

---

#### Step 4: "Bang per Buck" Analysis

**Good 1:** Utility per dollar = $\frac{MU_1}{p_1} = \frac{1}{4} = 0.25$

**Good 2:** Utility per dollar = $\frac{MU_2}{p_2} = \frac{2}{5} = 0.4$

**Good 2 gives MORE utility per dollar!** → Buy only good 2

---

#### Step 5: Optimal Bundle

$$q_1^* = 0$$
$$q_2^* = \frac{y}{p_2} = \frac{100}{5} = 20$$

**Verification:**
- Spending: $4(0) + 5(20) = 100$ ✓
- Utility: $0 + 2(20) = 40$

**If bought only good 1:** $U = 100/4 = 25$ (worse!)

---

### Answer

**(B) The individual spends her entire budget on good 2.** ✓

**Why other options wrong:**
- (A): Can determine optimal bundle (corner solution)
- (C): No good 1 consumed, not a 2:1 ratio
- (D): Spends on good 2, not good 1

---

## Problems 6-10: Cobb-Douglas Series

### Common Setup
- $U(q_1, q_2) = q_1^{1/4} q_2^{3/4}$
- Income: $y = 12$
- Price of good 1: $p_1 = 1$ (constant)
- Price of good 2: $p_2$ varies

---

### Demand Functions (General)

For $U = q_1^a q_2^b$ with $a = 1/4, b = 3/4$:

$$q_1^* = \frac{a}{a+b} \cdot \frac{y}{p_1} = \frac{1/4}{1} \cdot \frac{12}{1} = 3$$

$$q_2^* = \frac{b}{a+b} \cdot \frac{y}{p_2} = \frac{3/4}{1} \cdot \frac{12}{p_2} = \frac{9}{p_2}$$

**Key insight:** $q_1^* = 3$ always (independent of $p_2$!)

---

### Problem 6: Optimal Bundle when $p_2 = 1$

$$q_1^* = 3$$
$$q_2^* = \frac{9}{1} = 9$$

**Verification:**
- Spending: $1(3) + 1(9) = 12$ ✓
- Shares: 3/12 = 1/4, 9/12 = 3/4 ✓

**Answer: (D)** $q_1 = 3$ and $q_2 = 9$

---

### Problem 7: Expenses when $p_2 = 3$

$$q_1^* = 3$$
$$q_2^* = \frac{9}{3} = 3$$

**Expenses:**
- Good 1: $1 \times 3 = 3$
- Good 2: $3 \times 3 = 9$

**Cobb-Douglas property:** Expenditure shares constant!
- Always spend 1/4 of income on good 1 = $12 \times 1/4 = 3$
- Always spend 3/4 of income on good 2 = $12 \times 3/4 = 9$

**Answer: (D)** 9 for good 2

---

### Problem 8: SE and IE for Good 1 (Cross-Price Effect)

**Price change:** $p_2: 1 \to 3$

**Observation:** $q_1^*$ stays at 3 (TE = 0)

But decomposition still meaningful:

**Substitution Effect:**
- When $p_2$ increases, good 2 becomes relatively expensive
- Holding utility constant, substitute toward good 1
- **SE > 0** (increase $q_1$)

**Income Effect:**
- $p_2$ increase reduces real income (budget line pivots in)
- Good 1 is normal, so demand falls with lower real income
- **IE < 0** (decrease $q_1$)

**Total Effect:**
- TE = SE + IE = (+) + (-) = 0
- **Effects exactly cancel**

**Answer: (C)** in opposite directions, while both effects neutralize

---

### Problem 9: Characterizing Goods

**Good 1:**
- From Problem 8: IE < 0 for cross-price effect
- When real income ↓, demand for good 1 ↓
- **Good 1 is NORMAL** ✓

**Good 2:**
- Own-price increase: $q_2$ goes from 9 to 3 (decreases)
- Standard downward-sloping demand
- **Good 2 is ORDINARY** ✓

**Answer: (A)** Good 1 is a normal good, and good 2 is an ordinary good

---

### Problem 10: Indifference Curve at $(3, 3)$ when $p_2 = 3$

**Budget line:** $q_1 + 3q_2 = 12$

**Check if $(3, 3)$ is on budget line:**
$$1(3) + 3(3) = 3 + 9 = 12$$ ✓

**From Problem 7:** Optimal bundle is $(3, 3)$

**At optimum:** Indifference curve is **tangent** to budget line
- They touch at exactly one point
- MRS = price ratio at this point

**Answer: (B)** is tangent to the budget line

---

### Key Takeaways from Problems 6-10

1. **Cobb-Douglas has constant expenditure shares** regardless of prices
2. **Cross-price effects can have SE and IE that cancel** (as with good 1)
3. **Tangency condition** characterizes interior optimal bundles
4. **All Cobb-Douglas goods are normal** (demand increases with income)
5. **Own-price demand curves are downward-sloping** (ordinary goods)

---

[[02-Consumption-and-Demand|← Back to Theory]] | [[Exercise-3-Solutions|Next: Production Solutions →]]
