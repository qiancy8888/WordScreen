# Installation / 安装指南

## English

### Requirements

- KOReader is already installed and can open PDF documents.
- The vocabulary PDF follows the [two-pages-per-word format](PDF_FORMAT.md).
- Disable KOReader's built-in AutoTurn before starting WordScreen.
- v0.3.1-rc1 updates KOReader's activity bookkeeping on timed page turns; it does not force-disable the Kindle system screensaver or KeepAlive.

This guide installs only the WordScreen plugin. It does not cover Kindle jailbreaking or installation of KOReader itself.

### Install or update

1. Stop WordScreen if it is playing, then completely exit KOReader.
2. Connect the Kindle to a computer by USB.
3. Back up the existing `koreader/plugins/wordscreen.koplugin/` directory.
4. Extract the release archive. Copy its `koreader/` directory to the Kindle USB root and merge/overwrite when prompted.
5. Confirm these files exist at the exact paths:

   ```text
   Kindle/koreader/plugins/wordscreen.koplugin/main.lua
   Kindle/koreader/plugins/wordscreen.koplugin/_meta.lua
   Kindle/koreader/plugins/wordscreen.koplugin/heartoverlay.lua
   ```

6. Safely eject the Kindle and start KOReader.
7. Open a WordScreen-formatted PDF. Find **WordScreen - PDF Vocabulary** in KOReader's Tools / More tools menu.

### First run

1. Turn off KOReader AutoTurn.
2. Open the vocabulary PDF in single-page view. Fit the full page to the screen; avoid continuous scrolling for this fixed-page learning layout.
3. Use **Start ALL from FIRST word** to test the complete book, or **Resume HERE + enable home shortcut** to start at the current page and select this PDF for quick resume.
4. Use **Start FAVORITES - endless loop** after adding favorites with the heart control.
5. Use **STOP WordScreen (save position)** in the plugin menu to stop and save the current A/B page.

### Update without losing favorites

- Back up the plugin folder before replacing it.
- Do not delete `koreader/settings/wordscreen_koreader.lua`; it stores favorites and resume settings.
- Keep the PDF path stable if you want the existing favorites to remain associated with the same book.
- If the word order changes, use a new PDF filename. Favorites are indexed by path and word number, not by the word text.

### Native Kindle home-screen shortcut (experimental)

The plugin itself does not create a Kindle home-screen application icon. The v0.3.1-rc1 code can auto-resume the selected PDF after KOReader opens it. To open a PDF from the native Kindle library directly in KOReader, a separate compatible launcher such as KPVBooklet is required. That launcher is not included here and must be installed and tested separately for the exact Kindle model and firmware. If this path is not working, use the existing KUAL → KOReader route.

### Roll back

1. Stop WordScreen and completely exit KOReader.
2. Connect USB and move `koreader/plugins/wordscreen.koplugin/` out of the plugins directory, or restore the backup you made before updating.
3. Safely eject and restart KOReader.
4. If KOReader starts normally, the issue is isolated to the plugin. Keep the settings file unless you intentionally want to remove favorites and resume data.

## 简体中文

### 安装要求

- 已安装 KOReader，并能正常打开 PDF。
- 单词本符合[每词两页的格式规范](PDF_FORMAT.md)。
- 启动 WordScreen 前，关闭 KOReader 内置 AutoTurn 自动翻页。
- v0.3.1-rc1 在定时翻页时更新 KOReader 的活动计时；不会强制关闭 Kindle 系统屏保或 KeepAlive。

本指南只安装 WordScreen 插件，不包含 Kindle 越狱或 KOReader 主程序安装步骤。

### 安装或更新

1. 如果 WordScreen 正在播放，先停止播放，然后完全退出 KOReader。
2. 用 USB 将 Kindle 连接到电脑。
3. 备份现有的 `koreader/plugins/wordscreen.koplugin/` 文件夹。
4. 解压发布包，将其中的 `koreader/` 文件夹复制到 Kindle USB 根目录；出现提示时合并并覆盖同名文件。
5. 确认以下文件位于准确路径：

   ```text
   Kindle/koreader/plugins/wordscreen.koplugin/main.lua
   Kindle/koreader/plugins/wordscreen.koplugin/_meta.lua
   Kindle/koreader/plugins/wordscreen.koplugin/heartoverlay.lua
   ```

6. 安全弹出 Kindle，启动 KOReader。
7. 打开符合格式的单词本 PDF，在 KOReader 的“工具 / 更多工具”菜单中找到 **WordScreen - PDF Vocabulary**。

### 首次使用

1. 关闭 KOReader 内置 AutoTurn。
2. 打开单词本 PDF，使用单页模式；缩放选择适应整页。固定版式学习卡不建议使用连续滚动。
3. 使用 **Start ALL from FIRST word** 从第一词开始测试；或使用 **Resume HERE + enable home shortcut** 从当前页开始，并将这份 PDF 设为快速续播词库。
4. 收藏若干单词后，使用 **Start FAVORITES - endless loop** 测试收藏夹循环。
5. 需要停止并保存位置时，在插件菜单中使用 **STOP WordScreen (save position)**。

### 更新且保留收藏

- 覆盖更新前先备份插件目录。
- 不要删除 `koreader/settings/wordscreen_koreader.lua`，其中保存收藏和续播设置。
- 如果希望旧收藏继续对应同一本词库，请保持 PDF 文件路径不变。
- 如果词序发生变化，请使用新的 PDF 文件名。收藏按文件路径和词条序号索引，而不是按单词文本索引。

### Kindle 原生书库快捷入口（实验性）

插件本身不会创建 Kindle 原生主界面的独立 App 图标。v0.3.1-rc1 代码可以在 KOReader 打开指定 PDF 后尝试自动恢复学习进度。若希望从 Kindle 原生书库直接点击 PDF 并交给 KOReader 打开，需要另行安装兼容的启动组件，例如 KPVBooklet。该启动组件不包含在本项目中，必须针对具体 Kindle 型号和固件单独安装、验收。如果这条路径不可用，仍可通过原有的 KUAL → KOReader 方式进入。

### 回滚

1. 停止 WordScreen，完全退出 KOReader。
2. 连接 USB，将 `koreader/plugins/wordscreen.koplugin/` 移出插件目录，或恢复升级前备份。
3. 安全弹出 Kindle，重新启动 KOReader。
4. 如果 KOReader 恢复正常，问题范围基本可定位在插件本身。除非明确要清空收藏和续播数据，否则保留设置文件。
