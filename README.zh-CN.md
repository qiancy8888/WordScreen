# WordScreen v0.4.5

**面向 KOReader 与电子墨水屏设备的 PDF 单词播放及拼写练习插件。**

Copyright (C) 2026 qiancy8888

[English](README.md) | [安装指南](docs/INSTALLATION.md) | [单词本 PDF 格式](docs/PDF_FORMAT.md) | [实机验收状态](docs/TESTING.md) | [版本记录](CHANGELOG.md)

<badge>v0.4.5 正式稳定版</badge>

拼写练习及本次导航闪现修复已在 Kindle Paperwhite 1（PW1 / B024）、固件 5.6.1.1、KOReader 2026.07.1 上实机确认。

## 本次更新

- 拼写模式启动时取消播放器定时任务，避免残留播放回调抢占 PDF 页面。
- 播放 tick、自动启动和手动切词入口增加拼写模式保护。
- 拼写模式独占全屏滑动手势，避免 KOReader 原生 PDF 翻页与单词导航冲突。
- 增加切词过渡锁，防止一次滑动重复跳词。
- 使过期的自动跳词回调失效，避免错误切换到旧单词。
- 保留直接键盘输入、答对自动跳词、错题持久化、答错显示正确答案及手动滑动继续。

## 安装

1. 完全退出 KOReader。
2. 备份 `koreader/plugins/wordscreen.koplugin/` 和 `koreader/settings/wordscreen_koreader.lua`。
3. 将安装包中的 `koreader/` 文件夹复制到 Kindle USB 根目录，合并并覆盖插件文件。
4. 安全弹出 Kindle，重新启动 KOReader。
5. **不要删除设置文件**，其中保存收藏、播放设置和错题记录。无需替换 PDF。

## 实机验证

维护者已确认：从 `professor` 开始一轮，连续完成20个单词，第21个故意答错，向左滑动一次后直接进入第22个单词，不再闪现本轮第一个 `professor` 和第二个 `buyer`。

同时确认键盘输入、答对自动跳词、错题保存及显示正确答案、答错后滑动切词均正常。

## 运行要求

- PDF 总页数必须为偶数，每个单词严格连续占两页。
- 拼写模式从 B 页可选择的 PDF 文本提取英文标题，不支持图片 OCR。
- 已确认兼容组合：PW1 / B024、固件 5.6.1.1、KOReader 2026.07.1。其他型号和版本暂不作兼容保证。

## 许可证

GNU AGPL-3.0-or-later。WordScreen 为独立项目，与 Amazon、KOReader 无隶属关系。
