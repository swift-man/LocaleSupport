//
//  LocaleCountry.swift
//  LocaleSupport
//
//  Created by SwiftMan on 6/14/26.
//

import Foundation

public struct LocaleCountry: Codable, Hashable, Identifiable, Sendable {
  public let code: String
  public let localizedName: String
  public let englishName: String
  public let flagEmoji: String

  public var id: String { code }

  public init(
    code: String,
    localizedName: String,
    englishName: String,
    flagEmoji: String
  ) {
    self.code = code.uppercased()
    self.localizedName = localizedName
    self.englishName = englishName
    self.flagEmoji = flagEmoji
  }
}

public extension LocaleSupport {
  private static let nonCountryRegionCodes: Set<String> = [
    "AC",
    "CP",
    "CQ",
    "DG",
    "EA",
    "IC",
    "TA",
    "XK"
  ]

  static func countries(
    locale: Locale = .current,
    regionCodes: [String]? = nil,
    includingNonCountryRegions: Bool = false
  ) -> [LocaleCountry] {
    let supportedCodes = supportedRegionCodes()
    let validRegionCodes = Set(supportedCodes)
    let codes = (regionCodes ?? supportedCodes)
      .map { $0.uppercased() }
      .filter { $0.count == 2 }

    let uniqueCodes = Set(codes)
    let visibleCodes = uniqueCodes.filter {
      includingNonCountryRegions || !nonCountryRegionCodes.contains($0)
    }

    let englishLocale = Locale(identifier: "en_US_POSIX")

    return visibleCodes.compactMap { code in
      makeCountry(
        code: code,
        locale: locale,
        englishLocale: englishLocale,
        validRegionCodes: validRegionCodes
      )
    }
    .sorted {
      let result = $0.localizedName.compare(
        $1.localizedName,
        options: [.caseInsensitive, .diacriticInsensitive, .numeric],
        range: nil,
        locale: locale
      )

      if result == .orderedSame {
        return $0.code < $1.code
      }

      return result == .orderedAscending
    }
  }

  /// Returns localized metadata for an ISO 3166-1 alpha-2 country code.
  ///
  /// Returns `nil` when the code is invalid, unsupported, or represents a
  /// region that is not a country.
  static func country(
    code: String,
    locale: Locale = .current
  ) -> LocaleCountry? {
    let normalizedCode = code.uppercased()

    guard !nonCountryRegionCodes.contains(normalizedCode) else {
      return nil
    }

    return makeCountry(
      code: normalizedCode,
      locale: locale,
      englishLocale: Locale(identifier: "en_US_POSIX"),
      validRegionCodes: Set(supportedRegionCodes())
    )
  }

  /// Returns the flag emoji for a supported two-letter region code.
  static func flagEmoji(forRegionCode regionCode: String) -> String? {
    flagEmoji(
      for: regionCode,
      validRegionCodes: Set(supportedRegionCodes())
    )
  }

  func countries(
    locale: Locale = .current,
    regionCodes: [String]? = nil,
    includingNonCountryRegions: Bool = false
  ) -> [LocaleCountry] {
    Self.countries(
      locale: locale,
      regionCodes: regionCodes,
      includingNonCountryRegions: includingNonCountryRegions
    )
  }

  /// Instance convenience for ``country(code:locale:)``.
  func country(
    code: String,
    locale: Locale = .current
  ) -> LocaleCountry? {
    Self.country(code: code, locale: locale)
  }

  /// Instance convenience for ``flagEmoji(forRegionCode:)``.
  func flagEmoji(forRegionCode regionCode: String) -> String? {
    Self.flagEmoji(forRegionCode: regionCode)
  }

  private static func supportedRegionCodes() -> [String] {
    return Locale.isoRegionCodes
  }

  private static func makeCountry(
    code: String,
    locale: Locale,
    englishLocale: Locale,
    validRegionCodes: Set<String>
  ) -> LocaleCountry? {
    guard
      let localizedName = locale.localizedString(forRegionCode: code),
      let englishName = englishLocale.localizedString(forRegionCode: code),
      let flagEmoji = flagEmoji(
        for: code,
        validRegionCodes: validRegionCodes
      )
    else {
      return nil
    }

    return LocaleCountry(
      code: code,
      localizedName: localizedName,
      englishName: englishName,
      flagEmoji: flagEmoji
    )
  }

  private static func flagEmoji(
    for countryCode: String,
    validRegionCodes: Set<String>
  ) -> String? {
    let code = countryCode.uppercased()

    guard
      code.count == 2,
      code.allSatisfy({ $0 >= "A" && $0 <= "Z" }),
      validRegionCodes.contains(code)
    else {
      return nil
    }

    let base: UInt32 = 0x1F1E6
    let scalars = code.unicodeScalars.compactMap {
      UnicodeScalar(base + ($0.value - 0x41))
    }

    guard scalars.count == code.count else {
      return nil
    }

    return String(String.UnicodeScalarView(scalars))
  }
}
