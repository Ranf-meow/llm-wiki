# Slide 01 — 封面（Cover）

- **Kicker**: NTU CSIE PhD Dissertation · 教學導讀
- **Title**: 零樣本主題分類：WC-SBERT vs. 本地量化 LLM
- **Subtitle**: 拆解戚得郁 (2025) 如何用維基類別圖譜與描述性標籤，讓輕量編碼器正面對決本地大型語言模型
- **Metadata Badges**:
  - 論文：Chi, Te-Yu (2025)｜DOI: `10.6342/NTU202504846`
  - 三大基準：AG News · Yahoo! Answers · DBpedia-14
  - 時長：20 分鐘｜共 11 頁｜教學與批判閱讀導向
- **Core Takeaway**: 以台大資工博士論文（Chi, 2025）為核心，從零拆解輕量編碼器如何與本地量化 LLM 正面對決。
- **Visual Spec (`cover`)**:
  - 封面主標題與副標＋3 枚關鍵指標卡片（`.stat-row`）：
    - `0.847`（AG News 奪冠｜超越所有受測 LLM）
    - `0 筆`（目標測試集原文｜真正純零樣本）
    - `+23.0%`（DBpedia 標籤增強｜GPT-4o 相對躍升）
- **Citations**: `wiki/papers/2025-chi-zero-shot-topic-classification.md`
- **Speaker Notes**: 大家好，今天用 20 分鐘帶大家精讀台大資工戚得郁 2025 年博士論文。這篇論文回答了一個非常務實的工程問題：在完全沒有標註資料的「零樣本主題分類」任務上，我們一定要搬出昂貴的 LLM 嗎？還是經過巧思優化的輕量 Sentence-BERT 反而更穩、更快、更省？我們先從這個問題為什麼棘手開始看起。
