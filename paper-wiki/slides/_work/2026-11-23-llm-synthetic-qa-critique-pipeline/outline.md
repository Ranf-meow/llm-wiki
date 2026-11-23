# Slide Outline Contract — LLM 合成問答與 Critique 過濾管線

- **主題**：LLM 合成問答與 Critique 過濾管線（工程實作與批判檢視）
- **受眾**：具基礎 ML / LLM 背景之課程同學與讀書會成員
- **預計時長**：20 分鐘（共 11 頁，節奏緊湊且每頁聚焦單一核心論點）
- **輸出格式**：單檔離線互動式 HTML（`slides/2026-11-23-llm-synthetic-qa-critique-pipeline.html`）
- **C1 大綱自動檢查結果**：`PASS`（總預估 20.0 分鐘吻合目標；11 頁敘事起承轉合完整；視覺頁佔非封面頁 90%；最大連續純文字頁數 = 1；每頁皆具明確 Wiki 證據綁定與精簡字數預算 ≤ 420 視覺單位）

---

## 逐頁大綱合約（供 H1 人工核准）

| Slide | 角色定位 | 標題方向 | 核心 Takeaway（1 句） | 指定視覺類型 | 綁定 Wiki 來源 | 預估時間 |
| :---: | :--- | :--- | :--- | :--- | :--- | :---: |
| **01** | 封面 | LLM 合成問答與 Critique 過濾管線 | 用通用開源 LLM 免人工標註將封閉領域 PDF 轉為專業問答模型 | `cover` | `llm-synthetic-qa-critique-pipeline.md`, `2024-wu-*.md` | 1.0 分 |
| **02** | 動機與定位 | 封閉領域導入 LLM：四條路線比較 | 封閉小語料無法靠 Self-Instruct 憑空生知，需改採「錨定文件的模組化合成管線」 | `table`（四路線比較表） | `domain-specific-llm-adaptation.md` | 2.0 分 |
| **03** | 架構總覽 | 三階段端到端流水線架構 | 前處理 → 多角色生成與 Critique 過濾 → RAFT 微調，所有 LLM 模組可自由替換 | `svg-diagram`（內嵌 SVG 流程圖） | `llm-synthetic-qa-critique-pipeline.md`, `2024-wu-*.md` | 2.0 分 |
| **04** | Step 1 前處理 | 繁中標點 Chunking：為何 `overlap = 0` 更準？ | 補齊全形標點斷點後，`chunk=512, overlap=0` 的 Top-1 命中率勝過 `overlap=100` 約 +10% | `bar-chart` ＋ `pill-row`（斷點表） | `2024-wu-*.md` (Table 4.2, 4.4) | 2.0 分 |
| **05** | Step 2 生成 | 角色扮演與關鍵字雙軌生成策略 | 病患/資淺醫師雙軌產 11 題/chunk ＋ 資深醫師產 3 答案，打破單一敘事視角 | `stat-row`（量產漏斗）＋ 角色卡片 | `llm-synthetic-qa-critique-pipeline.md`, `2024-wu-*.md` | 2.0 分 |
| **06** | Step 3 審查 | Critique LLM 四維度審查與格式控管 | Groundedness/Relevance/Standalone/Similarity 雙重門檻（各≥3 且總分≥13）把關品質 | `grid-4`（四指標卡）＋ 門檻 Banner | `llm-synthetic-qa-critique-pipeline.md`, `2024-wu-*.md` | 2.0 分 |
| **07** | 實戰發現 ① | 異質模型分工：TAIDE 生題 ＋ Breeze 嚴審 | Breeze 當裁判遠比 TAIDE 嚴格（通過率 36% vs 84%），異質配對在 8 組合中奪冠 | `bar-chart`（通過率）＋ `table`（排名） | `2024-wu-*.md` (Table 4.6, 4.8) | 2.0 分 |
| **08** | 實戰發現 ② | 下游接 RAFT：單用 RAG 或微調都沒用 | 7B 小模型單接 RAG 反而略降，透過 RAFT（80/20 干擾設定）微調後 F1 暴衝至 0.5556 | `bar-chart`（四組消融）＋ RAFT 規則 | `raft.md`, `2024-wu-*.md` (Table 4.9) | 2.0 分 |
| **09** | 實戰發現 ③ | 低品質回收轉「拒答樣本」的雙面刃 | 零成本構造拒答負樣本雖能防幻覺，但比例過高會造成正例 F1 下滑 -0.137 | `bar-chart`（Table 4.7 vs 4.8） | `llm-synthetic-qa-critique-pipeline.md`, `2024-wu-*.md` | 1.5 分 |
| **10** | 批判與避坑 | 工程復現必須避開的 4 個陷阱 | 修正 Groundedness 漏餵 Answer、補 Reranker、改進關鍵字評估與確認開書公平性 | `grid-4`（精簡四張警戒卡） | `2024-wu-*.md`, `pubmedqa.md` | 2.0 分 |
| **11** | 總結與 Q&A | 實作 Checklist 與讀書會討論題 | 帶走 3 條繁中合成資料工程準則，並延伸探討 Chunking、成本與安全評估 | `cards`（Checklist ＋ 3 題 Q&A） | 全數參考 Wiki 頁 | 1.5 分 |

---

## C1 自動檢查明細
- [x] **敘事結構完整**：封面 → 動機 → 架構 → Step 1–3 → 3 大實戰發現 → 批判避坑 → 總結 Q&A。
- [x] **時長吻合**：合計 `20.0 分鐘`（目標 20 分鐘，誤差 0%）。
- [x] **單頁焦點**：每頁僅承載 1 個核心論點，且已針對先前初版第 10、11 頁偏密的問題預先規劃精簡文案預算（目標 VisualUnits ≤ 420）。
- [x] **視覺節奏**：非封面 10 頁中 9 頁具備明確視覺元件（表格 / SVG / 長條圖 / 數據漏斗 / 四欄卡片），視覺比例 `90%`，最大連續純文字頁數 `1`。
- [x] **證據綁定**：除封面外 100% 綁定至 `evidence.md` 與對應 Wiki 頁面。
