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
      regionCodes: ["1K"]
    )

    XCTAssertTrue(countries.isEmpty)
  }
}
