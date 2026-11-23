---
type: benchmark
title: "DDXPlus"
aliases: ["DDXPlus Medical Diagnosis Dataset"]
tags: [benchmark, medical, history-taking, diagnosis, ddxplus]
sources_count: 1
updated: 2026-11-23
---

# DDXPlus

> **簡介**：由 Fansi Tchango et al. (NeurIPS 2022) 建立的大規模自動醫療診斷與問診資料集，包含約 **130 萬份合成病患病歷**（80%/10%/10% 切分），涵蓋 **223 種臨床表現**與 **49 種診斷**，每份病歷平均含 `13.56` 項臨床表現、主訴（Chief Complaint）與黃金診斷標籤。

---

## 1. 評估任務與注意事項（Pitfalls）
- **兩種評估設定不可混比**：
  1. **多輪問診資訊蒐集（Interactive History Taking）**：只給主訴，由 Doctor LLM 與 Patient LLM 互動（上限 8 輪）後預測診斷——準確率通常較低（`~20%–34%`）。
  2. **完整病歷診斷預測（Offline / Streaming Diagnosis Prediction）**：直接給完整臨床表現清單預測診斷——準確率較高（`~48%–90%`）。
- **合成規則限制**：資料由專有醫學知識庫機率分布合成並經醫師驗證，屬 49 類封閉診斷空間，尚未涵蓋真實電子病歷的自由文字噪聲與長尾罕病。

---

## 2. 跨論文實驗結果對照表

| 論文 | 設定與方法 | 關鍵實驗條件 | 準確率（Accuracy） | 備註 |
| :--- | :--- | :--- | :---: | :--- |
| [吳承光 (2024)](../papers/2024-wu-ck-llm-diagnostic-reasoning.md) | Few-Shot Baseline vs. **DR-CoT** | 互動問診（8 輪，ID 咳嗽主訴，`text-davinci-003`，$k=2$） | 18.0% → **33.5%** | OD1 `+18%`、OD2 `+14%` |
| [吳承光 (2024)](../papers/2024-wu-ck-llm-diagnostic-reasoning.md) | Zero-Shot Baseline vs. **ZS-DRCoT** | 互動問診（8 輪，49 類，5 模型平均：GPT-3.5/Gemini-1.0/Claude-3-Haiku/Mixtral-8x22B/Llama3-70B） | 19.63% → **25.10%** | 相對 `+28.39%`；呼吸困難主訴反降 `-2.20%` |
| [吳承光 (2024)](../papers/2024-wu-ck-llm-diagnostic-reasoning.md) | Non-streaming Baseline vs. **ZS-DRCoT** | 給定完整病歷，3 模型平均（GPT-3.5 / Gemini-1.0 / Claude-3-Haiku） | 52.85% → **58.20%** | 無記憶更新 |
| [吳承光 (2024)](../papers/2024-wu-ck-llm-diagnostic-reasoning.md) | Streaming `ZS-DRCoT` + Single-Agent Memory | 完整病歷串流，3 模型平均（`bge-base-en-v1.5`，僅答對寫入） | 80.27% | 單模型最高 Claude `84.98%` |
| [吳承光 (2024)](../papers/2024-wu-ck-llm-diagnostic-reasoning.md) | **Streaming `ZS-DRCoT` + Multi-Agent Memory** | 完整病歷串流，$K=3$ Round-Robin 共享記憶（$O(1)$ 成本） | **90.48%** | 假設即時正確性回饋 $fb_t \in \{0,1\}$ |

---

## 相關頁面
- 收錄論文：[吳承光 (2024) 大型語言模型進行醫療診斷推理](../papers/2024-wu-ck-llm-diagnostic-reasoning.md)
- 核心概念：[醫師診斷思維鏈與多代理共享記憶](../concepts/diagnostic-reasoning-cot-and-shared-memory.md)
- 主題綜述：[封閉領域知識導入 LLM 路線總覽](../topics/domain-specific-llm-adaptation.md)
