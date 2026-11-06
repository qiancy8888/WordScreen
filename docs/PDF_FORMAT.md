# WordScreen PDF format / 单词本 PDF 格式规范

## English

WordScreen uses a strict **two consecutive pages per word** sequence. It does not perform OCR, text extraction, semantic page detection or automatic layout recognition.

### Page sequence

| PDF page | Face | Recommended content |
|---|---|---|
| 1, 3, 5... | A — Recall | English headword, phonetic transcription, part of speech if useful, one grayscale mnemonic illustration, and a short recall prompt such as “What does it mean?” |
| 2, 4, 6... | B — Reveal | Chinese meaning, concise explanation, and one or more useful English example sentences with translations if desired |

The plugin maps pages as follows:

- Word 1 = PDF pages 1 (A) and 2 (B)
- Word 2 = PDF pages 3 (A) and 4 (B)
- Word N = pages `2N-1` (A) and `2N` (B)

### Required constraints

- PDF page count must be even and at least 2.
- No separate cover, contents, introduction, answer key or blank page may be inserted into the sequence.
- Keep the order A then B for every word.
- Use a consistent page size and orientation throughout the document.
- Grayscale, high-contrast artwork is recommended for e-ink screens.
- Leave clear space in the upper-right title area for the heart overlay. The current overlay is screen-relative, so the reserved area should be tested on the target device.

### Important

The plugin only checks the filename extension and even page count. A random even-page PDF can pass this basic check even if it is not a vocabulary book. Correct semantic ordering is the responsibility of the PDF author.

Favorites are stored by PDF path and word index. Do not overwrite a file with a different word order at the same path unless you are willing to review or clear the old favorites.

## 简体中文

WordScreen 使用严格的**每个单词连续两页**的顺序。插件不会进行 OCR、文字提取、语义识别或自动版式识别。

### 页面顺序

| PDF 页码 | 页面 | 建议内容 |
|---|---|---|
| 1、3、5…… | A 页——主动回忆 | 英文单词、音标、必要时的词性、一幅灰度记忆插图，以及“What does it mean?”之类的回忆提示 |
| 2、4、6…… | B 页——揭晓答案 | 中文释义、简短解释，以及一条或多条实用英文例句；可附中文翻译 |

插件按以下方式映射页面：

- 第 1 个单词 = PDF 第 1 页（A）和第 2 页（B）
- 第 2 个单词 = PDF 第 3 页（A）和第 4 页（B）
- 第 N 个单词 = PDF 第 `2N-1` 页（A）和第 `2N` 页（B）

### 必须遵守的约束

- PDF 总页数必须是大于等于 2 的偶数。
- 不要在单词序列中插入独立封面、目录、前言、答案汇总或空白页。
- 每个单词必须先 A 页、后 B 页。
- 全部页面应使用一致的尺寸和方向。
- 电子墨水屏建议使用灰度、高对比度插图。
- 标题右上方应预留红心覆盖层的位置。当前红心采用屏幕相对坐标，必须在目标设备上检查是否遮挡文字。

### 重要说明

插件只检查文件扩展名和 PDF 总页数是否为偶数。任意偶数页 PDF 都可能通过基础检查，即使它并不是单词本。页面语义和 A/B 顺序必须由单词本制作者保证。

收藏按 PDF 文件路径和单词序号保存。如果在相同路径覆盖词序不同的新文件，旧收藏可能对应到错误单词；除非愿意重新检查或清空收藏，否则不要这样操作。
