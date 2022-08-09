//
//  ViewController.swift
//  LocaleSupportExample
//
//  Created by SwiftMan on 2022/08/09.
//

import UIKit
import LocaleSupport

class ViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
    
    let localeJP = Locale(localeIdentifiers: .japaneseJapan)
    print(localeJP)
    
    let localeSupport = LocaleSupport()
    let localeKR: Locale = localeSupport[.korean]
    print(localeKR)
  }
}

