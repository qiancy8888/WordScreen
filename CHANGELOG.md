# Changelog / 更新记录

## v0.4.5 — spelling navigation flash fix / 拼写导航闪现修复

- Prevents delayed WordScreen playback callbacks from changing PDF pages while spelling mode is active.
- Cancels player timers when spelling mode takes control and guards playback tick, auto-start, and manual word-turn paths.
- Gives spelling mode exclusive full-screen swipe handling so gestures do not fall through to KOReader's native PDF page turner.
- Adds a transition lock to prevent duplicate word advances and invalidates stale delayed auto-advance callbacks.
- User-confirmed on Kindle Paperwhite 1 + KOReader 2026.07.1: after 20 correct words from `professor`, an incorrect 21st answer followed by one swipe goes directly to word 22 without flashing `professor` or `buyer`. Keyboard, auto-advance, mistake saving/reveal and swipe navigation remain functional.

- 修复拼写模式下播放器残留的延迟回调抢占 PDF 页面控制的问题。
- 拼写模式接管时取消播放器定时任务，并在播放 tick、自动启动和手动切词入口增加保护。
- 拼写模式独占全屏滑动手势，避免 KOReader 原生 PDF 翻页与单词导航冲突。
- 增加切词过渡锁，防止一次滑动重复触发跳词；使过期的自动跳词回调失效。
- 用户已在 PW1 + KOReader 2026.07.1 上确认：从 `professor` 开始连续完成20词，第21词答错后滑动，直接进入第22词，不再闪现 `professor` 和 `buyer`。键盘输入、答对自动跳词、错题保存/揭示及滑动切词均正常。

## v0.4.4 — multi-sense example masking fix / 多词义例句遮挡修复

- Replaced fixed example masks with text-line-aware masking for multi-sense entries.
- Preserves Chinese definitions while hiding detected English example lines.
- 将固定遮挡条改为按 PDF 文本行位置遮挡多词义单词的英文例句，同时保留中文释义。

## v0.4.3 — spelling swipe fix / 拼写模式滑动修复

- Closes the modal keyboard host after a wrong answer so reader swipes work; reopens it after moving to the next word.
- 拼错后关闭模态键盘宿主以释放滑动手势；切换单词后重新弹出键盘。

## v0.4.2 — spelling startup crash fix / 拼写模式启动闪退修复

- Guards constructor-time `edited_callback` calls before `InputDialog:new()` returns.
- 修复输入框初始化期间提前触发回调导致的空对象访问。
