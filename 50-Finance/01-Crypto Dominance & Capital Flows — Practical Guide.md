
This tutorial gives you a systematic, quantitative way to read **stablecoin dominance (USDT/USDC/DAI)** alongside **BTC/ETH/OTHERS dominance** and **TOTAL/TOTAL2/TOTAL3**. Think of capital like water moving between connected tanks: **Fiat ↔ Stables ↔ BTC/ETH ↔ Alts**.

---

## 1) Definitions

- **STABLES.D** — Share of total crypto market cap held by stablecoins (USDT, USDC, DAI).
- **BTC.D / ETH.D / OTHERS.D** — Dominance of BTC, ETH, and the rest of the market (TOTAL3).
- **TOTAL** — Full crypto market cap. **TOTAL2** — ex-BTC. **TOTAL3** — ex-BTC & ETH.
- **Mint / Redeem** — Issuance (fiat → stable) and burning (stable → fiat) events.
- **OI / Funding** — Futures open interest and perp funding rate (leverage/skew).

**Key identity:** TOTAL = BTC cap + ETH cap + ALTs cap + STABLES cap.

---

## 2) Stable Dominance Mechanics — What Really Moves It

Stable dominance is a **ratio**. It moves due to:
1. **Mint/Burn (true inflow/outflow)** — supply changes of stables.
2. **Price moves in volatile assets** — BTC/ETH/ALTs falling increases stables’ *share* even with flat supply.

**Important:** Trading USDT↔BTC does **not** change USDT supply; it just changes hands. Dominance changes mainly from valuation swings or supply changes.

---

## 3) Sell Flood Sequence (Two Shocks)

1. **Rotation shock** — Coins sold → prices drop immediately → **TOTAL falls**; stable cap flat; **STABLES.D rises** (denominator shrinks).
2. **Redemption shock** — Stables redeemed to fiat → stable cap falls → **TOTAL falls further** (capital leaves the crypto system).

---

## 4) Spot vs Futures Read

- **Spot-led**: Exchange stable balances ↑ and spot volumes ↑ → healthier accumulation or rotation.
- **Futures-led**: OI spikes with skewed funding → leverage-driven; prone to squeezes.

**Heuristics:**
- OI↑ + funding↑ → crowded longs → risk of long squeeze.
- OI↑ + funding↓ → crowded shorts → risk of short squeeze.

---

## 5) Interpreting Dominance Combinations (Playbook)

- **STABLES.D ↑ + TOTAL ↑ + Stable supply ↑ (mint)** → fresh fiat inflow; constructive.  
- **STABLES.D ↑ + TOTAL ↓ + No mint** → risk-off rotation; defensive.  
- **STABLES.D ↓ + TOTAL ↑** → risk-on; capital rotating into BTC/ETH/ALTs.  
- **BTC.D ↑ + TOTAL ↑** → BTC-led rally (early-cycle or macro uncertainty).  
- **BTC.D ↓ + OTHERS.D ↑ + TOTAL2/TOTAL3 ↑** → Altseason conditions.  
- **ETH.D ↑ with sector breadth** → ETH-led rotation (DeFi/NFT/L2).

---

## 6) Dashboard Checklist (Quant Ready)

1. **Supply**: USDT/USDC/DAI circulating supply 24h/7d change (mint/burn).  
2. **Dominance**: STABLES.D, BTC.D, ETH.D, OTHERS.D (levels & deltas).  
3. **Market Caps**: TOTAL, TOTAL2, TOTAL3 change; breadth of TOTAL3.  
4. **Spot Flows**: Exchange stable balances, netflow (in/out), spot volume.  
5. **Futures**: OI change, funding rate, long/short skew; liquidation heatmap.  
6. **Regime Tagging**: Rule-based labels (BTC-led, Altseason, Risk-off, Inflow, Outflow).

---

## 7) Flowcharts (Mermaid)

Use the `.mmd` files in this pack for dashboards or docs.

- [[capital_flow_LR.mmd]] — Horizontal capital flow map (Fiat ↔ Stables ↔ BTC/ETH/Alts).  
- [[capital_flow_TD.mmd]] — Compact vertical version.  
- [[dominance_decision_tree.mmd]] — Parse-safe decision tree for daily read.

---

## 8) Quick Interpretation Rules (Cheat Sheet)

- **Stable ↑ + TOTAL ↑** = inflow likely (confirm mint).  
- **Stable ↑ + TOTAL ↓** = rotation to safety, risk-off.  
- **BTC.D ↑** = defensive or BTC-led early rally; confirm TOTAL.  
- **OTHERS.D ↑ + TOTAL3 ↑** = altseason conditions.  
- **OI spike** = leverage; combine with funding to detect squeeze risk.

---

## 9) Practical Tips

- Always **separate valuation effects** from **supply effects**.  
- **Confirm with supply**: Mint/burn beats narratives.  
- **Check exchange balances** for deployable “ammo.”  
- **Mind leverage**: Strong spot + muted OI is healthier than OI-led pumps.

---
