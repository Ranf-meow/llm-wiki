# 整合內容稿（`R1: Coherence Integrator` — `deck_content.md`）

- **簡報標題**：零樣本主題分類：WC-SBERT vs. 本地量化 LLM（戚得郁, 2025 教學精讀）
- **Slug**：`2026-11-23-zero-shot-topic-classification-wc-sbert-vs-llm`
- **頁數與時長**：11 頁｜20 分鐘
- **C2b 跨頁連貫性檢查**：**PASS**
  - **術語一致**：統一採 `零樣本主題分類（ZSTC）`、`WC-SBERT`、`度數區間剪枝`、`GPT-4o 描述性標籤`、`全自動 APE`、`單階段 MNR 自訓練`、`Ollama 本地量化 LLM`。
  - **零冗餘修整**：將 DBpedia `Building → Village (3,599 筆)` 精準數據集中於 Slide 10 批判分析，Slide 02 僅點出語意重疊現象，消除跨頁重複。
  - **視覺節奏**：10/10 非封面頁皆含結構化視覺元件（3 張自繪 SVG、2 組水平長條圖、2 張對照表、3 組統計指標列），連續純文字頁 = 0。
  - **過場銜接**：相鄰 10 組講者筆記皆具備自然提問與承先啟後轉場。

---

## Slide 01｜封面（`cover`）
- **Tag**：Paper LLM Wiki 教學精讀 · NTU CSIE 博士論文
- **H1**：零樣本主題分類：WC-SBERT vs. 本地量化 LLM
- **Subtitle**：拆解 **Chi (2025)** 如何透過「維基類別剪枝 ＋ GPT-4o 描述性標籤 ＋ 單階段 MNR 自訓練」，讓輕量編碼器正面對決本地量化大型語言模型。
- **Cover Meta (3 cards)**：
  1. 核心文獻：`Chi, Te-Yu (2025)` · 台大資工博論 (`10.6342/NTU202504846`)
  2. 評測基準：AG News (7.6K) · Yahoo! Answers (60K) · DBpedia-14 (70K)
  3. 關鍵戰績：AG News **`0.847`** 奪冠 · **0 筆**目標測試原文 · 20 分鐘 / 11 頁
- **Speaker Notes**：大家好，今天用 20 分鐘帶大家精讀台大資工戚得郁 2025 年博士論文。這篇論文回答一個非常務實的工程問題：在完全沒有標註資料的零樣本主題分類上，我們一定要搬出昂貴的 LLM 嗎？還是優化後的輕量 Sentence-BERT 反而更穩、更快、更省？我們先從這個問題為什麼棘手開始看起。

## Slide 02｜問題動機（`cards` + `.stat-row`）
- **Kicker**：01 · Problem & Motivation｜**Badge**：三大痛點
- **Title**：為什麼「零樣本主題分類（ZSTC）」這麼難？
- **Visual (3 cards + 3 stat-boxes)**：
  - Card 1（rose）：**痛點① 偽零樣本依賴** — 既有迭代自訓練（如 Gera et al., 2022）需接觸目標無標註原文並多輪訓練，違背純零樣本且易累積錯誤。
  - Card 2（amber）：**痛點② 短標籤語意單薄** — Bi-Encoder 直接編碼 `World`、`Building`、`Artist` 等單字，容易與鄰近類別（`Village`、`Album`）重疊混淆。
  - Card 3（primary）：**痛點③ 雲端 LLM 成本與隱私** — 面對數萬筆商業分類流量，外部 API 的費用、延遲與資料外洩風險皆成為部署瓶頸。
  - Stat Row：AG News `7,600 筆 / 4 類`｜Yahoo! Answers `60,000 筆 / 10 類`｜DBpedia-14 `70,000 筆 / 14 類`
- **Footer**：來源：wiki/papers/2025-chi-zero-shot-topic-classification.md (§1) · zstc-benchmarks.md
- **Speaker Notes**：真實商業場景常缺乏標註資料且類別隨時增減。過去三條路各有硬傷：迭代自訓練其實偷看了目標資料集原文；直接算單字標籤相似度語意過於單薄；全丟給雲端 LLM 面對六七萬筆文本成本與隱私吃不消。接下來看 WC-SBERT 如何用兩階段架構一次拆解這三個難題。

