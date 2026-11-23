# Paper LLM Wiki — Agent 行為規範與架構手冊 (`AGENTS.md`)

> 本知識庫參考 Andrej Karpathy 的 **LLM Wiki** 模式，專為**課程學習、讀書會導讀與簡報整理**設計，採用**純 Markdown / VS Code / GitHub** 原生相容格式。

---

## 1. 核心理念與分工

這不是一次性檢索的 RAG 系統，而是一座**持續累積、交叉連結、不斷修訂的論文知識庫**：

- **使用者的角色**：決定要讀哪些論文、提出學習或讀書會問題、主導討論焦點、檢視與修正觀點。
- **Agent 的角色**：負責閱讀原始論文、摘要提煉、拆解前置概念、維護數據對照、建立並維護雙向連結、整理讀書會簡報大綱、以及定期健康檢查（Lint）。
- **核心原則**：知識只需編譯一次，並隨新論文加入持續更新——標記新舊結論的矛盾、補齊技術演進脈絡，避免知識庫淪為互不關聯的「單篇摘要墳場」。

---

## 2. 三層架構與目錄規範

```text
paper-wiki/
├── AGENTS.md                 # 【Schema 層】本檔：規則、模板與四大工作流入口
├── README.md                 # GitHub 入口說明與快速指令範例
├── workflows/                # 【Workflow 層】進階多階段 Graph 工作流規格
│   └── slide-graph.md        # 投影片生成 StateGraph 完整規範
├── scripts/                  # 【Tooling 層】靜態檢查與自動化輔助腳本
│   └── validate-slides.ps1   # 投影片 C3 靜態規則 QA 驗證腳本
├── raw/                      # 【Raw Sources 層｜嚴格唯讀】原始資料，Agent 絕不修改既有檔案
│   ├── papers/               # 原始 PDF 或 arXiv/DOI 抓取的本地快照
│   └── assets/               # 擷取的關鍵架構圖、實驗圖（依 <paper-slug>/ 分資料夾）
├── wiki/                     # 【Wiki 層｜Agent 全權維護】所有結構化知識頁面
│   ├── index.md              # 內容導向總目錄（檢索入口）
│   ├── log.md                # 時間序操作紀錄（只追加不改寫歷史）
│   ├── papers/               # 單篇論文導讀頁
│   ├── concepts/             # 跨論文累積的核心概念、演算法、模型與數學基礎
│   ├── benchmarks/           # 資料集、評估指標與跨論文實驗數據對照
│   └── topics/               # 主題綜述、方法比較表、Mermaid 演進圖與爭論點
└── slides/                   # 【Output 層】讀書會 / 課堂互動式 HTML 投影片與工作狀態
    └── _work/<slug>/         # Graph 中間狀態檔（state.json / evidence / outline / drafts / qa）
```

### 嚴格邊界規則
1. **`raw/` 不可變（Immutable）**：Agent 可以將新抓取的 arXiv/DOI 原始檔或擷取出的圖表**新增**至 `raw/`，但**絕對不可修改或刪除**已存放在 `raw/` 中的原始文件。
2. **所有知識產出都在 `wiki/` 與 `slides/`**：任何摘要、整理、比較、筆記都寫在 `wiki/` 或 `slides/`，並透過相對路徑回指 `raw/`。
3. **本檔（`AGENTS.md`）可共同演進**：隨著知識庫成長（例如論文超過 50–100 篇需要引入搜尋腳本或 `qmd`、或新增頁面類型），Agent 可主動建議更新本檔，經使用者同意後修訂。

---

## 3. 格式、語言與命名慣例

### 3.1 語言風格
- **繁體中文為主**：內文、解說、批判分析與討論題一律使用自然流暢的繁體中文。
- **保留英文專有名詞**：論文原標題、作者姓名、模型名稱、演算法、資料集、評估指標與關鍵技術術語保留英文（必要時首次出現加註簡短中文說明）。
- **教學與導讀友善**：寫作以「能讓讀書會聽眾快速建立直覺」為目標，先講動機與直覺，再講數學細節與實驗證據。

