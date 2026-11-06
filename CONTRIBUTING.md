# Contributing / 参与贡献

## English

Thanks for your interest in WordScreen. The project is experimental; focused bug reports are especially useful.

### Before opening an issue

Include:
- Kindle model and firmware version.
- KOReader version/build.
- WordScreen version.
- PDF page count and whether the file follows the two-pages-per-word format.
- Exact steps to reproduce, expected result and actual result.
- Relevant KOReader crash/log excerpt, if available.

Remove Kindle serial numbers, Wi-Fi MAC addresses, account details and private vocabulary content from logs and screenshots.

### Pull requests

- Keep changes small and explain the user-visible behavior.
- Do not claim a feature is hardware-tested unless it has been tested on the stated model/firmware.
- Test both A and B page states, favorites, stop/close behavior and settings persistence when changing playback logic.
- Avoid writing settings to flash on every 4-second page transition; e-ink devices use flash storage and unnecessary writes should be minimized.
- Document any new KOReader API dependency and the KOReader versions tested.

## 简体中文

感谢关注 WordScreen。本项目目前仍处于实验阶段，清晰、可复现的问题反馈尤其有帮助。

### 提交 Issue 前请提供

- Kindle 型号和固件版本。
- KOReader 版本/构建号。
- WordScreen 版本。
- PDF 总页数，以及是否符合每词两页的格式。
- 可复现问题的具体步骤、预期结果和实际结果。
- 如有必要，提供相关 KOReader 日志或崩溃日志片段。

请从日志和截图中删除 Kindle 序列号、Wi-Fi MAC 地址、账户信息和私人词库内容。

### 提交 Pull Request

- 尽量保持修改范围小，并说明用户可见的变化。
- 未在指定型号/固件上实测的功能，不要标记为实机通过。
- 修改播放逻辑时，测试 A/B 两种页面状态、收藏、停止/关闭行为和设置持久化。
- 不要在每次 4 秒翻页时都写入设置文件；电子墨水设备使用闪存，应尽量减少不必要写入。
- 记录新增的 KOReader API 依赖，以及实际测试过的 KOReader 版本。