## Slide 03｜全覽架構（`svg-diagram`）
- **Kicker**：02 · End-to-End Architecture｜**Badge**：兩階段全景
- **Title**：WC-SBERT 兩階段架構：完全不碰目標測試集原文
- **Visual**：寬幅雙階段 SVG（Stage 1 通用維基類別剪枝與 MNR 預訓練 → 離線 `.npy` 645 萬篇 Wiki 摘要資產 → Stage 2 GPT-4o 描述性標籤 + 單階段 MNR 自訓練 → Task-Specific WC-SBERT）。
- **Callout (teal)**：**核心設計哲學**：Stage 1 只需訓練一次，將 645 萬篇維基摘要預編碼為 `.npy`；面對新任務時完全不碰測試集原文，僅需目標標籤即可完成適配。
- **Footer**：來源：wiki/papers/2025-chi-zero-shot-topic-classification.md (§3) · wc-sbert-and-label-augmentation.md
- **Speaker Notes**：這張圖是整篇論文的骨架。左邊 Stage 1 只跑一次，利用維基類別共現圖教會輕量模型理解主題語意；右邊 Stage 2 迎接新任務時，不拿任何目標原文，改用離線存好的維基摘要 `.npy` 搭配 GPT-4o 擴寫標籤做單次自訓練。接著我們深入三個最具教學價值的工程支柱，先看 Stage 1 的長尾剪枝。

## Slide 04｜教學核心一（`svg-diagram` + `.stat-row`）
- **Kicker**：03 · Pillar 1: Stage 1 Category Pruning｜**Badge**：長尾雜訊治理
- **Title**：維基類別共現圖：為何「度數剪枝」是成敗第一關？
- **Visual**：
  - SVG：Zipf 長尾度數分區剪枝圖（高頻雜訊 `d > 500` 如 `Use British English` 抽 2%｜黃金中頻 `5 ≤ d ≤ 500` **100% 保留**｜超低頻 `d < 5` 抽 20%）。
  - Stat Row：`1.56M → 0.99M`（類別數 -36.7%）｜`1.01M → 23.5K`（最大度數壓低兩數量級）｜`0.9910`（語意覆蓋率, r=0.9174）｜`+7.8%`（AG News `0.695 → 0.749`）
- **Footer**：來源：wiki/papers/2025-chi-zero-shot-topic-classification.md (§3.1, Table 5.6) · wc-sbert-and-label-augmentation.md
- **Speaker Notes**：第一堂資料工程課是「髒資料比少資料更致命」。原始 156 萬維基類別呈 Zipf 長尾，超高頻幾乎全是無主題意義的編務維護標籤。透過三段式度數抽樣保留中頻黃金區、大幅下採樣極端高低頻，資料瘦身 36.7% 卻維持 99.1% 語意覆蓋率，AG News 準確率立刻從 0.695 跳升到 0.749。那後續每層技術又各自貢獻了多少？我們看逐層消融實驗。

## Slide 05｜教學核心二（`bar-chart`）
- **Kicker**：04 · Ablation Ladder｜**Badge**：逐層消融拆解
- **Title**：六層技術疊加，哪一項貢獻了最大準確率躍升？
- **Visual**：左右雙欄長條圖（`.grid-2`）：
  - 左圖（AG News 6 階）：Original SBERT `0.654` → Wiki 未剪枝 `0.695` → +度數剪枝 `0.749` → +手寫模板 `0.813` → +GPT-4o 標籤 `0.836` → +單階段 MNR **`0.847`**
  - 右圖（DBpedia 關鍵 4 階 + Yahoo 關鍵 2 階對照）：DBpedia 單字 `0.614` → 模板 `0.718` → **GPT-4o 標籤 `0.883` (+23.0%)** → +MNR `0.886`；Yahoo 模板 `0.622` → GPT-4o `0.643` → +MNR `0.649`
