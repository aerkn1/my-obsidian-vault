# Economic Fluctuations

#economics #macroeconomics #is-lm #multiplier #fiscal-policy #monetary-policy

**Topic:** Block 8 - Short-Run Fluctuations and Stabilization Policy  
**Difficulty:** Advanced Level

---

## 🎯 What are Economic Fluctuations?

**Economic fluctuations (business cycles):** Short-run movements in output, employment, and prices around long-run trend.

**Phases:**
- **Expansion:** Output rising
- **Peak:** Maximum output before downturn
- **Recession:** Output falling (2+ quarters of negative growth)
- **Trough:** Minimum output before recovery

**Key difference from growth:**
- **Long-run growth:** Solow model, steady capital accumulation
- **Short-run fluctuations:** Demand-side shocks, sticky prices

---

## 📊 PART 1: THE GOODS MARKET

### 1. Aggregate Demand Components

**Identity:**
$$Y = C + I + G + NX$$

**Closed economy** (no trade): $NX = 0$
$$Y = C + I + G$$

---

### 2. Consumption Function

**Keynesian consumption:**
$$C = C_0 + c(Y - T)$$

Where:
- $C_0$ = Autonomous consumption (consumption even if $Y=0$)
- $c$ = **Marginal propensity to consume (MPC)** ∈ $(0,1)$
- $Y - T$ = Disposable income
- $T$ = Taxes

**MPC interpretation:** If income increases by $1, consumption increases by $c$.

**Example:** If $c = 0.75$, then $\$1$ more income → $\$0.75$ more consumption.

---

### 3. Investment Function

**Investment depends on interest rate:**
$$I = I_0 - br$$

Where:
- $I_0$ = Autonomous investment
- $b > 0$ = Interest rate sensitivity
- $r$ = Real interest rate

**Why negative?**
- Higher interest rate → more expensive to borrow
- Fewer profitable projects → less investment

---

### 4. Government

**Given exogenously:**
- $G$ = Government purchases
- $T$ = Taxes

**Budget deficit:**
$$\text{Deficit} = G - T$$

---

## 🔄 PART 2: GOODS MARKET EQUILIBRIUM

### 1. Equilibrium Condition

**Supply = Demand:**
$$Y = C + I + G$$

Substituting:
$$Y = C_0 + c(Y-T) + I_0 - br + G$$

**Solving for $Y$:**
$$Y = C_0 + cY - cT + I_0 - br + G$$
$$Y - cY = C_0 - cT + I_0 - br + G$$
$$Y(1-c) = C_0 - cT + I_0 - br + G$$

$$Y = \frac{1}{1-c}[C_0 - cT + I_0 - br + G]$$

---

### 2. The Multiplier ⭐

**Government spending multiplier:**
$$\text{Multiplier} = \frac{1}{1-c} = \frac{1}{1-MPC}$$

**Why greater than 1?**
1. Government spends \$1 → someone earns \$1
2. They spend $c \times \$1$ → someone else earns $c$
3. They spend $c^2 \times \$1$ → someone earns $c^2$
4. Continue forever: $1 + c + c^2 + c^3 + ... = \frac{1}{1-c}$

**Example:** If $MPC = 0.75$:
$$\text{Multiplier} = \frac{1}{1-0.75} = \frac{1}{0.25} = 4$$

\$1 increase in $G$ → \$4 increase in $Y$!

---

### 3. Effects of Policy Changes

**Increase in $G$:**
$$\Delta Y = \frac{1}{1-c} \Delta G$$

**Increase in $T$:**
$$\Delta Y = -\frac{c}{1-c} \Delta T$$

Tax multiplier smaller because households only spend fraction $c$ of tax cut.

**Balanced budget multiplier:**

Increase $G$ and $T$ by same amount:
$$\Delta Y = \frac{1}{1-c} \Delta G - \frac{c}{1-c} \Delta T$$

If $\Delta G = \Delta T$:
$$\Delta Y = \frac{1-c}{1-c} \Delta G = \Delta G$$

Balanced budget multiplier = 1!

---

## 💰 PART 3: THE MONEY MARKET

### 1. Money Demand

