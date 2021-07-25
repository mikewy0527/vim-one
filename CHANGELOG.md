# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [2.0.0]

### Added

- Color palette customization
- Atom one like, or Github like, diff color. [rakr/vim-one#53][rakr-#53]

### Fixed

- Reduce theme loading time from 170 ms to 18 ms by
  - Hard coding the 256 color, detail in [GH-93][rakr-gh-93]
  - Reusing highlight definitions with predefined groups `hi link`,
    [GH-95][rakr-gh-95]
- Clear previous definition in `X()`, [laggardkernel/vim-one#1][lk-#1]

### Removed

- Remove duplicate `hi` group definitions

[rakr-#53]: https://github.com/rakr/vim-one/issues/53
[rakr-gh-93]: https://github.com/rakr/vim-one/pull/93
[rakr-gh-95]: https://github.com/rakr/vim-one/pull/95
[lk-#1]: https://github.com/laggardkernel/vim-one/issues/1
[Unreleased]: https://github.com/laggardkernel/vim-one/compare/2.0.0...HEAD
[2.0.0]: https://github.com/laggardkernel/vim-one/releases/tag/1.0.0