- **Callout (amber)**：**教學重點**：剪枝預訓練與 GPT-4o 描述性標籤吃下超過九成紅利；DBpedia 單靠標籤增強就大跳 **+16.5 個百分點**，而 Stage 2 自訓練僅微增 `+0.3%`～`+1.3%`。
- **Footer**：來源：wiki/papers/2025-chi-zero-shot-topic-classification.md (§4.1, Tables 5.6 / 5.8 / 5.13 / 5.18)
- **Speaker Notes**：讀系統論文必看逐層消融。左邊 AG News 穩定爬坡到 0.847，但右邊 DBpedia 揭露了最大功臣：從手寫模板 0.718 到 GPT-4o 描述性標籤一口氣衝上 0.883，暴增 16.5 個百分點；反觀後續 Stage 2 自訓練僅微增 0.3% 到 1.3%。這引出下一個關鍵問題：GPT-4o 標籤到底怎麼設計，為何全自動 APE 反而慘敗？

## Slide 06｜教學核心三（`table`）
- **Kicker**：05 · Pillar 2: Descriptive Label Augmentation｜**Badge**：GPT-4o vs. APE
- **Title**：為何「人工引導 GPT-4o 標籤」大勝全自動 APE？
- **Visual**：
  - 4 列比較表（單字標籤 `0.749 / 0.614`｜手寫模板 `0.813 / 0.718`｜全自動 APE `0.693` 掉點｜**GPT-4o 人工引導 `0.836 / 0.883`**）。
  - 3 枚精簡規則膠囊卡片（`.grid-3`）：① 強制一致句型前綴 ② 限制 15–30 字客觀語氣 ③ 跨類禁止重複關鍵詞。
- **Footer**：來源：wiki/papers/2025-chi-zero-shot-topic-classification.md (§3.2, Tables 5.13 / 5.16) · wc-sbert-and-label-augmentation.md
- **Speaker Notes**：這是全篇最反直覺的一課：交給全自動 APE 跑多輪生成，AG News 竟然掉到 0.693，比原始單字標籤還差！因為沒有約束的 APE 容易寫出抽象百科定義且各類句式不一，把嵌入空間打亂。只要給 GPT-4o 三條清晰規則——統一前綴、精準字數、跨類去重——準確率立刻飆升。有了好標籤，接下來看 Stage 2 如何不碰目標原文完成自訓練。

## Slide 07｜教學核心四（`svg-diagram` + `.stat-row`）
- **Kicker**：06 · Pillar 3: Single-Pass MNR Self-Training｜**Badge**：Stage 2 改良
- **Title**：離線 `.npy` 重用 ＋ 單階段 MNR 如何取代多輪迭代？
- **Visual**：
  - SVG：雙輸入（`645萬篇預編碼 Wiki 摘要 .npy` + `GPT-4o 描述性標籤`）→ `Cosine > t (0.75–0.77)` → `三元組 (Anchor=Wiki類別, Pos=最似標籤, Hard Neg=最遠標籤)` → `MNR Loss (Batch 256, 3 epochs, FP16)` → `Task-Specific WC-SBERT`。
  - Stat Row：對比原版 Chi & Jang (2024) — AG News `0.840 → 0.847`｜Yahoo `0.638 → 0.649`｜DBpedia `0.881 → 0.886`｜目標原文需求 `0 筆`
- **Footer**：來源：wiki/papers/2025-chi-zero-shot-topic-classification.md (§3.3, Tables 5.18 / 5.20) · wc-sbert-and-label-augmentation.md
- **Speaker Notes**：Stage 2 解決了傳統自訓練的兩大毛病：不需接觸測試集原文，也不跑會累積錯誤的多輪迭代。作者把 645 萬篇維基摘要事先存成 `.npy` 跨任務重用，每逢新任務只算一次相似度篩選，組出含 Hard Negative 的三元組用 MNR Loss 跑 3 個 epoch 就全面超越 ACM TIST 2024 原版。接著看重頭戲：輕量 WC-SBERT 正面對決 Ollama 本地量化 LLM。

