# Slide 07 — 實戰發現 ① 異質模型分工

- **Kicker**: `06 · Empirical Finding 1`
- **Title**: `異質模型分工：TAIDE 生題 ＋ Breeze 嚴審奪冠`
- **Core Bullets**:
  - 相同 Critique Prompt 下，Breeze 通過率僅 `35.7%–37.3%`（嚴格），TAIDE 放行達 `79.9%–88.5%`（寬鬆）。
  - 8 種排列組合以 `TAIDE (Gen) + Breeze (Critique) + Breeze (Final)` 表現最佳（F1 `0.5556`）。
- **Visual Spec (`bar-chart` + `table`)**:
  - 左卡：`bar-chart` 展示 Table 4.6 通過率（Breeze→Breeze `35.73%`、TAIDE→Breeze `37.26%`、TAIDE→TAIDE `79.91%`、Breeze→TAIDE `88.45%`）。
  - 右卡：精簡 Table 4.8 排名表（不含低品質拒答樣本，前 4 名＋全 TAIDE 對照）＋ 1 句分工原因：TAIDE 語料廣度適合生題，Breeze ICL 穩定適合嚴審與開書作答。
- **Citations**: `wiki/papers/2024-wu-llm-finetune-dataset-from-unstructured-data.md` (Table 4.6, 4.8)
- **Speaker Notes**: `這個實測很具啟發性：不要迷信從頭到尾用同一顆模型！TAIDE 審查太寬鬆，八成以上都放行；改用嚴格的 Breeze 當裁判、搭配 TAIDE 豐富語料出題，品質立刻拉開差距。洗出好資料後，下一頁看下游接 RAFT 微調的效果。`
