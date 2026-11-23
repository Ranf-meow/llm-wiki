# Paper LLM Wiki — 總目錄（Index）

> 本頁由 Agent 自動維護，作為所有檢索與導覽的起點。所有連結皆採用標準相對路徑 Markdown 格式。

## Topics（主題綜述與脈絡）

- [封閉領域知識導入 LLM 路線總覽](./topics/domain-specific-llm-adaptation.md) — 比較 TAPT、純 RAG、合成 SFT/Bonito、RAFT、免微調診斷思維鏈＋共享記憶與零樣本主題分類之工程取捨與脈絡圖（來源數：3｜標籤：domain-adaptation, rag, raft, medical-ai, zero-shot）
- [LLM 推論效率、量化部署與綠能權衡](./topics/llm-inference-efficiency-and-deployment.md) — 綜合討論輕量 Bi-Encoder（WC-SBERT）替代本地量化 LLM，以及語意快取（GPTCache）與效益反轉點之延遲與總能耗決策（來源數：2｜標籤：inference-efficiency, quantization, semantic-caching, green-ai）

## Papers（單篇論文導讀）

- [Wu, Wei-Cheng (2024) 基於大型語言模型自非結構化文件建立微調資料集](./papers/2024-wu-llm-finetune-dataset-from-unstructured-data.md) — 以繁中標點 Chunking、多角色 Generator/Critique 合成與過濾、及 RAFT+QLoRA 微調將台大醫院耳科 PDF 轉為專業問答系統（2024｜NTU CSIE Thesis｜synthetic-data, raft, chunking）
- [Wu, Cheng-Kuang (2024) 大型語言模型進行醫療診斷推理](./papers/2024-wu-ck-llm-diagnostic-reasoning.md) — 提出免微調三部曲（LLM 標準化病人模擬、ZS-DRCoT 臨床 JSON 模板、Round-Robin 異質多代理共享記憶），於 DDXPlus 將診斷準確率由 52.85% 推升至 90.48%（2024｜NTU CSIE Thesis｜diagnostic-reasoning, cot, shared-memory）
- [Chi, Te-Yu (2025) 零樣本主題分類：WC-SBERT vs. 本地量化 LLM](./papers/2025-chi-zero-shot-topic-classification.md) — 以維基類別度數剪枝、GPT-4o 指導式描述性標籤增強與免目標語料單階段 MNR 自訓練打造輕量 WC-SBERT，與 Ollama 本地量化 LLM 全面對決（2025｜NTU CSIE PhD Dissertation｜zero-shot, wc-sbert, local-llm）
- [Chen, Kuan-Chun (2025) 大型語言模型推論中語意快取的能耗與效能權衡](./papers/2025-chen-semantic-caching-energy-tradeoff.md) — 於 GKE（NVIDIA T4 + Ollama 4-bit Mistral-7B + GPTCache + pgvector）以 Kepler/DCGM 實測整機總能耗，揭露閾值 0.75 省電 43.7% 而 0.85 反耗電 +12.7% 的「效益反轉點」（2025｜NTU Civil Eng Thesis｜semantic-caching, green-ai, energy）

## Concepts（核心概念與方法）

- [RAFT（Retrieval Augmented Fine-Tuning）](./concepts/raft.md) — 以 80% 含正解＋干擾段落、20% 純干擾段落模擬開書考的微調範式，解決小模型單用 RAG 或微調效果不佳問題（來源數：1｜raft, rag, fine-tuning）
- [LLM 合成問答與 Critique 過濾管線](./concepts/llm-synthetic-qa-critique-pipeline.md) — 角色扮演產題/產答、關鍵字定向提問、四指標 LLM-as-a-Judge 過濾、異質模型分工與低品質轉拒答工程細節（來源數：1｜synthetic-data, prompt-engineering, llm-as-a-judge）
- [異質多模型協作與互補效應](./concepts/heterogeneous-multi-llm-collaboration.md) — 跨論文綜述 Wu, W.-C. (2024) 角色分工與 Wu, C.-K. (2024) Round-Robin 共享記憶，剖析為何異質模型互補遠勝同質多代理擴增（來源數：2｜multi-llm, heterogeneous, collaboration）
- [醫師診斷思維鏈與多代理共享記憶](./concepts/diagnostic-reasoning-cot-and-shared-memory.md) — 拆解臨床 DR-CoT / ZS-DRCoT JSON 結構、LLM 病人模擬與 Round-Robin 串流共享記憶演算法（來源數：1｜diagnostic-reasoning, cot, shared-memory）
- [WC-SBERT、類別剪枝與描述性標籤增強](./concepts/wc-sbert-and-label-augmentation.md) — 結合維基類別度數剪枝、GPT-4o 描述性標籤增強（勝全自動 APE）與免目標原文單階段 MNR 自訓練的零樣本主題分類方法（來源數：1｜wc-sbert, zero-shot, label-augmentation）
- [語意快取與效益反轉點（Benefit Inversion Point）](./concepts/semantic-caching-and-benefit-inversion.md) — 解析 GPTCache Hit/Miss 路徑、CPU 卸載省電原理與高閾值下「CPU 檢索＋GPU 推論」雙重懲罰機制（來源數：1｜semantic-caching, green-ai, energy-consumption）

