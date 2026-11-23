---
type: concept
title: "WC-SBERT, Category Pruning & Descriptive Label Augmentation"
aliases: ["WC-SBERT", "Wikipedia Category Pruning", "Descriptive Label Augmentation", "MNR Loss Self-Training"]
tags: [wc-sbert, sbert, zero-shot-classification, label-augmentation, ape, self-training, mnr-loss]
sources_count: 1
updated: 2026-11-23
---

# WC-SBERT、類別剪枝與描述性標籤增強

> **一句話直覺**：讓輕量 Sentence-BERT（`all-mpnet-base-v2`）透過「**洗掉長尾雜訊的維基百科類別圖譜**」學會主題語意，再用 **GPT-4o 把乾癟的單字標籤擴寫成結構一致的完整句**，不碰目標測試集原文就能逼近甚至超越本地量化 LLM。

---

## 1. 三大核心工程支柱（Chi, 2025）

### 支柱一：Wikipedia 類別共現圖 ＋ Degree-based Pruning
- **基本假設**：出現在同一篇維基條目下的多個類別（如 `Basketball` 與 `Team sports`）語意高度相關，兩兩配對即可用 **MNR Loss** 訓練主題對比空間。
- **為何必須剪枝（Long-tail Mitigation）**：原始 156 萬維基類別呈典型 Zipf 長尾（最大度數 `1,013,030`），充斥無主題意義的編務標籤（如 `Use British English`）。
- **分層抽樣剪枝規則**：低頻（$d < 5$）抽 **20%**、中頻（$5 \le d \le 500$）**全保留**、高頻（$d > 500$）抽 **2%** → 語意覆蓋率維持 `0.9910`，但 AG News 零樣本準確率直接跳升 **`+7.8%`**（`0.695 → 0.749`）。

### 支柱二：GPT-4o 描述性標籤增強 vs. AutoPrompt（APE）
- **痛點**：Bi-Encoder（SBERT）將單字標籤（如 `Artist`、`Building`）直接編碼時容易與鄰近語意重疊（如 `Album`、`Village`）。
- **人工引導 GPT-4o 標籤設計關鍵**（[Chi, 2025](../papers/2025-chi-zero-shot-topic-classification.md) Appendix A.1）：
  1. 強制所有類別使用**一致句型前綴**（如 `"This news article reports on ..."`），降低風格雜訊；
  2. 限制 15–30 字、客觀學術語氣，且明確要求**類別間不可重複關鍵措辭**以拉開嵌入距離；
  3. 實測 DBpedia 準確率由手寫模板 `0.718` 暴衝至 **`0.883`（+23.0%）**！
- **為何全自動 APE 慘敗（AG News `0.693` vs. GPT 引導 `0.836`）**：APE 缺乏句型與目標語意約束，容易優化成抽象百科定義且各類句式不一，反而破壞嵌入空間穩定度。

### 支柱三：免接觸目標原文的單階段 MNR Loss 自訓練
- 預先用 Pre-trained WC-SBERT 編碼全部 645 萬篇 Wiki 摘要存成 `.npy`（跨任務重用）。
- 針對新任務，計算所有 Wiki 摘要與目標標籤的 Cosine Similarity，只取超過閾值 $t$ 的頁面，單次建立三元組 `(Anchor=Wiki 類別, Pos=最相似標籤, Hard Neg=最不相似標籤)` 以 MNR Loss 微調 3 epochs，徹底取代會累積錯誤的多輪迭代自訓練。

---

## 2. 優缺點與適用場景
- **優點**：真正符合零樣本（不需取得目標資料集無標註文本）；推論極快（僅需一次向量內積），在 [AG News / Yahoo / DBpedia](../benchmarks/zstc-benchmarks.md) 展現不輸甚至勝過本地量化 LLM 的穩定精度。
- **缺點**：Stage 2 閾值 $t$（0.75–0.77）仍需人工設定且邊際增益較小（+0.3%～+1.3%）；面對高度交織上下文（如 `Building` vs `Village`）仍有 Bi-Encoder 邊界混淆問題。

---

## 3. 引用與實踐此概念的論文
- [戚得郁 (2025) 零樣本主題分類：BERT 模型與 LLM 比較](../papers/2025-chi-zero-shot-topic-classification.md) — 完整提出剪枝策略、GPT-4o 描述性標籤、APE 對比與單階段 MNR 自訓練。

## 相關頁面
- 主題綜述：[LLM 推論效率、量化部署與綠能權衡](../topics/llm-inference-efficiency-and-deployment.md)、[封閉領域知識導入 LLM 路線總覽](../topics/domain-specific-llm-adaptation.md)
- 公開基準：[零樣本主題分類基準總表](../benchmarks/zstc-benchmarks.md)
- 相關簡報：[零樣本主題分類：WC-SBERT vs. 本地量化 LLM（教學型 HTML 投影片）](../../slides/2026-11-23-zero-shot-topic-classification-wc-sbert-vs-llm.html)
