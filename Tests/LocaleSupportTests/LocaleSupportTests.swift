//
//  LocaleSupportTests.swift
//  LocaleSupportTests
//
//  Created by SwiftMan on 2021/09/05.
//

import Foundation
import XCTest
@testable import LocaleSupport

final class LocaleSupportTests: XCTestCase {
  func testCountriesExcludeNonCountryRegionCodes() {
    let countries = LocaleSupport.countries(locale: Locale(identifier: "ko_KR"))
    let codes = Set(countries.map(\.code))

    XCTAssertTrue(codes.contains("KR"))
    XCTAssertTrue(codes.contains("US"))
    XCTAssertFalse(codes.contains("AC"))
    XCTAssertFalse(codes.contains("CP"))
    XCTAssertFalse(codes.contains("CQ"))
    XCTAssertFalse(codes.contains("DG"))
    XCTAssertFalse(codes.contains("EA"))
    XCTAssertFalse(codes.contains("IC"))
    XCTAssertFalse(codes.contains("TA"))
    XCTAssertFalse(codes.contains("XK"))
    XCTAssertEqual(codes.count, countries.count)
  }

  func testCountriesCanBeLimitedToAvailableRegionCodes() {
    let countries = LocaleSupport.countries(
      locale: Locale(identifier: "en_US"),
      regionCodes: ["kr", "US", "XK", "KR", "1K"]
    )

    XCTAssertEqual(countries.map(\.code).sorted(), ["KR", "US"])
    XCTAssertEqual(countries.first { $0.code == "KR" }?.flagEmoji, "🇰🇷")
  }

  func testCountriesCanIncludeNonCountryRegionCodesWhenRequested() {
    let countries = LocaleSupport.countries(
      locale: Locale(identifier: "en_US"),
      regionCodes: ["AC", "US"],
      includingNonCountryRegions: true
    )
    let codes = Set(countries.map(\.code))

    XCTAssertEqual(codes, ["AC", "US"])
  }

  func testCountryReturnsLocalizedMetadataForRegionCode() {
    let locale = Locale(identifier: "ko_KR")
    let country = LocaleSupport.country(code: "kr", locale: locale)

    XCTAssertEqual(country?.code, "KR")
    XCTAssertEqual(
      country?.localizedName,
      locale.localizedString(forRegionCode: "KR")
    )
    XCTAssertEqual(country?.flagEmoji, "🇰🇷")
  }

  func testCountryRejectsInvalidAndNonCountryRegionCodes() {
    XCTAssertNil(LocaleSupport.country(code: "1K"))
    XCTAssertNil(LocaleSupport.country(code: "ß"))
    XCTAssertNil(LocaleSupport.country(code: "A\u{301}"))
    XCTAssertNil(LocaleSupport.country(code: "XK"))
  }

  func testFlagEmojiReturnsEmojiForValidRegionCode() {
    XCTAssertEqual(
      LocaleSupport.flagEmoji(forRegionCode: "kr"),
      "🇰🇷"
    )
    XCTAssertNil(LocaleSupport.flagEmoji(forRegionCode: "1K"))
    XCTAssertNil(LocaleSupport.flagEmoji(forRegionCode: "ß"))
    XCTAssertNil(LocaleSupport.flagEmoji(forRegionCode: "A\u{301}"))
  }

  func testInstanceCountryConvenienceAPIsMatchStaticAPIs() {
    let localeSupport = LocaleSupport()
    let locale = Locale(identifier: "en_US")

    XCTAssertEqual(
      localeSupport.country(code: "US", locale: locale),
      LocaleSupport.country(code: "US", locale: locale)
    )
    XCTAssertEqual(
      localeSupport.flagEmoji(forRegionCode: "US"),
      LocaleSupport.flagEmoji(forRegionCode: "US")
    )
  }

  func testLocaleIdentifierDescriptionsUseCorrectDisplayNames() {
    XCTAssertEqual(
      LocaleIdentifiers.chineseTraditionalHanMacauSARChina.displayDescription,
      "Chinese (Traditional Han, Macau SAR China)"
    )
    XCTAssertEqual(
      LocaleIdentifiers.frenchCentralAfricanRepublic.displayDescription,
      "French (Central African Republic)"
    )
  }

  func testCountriesRejectInvalidRegionCodes() {
    let countries = LocaleSupport.countries(
      locale: Locale(identifier: "en_US"),
      regionCodes: ["1K", "ß", "A\u{301}"]
    )

    XCTAssertTrue(countries.isEmpty)
  }

  func testLocaleSupportIsSendable() {
    func requireSendable<Value: Sendable>(_: Value) {}

    requireSendable(LocaleSupport())
  }
}
