//
//  Locale+.swift
//  LocaleSupport
//
//  Created by SwiftMan on 2021/09/05.
//

import Foundation

extension Locale {
  public init(localeIdentifiers: LocaleIdentifiers) {
    self.init(identifier: localeIdentifiers.rawValue)
  }
}
