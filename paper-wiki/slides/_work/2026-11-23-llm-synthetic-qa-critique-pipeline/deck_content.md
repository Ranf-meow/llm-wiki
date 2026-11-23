# Deck Content（Reduce 整合定稿）— LLM 合成問答與 Critique 過濾管線

- **Slug**：`2026-11-23-llm-synthetic-qa-critique-pipeline`
- **C2a 單頁本地檢查**：`11 / 11 PASS`（0 幻覺數據、0 局部重試）
- **C2b 跨頁連貫性檢查**：`PASS`
  - 術語全份統一：`Question Generator LLM`、`Answer Generator LLM`、`Critique LLM`、`Final LLM`、`Breeze-7B`、`TAIDE-8B`、`RAFT`、`QLoRA`
  - 視覺節奏：非封面 10 頁中 9 頁含結構化視覺元件（`90%`），最大連續純文字頁數 = `1`
  - 過場銜接：全 11 頁 Speaker Notes 皆具前後頁承接轉場語句

---

## Slide 01｜封面（`cover`）
- **標題**：LLM 合成問答與 Critique 過濾管線
- **副標**：以通用開源 LLM、繁中標點 Chunking、多角色審查與 RAFT 開書微調，免人工標註建構封閉領域專業問答模型
- **資訊卡**：Wu (2024) NTU CSIE 碩論（`10.6342/NTU202401905`）｜台大醫院耳科遺傳性聽損 12 份繁中 PDF（112 頁）｜StateGraph 讀書會簡報（20 分鐘）
- **講者筆記**：歡迎來到本次 20 分鐘的讀書會分享！今天我們從工程實作的角度，拆解如何在完全沒有人工標註的封閉醫療領域，用現成開源 LLM 打造高品質微調資料集。下一頁我們先看為什麼既有方法在這個場景會卡關。

---

## Slide 02｜動機與定位（`table`）
- **標題**：封閉領域導入 LLM：四條路線為何需要新管線？
- **四路線比較表**：
  | 方法路線 | 人工標註 | 核心瓶頸 | 適用定位 |
  | :--- | :---: | :--- | :--- |
  | TAPT（繼續預訓練） | 否 | 耗算力，112 頁小語料難學好 | 大語料全參數更新 |
  | 純 RAG | 否 | 7B–8B 小模型易受干擾段落分心 | 快部署、強大模型佳 |
  | Self-Instruct / Bonito | 少 | 前者無法生新知；後者需另訓生成器 | 通用指令擴增 |
  | **合成 Q&A + RAFT（本篇）** | **幾乎免** | **仰賴 Prompt 與 Critique 品質** | **封閉小語料＋開源小模型** |
- **重點 Callout**：針對台大醫院 12 份未公開繁中耳科 PDF，以「提問 → 作答 → 審查」嚴格錨定文件 Chunk，建置時間從數月縮至 **4 小時～1 週內**。
- **出處**：`wiki/topics/domain-specific-llm-adaptation.md` · Wu (2024) Ch.1–2
- **講者筆記**：延續封面背景，手邊只有 112 頁未公開繁中醫療 PDF 時，四條路線一比就很清楚：TAPT 吃算力、Self-Instruct 生不出模型沒讀過的知識、純 RAG 在小模型上又容易分心。因此 Wu (2024) 選擇第四條路——錨定文件的合成管線搭配 RAFT。接下來看整套系統的三階段全貌。

---

## Slide 03｜架構總覽（`svg-diagram`）
- **標題**：三階段模組化流水線：從 PDF 到開書考模型
- **視覺**：三階段內嵌 SVG 流程圖（Stage 1 前處理 → Stage 2 合成與 Critique 過濾 → Stage 3 RAFT 微調與推論）
- **數據摘要**：`3 大可替換 LLM 模組`｜`11 題 × 3 答 / Chunk`｜`4 小時～<1 週建置`
- **出處**：`wiki/papers/2024-wu-llm-finetune-dataset-from-unstructured-data.md` · Fig. 1.1 & 3.3
- **講者筆記**：看完動機，這張架構圖是接下來每一頁的地圖。整套管線分成前處理、合成與審查、以及 RAFT 微調三個階段，最大特色是完全模組化——裡面的開源 LLM 都能各自獨立替換。接下來我們從 Stage 1 的繁中 Chunking 細節切入。

---

