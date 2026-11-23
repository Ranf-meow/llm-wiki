# Slide 08 — 跨論文法則①（異質多模型互補）

- **Kicker**: 07 · Cross-Paper Principle 1
- **Title**: 跨論文共通法則一：低成本的「異質多模型互補紅利」
- **Core Takeaway**: 兩篇論文獨立證實：讓不同架構與語料的模型分工或共享記憶，能以近乎零額外推論成本打破單模型同溫層盲區。
- **Visual Spec (`table` + `.callout`)**:
  - 3 列跨論文異質協作對照表（`<table>`）：
    - 欄位：`協作範式`｜`代表論文`｜`模型混搭方式`｜`實測互補證據`｜`推論額外成本`
    - Row 1：**離線管線分工**｜吳葦誠 (2024)｜`TAIDE-8B` 生題 ＋ `Breeze-7B` 嚴審與作答｜Breeze Critique 通過率 36%（TAIDE 84%）→ 組合 F1 **`0.5556`** 擊敗全 TAIDE (`0.4171`) 與全 Breeze (`0.5327`)｜**0**（線上仍為單一 7B 模型）
    - Row 2：**線上輪詢共享記憶**｜吳承光 (2024)｜`GPT-3.5` ＋ `Gemini-1.0` ＋ `Claude-3-Haiku` 輪流看診｜三家擅長不同上呼吸道疾病 → 共享答對推理讓準確率由單模均 `80.27%` 躍升 **`90.48%`**｜**$O(1)$**（免傳統 $O(K)$ 辯論）
    - Row 3：**大小模型混合路由（延伸）**｜戚得郁 (2025) Future Work｜輕量 `WC-SBERT` ＋ 本地 `Gemma 2`｜高信心樣本秒回、僅低 Margin 邊界交 LLM 複核｜壓低 80%+ LLM 呼叫次數
  - Callout (teal)：**統一洞見**：單一模型自產自審或自我記憶容易固守盲點；透過「離線分工」或「輪詢共享記憶」，無需昂貴即時投票就能拿到免費增益（Free Boost）。
- **Citations**: `wiki/concepts/heterogeneous-multi-llm-collaboration.md`, `wiki/papers/2024-wu-*.md`, `wiki/papers/2024-wu-ck-*.md`
- **Speaker Notes**: 把四篇擺在一起讀，第一個立刻浮現的跨論文規律就是「異質多模型互補」。吳葦誠在離線資料建置時把語料廣的 TAIDE 跟審查嚴的 Breeze 配對，線上推論依然只要跑單一 7B；吳承光則在線上讓 GPT、Gemini、Claude 輪流接單並共享答對記憶，只花 O(1) 推論成本卻繼承了三家的專長疾病。這比動輒同時呼叫五個模型投票辯論務實太多了！接著看第二個跨論文共通法則。
