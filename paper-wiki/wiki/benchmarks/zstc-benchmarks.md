---
type: benchmark
title: "Zero-Shot Topic Classification Benchmarks (AG News, Yahoo Answers, DBpedia)"
aliases: ["AG News", "Yahoo Answers", "DBpedia-14", "ZSTC Benchmarks"]
tags: [benchmark, topic-classification, zero-shot, ag-news, yahoo-answers, dbpedia]
sources_count: 1
updated: 2026-11-23
---

# 零樣本主題分類基準總表（AG News / Yahoo Answers / DBpedia）

> **簡介**：開放領域零樣本主題分類（ZSTC）最經典的三大英文基準測試集，常同時用來評估輕量編碼器（BERT/SBERT）與大型語言模型（LLM）在無標註條件下的語意分類能力。

---

## 1. 三大資料集規格（Chi, 2025 Ch.4.2）

| 資料集 | 測試集筆數 | 類別數 | 文本型態 | Chi (2025) 標籤前處理細節 |
| :--- | :---: | :---: | :--- | :--- |
| **AG News** | 7,600 | 4 | 新聞標題與簡介 | `Sci/Tech` 拆為 `Science` 與 `Technology` 兩類匹配後映回 |
| **Yahoo! Answers** | 60,000 | 10 | 問答社群提問與回答 | 含 `&` 之複合類別拆為雙標籤匹配後映回原類別 |
| **DBpedia (`dbpedia_14`)** | 70,000 | 14 | 維基百科實體摘要 | 駝峰詞拆分空白（如 `EducationInstitution` → `Education institution`） |

---

## 2. 評估注意事項與常見陷阱（Pitfalls）
- **是否接觸目標無標註文本（True Zero-Shot vs. Transductive Self-Training）**：如 Gera et al. (2022) 會用目標資料集測試／訓練原文做偽標籤自訓練（DBpedia 可達 `0.945`），而 WC-SBERT（Chi, 2025）完全不碰目標文本、僅取維基百科輔助自訓練。比較時須標明是否為純零樣本。
- **LLM 規格透明度**：本地量化 LLM 受參數量、量化格式（`q4_0` vs `q4_K_M`）與結構化輸出限制影響大，對照時須確認設定（Chi, 2025 採 Ollama `temperature=0` + JSON integer schema，但未在 Table 5.19 詳列具體量化版本與參數大小）。

---

## 3. 跨方法與跨模型實驗對照表（Accuracy，來源：[Chi, 2025](../papers/2025-chi-zero-shot-topic-classification.md)）

| 方法／模型 | 類型與關鍵實驗條件 | AG News | Yahoo Answers | DBpedia |
| :--- | :--- | :---: | :---: | :---: |
| BERT Fully Finetuned *(Ding et al., 2022)* | 全監督上限（需完整標註集） | *0.944* | *0.753* | *0.993* |
| SBERT (Triplet) + 1NN *(Chi, 2025)* | 全監督基準（`all-mpnet-base-v2`, FP16） | *0.935* | *0.695* | *0.988* |
| Word2Vec *(Ding et al., 2022)* | 全監督下限（靜態詞向量） | *0.711* | *0.357* | *0.697* |
| Ding et al. (2022) | 維基預訓練 BERT 零樣本分類器 | 0.796 | 0.573 | 0.902 |
| Gera et al. (2022) | 目標集多輪迭代自訓練（接觸目標原文） | 0.814 | 0.620 | **0.945** |
| Chi & Jang (2024, ACM TIST) | 原版 WC-SBERT（多輪自訓練 + Online Contrastive） | 0.840 | 0.638 | 0.881 |
| **WC-SBERT (Chi, 2025 最終版)** | 剪枝預訓練 ＋ GPT-4o 標籤 ＋ 單階段 MNR（免目標原文） | **0.847** | 0.649 | 0.886 |
| **Gemma 2**（Zero-shot / Few-shot） | Ollama 本地量化 LLM（`T=0`, JSON format） | 0.817 / 0.832 | **0.659** / 0.654 | 0.903 / **0.915** |
| GPT-4o mini（Zero-shot / Few-shot） | API / 統一 Prompt（`T=0`, JSON format） | 0.574 / 0.655 | 0.453 / 0.509 | 0.765 / 0.841 |
| Llama 3.1（Zero-shot / Few-shot） | Ollama 本地量化 LLM（`T=0`, JSON format） | 0.673 / 0.680 | 0.528 / 0.572 | 0.707 / 0.761 |
| Llama 3.2（Zero-shot / Few-shot） | Ollama 本地量化 LLM（`T=0`, JSON format） | 0.532 / 0.601 | 0.425 / 0.461 | 0.592 / 0.649 |

---

## 相關頁面
- 收錄論文：[戚得郁 (2025) 零樣本主題分類：BERT 與 LLM 比較](../papers/2025-chi-zero-shot-topic-classification.md)
- 核心概念：[WC-SBERT、類別剪枝與描述性標籤增強](../concepts/wc-sbert-and-label-augmentation.md)
- 主題綜述：[LLM 推論效率、量化部署與綠能權衡](../topics/llm-inference-efficiency-and-deployment.md)
