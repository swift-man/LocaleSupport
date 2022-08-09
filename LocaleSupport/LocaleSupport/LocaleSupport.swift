//
//  LocaleSupport.swift
//  LocaleSupport
//
//  Created by SwiftMan on 2021/09/05.
//

import Foundation

public final class LocalSupport {
  let dic: [LocaleIdentifiers: String]
  
  public init() {
    var dic: [LocaleIdentifiers: String] = [:]
    for identifier in LocaleIdentifiers.allCases {
      dic[identifier] = identifier.rawValue
    }
    self.dic = dic
  }
  
  public subscript (key: LocaleIdentifiers) -> Locale {
    get { return Locale(identifier: dic[key]!)
    }
  }
}