### 3.2 純 Markdown / VS Code / GitHub 相容規則
- **連結一律使用標準相對路徑 Markdown 連結**：例如 `[Self-Attention](../concepts/self-attention.md)`。**禁止使用** Obsidian 專屬語法（如 `[[Wikilinks]]`、`![[embed]]`、Dataview 語法）。
- **數學公式**：行內用 `$...$`，獨立區塊用 `$$...$$`（相容 GitHub 與 VS Code KaTeX/MathJax）。
- **架構與脈絡圖**：優先使用 **Mermaid**（`flowchart`、`graph`、`sequenceDiagram`、`timeline` 等 GitHub 原生支援圖表）呈現論文演進樹與概念關聯，彌補沒有 Graph View 的視覺總覽。
- **雙向連結維護（關鍵規則）**：由於純 Markdown 環境沒有自動 Backlinks，每當頁面 A 新增連往頁面 B 的連結時，Agent **必須同步確認頁面 B 的「相關頁面 / 引用來源」區塊是否已連回 A**，確保雙向可導航。

### 3.3 檔名規範
| 目錄 | 命名規則 | 範例 |
| :--- | :--- | :--- |
| `raw/papers/` | `YYYY_FirstAuthor_ShortTitle.<ext>` | `2017_Vaswani_AttentionIsAllYouNeed.pdf` |
| `raw/assets/` | `YYYY-firstauthor-short-title/<fig>.png` | `2017-vaswani-attention/fig1-architecture.png` |
| `wiki/papers/` | `YYYY-firstauthor-short-title.md`（小寫 kebab-case） | `2017-vaswani-attention-is-all-you-need.md` |
| `wiki/concepts/` | `<concept-slug>.md`（小寫英文 kebab-case） | `self-attention.md` |
| `wiki/benchmarks/` | `<benchmark-slug>.md`（小寫英文 kebab-case） | `mmlu.md` |
| `wiki/topics/` | `<topic-slug>.md`（小寫英文 kebab-case） | `efficient-attention.md` |
| `slides/` | `YYYY-MM-DD-<topic-or-paper-slug>.html`（中間狀態置於 `slides/_work/<slug>/`） | `2026-11-23-attention-reading-group.html` |

### 3.4 YAML Frontmatter 規範
所有 `wiki/` 頁面頂部皆包含簡潔的 YAML Frontmatter（GitHub 會自動渲染為頂部資訊表，也方便日後腳本檢索）：

- **Paper 頁**：
  ```yaml
  ---
  type: paper
  title: "Attention Is All You Need"
  authors: ["Ashish Vaswani", "Noam Shazeer", "..."]
  year: 2017
  venue: NeurIPS 2017
  arxiv: "1706.03762"
  raw_source: "../../raw/papers/2017_Vaswani_AttentionIsAllYouNeed.pdf"
  tags: [transformer, attention, sequence-modeling]
  updated: 2026-11-23
  ---
  ```
- **Concept / Benchmark / Topic 頁**：
  ```yaml
  ---
  type: concept # 或 benchmark / topic
  title: "Self-Attention"
  aliases: ["Scaled Dot-Product Attention"]
  tags: [attention, transformer]
  sources_count: 3
  updated: 2026-11-23
  ---
  ```

### 3.5 學術嚴謹與誠信原則
- **區分事實與解讀**：明確標註哪些是「論文原文宣稱／實驗結果」，哪些是「延伸解讀／批判觀點」。
- **實驗數據必附條件**：凡在 `wiki/benchmarks/` 或論文頁記錄數字（如 Accuracy、F1、Perplexity），**必須一併註明關鍵實驗條件**（模型規模、shot 數、訓練資料、硬體或推論設定），避免不同條件的數字直接比較。
- **顯式標記矛盾（Contradictions）**：若新論文的實驗結果或論點與既有頁面衝突，**不可悄悄覆蓋舊內容**，必須使用 `> [!WARNING]` 或專屬「爭議與矛盾」段落保留雙方出處與條件差異。

