//
//  LocaleSupportTests.swift
//  LocaleSupportTests
//
//  Created by SwiftMan on 2021/09/05.
//

import Foundation
import Testing
@testable import LocaleSupport

struct LocaleSupportTests {
  @Test func countriesExcludeNonCountryRegionCodes() {
    let countries = LocaleSupport.countries(locale: Locale(identifier: "ko_KR"))
    let codes = Set(countries.map(\.code))

    #expect(codes.contains("KR"))
    #expect(codes.contains("US"))
    #expect(!codes.contains("AC"))
    #expect(!codes.contains("CP"))
    #expect(!codes.contains("CQ"))
    #expect(!codes.contains("DG"))
    #expect(!codes.contains("EA"))
    #expect(!codes.contains("IC"))
    #expect(!codes.contains("TA"))
    #expect(!codes.contains("XK"))
    #expect(codes.count == countries.count)
  }

  @Test func countriesCanBeLimitedToAvailableRegionCodes() {
    let countries = LocaleSupport.countries(
      locale: Locale(identifier: "en_US"),
      regionCodes: ["kr", "US", "XK", "KR"]
    )

    #expect(countries.map(\.code).sorted() == ["KR", "US"])
    #expect(countries.first { $0.code == "KR" }?.lowercaseCode == "kr")
  }

  @Test func countriesCanIncludeNonCountryRegionCodesWhenRequested() {
    let countries = LocaleSupport.countries(
      locale: Locale(identifier: "en_US"),
      regionCodes: ["AC", "US"],
      includingNonCountryRegions: true
    )
    let codes = Set(countries.map(\.code))

    #expect(codes == ["AC", "US"])
  }

  @Test func localeIdentifierDescriptionsUseCorrectDisplayNames() {
    #expect(
      LocaleIdentifiers.chineseTraditionalHanMacauSARChina.displayDescription
        == "Chinese (Traditional Han, Macau SAR China)"
    )
    #expect(
      LocaleIdentifiers.frenchCentralAfricanRepublic.displayDescription
        == "French (Central African Republic)"
    )
  }

  @Test func scriptOnlyLocaleIdentifiersUseSpecificFallbackCountry() {
    #expect(LocaleIdentifiers.flagCountryKey(for: .punjabiArabic) == "Pakistan")
    #expect(LocaleIdentifiers.flagCountryKey(for: .uzbekArabic) == "Afghanistan")
    #expect(LocaleIdentifiers.flagCountryKey(for: .tachelhitLatin) == "Morocco")
  }

  @Test func flagEmojiRejectsInvalidRegionCodes() {
    let locale = Locale(identifier: "en_US")

    #expect(locale.getFlagEmoji(from: "KR") == "🇰🇷")
    #expect(locale.getFlagEmoji(from: "1K") == nil)
  }
}
