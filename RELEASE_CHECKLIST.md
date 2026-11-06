# First public release checklist / 首次公开发布检查表

- [x] Maintainer confirms AGPL-3.0-or-later and adds the full `LICENSE` file.
- [x] Maintainer creates the public GitHub repository `qiancy8888/WordScreen`.
- [x] Verify the source files match the archived v0.3.0 preview snapshot; only SPDX headers were added.
- [ ] Run a Lua syntax check with a compatible Lua/LuaJIT toolchain.
- [ ] Test plugin loading on Kindle PW1 / B024 / firmware 5.6.1.1.
- [ ] Test A/B playback, end-to-start loop, favorites, swipe, heart tap and persistence.
- [ ] Test v0.3.0 resume from both A and B pages after stop, document close and KOReader restart.
- [ ] Test KPVBooklet separately before documenting a working native-home shortcut.
- [x] Confirm no personal serial number, MAC address, private PDF or proprietary artwork is included in this source snapshot.
- [ ] Create a GitHub Release only after the remaining device tests; until then publish only as a clearly labeled preview.

---

- [x] 维护者确认采用 AGPL-3.0-or-later，并添加完整许可证文件。
- [x] 维护者创建公开 GitHub 仓库 `qiancy8888/WordScreen`。
- [x] 核对源代码与归档的 v0.3.0 预览快照一致；仅增加了 SPDX 许可证标识。
- [ ] 使用兼容的 Lua/LuaJIT 工具链执行语法检查。
- [ ] 在 Kindle PW1 / B024 / 固件 5.6.1.1 上测试插件加载。
- [ ] 测试 A/B 播放、末尾回到开头、收藏、滑动、红心点击和数据持久化。
- [ ] 分别测试 v0.3.0 从 A 页、B 页在停止、关闭文档、重启 KOReader 后的恢复。
- [ ] 单独测试 KPVBooklet，确认后才能宣传原生书库快捷启动已经可用。
- [x] 确认本次源代码快照未包含个人序列号、MAC 地址、私人 PDF 或未获授权的美术素材。
- [ ] 剩余实机测试完成后再创建 GitHub Release；在此之前只作为明确标注的预览版发布。
