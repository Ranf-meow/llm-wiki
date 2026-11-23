# Slide 02 — 動機與定位

- **Kicker**: `01 · Problem & Positioning`
- **Title**: `封閉領域導入 LLM：四條路線為何需要新管線？`
- **Core Bullets**:
  - 痛點：台大醫院 12 份未公開繁中耳科 PDF（112 頁）不在預訓練語料中，直接問易幻覺；專家標註又需數週至數月。
- **Visual Spec (`table`)**:
  - 4 列緊湊路線比較表（欄位：`方法路線`、`人工標註`、`核心瓶頸`、`適用定位`）：
    1. `TAPT（繼續預訓練）`｜否｜耗算力，112 頁小語料難學好｜大語料全參數更新
    2. `純 RAG`｜否｜7B–8B 小模型易受干擾段落分心｜快部署、強大模型佳
    3. `Self-Instruct / Bonito`｜少｜前者無法憑空生新知；後者需另訓生成器｜通用指令擴增
    4. `合成 Q&A + RAFT（本篇）`｜幾乎免｜仰賴 Prompt 與 Critique 品質｜**封閉小語料＋開源小模型**
  - 底部 1 條重點 Callout：改以「提問 → 作答 → 審查」嚴格錨定文件 Chunk，建置時間縮至 **4 小時～1 週內**。
- **Citations**: `wiki/topics/domain-specific-llm-adaptation.md`, `wiki/papers/2024-wu-llm-finetune-dataset-from-unstructured-data.md`
- **Speaker Notes**: `延續封面背景，手邊只有 112 頁未公開繁中醫療 PDF 時，四條路線一比就很清楚：TAPT 吃算力、Self-Instruct 生不出模型沒讀過的知識、純 RAG 在小模型上又容易分心。因此 Wu (2024) 選擇第四條路——錨定文件的合成管線搭配 RAFT。接下來看整套系統的三階段全貌。`
