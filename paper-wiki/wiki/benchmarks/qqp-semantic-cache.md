---
type: benchmark
title: "QQP Semantic Caching Workload"
aliases: ["Quora Question Pairs", "QQP Cache Benchmark"]
tags: [benchmark, semantic-caching, qqp, energy-consumption, latency]
sources_count: 1
updated: 2026-11-23
---

# QQP 語意快取壓測基準（Quora Question Pairs）

> **簡介**：Quora Question Pairs（QQP）原為人工標註「兩句提問是否語意重複（`is_duplicate ∈ {0, 1}`）」之語意比對資料集；在 [陳冠錞 (2025)](../papers/2025-chen-semantic-caching-energy-tradeoff.md) 中被改作語意快取系統的壓測負載，以模擬 FAQ 類型的改寫重複提問。

---

## 1. 實驗負載設定與關鍵陷阱（Pitfalls）
- **取樣規模**：挑選 `30,141` 組標記為 **`is_duplicate = 1`** 的重複問句對（例：`"What are some ways to hack a Facebook account?"` 與 `"How can we hack fb?"`）。
- **壓測工具**：`k6` 執行 10 分鐘漸增虛擬使用者（VUs）負載，每組設定重複跑 5 次並每次銷毀重建 K8s 資源。

> [!WARNING]
> **無負例（No Non-Duplicate Queries）與無正確率評估盲區**：因壓測集 100% 皆為語意重複題且未量測快取回覆正確率（False Positive Rate），低閾值（`0.70–0.75`）測得的 `99.99%` 命中率屬於理想上限；在真實混合流量下，須同時監控誤命中率與非重複流量的實際能耗反轉點。

---

## 2. 跨設定壓測對照表（GKE 單節點 T4 + Ollama 4-bit Mistral-7B + GPTCache + pgvector）

| 論文 | 相似度閾值 | Hit Rate | 平均延遲 (ms) | 總平均功率 (W) | 10 分鐘總能耗 (J) | 備註 |
| :--- | :---: | :---: | :---: | :---: | :---: | :--- |
| [陳冠錞 (2025)](../papers/2025-chen-semantic-caching-energy-tradeoff.md) | 無快取 Baseline | N/A | 30,294.1 | 155.88 | 93,256.2 | 直送 Ollama |
| [陳冠錞 (2025)](../papers/2025-chen-semantic-caching-energy-tradeoff.md) | `0.70` | 99.99% | **105.4** | 88.78 | 53,269.8 | 省電 42.9% |
| [陳冠錞 (2025)](../papers/2025-chen-semantic-caching-energy-tradeoff.md) | **`0.75`** | **99.99%** | 108.2 | **87.48** | **52,486.8** | **最佳節能（-43.7%）** |
| [陳冠錞 (2025)](../papers/2025-chen-semantic-caching-energy-tradeoff.md) | `0.80` | 99.30% | 177.1 | 122.48 | 73,488.6 | 僅跌 0.69% 命中即多耗 21 kJ |
| [陳冠錞 (2025)](../papers/2025-chen-semantic-caching-energy-tradeoff.md) | **`0.85`** | 87.30% | 4,634.7 | **175.22** | **105,130.2** | **效益反轉峰值（+12.7%）** |
| [陳冠錞 (2025)](../papers/2025-chen-semantic-caching-energy-tradeoff.md) | `0.90` | 54.90% | 19,638.8 | 174.50 | 104,702.4 | 寄生開銷 +12.3% |
| [陳冠錞 (2025)](../papers/2025-chen-semantic-caching-energy-tradeoff.md) | `0.95` | 29.40% | 29,035.7 | 172.40 | 103,441.2 | 寄生開銷 +10.9% |

---

## 相關頁面
- 收錄論文：[陳冠錞 (2025) LLM 推論中語意快取的能耗與效能權衡](../papers/2025-chen-semantic-caching-energy-tradeoff.md)
- 核心概念：[語意快取與效益反轉點](../concepts/semantic-caching-and-benefit-inversion.md)
- 主題綜述：[LLM 推論效率、量化部署與綠能權衡](../topics/llm-inference-efficiency-and-deployment.md)
