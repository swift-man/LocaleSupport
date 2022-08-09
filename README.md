# LocaleSupport

![Badge - Build](https://img.shields.io/badge/build-passing-ra1028.svg?style=flat-square)
![Badge - Swift](https://img.shields.io/badge/swift5-white.svg?style=flat-square&logo=Swift)
![Badge - Version](https://img.shields.io/badge/Version-1.0.0-1177AA?style=flat-square)
![Badge - Swift Package Manager](https://img.shields.io/badge/SPM-compatible-orange?style=flat-square)
![Badge - Platform](https://img.shields.io/badge/platform-mac|ios|watchos|tvos-yellow?style=flat-square)
![Badge - License](https://img.shields.io/badge/license-MIT-black?style=flat-square)

```swift
let localeJP = Locale(localeIdentifiers: .japaneseJapan)
print(localeJP) // ja_JP (fixed)
```

```swift
let localeSupport = LocaleSupport()
let localeKR: Locale = localeSupport[.korean]
print(localeKR) // ko (fixed)
```
