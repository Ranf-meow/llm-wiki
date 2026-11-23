# Slide 09 — 跨論文法則②（結構化 Schema 與領域約束）

- **Kicker**: 08 · Cross-Paper Principle 2
- **Title**: 跨論文共通法則二：結構化 Schema 與人工約束勝過盲目自動
- **Core Takeaway**: 四篇論文一致證明，明確鎖定輸出格式與注入領域專家約束，是壓低錯誤率與超越全自動黑箱優化的真正護城河。
- **Visual Spec (`cards` + `.stat-row`)**:
  - 3 張法則實證卡片（`.grid-3`）：
    - Card 1（primary）：**輸出 Schema 強制鎖定** — 吳葦誠規定 `評分:/評估:`（格式重試率僅 0.16%–0.18%）；吳承光用四欄位 JSON `ZS-DRCoT`；戚得郁以 Ollama `T=0` ＋ `{"label": int}` 杜絕多餘廢話。
    - Card 2（teal）：**人工領域約束 ＞ 全自動黑箱** — 戚得郁實測人工寫好三規則（統一前綴、字數、去重）引導 GPT-4o 產標籤（AG News `0.836`），狠甩全自動 APE（`0.693`）達 14.3 個百分點。
    - Card 3（amber）：**工程預設值不可盲信** — 陳冠錞證明語意快取閾值不能放著預設不動；吳葦誠證明 `overlap=0` 反勝常見預設 `overlap=100`（Top-1 +10%）。
  - Stat Row：`0.16%`（Breeze 格式重試率）｜`+14.3 pp`（人工約束標籤勝全自動 APE）｜`+10.3 pp`（`overlap=0` 勝 `overlap=100`）
- **Citations**: `wiki/topics/domain-specific-llm-adaptation.md` (§3), `wiki/papers/2025-chi-*.md` (§3.2), `wiki/papers/2024-wu-*.md` (§3.1–3.2)
- **Speaker Notes**: 第二條貫穿全館的工程鐵律是：別迷信「全自動」或「預設參數」。不管是在哪一層，只要明確鎖定 JSON 或評分 Schema，小模型也能表現得非常穩定；更關鍵的是，在戚得郁的實驗中，人為寫出清楚約束再交給 GPT-4o 產標籤，竟然大勝全自動 APE 超過 14 個百分點；在吳葦誠的實驗中，把大家習慣開著的 chunk overlap 關成 0 反而贏了 10 個百分點。這些都是只靠直覺想不到、必須靠嚴謹消融才會發現的工程真相。下一頁我們把四篇的「批判盲區」一次攤開來複盤。
