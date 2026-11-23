---
type: benchmark
title: "PubMedQA"
aliases: ["MedPubQA (Wu 2024 表格筆誤)"]
tags: [benchmark, biomedical, qa, yes-no]
sources_count: 1
updated: 2026-11-23
---

# PubMedQA

> **簡介**：由 Jin et al. (EMNLP-IJCNLP 2019) 建立的生醫研究問答資料集，問題來自 PubMed 論文標題，目標是根據論文摘要上下文（`CONTEXTS`）回答 `yes` / `no` / `maybe`（並附帶 `LONG_ANSWER`）。

---

## 1. 資料集結構與任務特性
- **原始格式**（參見 [Wu (2024)](../papers/2024-wu-llm-finetune-dataset-from-unstructured-data.md) Appendix Fig. A.5）：
  - `QUESTION`：生醫研究問題（例如 *"Are group 2 innate lymphoid cells (ILC2s) increased in chronic rhinosinusitis with nasal polyps or eosinophilia?"*）
  - `CONTEXTS`：多段論文摘要文字（背景、方法、結果）
  - `LONG_ANSWER`：完整結論句
  - `final_decision`：`yes` / `no` / `maybe`
- **Wu (2024) 使用的切分規模（Table 4.1）**：Train `211,269` 筆、Test `10,563` 筆，聚焦於 Yes/No 判斷並以 F1 Score 評估。

---

## 2. 評估注意事項與常見陷阱（Pitfalls）
> [!WARNING]
> **開書（含 Context / RAG）vs. 閉書（無 Context）不可直接比較！**
> PubMedQA 的問題幾乎完全依賴論文摘要中的統計結果才能作答。若方法 A 在推論時透過 RAG 取回對應的 `CONTEXTS`（近似開書考），而基準方法 B 並未在同等檢索條件下評估，F1 分數會出現懸殊落差。

- **標籤空間差異**：需確認各論文是做 3 類（`yes/no/maybe`）還是只做 2 類（`yes/no`），以及測試集究竟使用經典的 PQA-L（1,000 筆專家標註）還是大規模子集（如 PQA-A / PQA-U）。

---

## 3. 跨論文實驗結果對照表

| 論文 | 模型／方法 | 關鍵實驗條件 | F1 Score | 備註 |
| :--- | :--- | :--- | :---: | :--- |
| [Wu (2024)](../papers/2024-wu-llm-finetune-dataset-from-unstructured-data.md) *(轉引)* | TAPT (Gururangan et al., 2020) | 依 Wu (2024) Table 4.10 報告（Llama-2 基準對照，Yes/No） | 25.1 | 未明列推論期是否搭配 RAG 檢索 |
| [Wu (2024)](../papers/2024-wu-llm-finetune-dataset-from-unstructured-data.md) *(轉引)* | Bonito (Nayak et al., 2024) | 依 Wu (2024) Table 4.10 報告（Llama-2 基準對照，Yes/No） | 27.0 | Conditional Task Generation 合成微調集 |
| [Wu (2024)](../papers/2024-wu-llm-finetune-dataset-from-unstructured-data.md) | **Generator–Critique + RAFT + RAG** | Llama-2 + 英文 Prompt；將 `CONTEXTS` 存入向量庫做合成微調與 RAG 推論；Train 211,269 / Test 10,563；Yes/No | **95.6** | ⚠️ Table 4.10 誤拼為 `MedPubQA`；與 TAPT/Bonito 差距極大，推論是否皆處於同等 RAG 條件待查證 |

---

## 相關頁面
- 收錄論文：[Wu (2024) 基於 LLM 自非結構化文件建立微調資料集](../papers/2024-wu-llm-finetune-dataset-from-unstructured-data.md)
- 相關基準：[PrivacyQA](./privacyqa.md)
- 主題綜述：[封閉領域知識導入 LLM 路線總覽](../topics/domain-specific-llm-adaptation.md)
