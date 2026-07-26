# ``LocaleSupport``

Create Foundation `Locale` values from predefined identifiers and list localized country metadata.

## Overview

LocaleSupport provides a small Swift package for working with locale identifiers and country lists.
Use `LocaleSupport.countries(locale:regionCodes:includingNonCountryRegions:)` to create localized country data with ISO region codes, English names, localized names, and flag emoji.
Use `LocaleSupport.country(code:locale:)` for a single country and
`LocaleSupport.flagEmoji(forRegionCode:)` when only the flag is needed.

## Topics

### Locale Lookup

- ``LocaleSupport``
- ``LocaleIdentifiers``

### Countries

- ``LocaleCountry``
