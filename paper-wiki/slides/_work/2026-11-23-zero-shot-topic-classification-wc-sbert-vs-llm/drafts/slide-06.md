# Slide 06 — 教學核心三（Label Augmentation vs. APE）

- **Kicker**: 05 · 教學支柱二：描述性標籤設計課
- **Title**: 為什麼「人工引導 GPT-4o 標籤」大勝全自動 APE？
- **Core Takeaway**: 強制一致句型前綴與跨類語意區隔讓 DBpedia 暴增 +23%；全自動 APE 寫成泛百科定義反而讓 AG News 掉到 0.693。
- **Core Bullets (3 條設計原則)**:
  - **規則① 一致句型前綴**：所有類別共用相同開頭（如 `"This news article reports on ..."`），消除表層風格雜訊。
  - **規則② 精準長度與語氣**：控制 15–30 字、客觀學術語氣，避免發散成冗長百科定義。
  - **規則③ 跨類禁止重複用字**：拉開鄰近類別的向量距離，緩解 `Building / Village`、`Artist / Album` 混淆。
- **Visual Spec (`table`)**:
  - 4 列標籤策略比較表（`<table>`）：
    - 欄位：`標籤策略`｜`範例寫法（以 AG News World 為例）`｜`AG News Acc`｜`DBpedia Acc`｜`成敗關鍵`
    - Row 1：`單字標籤 (Label Only)`｜`"World"`｜`0.749`｜`0.614`｜語意單薄、跨類重疊嚴重
    - Row 2：`手寫統一模板`｜`"This news article is about World"`｜`0.813`｜`0.718`｜有情境前綴但仍缺關鍵語意詞
    - Row 3：`全自動 APE (T=0.8, 5步)`｜`"World is a term that encompasses the entire planet Earth..."`｜**`0.693`**（掉點）｜—｜抽象百科風且各類句式不一，破壞嵌入空間
    - Row 4：**`GPT-4o 人工引導`**｜`"This news article reports on global news, international developments..."`｜**`0.836`**｜**`0.883`**｜前綴一致＋語意豐富＋跨類去重
- **Citations**: `wiki/papers/2025-chi-zero-shot-topic-classification.md` (§3.2 & §4.1, Table 5.13/5.16), `wiki/concepts/wc-sbert-and-label-augmentation.md` (§1)
- **Speaker Notes**: 這一頁是整篇論文最反直覺、也最有實務價值的一課。很多人以為交給 AutoPrompt（APE）讓 GPT-4o 自己多輪排名生成會比人寫的好，結果在 AG News 上 APE 只拿了 0.693，甚至比原本光禿禿的單字標籤 0.749 還慘！原因就在表格第三列：APE 沒有限制句型與目標分布，寫出來的都是「世界是指整個地球」這種抽象百科定義，每個類別語氣都不一樣，直接把 Bi-Encoder 的向量空間打亂。只要加上三條明確約束，準確率馬上飆升到 0.836 與 DBpedia 0.883。那有了好標籤後，Stage 2 又是怎麼做到不碰目標原文自訓練的呢？
