# Testing status / 实机验收状态

## English

This table separates owner-reported device observations from features present in the v0.3.0 source but not yet accepted on hardware.

| Item | Current status | Notes |
|---|---|---|
| KOReader starts on Kindle PW1 and opens PDF | Owner-reported pass | PW1 / B024, firmware 5.6.1.1 workflow |
| WordScreen plugin menu appears | Owner-reported pass | Menu appeared after earlier plugin debugging |
| Earlier WordScreen plugin became usable | Owner-reported pass | This does not certify every v0.3.0 feature |
| Two-page A/B mapping | Implemented | Odd page A, even page B |
| 4-second A/B playback | Implemented; re-test required | Default values in source; refresh latency may affect perceived timing |
| Infinite all-word loop | Implemented; re-test required | Source wraps from last word to first |
| Favorites-only loop | Implemented; re-test required | Favorites are per PDF path |
| Left/right swipe navigation | Implemented; re-test required | Only intercepted while playback is active |
| Top heart overlay drawing and touch | Packaged; hardware acceptance pending | Check title overlap and touch-zone conflicts |
| Favorites survive KOReader restart | Implemented; hardware acceptance pending | Settings file is `wordscreen_koreader.lua` |
| v0.3.0 exact-page resume | Preview implementation; not accepted | Test both A and B pages after normal stop, document close and KOReader restart |
| Native Kindle-library PDF launch | External dependency; not accepted | Requires a compatible third-party launcher such as KPVBooklet |
| Playback through Kindle system sleep/screensaver | Not guaranteed | Current suspend handler saves progress and stops playback |
| Other Kindle models / firmware | Not tested | Do not assume compatibility |

### Suggested PW1 acceptance sequence

1. Record the exact KOReader version and PDF filename/page count.
2. Open a known WordScreen PDF and verify page 1 is word 1 A and page 2 is word 1 B.
3. Disable built-in AutoTurn. Start all-word playback and verify A → B → next word.
4. Observe the last word and confirm it returns to word 1.
5. Swipe left/right while playing.
6. Favorite a word on both A and B pages; verify the heart state is shared.
7. Exit and restart KOReader; verify favorites persist.
8. Stop on an A page, reopen the same PDF and test resume. Repeat on a B page.
9. Only after direct KOReader opening works, separately test the native Kindle-library launcher.
10. Record suspend/screensaver behavior separately; do not infer it from a short test.

## 简体中文

本表将维护者反馈的实机观察，与 v0.3.0 源码中已经实现但尚未在设备上验收的功能分开记录。

| 检查项 | 当前状态 | 说明 |
|---|---|---|
| Kindle PW1 上启动 KOReader 并打开 PDF | 维护者反馈通过 | PW1 / B024，固件 5.6.1.1 操作流程 |
| WordScreen 插件菜单出现 | 维护者反馈通过 | 经过前期插件调试后菜单已出现 |
| 早期 WordScreen 插件可以使用 | 维护者反馈通过 | 不代表 v0.3.0 的每项功能都已验收 |
| A/B 两页映射 | 已实现 | 奇数页 A，偶数页 B |
| A/B 默认各 4 秒播放 | 已实现，需复测 | 源码默认值为 4 秒；屏幕刷新耗时会影响体感 |
| 全部单词无限循环 | 已实现，需复测 | 源码在末词后回到第一个单词 |
| 收藏夹循环 | 已实现，需复测 | 收藏按 PDF 路径区分 |
| 左右滑动切换单词 | 已实现，需复测 | 仅在播放期间接管滑动手势 |
| 顶部红心绘制与触控 | 已打包，实机触控待验收 | 检查标题遮挡和触控区域冲突 |
| KOReader 重启后收藏保留 | 已实现，实机待验收 | 设置文件为 `wordscreen_koreader.lua` |
| v0.3.0 精确页码续播 | 预览实现，尚未验收 | 分别测试 A 页、B 页在停止、关闭文档、重启 KOReader 后的恢复 |
| Kindle 原生书库直接打开 PDF | 外部依赖，尚未验收 | 需要 KPVBooklet 等兼容的第三方启动组件 |
| Kindle 系统休眠/屏保期间持续播放 | 不作保证 | 当前挂起处理会保存进度并停止播放 |
| 其他 Kindle 型号 / 固件 | 未测试 | 不应默认认为兼容 |

### PW1 建议验收顺序

1. 记录准确的 KOReader 版本、PDF 文件名和总页数。
2. 打开已知 WordScreen 单词本，确认第 1 页是第 1 词 A 页、第 2 页是第 1 词 B 页。
3. 关闭 KOReader 内置 AutoTurn，启动全部单词播放，检查 A → B → 下一词。
4. 观察最后一个单词是否回到第一个。
5. 播放过程中测试左滑、右滑。
6. 在同一个单词的 A/B 两页分别收藏，确认红心状态一致。
7. 退出并重启 KOReader，确认收藏仍然存在。
8. 停在 A 页后退出并重新打开同一 PDF，测试续播；再对 B 页重复测试。
9. 只有 KOReader 内部直接打开 PDF 和自动续播通过后，再单独测试 Kindle 原生书库启动组件。
10. 单独记录休眠和屏保表现，不要用短时间测试推断长时间播放能力。