## Slide 04｜Step 1 前處理（`bar-chart` + `pill-row`）
- **標題**：繁中標點 Chunking：為何 `overlap = 0` 反而更準？
- **左卡**：Table 4.2 斷點表（`\n`, `\n\n`, `" "`, `.`, `,`, `\u200B`, `，`, `、`, `．`, `。`）＋ LLM 關鍵字實例（`性聯遺傳, POU3F4(DFNX2), 粒線體遺傳`）
- **右卡**：Table 4.4 Top-1 檢索命中率長條圖（`acge_text_embedding`，Top-5 皆 100%）：`(512, 0)` Breeze `67.48%` / TAIDE `64.82%` 全面勝過 `overlap=100`（`57.20%` / `57.14%`）
- **出處**：`wiki/papers/2024-wu-llm-finetune-dataset-from-unstructured-data.md` · Table 4.2 & 4.4
- **講者筆記**：進入 Stage 1 的第一個反直覺發現：大家做 RAG 常習慣設 overlap=100，但實測顯示配合全形標點斷點後，overlap=0 在兩款模型上都比 overlap=100 高出約 10 個百分點。原因在於重疊文字會讓相鄰 chunk 向量過於接近、干擾 Top-1 排名。切好段落並抽出關鍵字後，下一頁看怎麼用角色扮演量產問答。

---

## Slide 05｜Step 2 生成（`stat-row` + 角色卡）
- **標題**：角色扮演（Role-Playing）與關鍵字雙軌生成
- **雙角色卡**：
  - `Question Generator LLM`（病患 / 資淺醫師）：整段 5 題 ＋ 單一關鍵字各 2 題 = `11 題 / chunk`
  - `Answer Generator LLM`（資深專科醫師）：純依 chunk 每題生成 `3 個候選答案`（`max_new_tokens = 600`）
- **量產漏斗（`(512, 0)`）**：`243 Chunks` → `~2,673 題` → `~8,019 組候選` → `~36% 嚴審留存`
- **出處**：`wiki/concepts/llm-synthetic-qa-critique-pipeline.md` · Wu (2024) Sec. 3.2 & 4.2
- **講者筆記**：這裡有兩個很實用的 Prompt 巧思：第一是用病患與專科醫師角色扮演，讓提問口吻貼近真實問診；第二是只給單一關鍵字強制額外提問，避免模型只會把段落標題改寫成問題。量產出約 8,000 組候選後，下一頁看 Critique LLM 如何把關篩選。

---

## Slide 06｜Step 3 審查（`grid-4` + Callouts）
- **標題**：Critique LLM：四維度品質審查與強制格式
- **四張指標卡（1–5 分）**：`Groundedness`（內文可答）、`Relevance`（像病患提問）、`Standalone`（含「在內文中」強制 1 分）、`Similarity`（淘汰複述題目）
- **雙重門檻與容錯**：各指標 `≥ 3` 且總分 `≥ 13 / 20`；強制 `評分:` ＋ `評估:`，重試錯誤率 Breeze `0.161%`（3.26s）、TAIDE `0.176%`（4.28s）
- **出處**：`wiki/concepts/llm-synthetic-qa-critique-pipeline.md` · Wu (2024) Table 4.5 & App. A.1.2
- **講者筆記**：進入最關鍵的過濾關卡。四個指標同時卡單項底線與總分，防止單一高分掩蓋缺陷；尤其 Standalone 寫死「出現『在內文中』就給 1 分」是非常值得抄進專案的規則。有趣的是，同一份審查 Prompt 交給不同模型跑，嚴格度竟差了兩倍以上——我們看下一頁的實測數據。

---

## Slide 07｜實戰發現 ①（`bar-chart` + `table`）
- **標題**：異質模型分工：TAIDE 生題 ＋ Breeze 嚴審奪冠
- **左卡（Table 4.6 通過率）**：Critique=Breeze `35.73% / 37.26%`（嚴格）vs Critique=TAIDE `79.91% / 88.45%`（寬鬆）
- **右卡（Table 4.8 全正例排名）**：`TAIDE / Breeze / Breeze` 奪冠（P `0.7931` / R `0.4275` / F1 `0.5556`），勝過單一模型組合
- **出處**：`wiki/papers/2024-wu-llm-finetune-dataset-from-unstructured-data.md` · Table 4.6 & 4.8
- **講者筆記**：這個實測很具啟發性：不要迷信從頭到尾用同一顆模型！TAIDE 審查太寬鬆，八成以上都放行；改用嚴格的 Breeze 當裁判、搭配 TAIDE 豐富語料出題，品質立刻拉開差距。洗出好資料後，下一頁看下游接 RAFT 微調的效果。

---

