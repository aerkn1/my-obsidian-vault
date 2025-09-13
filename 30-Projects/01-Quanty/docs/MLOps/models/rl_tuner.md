# RL Tuner (Optional) — Deep Dive

- **Context:** subset of features + Conf_total + macro regime.
- **Actions:** small deltas around RR and leverage with hard bounds.
- **Reward:** clipped realised_R; penalize drawdown spikes.
- **Offline eval:** IPS/DR with logged propensities; validate on time‑split.
- **Online:** shadow mode; throttle updates; revert on KPI drop.
