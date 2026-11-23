# Slide 09 — 實戰發現 ③ 低品質轉拒答的雙面刃

- **Kicker**: `08 · Empirical Finding 3`
- **Title**: `低品質回收轉「拒答樣本」：巧思與過度拒答代價`
- **Core Bullets**:
  - 巧思：從 Critique 淘汰的 Low Quality 挑出部分問題，答案統一改為「非常不好意思，目前沒辦法回答您的問題」混入訓練集。
  - 代價：在全正例測試集上，加入拒答樣本使正例 Recall 降 `-0.123`、F1 降 `-0.137`。
- **Visual Spec (`bar-chart` + Callout)**:
  - 左卡：3 條精簡說明拒答樣本建構邏輯。
  - 右卡：`bar-chart` 對比 Table 4.7 vs 4.8（最佳組合 `TAIDE/Breeze/Breeze`）：
    - 含低品質拒答（Table 4.7）：`F1 0.4184` · `R 0.3048` · `P 0.6667`
    - 移除低品質拒答（Table 4.8）：**`F1 0.5556`** · **`R 0.4275`** · **`P 0.7931`**
  - 底部 Callout：工程調校須控管負樣本佔比、避免與 RAFT 20% 憑記憶作答訊號衝突，並補齊含負例的混合評測集。
- **Citations**: `wiki/concepts/llm-synthetic-qa-critique-pipeline.md`, `wiki/papers/2024-wu-llm-finetune-dataset-from-unstructured-data.md` (Table 4.7, 4.8)
- **Speaker Notes**: `把沒過審的問題回收改寫成拒答句看似零成本，但實測提醒我們：負樣本比例過高會讓模型變得過度保守。而且還要注意一個潛在衝突——RAFT 的 20% 樣本教模型「沒檢索到也要硬答」，拒答樣本卻教它「沒相關就拒答」，實作上必須明確切割邊界。下一頁我們整理復現這套系統必避的 4 大陷阱。`
