//
//  LocaleSupport.swift
//  LocaleSupport
//
//  Created by SwiftMan on 2021/09/05.
//

import Foundation

public final class LocaleSupport {
  public init() {}
  
  public subscript (key: LocaleIdentifiers) -> Locale {
    Locale(identifier: key.rawValue)
  }
}