**Liquidity preference:**
$$L(Y, r) = Y - \beta r$$

Where:
- $Y$ = Income (positive effect: more transactions need more money)
- $r$ = Interest rate (negative effect: opportunity cost of holding money)
- $\beta > 0$ = Interest sensitivity

**Why $Y$ positive?**
- Higher income → more transactions → need more money

**Why $r$ negative?**
- Higher interest rate → higher opportunity cost of cash
- Prefer bonds over money → money demand falls

---

### 2. Money Supply

**Controlled by central bank:**
$$M^S = M$$

Assumed fixed (exogenous) in short run.

---

### 3. Money Market Equilibrium

**Condition:**
$$M = L(Y, r)$$
$$M = Y - \beta r$$

**Solving for $r$:**
$$\beta r = Y - M$$
$$r = \frac{Y - M}{\beta}$$

**Interpretation:** Interest rate adjusts to equate money supply and demand.

---

## 🔗 PART 4: IS-LM MODEL

### 1. IS Curve (Goods Market)

**Equilibrium in goods market for different $(Y, r)$ combinations.**

From goods market equilibrium:
$$Y = \frac{1}{1-c}[C_0 - cT + I_0 - br + G]$$

**IS Curve:** Shows negative relationship between $Y$ and $r$
- Higher $r$ → lower $I$ → lower $Y$
- **Downward sloping** in $(Y,r)$ space

**Slope:** $-\frac{b}{1-c}$ (negative)

---

### 2. LM Curve (Money Market)

**Equilibrium in money market for different $(Y, r)$ combinations.**

From money market equilibrium:
$$r = \frac{Y - M}{\beta}$$

**LM Curve:** Shows positive relationship between $Y$ and $r$
- Higher $Y$ → more money demand → higher $r$ (to clear market)
- **Upward sloping** in $(Y,r)$ space

**Slope:** $\frac{1}{\beta}$ (positive)

---

### 3. General Equilibrium

**Both markets clear:** Find $(Y^*, r^*)$ where IS = LM

**Method:** Solve system of two equations
1. IS: $Y = \frac{1}{1-c}[C_0 - cT + I_0 - br + G]$
2. LM: $r = \frac{Y - M}{\beta}$

Substitute LM into IS to find $Y^*$, then find $r^*$.

---

## 🏛️ PART 5: FISCAL POLICY

### 1. Expansionary Fiscal Policy

**Increase $G$ or decrease $T$:**

**Effects:**
1. **IS curve shifts right** (goods market directly affected)
2. **Y increases, r increases**
3. **Consumption increases** (higher $Y$)
4. **Investment decreases** (higher $r$) - **crowding out**

**Government spending multiplier:**
$$\frac{\partial Y}{\partial G} = \frac{\frac{1}{1-c}}{1 + \frac{b}{\beta(1-c)}}$$

Smaller than simple multiplier $\frac{1}{1-c}$ due to interest rate increase crowding out investment.

---

### 2. Crowding Out

**Definition:** Government spending increases interest rates, which reduces private investment.

**Mechanism:**
1. $G \uparrow$ → $Y \uparrow$
2. $Y \uparrow$ → Money demand $\uparrow$
3. Money demand $\uparrow$ with fixed $M$ → $r \uparrow$
4. $r \uparrow$ → $I \downarrow$ (crowding out!)

**Complete crowding out:** $\Delta Y = 0$ (all increase in $G$ offset by decrease in $I$)
- Happens when LM is vertical

---

## 💵 PART 6: MONETARY POLICY

### 1. Expansionary Monetary Policy

**Increase $M$:**

**Effects:**
1. **LM curve shifts down/right** (money market directly affected)
2. **Y increases, r decreases**
3. **Consumption increases** (higher $Y$)
4. **Investment increases** (lower $r$)

**No crowding out!** Both $C$ and $I$ increase.

---

### 2. Monetary Policy Multiplier

$$\frac{\partial Y}{\partial M} = \frac{\frac{b}{\beta(1-c)}}{1 + \frac{b}{\beta(1-c)}}$$

**Interpretation:** \$1 increase in money supply increases output by this amount.

---

### 3. Interest Rate Effect

