# First public release checklist / 首次公开发布检查表

- [x] Maintainer confirms AGPL-3.0-or-later and adds the full `LICENSE` file.
- [x] Maintainer creates the public GitHub repository `qiancy8888/WordScreen`.
- [x] Import the maintainer-supplied v0.3.1-rc1 source archive and verify the activity-hook fix is present without a direct AutoSuspend / powerd / KeepAlive override.
- [x] Record the maintainer-reported overnight PW1 + KOReader v2026.07.1 run without screensaver activation.
- [ ] Run a Lua syntax check with a compatible Lua/LuaJIT toolchain.
- [ ] Test plugin loading on Kindle PW1 / B024 / firmware 5.6.1.1.
- [ ] Test A/B playback, end-to-start loop, favorites, swipe, heart tap and persistence.
- [ ] Test v0.3.1-rc1 resume from both A and B pages after stop, document close, KOReader restart and actual suspend/resume.
- [ ] Verify normal Kindle sleep after manual STOP / KOReader exit and record battery consumption.
- [ ] Test KPVBooklet separately before documenting a working native-home shortcut.
- [x] Confirm no personal serial number, MAC address, private PDF or proprietary artwork is included in this source snapshot.
- [ ] Create a GitHub Release only after the remaining device tests; until then publish only as a clearly labeled preview.

---

- [x] 维护者确认采用 AGPL-3.0-or-later，并添加完整许可证文件。
- [x] 维护者创建公开 GitHub 仓库 `qiancy8888/WordScreen`。
- [x] 导入维护者提供的 v0.3.1-rc1 源码归档，并确认活动计时钩子修复存在，且未直接覆盖 AutoSuspend / powerd / KeepAlive。
- [x] 记录维护者反馈的 PW1 + KOReader v2026.07.1 整夜播放未进入屏保的测试结果。
- [ ] 使用兼容的 Lua/LuaJIT 工具链执行语法检查。
- [ ] 在 Kindle PW1 / B024 / 固件 5.6.1.1 上测试插件加载。
- [ ] 测试 A/B 播放、末尾回到开头、收藏、滑动、红心点击和数据持久化。
- [ ] 分别测试 v0.3.1-rc1 从 A 页、B 页在停止、关闭文档、重启 KOReader 及实际休眠唤醒后的恢复。
- [ ] 验证手动 STOP / 退出 KOReader 后 Kindle 能恢复正常休眠，并记录电池消耗。
- [ ] 单独测试 KPVBooklet，确认后才能宣传原生书库快捷启动已经可用。
- [x] 确认本次源代码快照未包含个人序列号、MAC 地址、私人 PDF 或未获授权的美术素材。
- [ ] 剩余实机测试完成后再创建 GitHub Release；在此之前只作为明确标注的预览版发布。
