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
    "XK",
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
      guard
        let localizedName = locale.localizedString(forRegionCode: code),
        let englishName = englishLocale.localizedString(forRegionCode: code),
        let flagEmoji = flagEmoji(for: code, validRegionCodes: validRegionCodes)
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

  private static func supportedRegionCodes() -> [String] {
    if #available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *) {
      return Locale.Region.isoRegions.map(\.identifier)
    }

    return Locale.isoRegionCodes
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
