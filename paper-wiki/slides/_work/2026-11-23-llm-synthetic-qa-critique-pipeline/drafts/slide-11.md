# Slide 11 — 總結 Checklist 與讀書會 Q&A

- **Kicker**: `10 · Takeaways & Discussion`
- **Title**: `實作 Checklist 與讀書會討論題`
- **Core Bullets**:
  - 左卡（3 條 Checklist，精簡版）：
    1. **繁中切分**：補全形標點斷點，實測 `overlap = 0` ＋ LLM 關鍵字雙軌產題。
    2. **異質嚴審**：生成與審查分模型；Groundedness 務必納入 `Answer` 審查。
    3. **RAFT 對齊**：小模型以 80/20 干擾設定微調，鎖定訓練與推論 Prompt 一致。
  - 右卡（3 題 Q&A，精簡版）：
    1. **Chunking**：長篇跨段推論論文上，`overlap = 0` 還會贏嗎？
    2. **成本取捨**：當代強模型＋Reranker 能否靠純 RAG 追上 RAFT？
    3. **安全評測**：醫療場景如何設計含正／負例的拒答測試集？
- **Visual Spec (`cards` 雙欄 + 精簡出處列)**:
  - 雙欄卡片各 3 條精簡要點，移除過長檔案清單以維持版面呼吸感（出處簡列於 footer，VisualUnits 控制在 ≤ 380）。
- **Citations**: `wiki/concepts/llm-synthetic-qa-critique-pipeline.md`, `wiki/papers/2024-wu-llm-finetune-dataset-from-unstructured-data.md`, `wiki/concepts/raft.md`
- **Speaker Notes**: `最後用 3 條明天就能直接套用的工程準則收尾，也歡迎大家針對右邊三個討論題分享各自做 RAG 或微調的實戰經驗！以上所有細節與原始數據都完整收錄在我們的 Paper LLM Wiki 中。謝謝大家！`