---

## 4. 四大核心操作流程

### 操作一：`Ingest`（消化新論文 — 兩階段互動協議）

當使用者丟入新 PDF 至 `raw/papers/`，或提供 arXiv 連結／DOI 要求收錄時，**必須嚴格遵守以下兩階段流程**：

#### 階段一：取得、閱讀與討論（⚠️ 此階段不可修改 `wiki/` 檔案）
1. **確認原始來源**：
   - 若使用者提供 **PDF**：從 `raw/papers/` 讀取（必要時確認檔名符合規範，或建議標準檔名）。
   - 若使用者提供 **arXiv 連結 / ID 或 DOI**：抓取論文中繼資料與可閱讀快照（優先保留 PDF，並可視需要一併保存 arXiv HTML／文字版本以便精準讀取公式）存入 `raw/papers/`。
2. **對照現有知識庫**：先閱讀 `wiki/index.md`，找出與本篇論文相關的既有論文頁、前置概念頁、Benchmark 頁與主題綜述頁。
3. **提出導讀討論簡報（與使用者對齊）**：
   - **一句話總結與核心貢獻**（這篇解決什麼痛點？為什麼值得讀？）
   - **與現有 Wiki 的關聯或衝突**（延伸了哪篇？補強或推翻了哪個既有結論？）
   - **預計更新計畫（Edit Plan）**：明確列出準備**新增**與**修改**哪些檔案（例如：1 篇 Paper 頁、2 篇 Concept 頁、1 篇 Benchmark 頁、1 篇 Topic 頁 + `index.md` + `log.md`）。
   - **詢問使用者焦點**：詢問這次課程或讀書會想特別深入哪個面向（例如：數學推導細節、特定消融實驗、實作技巧、或與某篇課堂論文的對比）？

#### 階段二：確認後寫入與交叉連結（使用者確認或補充後執行）
1. **撰寫 Paper 頁**（依第 5 節模板寫入 `wiki/papers/`）。
2. **更新或建立跨論文頁面**：
   - 補齊或更新相關的 `wiki/concepts/`（將這篇的新變體、直覺解釋或公式補進去）。
   - 若涉及標準資料集／指標，更新 `wiki/benchmarks/` 的對照表（務必註明實驗條件）。
   - 更新對應的 `wiki/topics/` 綜述頁、方法比較表或 Mermaid 演進圖；若有論點衝突，顯式標註。
3. **維護雙向連結**：確認所有被引用的既有頁面都已補上連回這篇新論文的連結。
4. **更新索引與日誌**：
   - 更新 `wiki/index.md`（新增條目與一句話摘要，更新相關分類）。
   - 在 `wiki/log.md` 末尾追加一筆標準格式紀錄。
5. **簡要回報**：列出本次實際建立與修改的檔案清單（附連結），方便使用者在 VS Code 檢視。

---

### 操作二：`Query`（提問、探索與知識沉澱）

當使用者對知識庫提問（例如「比較 A、B、C 三篇在長上下文的取捨」、「解釋某概念的演進」）：
1. **先讀 `wiki/index.md`** 定位相關頁面，再深入讀取對應的 `wiki/` 頁面（僅在需要核對原文細節、公式或圖表數據時才回查 `raw/`）。
2. **合成回答並附出處**：回答時使用相對路徑或檔名明確標註每個論點來自哪篇 Wiki 頁／哪篇原始論文。
3. **主動提議知識沉澱**：若本次問答產出了高價值的跨論文比較表、概念釐清、脈絡圖或讀書會討論結論，**在回答結尾詢問使用者是否要回存至 `wiki/topics/`（或對應頁面）**，讓探索成果複利累積而非消失在對話紀錄裡。若回存，同步更新 `index.md` 與 `log.md`。

---

### 操作三：`Slide`（Graph 驅動之讀書會 / 課堂 HTML 簡報管線）

