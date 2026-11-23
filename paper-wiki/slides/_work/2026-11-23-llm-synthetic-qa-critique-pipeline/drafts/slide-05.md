# Slide 05 — Step 2 角色扮演與關鍵字雙軌生成

- **Kicker**: `04 · Step 2 — Synthetic Generation`
- **Title**: `角色扮演（Role-Playing）與關鍵字雙軌生成`
- **Core Bullets**:
  - Question Generator（病患 / 資淺醫師）：整段 5 題 ＋ 單一關鍵字各 2 題 = **11 題 / chunk**，破除原段落敘事視角限制。
  - Answer Generator（資深專科醫師）：純依該 chunk 每題生成 **3 個候選答案**（`max_new_tokens = 600`）。
- **Visual Spec (`stat-row` + 2 Role Cards)**:
  - 上半部 2 張角色卡（Question Gen vs Answer Gen，精簡條列各 3 條）。
  - 下半部 4 格 `stat-row` 量產漏斗（以 `(512, 0)` 為例）：`243 Chunks` → `~2,673 題 (×11)` → `~8,019 組候選 (×3)` → `~36% 嚴審留存`。
- **Citations**: `wiki/concepts/llm-synthetic-qa-critique-pipeline.md`, `wiki/papers/2024-wu-llm-finetune-dataset-from-unstructured-data.md` (Sec. 3.2, 4.2)
- **Speaker Notes**: `這裡有兩個很實用的 Prompt 巧思：第一是用病患與專科醫師角色扮演，讓提問口吻貼近真實問診；第二是只給單一關鍵字強制額外提問，避免模型只會把段落標題改寫成問題。量產出約 8,000 組候選後，下一頁看 Critique LLM 如何把關篩選。`
