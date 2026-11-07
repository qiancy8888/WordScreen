# WordScreen for KOReader

**A PDF-based vocabulary player and spelling practice plugin for KOReader and e-ink devices.**

Copyright (C) 2026 qiancy8888

[简体中文](README.zh-CN.md) | [Installation](docs/INSTALLATION.md) | [PDF format](docs/PDF_FORMAT.md) | [Testing status](docs/TESTING.md) | [Changelog](CHANGELOG.md)

> **Current version: v0.4.3.** The integrated spelling workflow has been tested by the maintainer on Kindle Paperwhite 1 (PW1 / B024), firmware 5.6.1.1, with KOReader 2026.07.1. Other Kindle models and KOReader versions are not yet declared compatible.

## Features

- Two consecutive PDF pages per word: A (recall) and B (reveal).
- Timed A/B playback, all-word looping and favorites-only looping.
- Persistent favorites and playback resume settings.
- Manual spelling mode integrated into the same WordScreen plugin; no separate spelling plugin is required.
- Spelling mode reuses the PDF already open in KOReader and displays only B pages (2, 4, 6, ...).
- Masks the English headword, phonetic transcription, example sentence and lower word-origin hint while leaving the illustration and Chinese meaning visible. The PDF itself is not modified.
- Opens KOReader's virtual keyboard directly. Typed letters appear in rounded answer boxes without a visible text-entry dialog.
- Correct answers advance automatically. Wrong answers are saved to the mistake book, reveal the correct spelling and wait for a manual swipe.
- After a wrong answer, the modal keyboard host closes so reader swipes work; the keyboard reopens after moving to another word.
- Mistake records persist in the existing WordScreen settings file. Pending mistakes leave the review list after three consecutive correct answers.

## Install

See the bilingual [installation guide](docs/INSTALLATION.md). Back up the plugin directory and `koreader/settings/wordscreen_koreader.lua` before updating. Copy the `koreader/` folder from the repository or release archive to the Kindle USB root. The original PDF does not need to be replaced.

Plugin path:

```text
koreader/plugins/wordscreen.koplugin/
├── _meta.lua
├── main.lua
├── heartoverlay.lua
├── spelling.lua
└── spellingoverlay.lua
```

## Requirements and limitations

- KOReader must already be installed and able to open PDF documents.
- The PDF must contain an even number of pages, with exactly two consecutive pages per word.
- Spelling mode extracts the headword from selectable PDF text on each B page; it does not OCR image-only headings.
- The spelling overlay geometry is designed for the supplied portrait PET PDF at full-page view. The 849-word / 1698-page PDF and alternate zoom/crop layouts have not been validated in v0.4.3.
- This repository does not bundle KOReader, Kindle jailbreak components, KUAL, MRPI, KPVBooklet, vocabulary PDFs, fonts or illustration assets.

## Device verification

The user confirmed v0.4.3 on PW1 + KOReader 2026.07.1: spelling mode opens; the keyboard appears directly; typed characters update the answer boxes; correct answers advance automatically; wrong answers are saved and reveal the answer; left/right swipe navigation works after a wrong answer; and the original playback mode remains available. See [testing status](docs/TESTING.md).

This is a single-device report, not a general compatibility guarantee. Other models and firmware versions need their own testing.

## Development

Please read [CONTRIBUTING.md](CONTRIBUTING.md) and the manual [test matrix](docs/TESTING.md) before submitting changes. Bug reports should include Kindle model, firmware, KOReader version, PDF page count and relevant logs. Remove serial numbers, Wi-Fi MAC addresses and private vocabulary data from screenshots/logs.

## License

WordScreen is licensed under the **GNU Affero General Public License v3.0 or later (AGPL-3.0-or-later)**. See [LICENSE](LICENSE).

## Disclaimer

WordScreen is an independent community project and is not affiliated with Amazon or KOReader. Kindle is a trademark of Amazon. Use third-party jailbreaks and plugins at your own risk.
