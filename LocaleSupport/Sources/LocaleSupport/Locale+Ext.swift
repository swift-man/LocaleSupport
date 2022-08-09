//
//  Locale+Ext.swift
//  LocaleSupport
//
//  Created by 김승진 on 2021/09/05.
//

import Foundation

extension Locale {
  public init(localeidentifiers: LocaleIdentifiers) {
    self.init(identifier: localeidentifiers.rawValue)
  }
}
