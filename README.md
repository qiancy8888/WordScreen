# WordScreen for KOReader

**A PDF-based vocabulary learning plugin for KOReader and e-ink devices.**

Copyright (C) 2026 qiancy8888

[简体中文](README.zh-CN.md) | [Installation](docs/INSTALLATION.md) | [PDF format](docs/PDF_FORMAT.md) | [Testing status](docs/TESTING.md) | [Changelog](CHANGELOG.md)

> **Project status: release candidate / experimental.** The current source snapshot is v0.3.1-rc1. The maintainer reports one overnight playback run on Kindle Paperwhite 1 (PW1) + KOReader v2026.07.1 without entering the screensaver. This is a single-device field report, not a guarantee for other models, firmware versions or usage conditions.

## What it does

WordScreen turns a specially formatted PDF vocabulary book into a two-stage learning sequence:

1. **A page — recall:** English word, phonetic transcription and a grayscale mnemonic illustration.
2. **B page — reveal:** Chinese meaning and example sentence.

The plugin advances between the two pages of each word, then moves to the next word.

## Features in the current source

- Two consecutive PDF pages per vocabulary item (A then B).
- Automatic A/B playback; default delay is 4 seconds per page.
- All-words looping and favorites-only looping.
- Left swipe for the next word; right swipe for the previous word while playback is active.
- A small heart overlay near the top-right word-title area to favorite/unfavorite the current item.
- Favorites stored locally in KOReader settings, keyed by PDF path and word index.
- A v0.3.1-rc1 quick-resume implementation that stores the exact PDF page/A-B face and attempts to resume after KOReader restores the reader view.
- Optional native Kindle-library launch through a separately installed PDF-to-KOReader launcher such as KPVBooklet. The launcher is **not included** in this repository.

## Requirements

- KOReader installed and working on the target device.
- A PDF vocabulary book following the [WordScreen PDF format](docs/PDF_FORMAT.md).
- KOReader's built-in AutoTurn disabled while WordScreen is playing.

WordScreen is a third-party KOReader plugin. It does not include KOReader, Kindle jailbreak files, KUAL, MRPI, KPVBooklet, vocabulary PDFs, fonts or illustration assets.

## Install

See the bilingual [installation guide](docs/INSTALLATION.md). The plugin folder must end up at:

```text
koreader/plugins/wordscreen.koplugin/
├── main.lua
├── _meta.lua
└── heartoverlay.lua
```

## Compatibility and verification

The project owner's primary device is a Kindle Paperwhite 1 (PW1 / B024), firmware 5.6.1.1, with KOReader installed. KOReader was reported to launch and open PDFs on that device, and the WordScreen plugin menu was reported to appear and become usable in the earlier plugin iteration.

The v0.3.1-rc1 activity-timer handling and suspend/resume path have an owner-reported overnight test on PW1 + KOReader v2026.07.1. Exact-page resume, native Kindle-library launch and repeatability still require separate real-device verification. KPVBooklet is a separate project; its compatibility with a particular Kindle model and firmware must be checked independently. See [testing status](docs/TESTING.md).

Other Kindle models and firmware versions are not yet declared compatible.

## Important limitations

- The plugin checks that the current document is a PDF with an even page count of at least two. It does **not** read or understand the PDF's text or verify that pages are in A/B order.
- A PDF must not contain a cover, contents page, or extra page unless those pages are deliberately included in the two-page-per-word sequence.
- Favorites are keyed by the PDF's file path and word number, not by the word text. Replacing a PDF at the same path with a different word order can make old favorites point to different words. Use a new filename for a substantially changed vocabulary list.
- The heart overlay uses screen-relative coordinates. Leave clear space near the top-right title area in the PDF layout.
- During timed playback, each page transition sends KOReader's `InputEvent` activity hook so its normal AutoSuspend / Kindle T1 bookkeeping can stay synchronized. The plugin does not disable Kindle `powerd`, the system screensaver or KeepAlive.
- If KOReader reports a suspend event, the plugin stores the exact A/B page and attempts to resume after the reader view is restored.
- One overnight run on PW1 + KOReader v2026.07.1 was reported without screensaver activation. This is not a compatibility guarantee; manual-stop behavior, battery use and repeatability still need testing.

## Development

Please read [CONTRIBUTING.md](CONTRIBUTING.md) and the manual [test matrix](docs/TESTING.md) before submitting changes. Bug reports should include the Kindle model, firmware, KOReader version, PDF page count and relevant logs. Remove serial numbers, Wi-Fi MAC addresses and private vocabulary data from screenshots/logs.

## License

The WordScreen source code in this repository is licensed under the **GNU Affero General Public License v3.0 or later (AGPL-3.0-or-later)**. See the full text in [LICENSE](LICENSE). This license applies to WordScreen files in this repository; KOReader, KPVBooklet and other third-party components remain separate projects under their own terms.

## Disclaimer

WordScreen is an independent community project and is not affiliated with Amazon or the KOReader project. Kindle is a trademark of Amazon. Use third-party jailbreaks and plugins at your own risk.
