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
}