## Slide 08｜實驗對決一（`bar-chart`）
- **Kicker**：07 · Head-to-Head Benchmark (Table 5.19)｜**Badge**：WC-SBERT vs. 本地 LLM
- **Title**：正面對決：WC-SBERT vs. Ollama 本地量化 LLM
- **Visual**：三欄並排長條圖（`.grid-3`，AG News / Yahoo! Answers / DBpedia-14，各標出最佳設定 Accuracy）：
  - AG News：**WC-SBERT `0.847`**｜Gemma 2 (FS) `0.832`｜Llama 3.1 (FS) `0.680`｜GPT-4o mini (FS) `0.655`｜Llama 3.2 (FS) `0.601`
  - Yahoo! Answers：**Gemma 2 (ZS) `0.659`**｜WC-SBERT `0.649`｜Llama 3.1 (FS) `0.572`｜GPT-4o mini (FS) `0.509`｜Llama 3.2 (FS) `0.461`
  - DBpedia-14：**Gemma 2 (FS) `0.915`**｜WC-SBERT `0.886`｜GPT-4o mini (FS) `0.841`｜Llama 3.1 (FS) `0.761`｜Llama 3.2 (FS) `0.649`
- **Callout (primary)**：**公平推論控制**：所有 LLM 皆設定 `temperature = 0` ＋ JSON 整數 Schema（`{"label": int}`）；Few-shot 為每類 1 筆 GPT-4o 合成範例。小模型量化過度（Llama 3.2）表現明顯崩跌。
- **Footer**：來源：wiki/papers/2025-chi-zero-shot-topic-classification.md (§3.4 & §4.2, Table 5.19) · zstc-benchmarks.md
- **Speaker Notes**：這裡打破一個常見迷思：不是換成 LLM 就一定贏！在嚴格 `T=0` 與 JSON 整數輸出控制下，輕量 WC-SBERT 在 AG News 拿下 0.847 奪冠，在 Yahoo 與 DBpedia 也僅小輸表現最強的 Gemma 2，並大幅擊敗 Llama 3.1、Llama 3.2 與同 Prompt 下的 GPT-4o mini。接下來我們把結果放回整個 ZSTC 學術版圖做公平定位。

## Slide 09｜實驗對決二（`table`）
- **Kicker**：08 · Benchmark Positioning｜**Badge**：跨路線公平對照
- **Title**：全景基準定位：純零樣本 vs. 接觸目標集 vs. 全監督
- **Visual**：6 列全景對照表（全監督 BERT `0.944 / 0.753 / 0.993`｜Gera 2022 接觸目標原文 `0.814 / 0.620 / 0.945`｜Ding 2022 維基 BERT `0.796 / 0.573 / 0.902`｜原版 WC-SBERT `0.840 / 0.638 / 0.881`｜**新版 WC-SBERT `0.847 / 0.649 / 0.886`**｜Gemma 2 ZS/FS `0.832 / 0.659 / 0.915`）。
- **Callout (teal)**：**閱讀基準必查條件**：Gera (2022) 雖在 DBpedia 達 `0.945`，但仰賴目標集無標註全文迭代；WC-SBERT 堅持 0 筆目標原文，仍在 AG News 與 Yahoo 反超。
- **Footer**：來源：wiki/benchmarks/zstc-benchmarks.md (§1–3) · 2025-chi-zero-shot-topic-classification.md
- **Speaker Notes**：讀論文比較表時，永遠先看「實驗條件」再看數字。Gera (2022) 拿目標資料集做 Transductive 偽標籤，才在 DBpedia 衝到 0.945；相比之下，WC-SBERT 堅持完全不碰目標文本，依然在 AG News 與 Yahoo 勝出，並逼近全監督上限的八到九成。看完了所有亮點，下一頁我們切換到批判性視角，檢視這篇論文的四個限制與避坑點。

