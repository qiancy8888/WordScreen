# WordScreen for KOReader

**A PDF-based vocabulary player and spelling practice plugin for KOReader and e-ink devices.**

Copyright (C) 2026 qiancy8888

[简体中文](README.zh-CN.md) | [Installation](docs/INSTALLATION.md) | [PDF format](docs/PDF_FORMAT.md) | [Testing status](docs/TESTING.md) | [Changelog](CHANGELOG.md)

> **Current version: v0.4.5.** The spelling workflow and navigation-flash fix have been confirmed by the maintainer on Kindle Paperwhite 1 (PW1 / B024), firmware 5.6.1.1, KOReader 2026.07.1.

## Features

- Two consecutive PDF pages per word: A (recall) and B (reveal).
- Timed A/B playback, all-word looping and favorites-only looping.
- Persistent favorites and playback resume settings.
- Manual spelling mode integrated into the same WordScreen plugin; no separate spelling plugin is required.
- Spelling mode reuses the PDF already open in KOReader and displays only B pages (2, 4, 6, ...).
- Masks the English headword and selected English prompt areas while keeping the illustration and Chinese meaning visible. The PDF itself is not modified.
- Opens KOReader's virtual keyboard directly. Typed letters appear in rounded answer boxes without a visible text-entry dialog.
- Correct answers advance automatically. Wrong answers are saved to the mistake book, reveal the correct spelling and wait for a manual swipe.
- v0.4.5 prevents delayed playback callbacks and native page-turn gestures from racing spelling navigation; duplicate advances and stale callbacks are guarded.

## Install

See the bilingual [installation guide](docs/INSTALLATION.md). Back up the plugin directory and `koreader/settings/wordscreen_koreader.lua` before updating. Copy the `koreader/` folder from the repository or release archive to the Kindle USB root. The original PDF does not need to be replaced.

## Requirements and limitations

- KOReader must already be installed and able to open PDF documents.
- The PDF must contain an even number of pages, with exactly two consecutive pages per word.
- Spelling mode extracts the headword from selectable PDF text on each B page; it does not OCR image-only headings.
- The spelling overlay is calibrated for the supplied portrait PET PDF at full-page view. Other zoom/crop layouts need separate validation.
- This repository does not bundle KOReader, Kindle jailbreak components, KUAL, MRPI, KPVBooklet, vocabulary PDFs, fonts or illustration assets.

## Device verification

The user confirmed v0.4.5 on PW1 + KOReader 2026.07.1: starting at `professor`, completing 20 words, intentionally missing word 21, and swiping once goes directly to word 22 without briefly showing `professor` or `buyer`. Direct keyboard input, correct auto-advance, wrong-answer persistence/reveal, and swipe navigation remain functional. See [testing status](docs/TESTING.md).

This is a single-device report, not a general compatibility guarantee.

## License

WordScreen is licensed under the **GNU Affero General Public License v3.0 or later (AGPL-3.0-or-later)**. See [LICENSE](LICENSE).

## Disclaimer

WordScreen is an independent community project and is not affiliated with Amazon or KOReader. Kindle is a trademark of Amazon.