## Slide 08｜實戰發現 ②（`bar-chart` + RAFT 卡）
- **標題**：下游接 RAFT：單用 RAG 或微調都沒用，合用才爆發
- **左卡（RAFT 參數）**：`{P, C, Q, A}` 一致 Prompt、`top-k=5`、80%（1 正解+4 干擾）vs 20%（5 干擾）、QLoRA `r=64` / `max_seq_len=1600`
- **右卡（Table 4.9 消融，Breeze-7B）**：Vanilla `0.3592`、Fine-tuned `0.3608`、RAG `0.3471` → **Fine-tuned & RAG `0.5556`**（+0.19 F1）
- **出處**：`wiki/concepts/raft.md` · Wu (2024) Sec. 3.3 & Table 4.9
- **講者筆記**：看右邊這張消融圖就能明白為什麼要大費周章做合成資料：對 7B 小模型而言，單接 RAG 反而因為 5 段雜訊上下文分心而略降；透過 RAFT 模擬開書考微調後，F1 一次拉升超過 0.19！接著看一個容易踩雷的設計：低品質問題回收轉拒答。

---

## Slide 09｜實戰發現 ③（`bar-chart` + Callout）
- **標題**：低品質回收轉「拒答樣本」：巧思與過度拒答代價
- **左卡**：Low Quality 問題答案統一改為「非常不好意思，目前沒辦法回答您的問題」混入訓練集
- **右卡（Table 4.7 vs 4.8）**：含低品質拒答 F1 `0.4184`（R `0.3048`）vs 移除低品質拒答 F1 `0.5556`（R `0.4275`）
- **底部 Callout**：控管負樣本佔比、避免與 RAFT 20% 憑記憶作答訊號衝突，並補齊含負例測試集
- **出處**：`wiki/concepts/llm-synthetic-qa-critique-pipeline.md` · Wu (2024) Table 4.7 & 4.8
- **講者筆記**：把沒過審的問題回收改寫成拒答句看似零成本，但實測提醒我們：負樣本比例過高會讓模型變得過度保守。而且還要注意一個潛在衝突——RAFT 的 20% 樣本教模型「沒檢索到也要硬答」，拒答樣本卻教它「沒相關就拒答」，實作上必須明確切割邊界。下一頁我們整理復現這套系統必避的 4 大陷阱。

---

## Slide 10｜批判與避坑（`grid-4` 精簡警戒卡）
- **標題**：復現這套管線前，必須先避開的 4 個陷阱
- **四張精簡警戒卡**：
  1. **Groundedness 漏餵 Answer**：附錄 Fig. A.1 僅餵 `Q+Context` → 復現必改餵 `(Context, Q, A)`。
  2. **小語料檢索偏差**：112 頁讓 Top-5 輕鬆 100% → 擴展規模須補 Hybrid Search + Reranker。
  3. **關鍵字評估盲區**：僅驗 3 字面關鍵字且缺人工評分表 → 抓不到「中字但因果錯」幻覺。
  4. **公開基準公平性**：PubMedQA `95.6` vs Bonito `27.0` → 須核對雙方是否同等開書 RAG。
- **出處**：`wiki/papers/2024-wu-llm-finetune-dataset-from-unstructured-data.md` · `wiki/benchmarks/pubmedqa.md`
- **講者筆記**：讀書會最有價值的就是幫大家提前排雷！這 4 個坑是我們比對論文正文與附錄抓出來的：最隱蔽的是坑 1，附錄的 Groundedness Prompt 根本沒把 Answer 傳進去；坑 4 則提醒看 PubMedQA 95.6 分時，別忘了核對開書與閉書的比較公平性。最後一頁收斂成 3 條實作 Checklist 與討論題。

---

## Slide 11｜總結與 Q&A（`cards` 精簡雙欄）
- **標題**：實作 Checklist 與讀書會討論題
- **左卡（3 條 Checklist）**：
  1. **繁中切分**：補全形標點斷點，實測 `overlap = 0` ＋ LLM 關鍵字雙軌產題。
  2. **異質嚴審**：生成與審查分模型；Groundedness 務必納入 `Answer`。
  3. **RAFT 對齊**：小模型採 80/20 干擾微調，鎖定訓練與推論 Prompt 一致。
- **右卡（3 題 Q&A）**：
  1. **Chunking**：長篇跨段推論論文上，`overlap = 0` 還會贏嗎？
  2. **成本取捨**：當代強模型＋Reranker 能否靠純 RAG 追上 RAFT？
  3. **安全評測**：醫療場景如何設計含正／負例的拒答測試集？
- **出處**：`wiki/concepts/llm-synthetic-qa-critique-pipeline.md` · `2024-wu-*.md` · `raft.md`
- **講者筆記**：最後用 3 條明天就能直接套用的工程準則收尾，也歡迎大家針對右邊三個討論題分享各自做 RAG 或微調的實戰經驗！以上所有細節與原始數據都完整收錄在我們的 Paper LLM Wiki 中。謝謝大家！
