# WordScreen for KOReader

**面向 KOReader 与电子墨水屏设备的 PDF 单词播放及拼写练习插件。**

Copyright (C) 2026 qiancy8888

[English](README.md) | [安装指南](docs/INSTALLATION.md) | [单词本 PDF 格式](docs/PDF_FORMAT.md) | [实机验收状态](docs/TESTING.md) | [版本记录](CHANGELOG.md)

> **当前版本：v0.4.3。** 拼写练习整合流程已由维护者在 Kindle Paperwhite 1（PW1 / B024）、固件 5.6.1.1、KOReader 2026.07.1 上实机测试。暂不宣称兼容其他 Kindle 型号或 KOReader 版本。

## 功能

- 每个单词连续使用 PDF 两页：A 页（主动回忆）和 B 页（揭晓答案）。
- A/B 定时播放、全部单词循环、收藏夹循环。
- 收藏和播放续播设置持久化保存。
- 拼写练习直接集成在原 WordScreen 插件中，不需要独立拼写插件。
- 拼写模式复用 KOReader 当前打开的 PDF，只显示 B 页（第 2、4、6……页）。
- 临时遮挡英文单词、音标、英文例句和底部词源提示，保留原 PDF 插图和中文释义；不修改 PDF 文件。
- 直接弹出 KOReader 虚拟键盘，输入字母实时显示在圆角方格中，不显示输入对话框。
- 答对后自动跳转下一词；答错后自动保存错题、显示正确答案，并等待手动滑动切换。
- 拼错后关闭模态键盘宿主，释放阅读页面滑动；切换单词后重新弹出键盘。
- 错题保存在原 WordScreen 设置文件中；连续答对三次后从待复习列表移出。

## 安装

请阅读双语[安装指南](docs/INSTALLATION.md)。更新前备份插件目录和 `koreader/settings/wordscreen_koreader.lua`。将仓库或发布包中的 `koreader/` 文件夹复制到 Kindle USB 根目录即可，无需替换原来的 PDF。

插件目录：

```text
koreader/plugins/wordscreen.koplugin/
├── _meta.lua
├── main.lua
├── heartoverlay.lua
├── spelling.lua
└── spellingoverlay.lua
```

## 运行要求与限制

- 设备已安装 KOReader，并能正常打开 PDF。
- PDF 总页数必须为偶数，每个单词严格连续占两页。
- 拼写模式从 B 页可选择的 PDF 文本中提取英文标题；不会对图片中的标题进行 OCR。
- 拼写遮挡层按原 PET 纵向 PDF 的整页显示布局设计。v0.4.3 尚未验证 849 词 / 1698 页版本，以及其他缩放、裁切布局。
- 本仓库不包含 KOReader、Kindle 越狱组件、KUAL、MRPI、KPVBooklet、单词本 PDF、字体或插图资源。

## 实机验证

用户已在 PW1 + KOReader 2026.07.1 上确认 v0.4.3 的以下功能：拼写模式正常进入、键盘直接弹出、输入字母实时显示、答对自动跳词、答错自动保存并显示答案、拼错后左右滑动切词正常，原有播放模式仍可使用。详见[实机验收状态](docs/TESTING.md)。

以上为单台设备的实测反馈，不构成对其他型号和固件的兼容性保证。

## 参与开发

提交修改前请阅读 [CONTRIBUTING.md](CONTRIBUTING.md) 和[实机测试矩阵](docs/TESTING.md)。提交问题时请注明 Kindle 型号、固件、KOReader 版本、PDF 页数和相关日志。截图或日志中请去掉序列号、Wi-Fi MAC 地址和私人词库内容。

## 许可证

本仓库中的 WordScreen 源代码采用 **GNU Affero 通用公共许可证第 3 版或任何后续版本（AGPL-3.0-or-later）**。完整许可证见 [LICENSE](LICENSE)。

## 免责声明

WordScreen 是独立社区项目，与 Amazon 或 KOReader 项目没有隶属关系。Kindle 是 Amazon 的商标。使用第三方越狱与插件的风险由使用者自行承担。
