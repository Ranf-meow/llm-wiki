# Slide 02 — 全景地圖（Lifecycle Map）

- **Kicker**: 01 · End-to-End Lifecycle Map
- **Title**: 四篇論文如何拼出完整 LLM 工程生命週期？
- **Core Takeaway**: 從改權重微調、免微調推理、模型降維到快取部署，四篇論文恰好對應現代 AI 系統最關鍵的四道工程層級。
- **Visual Spec (`svg-diagram`)**:
  - 橫向四階段生命週期流程 SVG（viewBox `0 0 960 250`）：
    - Layer 1（indigo）：`資料建置與權重適配`｜吳葦誠 (2024)｜合成 Q&A ＋ Critique ＋ RAFT 微調｜解「封閉未見知識」
    - Layer 2（teal）：`免微調推理與持續記憶`｜吳承光 (2024)｜ZS-DRCoT ＋ O(1) 異質共享記憶｜解「多輪臨床推理」
    - Layer 3（amber）：`模型降維與本地量化`｜戚得郁 (2025)｜WC-SBERT vs. Ollama 量化 LLM｜解「零樣本分類性價比」
    - Layer 4（rose）：`線上快取與綠能觀測`｜陳冠錞 (2025)｜GPTCache ＋ Kepler/DCGM 閾值調優｜解「推論延遲與耗電」
    - 下方貫穿箭頭：`共通設計主軸：異質互補 · 結構化格式鎖定 · 批判實驗檢核`
- **Callout**: 四篇分屬不同任務，卻共同回答一個核心問題：**如何在精度、成本、延遲與耗電之間找到最佳工程平衡點？**
- **Citations**: `wiki/topics/domain-specific-llm-adaptation.md`, `wiki/topics/llm-inference-efficiency-and-deployment.md`
- **Speaker Notes**: 大家可以先把這四篇想成蓋一棟 LLM 應用大樓的四層樓：第一層吳葦誠解決「模型根本沒讀過內部文件怎麼辦」；第二層吳承光解決「模型已經懂基礎知識，如何不微調就越做越準」；第三層戚得郁提醒我們「別什麼任務都拿大砲打小鳥，輕量編碼器有時更強」；第四層陳冠錞則盯緊生產環境的電費帳單，揭露語意快取的耗電陷阱。下一頁我們先用一張總表建立全局錨點。
