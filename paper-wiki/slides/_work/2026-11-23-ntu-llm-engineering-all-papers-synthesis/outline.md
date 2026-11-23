# 投影片大綱合約（`N2: Outline Planner` — 待 H1 人工核准）

- **主題**：台大 LLM 工程實戰全景：從資料合成微調、診斷推理到推論降本減碳（全館 4 篇獨立碩博論文統整）
- **受眾**：課程學習者與讀書會成員（教學型、全棧工程視角與批判性閱讀）
- **目標時長**：25 分鐘（共 12 頁，預估總計 25 分鐘，誤差 0%）
- **去重註記**：使用者先前共上傳 5 份 PDF，其中 `ntu-112-2_(1).pdf` 與 `ntu-112-2_(2).pdf` 經 SHA256 驗證為完全重複（吳承光 2024），故本大綱涵蓋 Wiki 內**全部 4 篇獨立論文**（若需補傳第 5 篇不同論文，可於 H1 補齊後擴充）。
- **C1 大綱檢查**：**PASS**（起承轉合完整、每頁單一焦點、11/11 非封面頁皆綁定 Wiki 來源、視覺比例 100%、連續純文字頁 0）

---

## 逐頁大綱規劃（12 頁｜25 分鐘）

| Slide # | 角色定位 | 標題方向 | 核心 Takeaway（1 句） | 指定視覺類型 | 綁定 Wiki 來源 | 預估時間 |
| :---: | :--- | :--- | :--- | :---: | :--- | :---: |
| **01** | 封面 | 台大 LLM 工程實戰全景：從資料合成到推論減碳 | 一條龍串聯四篇台大碩博論文，建立「資料→推理→選型→能耗」的全棧工程直覺 | `cover` | `index.md` | 1 min |
| **02** | 全景地圖 | 四篇論文如何拼出完整 LLM 工程生命週期？ | 從權重微調、免微調推理、模型降維到快取部署，四篇恰好對應 AI 系統四道關鍵層級 | `svg-diagram` | `domain-specific-llm-adaptation.md`、`llm-inference-efficiency-and-deployment.md` | 2 min |
| **03** | 全覽對照 | 四篇論文定位、核心方法與代表戰績總表 | 一次看清各篇任務場景、是否改權重、核心突破與關鍵量化成績，建立學習錨點 | `table` | 四篇 `papers/*.md` | 2 min |
| **04** | 論文①精要 | Layer 1 資料與微調：吳葦誠 (2024) 合成 Q&A ＋ RAFT | 面對未公開繁中醫療 PDF，單用微調或純 RAG 皆失效，唯有 Critique 過濾＋RAFT 開書考大幅突破（F1 0.556） | `bar-chart` | `2024-wu-llm-finetune-dataset-from-unstructured-data.md` | 2.5 min |
| **05** | 論文②精要 | Layer 2 推理與記憶：吳承光 (2024) ZS-DRCoT ＋ 共享記憶 | 免微調也能自我進化：JSON 臨床思維鏈搭配 O(1) 輪詢異質共享記憶，將 DDXPlus 由 52.85% 推升至 90.48% | `bar-chart` | `2024-wu-ck-llm-diagnostic-reasoning.md` | 2.5 min |
| **06** | 論文③精要 | Layer 3 模型降維：戚得郁 (2025) WC-SBERT vs. 本地 LLM | 結構化主題分類不必殺雞用牛刀：維基剪枝＋GPT-4o 描述標籤讓輕量 SBERT 在 AG News（0.847）奪冠 | `bar-chart` | `2025-chi-zero-shot-topic-classification.md` | 2.5 min |
| **07** | 論文④精要 | Layer 4 推論減碳：陳冠錞 (2025) 語意快取與效益反轉點 | 快取並非裝了就省電：閾值 0.75 省電 43.7%，但調嚴至 0.85 觸發雙重懲罰反而多耗電 +12.7% | `svg-diagram` | `2025-chen-semantic-caching-energy-tradeoff.md`、`semantic-caching-and-benefit-inversion.md` | 2.5 min |
| **08** | 跨論文法則① | 跨論文法則一：低成本的「異質多模型互補紅利」 | 離線角色分工（TAIDE＋Breeze）與線上輪詢共享記憶（GPT＋Gemini＋Claude）獨立證實混搭遠勝單模型 | `table` | `heterogeneous-multi-llm-collaboration.md` | 2 min |
| **09** | 跨論文法則② | 跨論文法則二：結構化 Schema 與領域約束勝過黑箱自動 | 四篇一致顯示明確格式鎖定與人工領域設計（如 GPT-4o 三規則勝 APE）是系統穩定的真正護城河 | `cards` | `domain-specific-llm-adaptation.md` §3、`2025-chi` §3.2 | 2 min |
| **10** | 批判總複盤 | 跨論文批判讀法：四篇共揭露哪些反直覺陷阱與盲區？ | 逐一拆解純 RAG 分心、呼吸困難負遷移、Stage 2 微幅增益缺延遲，以及 QQP 無負例與文表勘誤 | `cards` | 四篇 `papers/*.md` §5 | 2.5 min |
| **11** | 終極整合 | 四篇合體！下一代高準確、低成本、綠能混合系統藍圖 | 以 WC-SBERT 前置分流 → 差異化閾值語意快取 → RAFT 專家或異質共享記憶，打造分層最佳解 | `svg-diagram` | `domain-specific-llm-adaptation.md` §4、`llm-inference-efficiency-and-deployment.md` §3 | 2 min |
| **12** | 總結與討論 | 工程選型決策清單與跨論文讀書會討論題 | 帶走四條「何時該用哪一招」的實戰決策準則，並以三道跨論文融合題開啟討論 | `checklist` | `domain-specific-llm-adaptation.md`、`llm-inference-efficiency-and-deployment.md` | 1.5 min |

---

## C1 自動檢查紀錄
- [x] **敘事弧線**：全景定位（S02–S03）→ 四層精要拆解（S04–S07）→ 跨論文法則與批判（S08–S10）→ 四篇合體架構與選型清單（S11–S12）。
- [x] **時間校準**：1 + 2 + 2 + 2.5×4 + 2 + 2 + 2.5 + 2 + 1.5 = **25 分鐘**（0% 誤差）。
- [x] **單頁聚焦**：每頁聚焦單一論文層級或跨論文法則，避免文字牆。
- [x] **來源綁定**：11/11 非封面頁皆綁定明確 Wiki 頁面與章節。
- [x] **視覺節奏**：3 張自繪 SVG ＋ 3 組長條圖 ＋ 2 張對照表 ＋ 3 組卡片/清單搭配 `.stat-row`，非封面視覺比例 100%、連續純文字頁 = 0。