## Slide 10｜批判性閱讀與工程避坑（`cards` + `.stat-row`）
- **Kicker**：09 · Critical Reading & Pitfalls｜**Badge**：四大批判觀察
- **Title**：讀論文不能只看亮點：四大實務限制與檢視要點
- **Visual**：2×2 警示卡片（`.grid-2`）：
  1. （amber）**Stage 2 邊際效益極小**：DBpedia 最大跳躍來自 GPT-4o 標籤（`0.718 → 0.883`），Stage 2 僅微增 `+0.3%`；實務 MVP 可先省去 Stage 2。
  2. （rose）**本地 LLM 規格與延遲缺漏**：Table 5.19 未標明各模型參數量與確切量化格式（`q4_0` / `q4_K_M`），亦缺實測延遲（ms）與能耗（J）。
  3. （primary）**手動閾值與文表小勘誤**：自訓練閾值 `t`（0.75–0.77）仍須手調；Ch.6 p.80 載 DBpedia 升 18.5%，與 Table 5.13 實測（+16.5 pp / 相對 +23.0%）有出入。
  4. （teal）**Bi-Encoder 語意混淆上限**：DBpedia 有 `3,599` 筆 `Building` 誤分為 `Village`（簡介常提所在地），反映向量池化難區分主體與背景。
- **Callout (amber)**：**跨論文互補視角**：本 Wiki 收錄之陳冠錞 (2025) 實測了 Ollama 4-bit 在 GKE T4 的延遲與耗電量，正好補齊本篇缺少的系統能耗維度。
- **Footer**：來源：wiki/papers/2025-chi-zero-shot-topic-classification.md (§5) · llm-inference-efficiency-and-deployment.md
- **Speaker Notes**：嚴謹的精讀一定要看限制與實驗盲區。這四點特別值得記下：第一，做原型時靠「剪枝預訓練＋GPT 標籤」就能吃下九成以上紅利；第二，Table 5.19 少了參數量、量化版本與毫秒延遲對比，這正好可以跟 Wiki 裡陳冠錞 (2025) 的能耗實測互補；第三，閾值 t 尚未自動化且有一處百分比筆誤；第四，3,599 筆 Building 誤判為 Village 提醒我們 Bi-Encoder 的結構邊界。最後收斂成工程選型清單與討論題。

## Slide 11｜總結、決策清單與討論題（`checklist` + `.stat-row`）
- **Kicker**：10 · Takeaways & Reading-Group Q&A｜**Badge**：落地指南
- **Title**：工程選型決策清單與三道讀書會討論題
- **Visual**：
  - Stat Row：`+7.8%`（維基度數剪枝增益）｜`+23.0%`（GPT-4o 標籤於 DBpedia 相對躍升）｜`0.847`（輕量編碼器 AG News 奪冠）
  - 2 欄卡片（`.grid-2`）：
    - 左欄（`.card.teal`）**工程選型 Checklist**：① 高吞吐結構化分類 → 首選 **WC-SBERT ＋ GPT-4o 標籤**（毫秒級內積）；② 細粒度複雜語意 → **Gemma 2 本地量化**（`T=0` + JSON Schema）；③ 進階架構 → **Hybrid Routing**（以 Top-1/Top-2 Margin 篩出低信心樣本交 LLM 複核）。
    - 右欄（`.card.primary`）**讀書會討論題（Q&A）**：① 為何缺乏目標分布錨定的 APE（0.693）慘敗給人工引導標籤（0.836）？② 用 WC-SBERT Margin 路由給 Gemma 2，能否兼顧 90%+ 精度與低延遲？③ `Building → Village`（3,599 筆）揭示了 Bi-Encoder 向量池化的何種本質限制？
- **Footer**：Wiki 參考：2025-chi-*.md · wc-sbert-*.md · zstc-benchmarks.md｜快捷鍵：←/→ · N 筆記 · O 全覽 · F 全螢幕
- **Speaker Notes**：最後帶走三個關鍵數字：度數剪枝 +7.8%、GPT-4o 描述性標籤讓 DBpedia 相對躍升 +23%、以及 WC-SBERT 在 AG News 以 0.847 奪冠。面對實務專案，先用輕量編碼器加高品質標籤吃下絕大多數請求，把昂貴的 LLM 留給低信心邊界樣本。現在把時間交給大家，歡迎從右邊三道問題開始討論！
