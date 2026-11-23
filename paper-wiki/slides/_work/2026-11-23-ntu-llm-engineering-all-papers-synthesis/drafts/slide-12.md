# Slide 12 — 總結、決策清單與討論題（Takeaways & Q&A）

- **Kicker**: 11 · Decision Checklist & Reading-Group Q&A
- **Title**: 工程選型決策清單與跨論文讀書會討論題
- **Core Takeaway**: 面對新專案先問四個問題決定落點，並帶著三道跨論文融合議題進入讀書會深度思辨。
- **Visual Spec (`checklist` + `.stat-row`)**:
  - 上方 4 枚全館代表數字（`.stat-row`）：`0.556 F1`（RAFT 突破純 RAG 瓶頸）｜`90.48%`（O(1) 異質共享記憶）｜`0.847`（WC-SBERT 勝全數 LLM）｜`-43.7%`（0.75 快取省電 vs. 0.85 反轉 +12.7%）
  - 下方 2 欄卡片（`.grid-2`）：
    - 左欄（`.card.teal`）**四步實戰選型 Checklist**：
      - ① **結構化分類？** → 先上 **WC-SBERT ＋ GPT-4o 標籤**，別直接燒 LLM。
      - ② **未公開封閉小語料？** → 用 **Critique 過濾 ＋ RAFT 微調**，避開 7B 純 RAG 分心。
      - ③ **模型已有基礎知識需複雜推理？** → 上 **JSON CoT ＋ O(1) 異質共享記憶**，免改權重。
      - ④ **高重複線上推論？** → 裝 **語意快取並監控 Hit Rate／功耗**，嚴防跨過效益反轉點。
    - 右欄（`.card.primary`）**跨論文讀書會討論題（Q&A）**：
      - **Q1（記憶 vs. 微調）**：把吳承光的共享記憶庫套在吳葦誠的耳科問答，能否取代 QLoRA 微調？
      - **Q2（自動審查補回饋）**：沒有即時標準答案 `fb_t` 時，能否用吳葦誠的 Critique LLM 決定是否寫入記憶庫？
      - **Q3（綠能與精度三角）**：若在陳冠錞的語意快取補上答錯率指標並以 WC-SBERT 分流閾值，最佳操作點會落在哪裡？
- **Citations**: `wiki/topics/domain-specific-llm-adaptation.md`, `wiki/topics/llm-inference-efficiency-and-deployment.md`, 四篇 `wiki/papers/*.md` (§6)
- **Speaker Notes**: 最後用一分半鐘幫大家收尾。這四篇台大論文涵蓋了從資料合成、免微調推理、模型降維到雲端減碳的完整光譜。下次規劃 AI 系統時，不妨拿左邊這四條檢查表逐一過濾——先降維、再看是否改權重、善用異質互補、上線盯緊反轉點。接下來把時間交給大家，歡迎針對右邊三道跨論文融合題展開討論！
