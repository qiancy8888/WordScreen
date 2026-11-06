# WordScreen for KOReader

**面向 KOReader 与电子墨水屏设备的 PDF 英语单词学习插件。**

Copyright (C) 2026 qiancy8888

[English](README.md) | [安装指南](docs/INSTALLATION.md) | [单词本 PDF 格式](docs/PDF_FORMAT.md) | [实机验收状态](docs/TESTING.md) | [版本记录](CHANGELOG.md)

> **项目状态：预览版 / 实验性。** 当前源代码快照为 v0.3.0。插件已在 Kindle Paperwhite 1（PW1）的实际使用流程中开发；但 v0.3.0 的断点续播和 Kindle 原生书库快捷启动仍需实机验收。不要将所有功能理解为已经在所有 Kindle 型号上验证通过。

## 项目简介

WordScreen 将符合固定格式的 PDF 单词本转换为两阶段学习流程：

1. **A 页——主动回忆：** 英文单词、音标和灰度记忆插图。
2. **B 页——揭晓答案：** 中文释义和英文例句。

插件自动在同一单词的两页之间切换，再进入下一个单词。

## 当前源代码包含的功能

- 每个单词连续占用两页 PDF（A 页在前，B 页在后）。
- A/B 两阶段自动播放，默认每页 4 秒。
- 全部单词无限循环、收藏夹单词无限循环。
- 播放时左滑进入下一个单词，右滑返回上一个单词。
- 页面顶部单词标题附近显示小红心，可收藏或取消收藏。
- 收藏数据保存在 KOReader 本地设置中，以 PDF 路径和词条序号作为索引。
- v0.3.0 实现了断点续播：保存 PDF 页码，并尝试在再次打开指定 PDF 时恢复播放。
- 可选通过独立的 Kindle PDF 启动组件（例如 KPVBooklet）从 Kindle 原生书库打开 PDF；本仓库不包含该启动组件。

## 运行要求

- 目标设备已安装并能正常运行 KOReader。
- 单词本 PDF 符合 [WordScreen PDF 格式规范](docs/PDF_FORMAT.md)。
- WordScreen 播放期间关闭 KOReader 内置 AutoTurn，避免两个自动翻页机制冲突。

WordScreen 是第三方 KOReader 插件。本项目不包含 KOReader 主程序、Kindle 越狱文件、KUAL、MRPI、KPVBooklet、单词本 PDF、字体或插图素材。

## 安装

请阅读双语[安装指南](docs/INSTALLATION.md)。插件最终目录必须为：

```text
koreader/plugins/wordscreen.koplugin/
├── main.lua
├── _meta.lua
└── heartoverlay.lua
```

## 兼容性与验证情况

项目维护者的主要测试设备为 Kindle Paperwhite 第一代（PW1 / B024），固件 5.6.1.1，已安装 KOReader。维护者反馈 KOReader 可以在该设备启动并打开 PDF，早期 WordScreen 插件菜单也曾成功出现并可用。

v0.3.0 的断点续播和 Kindle 原生书库启动属于**预览实现**，仍需在真实设备上验收。KPVBooklet 是独立项目，必须单独核实它与具体 Kindle 型号、固件的兼容性。详见[实机验收状态](docs/TESTING.md)。

其他 Kindle 型号和固件版本暂不宣称兼容。

## 当前限制

- 插件只检查当前文档是否为页数不少于 2 的偶数页 PDF；**不会读取 PDF 文字，也不会判断页面语义是否正确**。
- PDF 不应有封面、目录或额外空白页，除非这些页面也被有意纳入“两页一个单词”的顺序。
- 收藏按 PDF 文件路径和单词序号保存，不按单词文本保存。同一路径覆盖了词序不同的新 PDF，旧收藏可能指向其他单词。词库有较大变化时请使用新文件名。
- 红心覆盖层使用屏幕相对坐标，PDF 版式需要在标题右上方预留空间。
- 插件请求 KOReader 暂停自身自动休眠，不代表可以阻止 Kindle 系统层休眠或屏保。
- 当前代码收到 KOReader 挂起事件时会保存进度并停止播放；不承诺设备休眠期间持续播放。

## 参与开发

提交修改前请阅读 [CONTRIBUTING.md](CONTRIBUTING.md) 和[实机测试矩阵](docs/TESTING.md)。提交问题时请注明 Kindle 型号、固件版本、KOReader 版本、PDF 页数和相关日志。截图或日志中请去掉序列号、Wi-Fi MAC 地址和私人词库内容。

## 许可证

本仓库中的 WordScreen 源代码采用 **GNU Affero 通用公共许可证第 3 版或任何后续版本（AGPL-3.0-or-later）**。完整许可证文本见 [LICENSE](LICENSE)。该许可证适用于本仓库中的 WordScreen 文件；KOReader、KPVBooklet 等第三方组件仍是独立项目，继续遵循各自的许可证。

## 免责声明

WordScreen 是独立社区项目，与 Amazon 或 KOReader 项目没有隶属关系。Kindle 是 Amazon 的商标。使用第三方越狱与插件的风险由使用者自行承担。
