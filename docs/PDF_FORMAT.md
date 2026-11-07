# WordScreen PDF format / 单词本 PDF 格式规范

## English

WordScreen uses a strict **two consecutive pages per word** sequence.

| PDF page | Face | Recommended content |
|---|---|---|
| 1, 3, 5... | A — Recall | English headword, phonetic transcription, part of speech if useful, grayscale mnemonic illustration and a recall prompt |
| 2, 4, 6... | B — Reveal / Spelling | Selectable English headword near the top, illustration, Chinese meaning and optional example / word-origin content |

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
- For spelling mode, the B-page English headword must be selectable PDF text (not just part of an image) and should be placed near the top of the page. The current parser looks for a Latin headword in the upper title region.
- The current spelling overlay is designed for the supplied portrait PET layout at full-page zoom; other layouts need calibration.

### Important

Playback only needs the two-page sequence and an even page count. Spelling mode additionally extracts the B-page headword from PDF text; it does not OCR image-only headings. The plugin does not semantically validate arbitrary PDFs.

Favorites and spelling mistakes are stored by PDF path and word index. Do not overwrite a file with a different word order at the same path unless you are willing to review or clear old records.

## 简体中文

WordScreen 使用严格的**每个单词连续两页**的顺序。

| PDF 页码 | 页面 | 建议内容 |
|---|---|---|
| 1、3、5…… | A 页——主动回忆 | 英文单词、音标、必要时的词性、灰度记忆插图和回忆提示 |
| 2、4、6…… | B 页——揭晓答案 / 拼写 | 页面上方保留可选择的英文单词文本，并包含插图、中文释义；例句和词源说明可按需保留 |

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
- 拼写模式需要从 B 页提取英文标题，因此英文单词必须是可选择的 PDF 文本，不能只是图片的一部分，并建议放在页面上方。当前解析器会在标题区域寻找拉丁字母单词。
- 当前拼写遮挡层针对原 PET 纵向版式的整页显示设计；其他版式需要重新校准。

### 重要说明

自动播放只要求 PDF 按每词两页排列且总页数为偶数。拼写模式还会从 B 页 PDF 文本中提取英文标题，不会对图片中的标题进行 OCR。插件不会对任意 PDF 进行语义校验。

收藏和错题按 PDF 文件路径及单词序号保存。如果在相同路径覆盖词序不同的新文件，旧记录可能对应到其他单词；除非愿意重新检查或清空记录，否则不要这样操作。
