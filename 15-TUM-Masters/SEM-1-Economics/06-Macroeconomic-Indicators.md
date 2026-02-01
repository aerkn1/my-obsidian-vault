# Macroeconomic Indicators

#economics #macroeconomics #gdp #inflation #unemployment

**Topic:** Block 6 - Measuring Economic Performance  
**Difficulty:** Intermediate Level

---

## 🎯 What is Macroeconomics?

**Macroeconomics** studies the economy as a whole - aggregate output, employment, price levels, and economic growth.

**Key Questions:**
- How much does the economy produce? (GDP)
- How fast are prices rising? (Inflation)
- How many people are working? (Employment/Unemployment)
- How fast is the economy growing?

---

## 📊 PART 1: GDP (Gross Domestic Product)

### 1. Definition

**GDP:** Total **market value** of all **final goods and services** produced **within a country** during a **specific period**.

**Key Features:**

**1. Market value:** Uses prices to add up different goods

**2. Final goods only:** Avoids double counting
- ✅ Bread sold to consumers (final)
- ❌ Flour sold to bakery (intermediate)

**3. Produced within borders:** Geographic location matters

**4. Specific period:** Flow variable (per year)

---

### 2. Nominal vs Real GDP ⭐

**Nominal GDP:** Measured at **current prices**
$$\text{Nominal GDP}_t = \sum P_t \times Q_t$$

**Real GDP:** Measured at **base year prices**
$$\text{Real GDP}_t = \sum P_{\text{base}} \times Q_t$$

**Key insights:**
- Nominal can rise from: (1) more production OR (2) higher prices
- Real rises ONLY from more production
- Real is better for comparing across years

---

### 3. GDP Deflator

$$\text{GDP Deflator}_t = \frac{\text{Nominal GDP}_t}{\text{Real GDP}_t} \times 100$$

**Interpretation:**
- **Base year:** Deflator = 100
- **Deflator > 100:** Prices increased since base year
- **Deflator < 100:** Prices decreased since base year

---

## 💰 PART 2: PRICE INDICES

### 1. Consumer Price Index (CPI)

**Definition:** Measures cost of **fixed basket** of consumer goods.

$$\text{CPI}_t = \frac{\text{Cost of basket in year } t}{\text{Cost of basket in base year}} \times 100$$

---

### 2. GDP Deflator vs CPI

| Feature | GDP Deflator | CPI |
|---------|-------------|-----|
| **Basket** | Changes | Fixed |
| **Imports** | Excluded | Included |
| **Coverage** | All goods produced | Consumer goods only |

---

### 3. Inflation Rate

$$\text{Inflation}_{t-1 \to t} = \frac{\text{Index}_t - \text{Index}_{t-1}}{\text{Index}_{t-1}} \times 100\%$$

---

## 👷 PART 3: LABOR MARKET

### 1. Definitions

**Adult Population (N):** Everyone 16+ years

**Labor Force:** Employed + Unemployed

**Employed (E):** Has a job

**Unemployed (U):** No job, actively seeking

**Not in Labor Force:** Not working, not seeking

---

### 2. Key Rates

**Labor Force Participation Rate:**
$$e = \frac{E + U}{N}$$

**Unemployment Rate:**
$$u = \frac{U}{E + U}$$

**Key relationships:**
- Labor Force $= e \times N$
- Unemployed $= u \times e \times N$
- Employed $= (1-u) \times e \times N$

---

## 🔍 PROBLEM-SOLVING FRAMEWORK

### Multi-Good GDP Calculation

**Given:** Quantities and prices for multiple goods across years

**Step 1: Nominal GDP each year**
$$\text{Nom}_t = P_t^{\text{good1}} \times Q_t^{\text{good1}} + P_t^{\text{good2}} \times Q_t^{\text{good2}} + ...$$

**Step 2: Real GDP each year (use base year prices)**
$$\text{Real}_t = P_{\text{base}}^{\text{good1}} \times Q_t^{\text{good1}} + P_{\text{base}}^{\text{good2}} \times Q_t^{\text{good2}} + ...$$

**Step 3: GDP Deflator**
$$\text{Deflator}_t = \frac{\text{Nom}_t}{\text{Real}_t} \times 100$$

**Step 4: CPI (fixed basket)**

Choose base year quantities, apply each year's prices:
$$\text{CPI}_t = \frac{P_t^{\text{good1}} \times Q_{\text{base}}^{\text{good1}} + P_t^{\text{good2}} \times Q_{\text{base}}^{\text{good2}} + ...}{\text{Base year cost}} \times 100$$

---

### Labor Market Calculations

| Given | Find | Formula |
|-------|------|---------|
| $N$, $e$ | Labor Force | $e \times N$ |
| LF, $u$ | Unemployed | $u \times LF$ |
| LF, $u$ | Employed | $(1-u) \times LF$ |
| $E$, $U$ | $u$ | $\frac{U}{E+U}$ |

---

## 💡 Common Mistakes

❌ **Wrong unemployment formula**
- Wrong: $u = \frac{U}{N}$
- Correct: $u = \frac{U}{E+U}$

❌ **Forgetting base year = 100**
- All indices = 100 in base year

❌ **Mixing nominal and real**
- Real removes inflation effects
- Use real for production comparisons

---

## 📋 Formula Quick Reference

**GDP Deflator:**
$$\frac{\text{Nominal}}{\text{Real}} \times 100$$

**CPI:**
$$\frac{\text{Basket cost}_t}{\text{Basket cost}_{\text{base}}} \times 100$$

**Inflation:**
$$\frac{\text{Index}_t - \text{Index}_{t-1}}{\text{Index}_{t-1}}$$

**Labor Force:**
$$e \times N$$

**Unemployment Rate:**
$$\frac{U}{E+U}$$

---

[[Exam-Block-6-Solutions|Practice Problems →]]

[[07-Economic-Growth|Next Topic →]]
