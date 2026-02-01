# Use Cases PRD - Summary

**Status:** In Progress (UC-01 and UC-02 completed in detail)

## Completed Use Cases (Detailed)

### ✅ UC-01: Single Patent Deep Analysis
**Coverage:** 100% Complete (~50 pages)

**Documented:**
- Input validation with regex patterns
- Complete data flow with mermaid diagram
- All 4 dimension calculations with formulas:
  - Influence: Field normalization, H-index, citation velocity
  - Legal: Opposition scoring, renewal consistency, family value
  - Financial: Cost calculation (EPO + national), ROI, efficiency
  - Future: ML prediction, SHAP explanation, trend classification
- Synthesis logic (6 categories)
- Licensing intelligence generation
- Complete API response format
- UI dashboard specification
- Error handling (3 scenarios)
- Performance requirements (<5s target)

**Key Formulas Documented:**
```python
# Influence Score
influence = (
    field_normalized_score * 0.5 +
    h_index_score * 0.3 +
    diversity_score * 0.2
)

# Financial Score  
financial = efficiency_score + roi_score + risk_inverse

# Future Score
future = prediction_score + trend_bonus + confidence_bonus
```

### ✅ UC-02: Company Portfolio Analysis
**Coverage:** 100% Complete (~40 pages)

**Documented:**
- Company fuzzy search & disambiguation
- Portfolio retrieval with filters
- Sampling strategy (stratified by year + CPC)
- Batch processing (50 patents/batch, parallel)
- Aggregation metrics (summary, distribution, financial)
- Optimization analysis:
  - Abandonment candidates
  - Geographic trimming opportunities
  - Savings calculation
- Complete dashboard specification
- Performance requirements (<60s for 500 patents)

**Key Insights:**
- Parallel processing: 10x faster than serial
- Pre-computation strategy for top 50 companies
- Progressive UI rendering

## Remaining Use Cases (To Document)

### 🚧 UC-03: Manual Portfolio Upload
**Scope:**
- CSV validation logic
- Batch upload processing
- Duplicate detection
- Error reporting

### 🚧 UC-04: Licensing Opportunity Discovery
**Scope:**
- Fit score calculation (5 components)
- Company ranking algorithm
- Licensing value estimation
- Contact strategy generation

### 🚧 UC-05: Portfolio Financial Optimization
**Scope:**
- Optimization algorithm
- Scenario simulation
- Risk assessment
- Roadmap generation

### 🚧 UC-06: Hidden Gems Discovery
**Scope:**
- Hidden gem criteria
- Value explanation logic
- Licensing prioritization
- Strategic recommendations

### 🚧 UC-07: Market Intelligence
**Scope:**
- CPC-to-market mapping
- Competitive landscape
- White space analysis
- Technology trends

### 🚧 UC-08: ML-Powered Future Prediction
**Scope:**
- Feature engineering pipeline
- Prediction confidence
- SHAP explanation detail
- Trend visualization

## Documentation Approach

Each use case follows this structure:
1. **Overview** (actor, goal, success criteria)
2. **Input Specification** (format, validation, examples)
3. **Data Flow** (mermaid diagram, step-by-step)
4. **Calculations** (detailed formulas with examples)
5. **Output Specification** (API response, UI format)
6. **Error Handling** (failure modes, fallbacks)
7. **Performance** (targets, optimization)

## Next Steps

Priority order for remaining use cases:
1. UC-04 (Licensing) - Core differentiator
2. UC-05 (Optimization) - High business value
3. UC-06 (Hidden Gems) - Unique value proposition
4. UC-07 (Market Intel) - Context enrichment
5. UC-03 (Manual Upload) - Simple functionality
6. UC-08 (ML Detail) - Already covered in ML Guidelines PRD

**Recommendation:** Proceed with Architecture PRD now, return to complete remaining use cases after architecture is documented.

---

**Location:** Full documentation in Obsidian vault
**File:** `30-projects/patent-iq/PRD-Use-Cases-Detail.md`
**Pages Completed:** ~90 pages (2 of 8 use cases)
**Estimated Total:** ~300 pages when complete
