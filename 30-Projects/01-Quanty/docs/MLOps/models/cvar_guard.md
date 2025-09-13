# CVaR Guard — Deep Dive

- Loss samples by symbol/TF/cluster; compute empirical CVaRα (α=0.95/0.975).
- Optionally fit GPD over u (POT) for tail; use analytical CVaR.
- Expose Redis `cvar:<symbol>:<tf>` and an HTTP `/sizing` that returns max size/leverage so tail loss ≤ budget.
- Monitor sample size and CI; fallback to cluster‑level CVaR if per‑symbol is sparse.
