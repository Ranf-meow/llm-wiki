# Slide 06 — Step 3 Critique LLM 四維度審查

- **Kicker**: `05 · Step 3 — LLM-as-a-Judge`
- **Title**: `Critique LLM：四維度品質審查與強制格式`
- **Core Bullets**:
  - 雙重過濾門檻：四項各 1–5 分，須**每項 ≥ 3 且總分 ≥ 13 / 20** 才算 `Good Quality`。
  - 強制輸出 `評分:` ＋ `評估:`（解析失敗自動重試），重試錯誤率僅 Breeze **0.161%**（3.26s）、TAIDE **0.176%**（4.28s）。
- **Visual Spec (`grid-4` + 2 Callouts)**:
  - 4 張等寬指標卡：
    1. `Groundedness`：能否依內文毫不含糊回答
    2. `Relevance`：是否像真實病患問診提問
    3. `Standalone`：問題獨立可懂；含「在內文中」強制 **1 分**
    4. `Similarity`：淘汰複述題目當答案的假回覆
  - 底部雙欄 Callout：雙重門檻 vs 格式重試率（Table 4.5）。
- **Citations**: `wiki/concepts/llm-synthetic-qa-critique-pipeline.md`, `wiki/papers/2024-wu-llm-finetune-dataset-from-unstructured-data.md` (Sec. 4.2.3, Table 4.5, App. A.1.2)
- **Speaker Notes**: `進入最關鍵的過濾關卡。四個指標同時卡單項底線與總分，防止單一高分掩蓋缺陷；尤其 Standalone 寫死「出現『在內文中』就給 1 分」是非常值得抄進專案的規則。有趣的是，同一份審查 Prompt 交給不同模型跑，嚴格度竟差了兩倍以上——我們看下一頁的實測數據。`
