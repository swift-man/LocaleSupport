//
//  LocaleSupport.swift
//  LocaleSupport
//
//  Created by SwiftMan on 2021/09/05.
//

import Foundation

public final class LocaleSupport {
  private let localeMap: [LocaleIdentifiers: String]
  
  public init() {
    var localeMap: [LocaleIdentifiers: String] = [:]
    LocaleIdentifiers.allCases.forEach {
      localeMap[$0] = $0.rawValue
    }
    self.localeMap = localeMap
  }
  
  public subscript (key: LocaleIdentifiers) -> Locale {
    get { return Locale(identifier: localeMap[key]!)
    }
  }
}
