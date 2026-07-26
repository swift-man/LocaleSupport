# Changelog

All notable changes to this project are documented in this file.

## [Unreleased]

> `2.0.0` was withdrawn and replaced by `1.2.0` without code changes.

## [1.2.0] - 2026-07-27

### Added
- Added static and instance `country(code:locale:)` APIs for single-country metadata lookup.
- Added static and instance `flagEmoji(forRegionCode:)` APIs.
- Added visionOS 1.0 package support.

### Changed
- Raised the minimum Swift tools requirement from 5.6 to 6.3 and adopted Swift 6 language mode.
- Made `LocaleSupport` and `LocaleCountry` conform to `Sendable`.
- Cached supported region-code lookups and reused validated codes during country and flag construction.
- Skipped redundant normalization when the default ISO region-code list is used.

### Fixed
- Rejected malformed and unsupported region codes consistently across country-list, country, and flag APIs.

## [1.1.0] - 2026-06-18

### Added
- Added the `LocaleCountry` model for localized country metadata.
- Added static and instance `LocaleSupport.countries(locale:regionCodes:includingNonCountryRegions:)` APIs.
- Added DocC documentation catalog and the `GeneratingDocumentationSite` helper script.
- Added a GitHub Actions workflow to deploy DocC output to the `swift-man/docs` repository.
- Added review exclusion rules in `.reviewbot.yml`.

### Changed
- Reorganized public source files under `Sources/LocaleSupport/Public`.
- Updated the README version badge to `1.1.0`.
- Replaced Swift Testing usage with XCTest to preserve Swift tools 5.6 compatibility.
- Reused a `Set` of valid region codes while building country lists to avoid repeated lookup costs.

### Fixed
- Fixed `displayDescription` spelling while keeping the deprecated `dispayDescription` compatibility alias.
- Fixed swapped display descriptions for `chineseTraditionalHanMacauSARChina` and `frenchCentralAfricanRepublic`.
- Removed the latest-SDK-only `Locale.Region.isoRegions` reference to preserve older SDK compatibility.
- Disabled persisted checkout credentials in the DocC deployment workflow.
- Cleared stale target symbol graphs before generating DocC output.

## [1.0.0] - 2022-08-09

### Added
- Initial LocaleSupport release.

[Unreleased]: https://github.com/swift-man/LocaleSupport/compare/1.2.0...HEAD
[1.2.0]: https://github.com/swift-man/LocaleSupport/compare/1.1.0...1.2.0
[1.1.0]: https://github.com/swift-man/LocaleSupport/releases/tag/1.1.0
[1.0.0]: https://github.com/swift-man/LocaleSupport/releases/tag/1.0.0
