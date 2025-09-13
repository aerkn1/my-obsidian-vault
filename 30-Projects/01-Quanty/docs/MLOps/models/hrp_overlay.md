# HRP Overlay — Deep Dive

- Compute 1h/4h returns matrix → correlation → distance `sqrt(0.5*(1-corr))` → hierarchical clustering + quasi-diagonalization.
- Recursive bisection weights; aggregate to cluster budgets. Publish `hrp:budget` and scale new trade risk to avoid crowding.
- Cap turnover; damp daily changes with EMA(λ=0.2).
