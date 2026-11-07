# Installation / 安装指南

## English

1. Completely exit KOReader before copying files.
2. Back up `koreader/plugins/wordscreen.koplugin/` and `koreader/settings/wordscreen_koreader.lua`.
3. Extract the release ZIP and copy its `koreader/` folder to the Kindle USB root, merging/overwriting the plugin files.
4. Safely eject the Kindle and restart KOReader.
5. Open the existing two-page-per-word PET PDF. In Tools / More tools, open WordScreen and choose a spelling practice command.

Do not delete `wordscreen_koreader.lua`: it stores favorites, playback settings and spelling mistakes. The PDF does not need to be replaced.

### Spelling mode

- Uses only B pages (2, 4, 6, ...); no autoplay.
- The English headword, phonetic transcription, example sentence and lower word-origin hint are masked. The illustration and Chinese meaning remain visible.
- The KOReader virtual keyboard opens directly. Typed letters appear in the rounded answer boxes.
- Correct: automatically advances to the next word. Wrong: saves the mistake, reveals the correct word and waits for a manual swipe.
- After a wrong answer, the keyboard host closes so reader swipes work; the keyboard reopens on the next word.

### Rollback

Exit KOReader and restore the backed-up plugin directory. Keep the settings file to preserve favorites and mistakes.

## 简体中文

1. 复制文件前，先完全退出 KOReader。
2. 备份 `koreader/plugins/wordscreen.koplugin/` 和 `koreader/settings/wordscreen_koreader.lua`。
3. 解压发布包，将其中的 `koreader/` 文件夹复制到 Kindle USB 根目录，合并并覆盖插件文件。
4. 安全弹出 Kindle，重新启动 KOReader。
5. 打开原来的每词两页 PET PDF，在“工具 / 更多工具”中打开 WordScreen，选择拼写练习。

不要删除 `wordscreen_koreader.lua`，其中保存收藏、播放设置和错题记录。无需替换 PDF。

### 拼写模式

- 只使用 B 页（第 2、4、6……页），不自动播放。
- 遮挡英文单词、音标、英文例句和底部词源提示；保留插图和中文释义。
- 直接弹出 KOReader 虚拟键盘，输入字母实时显示在圆角方格中。
- 答对后自动进入下一词；答错后保存错题、显示正确答案，并等待手动滑动切换。
- 拼错后关闭键盘输入宿主以释放阅读页面的滑动手势；切换单词后重新弹出键盘。

### 回滚

退出 KOReader 并恢复备份的插件目录。保留设置文件即可保留收藏和错题记录。
