# Slide 07 — 論文④精要（陳冠錞 2025）

- **Kicker**: 06 · Layer 4 — Semantic Caching & Green Energy Trade-Off
- **Title**: 陳冠錞 (2025)：語意快取非線性能耗與 `0.85` 效益反轉點
- **Core Takeaway**: 語意快取並非裝了就省電——閾值 0.75 可靠 CPU 卸載省電 43.7%，但調嚴至 0.85 即因「查詢失敗＋GPU 推論」雙重懲罰反而多耗電 +12.7%。
- **Visual Spec (`svg-diagram` + `.stat-row`)**:
  - 總能耗曲線 SVG（viewBox `0 0 920 205`）：X 軸為閾值 `0.70 / 0.75 / 0.80 / 0.85 / 0.90 / 0.95`，Y 軸為 10 分鐘總能耗（kJ），畫出橫向虛線 Baseline `93.3 kJ`（155.9 W），與折線 `53.3 → 52.5 (最佳綠點 -43.7%) → 73.5 (微跌0.69%命中驟增21kJ) → 105.1 (紅點 0.85 效益反轉峰值 +12.7%) → 104.7 → 103.4`，清楚標示「節能區」與「寄生開銷區」。
  - Stat Row（GKE T4 + Ollama 4-bit Mistral-7B + GPTCache + pgvector，Kepler + DCGM）：`108 ms`（0.75 延遲，快 Baseline 280 倍）｜`-43.7%`（0.75 省電 `52.5 kJ`）｜`+12.7%`（0.85 效益反轉 `105.1 kJ`）｜`175.2 W`（雙重懲罰峰值功率）
- **Citations**: `wiki/papers/2025-chen-semantic-caching-energy-tradeoff.md` (§3–4, Table 4.1), `wiki/concepts/semantic-caching-and-benefit-inversion.md`
- **Speaker Notes**: 第四層來到最常被工程師忽略的線上能耗帳。陳冠錞在 GKE 的 T4 GPU 上用 Kepler 加 DCGM 實測了整機 CPU、DRAM 與 GPU 總焦耳數，結果畫出這條極具衝擊力的非線性曲線：在 0.75 處因為 99.99% 請求都在 CPU 快取層截殺，總耗電大降 43.7%、延遲從 30 秒變 108 毫秒；但只要把閾值收嚴到 0.85，就算命中率還有 87.3%，剩下 12.7% 沒命中的請求承受了「CPU 向量查表失敗＋喚醒 GPU 推論」的雙重懲罰，總耗電反超無快取 12.7%！講完四篇各自的核心後，下一頁我們開始往上抽象，提煉跨論文共通法則。
