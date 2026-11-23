---
type: concept
title: "Diagnostic-Reasoning CoT (ZS-DRCoT) & Shared Streaming Memory"
aliases: ["ZS-DRCoT", "Multi-Agent Shared Memory", "StreamICL"]
tags: [cot, diagnostic-reasoning, zero-shot, shared-memory, multi-agent, streaming-icl]
sources_count: 1
updated: 2026-11-23
---

# 醫師診斷思維鏈（ZS-DRCoT）與多代理共享記憶

> **一句話直覺**：不微調模型權重，而是先用 **JSON 欄位把醫師看診腦中的「陽性表現 → 陰性表現 → 鑑別診斷 → 下一題」強制結構化**，再讓多款模型輪流看診並把**答對的推理筆記存進共享錯題本／經驗庫**，越看診越準。

---

## 1. 技術演進：從 Few-Shot DR-CoT 到 Zero-Shot JSON `ZS-DRCoT`
1. **Few-Shot DR-CoT**：在多輪醫病對話範例中插入三步中間推理 $r_i$，可將問診診斷準確率提升 `+15.5%`～`+21.5%`，但由醫師撰寫完整多輪對話範例過於昂貴且推論 Token 膨脹。
2. **Zero-Shot `ZS-DRCoT`**（[吳承光, 2024](../papers/2024-wu-ck-llm-diagnostic-reasoning.md)）：完全免範例，直接在 Prompt 指定 JSON Schema 強制模型每輪依序填寫：
   - `positive_clinical_findings`（已確認陽性症狀 — 消融顯示移除會掉 `-7.67%`，最關鍵）
   - `negative_clinical_findings`（已排除陰性症狀 — 移除平均掉 `-2.00%`）
   - `ranked_differential_diagnosis`（排序鑑別診斷 — 移除掉 `-4.67%`）
   - `question_to_ask`（依據上述鑑別診斷提出下一題）

---

## 2. 串流共享記憶與 Round-Robin $O(1)$ 多代理演算法
為解決傳統多代理辯論／投票推論成本高達 $O(K)$ 的問題，[吳承光 (2024)](../papers/2024-wu-ck-llm-diagnostic-reasoning.md) 設計 Algorithm 1：
- **輪詢排程（Round-Robin）**：第 $t$ 位病人只派 1 個代理 $k = t \bmod K$ 推論（維持 **$O(1)$ 成本**）。
- **檢索歷史經驗**：以 `BAAI/bge-base-en-v1.5` 編碼當前病歷 $x_t$，從共享向量記憶庫 $\mathcal{M}_{t-1}$ 撈出相似過往病例 $(x, \hat{r}, \hat{y})$ 作為動態 In-Context Examples。
- **正確性過濾寫入**：僅當臨床回饋 $fb_t = 1$（預測正確）時才將 $(x_t, \hat{r}_t, \hat{y}_t)$ 寫入共享記憶庫，避免錯誤推理污染後續檢索。

---

## 3. 優缺點與工程限制
- **優點**：完全免微調即可在 [DDXPlus](../benchmarks/ddxplus.md) 上從 `52.85%` 飆升至 **`90.48%`**；推論成本不隨代理數量線性增加。
- **限制**：高複雜主訴（如呼吸困難）可能因過早鎖定錯誤鑑別診斷而出現負遷移（`-2.20%`）；串流更新高度仰賴即時正確回饋 $fb_t$ 與記憶庫長期維護機制。

---

## 4. 引用與實踐此概念的論文
- [吳承光 (2024) 大型語言模型進行醫療診斷推理](../papers/2024-wu-ck-llm-diagnostic-reasoning.md) — 完整提出並於 DDXPlus 驗證 `DR-CoT`、`ZS-DRCoT` 與 Round-Robin Multi-Agent Memory。

## 相關頁面
- 跨論文概念：[異質多模型協作與互補效應](./heterogeneous-multi-llm-collaboration.md)
- 主題綜述：[封閉領域知識導入 LLM 路線總覽](../topics/domain-specific-llm-adaptation.md)
- 相關基準：[DDXPlus](../benchmarks/ddxplus.md)