$$\frac{\partial r}{\partial M} = -\frac{1}{\beta + b(1-c)}$$

Negative: More money → lower interest rate.

---

## 🔧 PROBLEM-SOLVING FRAMEWORK

### Finding Multipliers

**Government spending multiplier:**

**Step 1:** Write equilibrium
$$Y = C + I + G$$

**Step 2:** Substitute functions
$$Y = C_0 + c(Y-T) + I_0 - br + G$$

**Step 3:** Ignore money market (partial equilibrium)
$$\frac{\partial Y}{\partial G} = \frac{1}{1-c}$$

**Or with money market (general equilibrium):**
$$\frac{\partial Y}{\partial G} = \frac{1}{1-c + \frac{b}{\beta}}$$

---

### Finding Interest Rate Effects

From money market:
$$r = \frac{Y - M}{\beta}$$

**Effect of tax on interest rate:**
$$\frac{\partial r}{\partial T} = \frac{1}{\beta} \cdot \frac{\partial Y}{\partial T}$$

Calculate $\frac{\partial Y}{\partial T}$ first, then multiply by $\frac{1}{\beta}$.

---

### IS-LM Graphical Analysis

**Step 1:** Identify which curve shifts
- Fiscal policy: IS shifts
- Monetary policy: LM shifts

**Step 2:** Direction of shift
- Expansionary: Right (higher $Y$)
- Contractionary: Left (lower $Y$)

**Step 3:** New equilibrium
- Find intersection of new curves
- Determine changes in $Y$ and $r$

---

## 💡 Common Mistakes

❌ **Forgetting interest rate effect on investment**
- Simple multiplier ignores that $r$ changes
- Real multiplier accounts for crowding out

❌ **Confusing money supply and money demand**
- Supply: $M$ (controlled by central bank)
- Demand: $L(Y,r)$ (depends on $Y$ and $r$)

❌ **Wrong signs on multipliers**
- $\frac{\partial Y}{\partial G} > 0$ (positive)
- $\frac{\partial Y}{\partial T} < 0$ (negative)
- $\frac{\partial Y}{\partial M} > 0$ (positive)

❌ **Forgetting ceteris paribus**
- When calculating $\frac{\partial Y}{\partial G}$, hold $T$ and $M$ constant
- Each multiplier assumes other variables unchanged

---

## 🎓 Key Insights

1. **Fiscal policy has crowding out**
   - Increases $Y$ but also $r$
   - Higher $r$ reduces $I$
   - Net effect on $Y$ smaller than simple multiplier

2. **Monetary policy more effective**
   - Increases $Y$ and reduces $r$
   - Both $C$ and $I$ increase
   - No crowding out

3. **Multiplier depends on MPC**
   - Higher $MPC$ → larger multiplier
   - More consumption spending ripples through economy

4. **Balanced budget multiplier = 1**
   - Increase $G$ and $T$ equally
   - Output increases by full amount of $G$ increase
   - Surprising result!

5. **Short run vs long run**
   - Short run: Prices sticky, output adjusts
   - Long run: Prices flexible, output at potential
   - IS-LM is short-run model

---

## 📋 Formula Quick Reference

**Goods Market:**
- $Y = C + I + G$
- $C = C_0 + c(Y-T)$
- $I = I_0 - br$

**Multipliers:**
- Government: $\frac{1}{1-c}$
- Tax: $-\frac{c}{1-c}$
- Balanced budget: $1$

**Money Market:**
- $M = L(Y,r) = Y - \beta r$
- $r = \frac{Y-M}{\beta}$

**IS-LM:**
- IS slope: $-\frac{b}{1-c}$
- LM slope: $\frac{1}{\beta}$

**Policy Effects:**
- $\frac{\partial Y}{\partial G} > 0$
- $\frac{\partial Y}{\partial T} < 0$
- $\frac{\partial Y}{\partial M} > 0$
- $\frac{\partial r}{\partial G} > 0$
- $\frac{\partial r}{\partial M} < 0$

---

[[Exam-Block-8-Solutions|Practice Problems →]]

[[07-Economic-Growth|← Previous Topic]]

[[06-Macroeconomic-Indicators|First Topic]]
