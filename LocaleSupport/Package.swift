// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "LocaleSupport",
  platforms:
    [
      .iOS(.v15),
      .tvOS(.v15),
      .macOS(.v11),
      .watchOS(.v5),
    ],
  products:
    [
      .library(
        name: "LocaleSupport",
        targets: ["LocaleSupport"]),
    ],
  dependencies: [],
  targets:
    [
      .target(
        name: "LocaleSupport",
        dependencies: [],
        path: "Sources/LocaleSupport",
        exclude: ["Info.plist"]),
      .testTarget(
        name: "LocaleSupportTests",
        dependencies: ["LocaleSupport"],
        path: "Tests/LocaleSupportTests",
        exclude: ["Info.plist"]),
    ],
  swiftLanguageVersions: [.v5]
)
