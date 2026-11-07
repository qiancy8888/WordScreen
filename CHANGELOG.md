# Changelog / 更新记录

## v0.3.1-rc1 — Kindle activity and resume fix / Kindle 活动计时与唤醒恢复修复

- Removed the direct pause of KOReader AutoSuspend during WordScreen playback.
- Timed page transitions now execute KOReader's InputEvent activity hook so AutoSuspend's last-action time and Kindle T1 reset logic remain synchronized.
- WordScreen no longer changes Kindle powerd `preventScreenSaver` or KeepAlive state.
- Playback position and A/B face are retained across a device suspend; playback is scheduled to resume after KOReader restores the reader view.
- The maintainer reports that this exact release-candidate build ran overnight on Kindle PW1 + KOReader v2026.07.1 without entering the screensaver. This is a single-device report, not a guarantee for other models or conditions.
- Manual stop/exit behavior, battery consumption and repeatability still need separate checks.

- 移除播放期间直接暂停 KOReader AutoSuspend 的做法。
- 定时翻页时触发 KOReader 的 InputEvent 活动钩子，使 AutoSuspend 的最后活动时间与 Kindle T1 计时保持同步。
- WordScreen 不再修改 Kindle powerd 的 `preventScreenSaver` 或 KeepAlive 状态。
- 设备休眠前保存播放位置和 A/B 页面状态，唤醒并恢复阅读界面后尝试自动续播。
- 维护者反馈：这一候选版本在 Kindle PW1 + KOReader v2026.07.1 上整夜运行未进入屏保。这是单台设备的一次测试反馈，不代表其他型号或环境均已验证。
- 手动停止/退出后的行为、电池消耗及重复测试仍需单独验收。

---

## 2026-11-06 — public repository preparation / 公开仓库准备

- Declared the WordScreen project license as GNU AGPL v3.0-or-later (`AGPL-3.0-or-later`).
- Added the full license text to the repository and preview installation archive.
- Added SPDX license identifiers to the first-party Lua source files.
- This is a licensing and packaging update; the plugin code version remains v0.3.0 preview.

- 确定 WordScreen 项目采用 GNU AGPL 第 3 版或后续版本（`AGPL-3.0-or-later`）。
- 在仓库和预览安装包中加入完整许可证文本。
- 为项目自有 Lua 源文件添加 SPDX 许可证标识。
- 本次属于许可证与打包信息更新，插件代码版本仍为 v0.3.0 preview。


## v0.3.0 — preview snapshot / 预览快照

- Added a quick-resume setting for one selected PDF.
- Stores the current PDF page, preserving A/B face on resume.
- Attempts automatic resume when the selected PDF becomes ready in KOReader.
- Documents optional native Kindle-library launch through a separate launcher such as KPVBooklet.
- Quick-resume and native-library launch still require PW1 hardware acceptance.

- 增加针对单一指定 PDF 的快速续播设置。
- 保存当前 PDF 页码，续播时保留 A/B 页面状态。
- 指定 PDF 在 KOReader 中就绪后，尝试自动恢复播放。
- 说明通过 KPVBooklet 等独立启动组件从 Kindle 原生书库打开 PDF 的可选方案。
- 断点续播和原生书库启动仍需 PW1 实机验收。

## v0.2.1 — top-heart layout / 顶部红心布局

- Moved the heart overlay to the top-right area beside the word title.
- Enlarged the touch target around the heart.
- 顶部红心移动到单词标题右侧。
- 扩大红心周围的触控热区。

## v0.2.0 — favorites overlay / 红心收藏

- Added an on-page heart overlay for favorite/unfavorite.
- Added persistent favorites per PDF path and word index.
- 增加页面红心收藏/取消收藏。
- 按 PDF 路径和单词序号持久化收藏数据。

## v0.1.0 — first KOReader plugin / 首个 KOReader 插件版本

- Added two-page-per-word PDF playback.
- Added A/B timed playback and all-word looping.
- Added favorites playback, menu controls and swipe navigation in the early plugin iteration.
- 加入每词两页的 PDF 播放逻辑。
- 加入 A/B 定时播放和全部单词循环。
- 早期插件迭代加入收藏夹播放、菜单控制和滑动切词。
