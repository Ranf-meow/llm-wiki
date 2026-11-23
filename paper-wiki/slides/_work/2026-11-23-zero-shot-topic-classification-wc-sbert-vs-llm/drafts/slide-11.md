# Slide 11 — 總結、決策清單與討論題（Takeaways & Q&A）

- **Kicker**: 10 · 工程選型清單與讀書會討論
- **Title**: 實務落地決策指南與三道延伸思辨題
- **Core Takeaway**: 依流量規模與語意複雜度靈活選擇 WC-SBERT、Gemma 2 或混合路由，並帶著三個核心問題進入讀書會討論。
- **Core Bullets (左右雙欄：左欄 3 條落地決策清單，右欄 3 題讀書會討論題)**:
  - **左欄 — 工程選型 Checklist（`.card.teal`）**：
    - **高吞吐 / 低預算 / 結構化分類** → 優先用 **WC-SBERT ＋ GPT-4o 描述性標籤**（毫秒級內積推論，不需跑生成式 LLM）。
    - **細粒度複雜語意 / 算力充裕** → 選用 **Gemma 2 本地量化**（搭配 `T=0` + JSON Schema 鎖定輸出格式，避開過度量化的極小模型）。
    - **兼顧精度與成本的未來架構** → **Hybrid Routing**：以 WC-SBERT 計算 Top-1 與 Top-2 相似度 Margin，高信心秒回、僅低信心樣本交由 LLM 複核。
  - **右欄 — 讀書會討論題（`.card.primary`）**：
    - **Q1**：為何缺乏目標分布錨定的全自動 APE（0.693）會慘敗給人工引導 GPT-4o 標籤（0.836）？
    - **Q2**：若用 WC-SBERT 相似度 Margin 做分流路由給 Gemma 2，能同時兼顧 90%+ 準確率與毫秒級延遲嗎？
    - **Q3**：`Building` 3,599 筆誤分為 `Village`，揭露了 Bi-Encoder 向量池化的什麼本質限制？
- **Visual Spec (`checklist` + `.stat-row`)**:
  - 上方 3 枚帶走關鍵數字（`.stat-row`）：`+7.8%`（維基度數剪枝增益）、`+23.0%`（GPT-4o 標籤於 DBpedia 相對躍升）、`0.847`（AG News 輕量編碼器奪冠）。
  - 下方 2 欄卡片（`.grid-2`）：左欄實務選型清單、右欄三道讀書會討論題。
- **Citations**: `wiki/papers/2025-chi-zero-shot-topic-classification.md` (§6), `wiki/topics/llm-inference-efficiency-and-deployment.md` (§1–3)
- **Speaker Notes**: 最後用一分鐘幫大家做總結：今天帶走三個數字——度數剪枝 +7.8%、GPT-4o 描述性標籤讓 DBpedia 相對暴增 +23%、以及輕量 WC-SBERT 在 AG News 以 0.847 奪冠。面對實務專案，記得「殺雞不用牛刀」：先用輕量編碼器加好標籤吃下高流量請求，把昂貴的 LLM 留給低信心邊界樣本做複核。接下來把時間交給大家，我們可以從右邊這三道討論題開始交流！
