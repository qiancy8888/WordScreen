# Changelog / 更新记录

## v0.4.3 — spelling swipe fix / 拼写模式滑动修复

- Integrated spelling practice into the existing WordScreen plugin; no separate spelling plugin is needed.
- Reuses the currently open two-page-per-word PDF and practices on B pages only. The English title, phonetic transcription, example and word-origin hint are masked; illustration and Chinese meaning remain visible.
- Shows the KOReader virtual keyboard immediately and renders typed letters directly in the rounded answer boxes, without a visible text-entry dialog.
- Correct answers advance automatically. Wrong answers are persisted and reveal the correct spelling, then wait for manual navigation.
- Fixed swipe navigation after a wrong answer: close the modal keyboard host to release reader gestures, then reopen the keyboard after moving to another word.
- Preserves the existing playback, favorites and settings data.
- User-confirmed on Kindle Paperwhite 1 + KOReader 2026.07.1: entering spelling mode, keyboard/input behavior, correct auto-advance, wrong-answer reveal/persistence, and swipe navigation after wrong answers.

- 拼写练习已整合进原 WordScreen 插件，不再需要独立的拼写插件。
- 复用当前打开的每词两页 PDF，只在 B 页进行拼写；遮挡英文单词、音标、例句和词源提示，保留插图及中文释义。
- 进入拼写模式后直接显示 KOReader 虚拟键盘，输入字母实时填入圆角方格，不再显示输入对话框。
- 拼写正确自动跳转；拼写错误自动保存错题并显示正确答案，等待手动切换。
- 修复拼错后无法滑动的问题：关闭模态键盘宿主以释放阅读页手势，切换单词后重新弹出键盘。
- 保留原有播放、收藏和设置数据。
- 用户已在 Kindle Paperwhite 1 + KOReader 2026.07.1 上确认：拼写模式进入、键盘和输入、答对自动跳词、答错揭示/记录，以及拼错后滑动切词均正常。

### Known limitations / 已知限制

- Compatibility is confirmed only for the reported PW1 + KOReader 2026.07.1 setup.
- Overlay placement is designed for the supplied portrait PET PDF at full-page zoom. The 849-word / 1698-page PDF and alternate zoom/crop layouts remain unverified.
- This release does not bundle KOReader, Kindle jailbreak components, KUAL, MRPI, KPVBooklet, fonts or vocabulary PDFs.

## v0.4.2 — spelling startup crash fix / 拼写模式启动闪退修复

- Guarded the constructor-time `edited_callback` because KOReader may invoke it before `InputDialog:new()` returns and assigns the dialog variable.
- Added a regression test that simulates the early callback.
- 修复 KOReader 创建输入框期间提前触发 `edited_callback` 导致的空对象访问。
- 增加模拟构造阶段提前回调的回归测试。

## v0.3.1-rc1 — Kindle activity and resume fix / Kindle 活动计时与唤醒恢复修复

- Timed page transitions execute KOReader's InputEvent activity hook to keep normal AutoSuspend / Kindle T1 bookkeeping synchronized.
- WordScreen does not directly disable Kindle powerd, screensaver or KeepAlive.
- The maintainer reported an overnight playback run on PW1 + KOReader v2026.07.1 without screensaver activation.
- 定时翻页触发 KOReader InputEvent 活动钩子，使 AutoSuspend / Kindle T1 计时按正常机制更新。
- 不直接关闭 Kindle powerd、屏保或 KeepAlive。
- 维护者曾反馈 PW1 + KOReader v2026.07.1 整夜播放未触发屏保。
