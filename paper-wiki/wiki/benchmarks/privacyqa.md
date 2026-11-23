---
type: benchmark
title: "PrivacyQA"
aliases: []
tags: [benchmark, legal, privacy-policy, qa]
sources_count: 1
updated: 2026-11-23
---

# PrivacyQA

> **簡介**：由 Ravichander et al. (2019) 建構的隱私權政策問答資料集，結合計算語言學與法律視角，評估模型針對行動應用程式隱私政策條文（`text`）回答使用者隱私問題（`question`）與判斷相關性（`Relevant` / `Irrelevant`）的能力。

---

## 1. 資料集結構與任務特性
- **原始格式**（參見 [Wu (2024)](../papers/2024-wu-llm-finetune-dataset-from-unstructured-data.md) Appendix Fig. A.6）：
  - `question`：使用者對隱私政策的疑問（例如 *"will my personal details be shared with third party companies?"*）
  - `text`：隱私權政策條文段落
  - `answer`：標註該條文是否能回答該問題（如 `Relevant`）
- **Wu (2024) 使用的切分規模（Table 4.1）**：Train `10,923` 筆、Test `10,923` 筆（註：Table 4.1 顯示 Train 與 Test 筆數完全相同，實務引用時需留意原始論文是否誤植或採用特定抽樣切分）。

---

## 2. 評估注意事項與常見陷阱（Pitfalls）
- **法律條文長距與歧義**：隱私權政策常使用模糊免責措辭，模型容易過度推論或遺漏例外條款。
- **檢索條件對齊**：與 [PubMedQA](./pubmedqa.md) 相同，評估時必須清楚區分「直接給定候選條文」與「從資料庫檢索條文（RAG）」兩種設定，方能公平比較不同領域適應方法。

---

## 3. 跨論文實驗結果對照表

| 論文 | 模型／方法 | 關鍵實驗條件 | F1 Score | 備註 |
| :--- | :--- | :--- | :---: | :--- |
| [Wu (2024)](../papers/2024-wu-llm-finetune-dataset-from-unstructured-data.md) *(轉引)* | TAPT (Gururangan et al., 2020) | 依 Wu (2024) Table 4.10 報告（Llama-2 基準對照） | 42.0 | Continuous Pre-training 路線 |
| [Wu (2024)](../papers/2024-wu-llm-finetune-dataset-from-unstructured-data.md) *(轉引)* | Bonito (Nayak et al., 2024) | 依 Wu (2024) Table 4.10 報告（Llama-2 基準對照） | 56.9 | 需額外訓練生成器模型 |
| [Wu (2024)](../papers/2024-wu-llm-finetune-dataset-from-unstructured-data.md) | **Generator–Critique + RAFT + RAG** | Llama-2 + 英文 Prompt；將文本入庫做合成微調與 RAG 推論；Table 4.1 標示 Train/Test 皆為 10,923 | **66.3** | 勝過 Bonito (+9.4) 與 TAPT (+24.3) |

---

## 相關頁面
- 收錄論文：[Wu (2024) 基於 LLM 自非結構化文件建立微調資料集](../papers/2024-wu-llm-finetune-dataset-from-unstructured-data.md)
- 相關基準：[PubMedQA](./pubmedqa.md)
- 主題綜述：[封閉領域知識導入 LLM 路線總覽](../topics/domain-specific-llm-adaptation.md)
