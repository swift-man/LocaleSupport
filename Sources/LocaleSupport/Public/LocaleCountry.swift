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
    let codes = regionCodes?.compactMap(normalizedRegionCode)
      ?? supportedRegionCodes

    let uniqueCodes = Set(codes)
    let visibleCodes = uniqueCodes.filter {
      validRegionCodes.contains($0) &&
        (includingNonCountryRegions || !nonCountryRegionCodes.contains($0))
    }

    return visibleCodes.compactMap { code in
      makeCountry(code: code, locale: locale)
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
    guard
      let normalizedCode = normalizedRegionCode(code),
      validRegionCodes.contains(normalizedCode),
      !nonCountryRegionCodes.contains(normalizedCode)
    else {
      return nil
    }

    return makeCountry(code: normalizedCode, locale: locale)
  }

  /// Returns the flag emoji for a supported two-letter region code.
  static func flagEmoji(forRegionCode regionCode: String) -> String? {
    guard
      let normalizedCode = normalizedRegionCode(regionCode),
      validRegionCodes.contains(normalizedCode)
    else {
      return nil
    }

    return flagEmoji(forValidatedRegionCode: normalizedCode)
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

  private static let englishLocale = Locale(identifier: "en_US_POSIX")
  private static let supportedRegionCodes = Locale.isoRegionCodes
  private static let validRegionCodes = Set(supportedRegionCodes)

  private static func makeCountry(
    code: String,
    locale: Locale
  ) -> LocaleCountry? {
    guard
      let localizedName = locale.localizedString(forRegionCode: code),
      let englishName = englishLocale.localizedString(forRegionCode: code),
      let flagEmoji = flagEmoji(forValidatedRegionCode: code)
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
    forValidatedRegionCode code: String
  ) -> String? {
    let base: UInt32 = 0x1F1E6
    let scalars = code.unicodeScalars.compactMap {
      UnicodeScalar(base + ($0.value - 0x41))
    }

    guard scalars.count == code.count else {
      return nil
    }

    return String(String.UnicodeScalarView(scalars))
  }

  private static func normalizedRegionCode(_ code: String) -> String? {
    guard
      code.unicodeScalars.count == 2,
      code.unicodeScalars.allSatisfy({
        (0x41...0x5A).contains($0.value) ||
          (0x61...0x7A).contains($0.value)
      })
    else {
      return nil
    }

    return code.uppercased()
  }
}