當使用者要求從 Wiki 製作簡報時，**必須嚴格遵循 [workflows/slide-graph.md](./workflows/slide-graph.md) 定義的 StateGraph 流程**，將中間狀態保留於 `slides/_work/<slug>/`，最終輸出單檔離線互動 HTML 至 `slides/YYYY-MM-DD-<slug>.html`：

1. **Phase 0（檢索與打包）**：先讀 `wiki/index.md` 與相關頁產出 `evidence.md`，並執行 `C0` 素材覆蓋度檢查。
2. **Phase 1（大綱規劃 ＋ ⚠️ H1 唯一人工必停關卡）**：產出合約級 `outline.md`（含頁數、每頁 Takeaway、視覺類型、綁定來源與時長），通過 `C1` 自動檢查後**必須停下來請使用者確認大綱**。
3. **Phase 2（Map-Reduce 逐頁內容生成）**：大綱核准後全自動執行——**Fan-out** 並行產出各頁草稿 `drafts/slide-XX.md` 並做 `C2a` 單頁事實／字數／視覺規格檢查（失敗僅局部重修該頁），再經 **Reduce** 整合為 `deck_content.md` 並通過 `C2b` 跨頁連貫性與視覺多樣性檢查。
4. **Phase 3（HTML 渲染、靜態 QA 與歸檔）**：渲染單檔離線 `.html`，必跑 [scripts/validate-slides.ps1](./scripts/validate-slides.ps1) 執行 `C3` 靜態規則 QA（語法／頁碼／無外部 CDN／視覺寬度防爆版／視覺比例；所有迴圈上限 `max_retries = 2`），通過後產出 `qa_report.md` 並更新 `wiki/index.md`、`wiki/log.md` 與來源頁雙向連結。

> 若使用者明確要求「只要純 Markdown 大綱、不需做 HTML 投影片」，可只執行至 Phase 1–2 並依第 5.5 節格式輸出。

---

### 操作四：`Lint`（定期知識庫健檢）

當使用者要求執行健檢（Lint）時，全面掃描 `wiki/` 與 `slides/`，產出健檢報告並詢問是否要自動修復：
1. **連結完整性**：檢查所有相對路徑 Markdown 連結是否失效（Broken Links），確認沒有誤用 `[[Wikilinks]]`。
2. **雙向連結對稱性**：檢查 A 連到 B 但 B 未連回 A 的缺漏。
3. **孤島頁面（Orphans）**：找出除了 `index.md` 之外沒有任何頁面連入的檔案。
4. **前置概念缺口**：檢查論文頁的「前置知識」中反覆出現、但 `wiki/concepts/` 尚未獨立建頁的重要術語。
5. **Benchmark 衛生檢查**：檢查 `wiki/benchmarks/` 是否有缺少實驗條件的裸數字，或與新收錄論文矛盾卻未標註的 SOTA 宣稱。
6. **矛盾與過時主張**：跨頁面檢視是否存在互相衝突的論點或已被後續論文修正的舊說法。
7. **索引一致性**：核對 `wiki/index.md` 與實際檔案列表是否完全同步（無漏登、無幽靈條目）。
8. **記錄結果**：修復完成後在 `wiki/log.md` 追加一筆 `lint` 紀錄。

---

## 5. 頁面模板參考

### 5.1 單篇論文頁（`wiki/papers/YYYY-firstauthor-short-title.md`）

