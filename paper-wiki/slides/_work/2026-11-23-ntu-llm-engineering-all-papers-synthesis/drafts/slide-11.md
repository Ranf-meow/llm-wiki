# Slide 11 — 終極整合藍圖（Unified Hybrid Architecture）

- **Kicker**: 10 · Unified System Blueprint
- **Title**: 四篇合體！下一代高準確、低成本、綠能混合 LLM 架構
- **Core Takeaway**: 將四篇互補技術串聯成單一分層管線，用輕量路由、動態閾值快取與雙軌專家推理同時優化準確率、延遲與碳排。
- **Visual Spec (`svg-diagram` + `.callout`)**:
  - 寬幅端到端整合架構 SVG（viewBox `0 0 960 255`）：
    - 入口：`線上使用者請求` → **閘道一（戚得郁 2025）**：`WC-SBERT 意圖分類與風險定級`
      - 結構化分類且高信心 Margin → 直接毫秒級回傳！
      - 需生成／推理請求 → **閘道二（陳冠錞 2025）**：`差異化閾值 GPTCache（FAQ 設寬省電 / 醫療設嚴防錯 + Kepler/DCGM 監控）`
        - Cache Hit → `CPU 卸載 ~108ms 回傳 (-43.7% 能耗)`
        - Cache Miss → 依知識來源分流兩大專家引擎：
          - 引擎 A（未公開封閉文件，**吳葦誠 2024**）：`Critique 合成 ＋ RAFT 微調 7B 專家`
          - 引擎 B（複雜多輪推理，**吳承光 2024**）：`ZS-DRCoT ＋ Round-Robin 異質共享記憶（Critique 輔助回饋寫入）`
  - Callout (teal)：**跨論文互補閉環**：戚得郁補齊快取前的意圖分級；陳冠錞補齊戚得郁缺少的系統延遲與能耗監控；吳葦誠的 Critique 審查可協助解除吳承光對即時黃金標籤的依賴！
- **Citations**: `wiki/topics/domain-specific-llm-adaptation.md` (§4), `wiki/topics/llm-inference-efficiency-and-deployment.md` (§1–3)
- **Speaker Notes**: 這張圖就是「建立 Paper LLM Wiki」最大的複利價值——單篇看只是四個點，連起來就變成一整套可落地的企業級架構！請求進來先過 WC-SBERT：純分類高信心直接秒回；需要生成的先過依風險設定差異化閾值的語意快取，安全省下大量 GPU 電力；真正打穿快取的難題，再依「未公開小語料」走 RAFT 專家小模型，或依「複雜推理」走 ZS-DRCoT 異質共享記憶，甚至用 Critique LLM 幫記憶庫把關。最後一頁收斂成實戰選型清單與討論題。
