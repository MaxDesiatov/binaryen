// swift-tools-version:5.0
import PackageDescription

let package = Package(
  name: "binaryen",
  products: [
    .library(name: "CBinaryen", targets: ["CBinaryen"]),
  ],
  targets: [
    .target(
      name: "CBinaryen",
      path: "src",
      exclude: ["support/command-line.cpp"],
      publicHeadersPath: "."
    )
  ],
  cxxLanguageStandard: .cxx14
)
