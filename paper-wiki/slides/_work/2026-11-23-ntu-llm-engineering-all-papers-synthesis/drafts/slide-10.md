# Slide 10 — 跨論文批判總複盤（Critical Reading）

- **Kicker**: 09 · Cross-Paper Critical Review
- **Title**: 批判性閱讀總複盤：四篇論文各自藏著哪些陷阱與盲區？
- **Core Takeaway**: 讀論文不能只背亮眼數字——四篇各自暴露了 Prompt 漏審、高歧義負遷移、規格漏標與壓測無負例等實務落地必檢陷阱。
- **Visual Spec (`cards` + `.stat-row`)**:
  - 2×2 四篇批判卡片（`.grid-2`）：
    - Card 1（primary）：**吳葦誠 (2024) — 審查漏看 Answer** — Appendix Groundedness Prompt 只餵 `Q + Context` 未審 `Answer`；加拒答樣本讓正例 F1 從 `0.556` 掉到 `0.418`；缺摘要所稱人工幻覺評分表。
    - Card 2（teal）：**吳承光 (2024) — 負遷移與即時標籤假設** — 「呼吸困難」主訴下 `ZS-DRCoT` 反而倒退 `-2.20%`（Llama3 `-10.5%`）；記憶寫入假設每次看診結束都能立刻拿到黃金標籤 `fb_t`。
    - Card 3（amber）：**戚得郁 (2025) — 邊際效益與規格缺漏** — Stage 2 自訓練僅微增 `+0.3%`～`+1.3%`；Table 5.19 缺本地 LLM 參數量、量化後綴與實測延遲；`Building→Village` 誤判 3,599 筆。
    - Card 4（rose）：**陳冠錞 (2025) — 壓測無負例與文表勘誤** — QQP 壓測 100% 為重複問句且未量答錯率（False Positive）；摘要將 `105.1 kJ` 誤寫成 `0.95`（實測表為 `0.85`）；未算每請求焦耳數。
  - Stat Row：`-2.20%`（呼吸困難 CoT 負遷移）｜`+0.3%`（DBpedia Stage 2 邊際效益）｜`100% 重複`（QQP 壓測缺負例與正確率）
- **Citations**: 四篇 `wiki/papers/*.md` (§5 批判性閱讀觀察)
- **Speaker Notes**: 作為教學與讀書會，這頁是我最希望大家帶走的「批判性肌肉」。每一篇優秀論文在工程復現時都有暗礁：復現吳葦誠時，記得把 Answer 加進 Groundedness Prompt 防幻覺；套用吳承光時，要注意高歧義問題可能引發思維鏈錨定負遷移，而且門診不會當場給你標準答案；導入戚得郁時，MVP 先做剪枝加 GPT 標籤就拿九成紅利；落地陳冠錞時，一定要補上非重複負例與答錯率監控，才不會省了電卻答非所問。那如果把這四篇的優點合體、彼此補齊短板，會長成什麼系統？看下一頁。
