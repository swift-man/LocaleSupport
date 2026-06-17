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

  /// ISO 두 글자 국가 코드(예: "KR", "US")를 받아 해당 국가의 국기 이모지를 반환합니다.
  /// - Parameter countryCode: ISO 3166-1 alpha-2 국가 코드
  /// - Returns: 국기 이모지 String (올바르지 않은 코드일 경우 nil)
  public func getFlagEmoji(from countryCode: String) -> String? {
    // 대소문자 구분 없이 처리하기 위해 대문자로 변환
    let code = countryCode.uppercased()

    // ISO 두 글자 코드가 맞는지 검증
    guard
      code.count == 2,
      code.allSatisfy({ $0 >= "A" && $0 <= "Z" }),
      Locale.isoRegionCodes.contains(code)
    else {
      return nil
    }

    // 이모지 국기 스칼라 값의 시작점 (0x1F1E6은 'REGIONAL INDICATOR SYMBOL LETTER A')
    let base: UInt32 = 0x1F1E6

    var emojiString = ""
    for scalar in code.unicodeScalars {
      // 각 알파벳(A-Z)의 값을 스칼라 시작점에 더해 국기 코드 컴포넌트를 생성
      if let flagScalar = UnicodeScalar(base + (scalar.value - 0x41)) {
        emojiString.append(String(flagScalar))
      }
    }

    return emojiString.isEmpty ? nil : emojiString
  }
}
