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
  public var lowercaseCode: String { code.lowercased() }

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
  static let nonCountryRegionCodes: Set<String> = [
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
    let codes = (regionCodes ?? supportedRegionCodes())
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
        let flagEmoji = locale.getFlagEmoji(from: code)
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
      $0.localizedName.localizedStandardCompare($1.localizedName) == .orderedAscending
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
}