## Benchmarks（資料集、指標與實驗對照）

- [PubMedQA](./benchmarks/pubmedqa.md) — 生醫研究摘要 Yes/No/Maybe 問答基準；收錄 Wu (2024) 與 TAPT/Bonito 之 F1 對照與開書公平性註記（來源數：1｜biomedical, qa）
- [PrivacyQA](./benchmarks/privacyqa.md) — 行動應用隱私權政策問答與相關性基準；收錄 Wu (2024) 與 TAPT/Bonito 之 F1 對照（來源數：1｜legal, qa）
- [DDXPlus](./benchmarks/ddxplus.md) — 合成臨床問診與鑑別診斷基準；收錄 Wu, C.-K. (2024) 單模型與 Round-Robin 異質共享記憶表現對照（來源數：1｜medical-diagnosis, differential-diagnosis）
- [ZSTC Benchmarks（AG News / Yahoo Answers / DBpedia）](./benchmarks/zstc-benchmarks.md) — 零樣本主題分類三大公開基準；收錄 Chi (2025) WC-SBERT 各消融階段與 Ollama 本地量化 LLM（Gemma 2 / Llama 3.1 / 3.2 / GPT-4o mini）對照表（來源數：1｜zero-shot, topic-classification）
- [QQP 語意快取壓測基準](./benchmarks/qqp-semantic-cache.md) — 改編自 Quora Question Pairs（30,141 組重複問句對）之語意快取壓測基準；收錄 Chen (2025) 於 GKE T4（閾值 0.70–0.95）之命中率、延遲與總能耗實測（來源數：1｜semantic-caching, energy-benchmark）

## Slides（讀書會與課堂簡報大綱）

- [LLM 合成問答與 Critique 過濾管線（互動式 HTML 投影片）](../slides/2026-11-23-llm-synthetic-qa-critique-pipeline.html) — 依 StateGraph（Map-Reduce + C3 靜態驗證 0 警示）製作之 11 頁離線簡報，視覺比例 90%，含完整中間檔與 QA 報告（2026-11-23｜synthetic-data, critique, raft）
- [零樣本主題分類：WC-SBERT vs. 本地量化 LLM（教學型互動 HTML 投影片）](../slides/2026-11-23-zero-shot-topic-classification-wc-sbert-vs-llm.html) — 依 StateGraph（H1 核准 + Map-Reduce + C3 靜態驗證 0 警示）製作之 11 頁離線教學簡報，視覺比例 100%，完整拆解 Chi (2025) 維基剪枝、GPT-4o 標籤 vs. APE、單階段 MNR 與 Ollama 本地 LLM 對決（2026-11-23｜zero-shot, wc-sbert, local-llm）
- [台大 LLM 工程實戰全景：從資料合成到推論減碳（全館 4 篇獨立論文統整 HTML 投影片）](../slides/2026-11-23-ntu-llm-engineering-all-papers-synthesis.html) — 依 StateGraph（H1 核准 + Map-Reduce + C3 靜態驗證 0 警示）製作之 12 頁離線綜合教學簡報，視覺比例 100%，串聯吳葦誠 (2024)、吳承光 (2024)、戚得郁 (2025) 與陳冠錞 (2025) 四層生命週期、跨論文法則與混合系統藍圖（2026-11-23｜synthesis, raft, shared-memory, wc-sbert, green-ai）
