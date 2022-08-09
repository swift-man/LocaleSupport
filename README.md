# LocaleSupport

![Badge](https://img.shields.io/badge/swift-white.svg?style=flat-square&logo=Swift)
![Badge - Version](https://img.shields.io/badge/Version-1.0.0-1177AA?style=flat-square)


```swift
let localeJP = Locale(localeIdentifiers: .japaneseJapan)
print(localeJP) // ja_JP (fixed)
```

```swift
let localeSupport = LocaleSupport()
let localeKR: Locale = localeSupport[.korean]
print(localeKR) // ko (fixed)
```