```markdown
---
type: paper
title: "<Paper Title>"
authors: ["Author A", "Author B"]
year: 2024
venue: "<Conference / Journal / arXiv>"
arxiv: "<arXiv ID>"
raw_source: "../../raw/papers/<filename>"
tags: [tag1, tag2]
updated: YYYY-MM-DD
---

# <論文標題>（<簡稱或中文副標>）

> **一句話總結（TL;DR）**：<用 1–2 句說清楚這篇解決什麼問題、核心做法與關鍵結論。>

## 1. 研究動機與問題定義
- 現有方法的痛點是什麼？
- 本篇的核心假設（Key Insight）是什麼？

## 2. 前置知識（Prerequisites）
閱讀本篇前建議先理解：
- [概念 A](../concepts/concept-a.md) — <一句話說明與本篇的關聯>
- [前置論文 B](./yyyy-author-paper-b.md) — <本篇改良或對比的對象>

## 3. 核心方法與直覺
- **直覺理解**：<用白話或類比講清楚怎麼運作>
- **架構／演算法步驟**：<條列核心流程，可用 Mermaid 或公式輔助>
- **關鍵公式與設計細節**：<僅放最核心的公式並解釋符號意義>

## 4. 實驗設定與關鍵發現
- **主要資料集與指標**：連結至對應的 [Benchmark 頁](../benchmarks/benchmark-name.md)
- **關鍵實驗數據與結論**：<附實驗條件：模型大小、資料集、Baseline 設定>
- **消融實驗（Ablation Study）洞見**：<哪些元件真正有效？>

## 5. 限制、批判與與既有知識的關係
- **作者自述限制 & 我們的批判觀察**：<方法弱點、未驗證的假設、算力成本等>
- **與現有 Wiki 的關聯／矛盾**：<若與其他論文結論打架，用 `> [!WARNING]` 明確標註>

## 6. 讀書會討論題（Discussion Questions）
1. <適合在課堂或讀書會引發思考的開放式問題>
2. <可延伸的實作或實驗發想>

## 相關頁面
- 主題綜述：[主題名稱](../topics/topic-name.md)
- 核心概念：[概念名稱](../concepts/concept-name.md)
- 相關簡報：[簡報名稱](../../slides/yyyy-mm-dd-slug.md)（若有）
```

### 5.2 概念頁（`wiki/concepts/<slug>.md`）
應包含：**直覺定義** → **數學／技術表述** → **演進與常見變體** → **優缺點與適用場景** → **引用此概念的論文（雙向連結列表）** → **相關頁面**。

### 5.3 Benchmark 頁（`wiki/benchmarks/<slug>.md`）
應包含：**資料集／指標簡介與評估任務** → **評估注意事項與常見陷阱（Pitfalls）** → **跨論文實驗結果對照表**（欄位必含：`論文`、`模型／方法`、`關鍵實驗條件`、`分數／指標`、`備註`）→ **相關頁面**。

### 5.4 主題綜述頁（`wiki/topics/<slug>.md`）
應包含：**主題核心問題** → **技術路線與演進脈絡（附 Mermaid 圖）** → **跨論文方法對照表** → **現存爭議與矛盾（Contradictions）** → **開放問題（Open Problems）** → **收錄論文與相關頁面**。

### 5.5 簡報大綱頁（`slides/YYYY-MM-DD-<slug>.md`）
```markdown
# <簡報標題>

- **場合／目標**：<課程報告 / 讀書會導讀，預計 XX 分鐘>
- **參考 Wiki 頁面**：[論文頁](../wiki/papers/xxx.md)、[主題頁](../wiki/topics/xxx.md)
- **更新日期**：YYYY-MM-DD

---

## Slide 1：封面與開場鉤子
- 標題與副標
- 一句話點出為什麼大家該關心這個問題

> **講者筆記**：<開場白建議>

---

## Slide 2：...
- 重點 1
- 重點 2
- **視覺建議**：<建議放哪張圖或 Mermaid 圖>

> **講者筆記**：<口語講解重點與轉場>
```

---

## 6. 索引與日誌格式

### `wiki/index.md`
- 按類別分區（`Papers`、`Concepts`、`Benchmarks`、`Topics`、`Slides`）。
- 每個條目一行：`- [顯示標題](./路徑.md) — 一句話核心摘要（年份／標籤或來源數）`。
- 每次 `Ingest`、回存 `Query` 或新增 `Slide` 時必須同步更新。

### `wiki/log.md`
- **只追加（Append-Only）**，每筆紀錄以固定前綴開頭，方便使用 `grep` 或指令檢索：
  ```markdown
  ## [YYYY-MM-DD] <ingest|query|slide|lint|init> | <簡短標題>
  - **摘要**：<做了什麼>
  - **影響檔案**：<新增或修改的檔案列表>
  ```
