# Probability Sampling Methods in Detail

## 🎯 The Foundations of Statistical Inference

Probability sampling is the gold standard for generalizing from sample to population.

---

## 🎲 Core Principle

**Every unit has a KNOWN, NON-ZERO probability of selection**

This enables:
✅ Statistical inference
✅ Unbiased estimates
✅ Calculable sampling error
✅ Confidence intervals

---

## 1️⃣ Simple Random Sampling (SRS)

### Definition
Every unit has **equal** probability of selection

### Process
1. Create sampling frame (list of all units)
2. Number units 1 to N
3. Use random number generator
4. Select n units

### Probability
P(selection) = n/N for each unit

### Example
- Population: 10,000 students
- Sample: 500 students
- Each has 500/10,000 = 5% chance

### Advantages
✅ Simple, straightforward
✅ Unbiased
✅ Easy to understand
✅ Valid statistical inference

### Disadvantages
❌ Need complete sampling frame
❌ May miss small subgroups  
❌ Can be inefficient
❌ May not be representative by chance (small samples)

---

## 2️⃣ Stratified Random Sampling

### Definition
Divide population into **strata**, then random sample from each

### Key Principle
**Homogeneous within strata, heterogeneous between strata**

### Process
1. Identify stratification variable (gender, age, region)
2. Divide population into mutually exclusive strata
3. Randomly sample from each stratum
4. Combine samples

### Types

**Proportional Stratified:**
- Sample fraction same for all strata
- Stratum sample size proportional to stratum population size

**Disproportional Stratified:**
- Different sampling fractions
- Oversample small groups
- Use weights in analysis

### Example
Study of company employees (N=1000):

**Strata:**
- Management: 100 people → Sample 20 (20%)
- Professional: 400 people → Sample 80 (20%)
- Support: 500 people → Sample 100 (20%)
- Total sample: 200

### Advantages
✅ More precise than SRS (lower SE)
✅ Ensures representation
✅ Can compare subgroups
✅ Can use different methods per stratum

### Disadvantages
❌ Need stratification information
❌ More complex
❌ If wrong strata chosen, less efficient

---

## 3️⃣ Cluster Sampling

### Definition
Randomly select **clusters** (groups), then sample within clusters

### Key Principle
**Heterogeneous within clusters (mini-populations)**

### Process
1. Divide population into clusters
2. Randomly select k clusters
3. Sample all units in selected clusters (one-stage)
   OR randomly sample within selected clusters (two-stage)

### Example
Study of high school students in Germany:

**One-Stage:**
1. List all high schools (clusters)
2. Randomly select 50 schools
3. Survey ALL students in those 50 schools

**Two-Stage:**
1. Randomly select 50 schools
2. Within each school, randomly select 30 students

### Advantages
✅ Practical/economical
✅ Don't need complete population list
✅ Reduces travel/contact costs
✅ Administratively easier

### Disadvantages
❌ Less precise than SRS (higher SE)
❌ Students within schools similar (less information per person)
❌ Need larger sample for same precision

---

## 4️⃣ Systematic Sampling

### Definition
Select every **kth** unit from ordered list

### Process
1. Calculate sampling interval: k = N/n
2. Random start between 1 and k
3. Select every kth unit

### Example
- Population: 10,000 students
- Sample needed: 500
- k = 10,000/500 = 20
- Random start: 7
- Select: 7, 27, 47, 67, 87, ..., 9,987

### Advantages
✅ Simple to implement
✅ Spreads sample across population
✅ Often more practical than SRS

### Disadvantages
❌ If list has periodicity, can bias results
❌ Not truly random
❌ Can't calculate exact sampling error

### Danger: Periodicity
If list has pattern matching k, systematic sampling fails!

**Example:** Every 20th house is corner house (more expensive)
→ If k=20, sample all corner houses!

---

## 5️⃣ Multi-Stage Sampling

### Definition
Sampling in **multiple hierarchical stages**

### Common Design
**Stage 1:** Select regions (clusters)
**Stage 2:** Select districts within regions
**Stage 3:** Select households within districts  
**Stage 4:** Select individuals within households

### Example
National health survey:

1. **Stage 1:** Randomly select 20 states
2. **Stage 2:** Randomly select 5 counties per state
3. **Stage 3:** Randomly select 10 census blocks per county
4. **Stage 4:** Randomly select 5 households per block
5. **Stage 5:** Randomly select 1 adult per household

### Advantages
✅ Very practical for large populations
✅ Cost-effective
✅ Manageable

### Disadvantages
❌ Complex analysis
❌ Cumulative error across stages
❌ Less precision

---

## 📊 Comparing Methods

| Method | Precision | Cost | Complexity | Best For |
|--------|-----------|------|------------|----------|
| **SRS** | Baseline | Medium | Low | Homogeneous populations |
| **Stratified** | Highest | Medium | Medium | Known important subgroups |
| **Cluster** | Lowest | Lowest | Low | Geographically dispersed |
| **Systematic** | Similar to SRS | Low | Low | Ordered lists |
| **Multi-stage** | Low | Lowest | High | Very large populations |

---

## 🔑 Key Takeaways

1. **Probability sampling** = random selection = statistical inference
2. **SRS**: Simplest, every unit equal probability
3. **Stratified**: Best precision, ensure representation
4. **Cluster**: Most practical, lowest precision
5. **Systematic**: Simple but watch for periodicity
6. **Multi-stage**: For very large populations
7. **Trade-off**: Precision vs. Cost vs. Practicality

---

*Part of: [[00-Index|Business Research Methods Course Notes]]*
