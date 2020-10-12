// swift-tools-version:5.0
import PackageDescription

let package = Package(
  name: "binaryen",
  products: [
    .executable(name: "binaryen-test", targets: ["binaryen-test"]),
    .library(name: "CBinaryen", targets: ["CBinaryen"]),
  ],
  targets: [
    .target(name: "binaryen-test", dependencies: ["CBinaryen"]),
    .target(
      name: "CBinaryen",
      path: "src",
      exclude: ["tools", "support/threads.cpp"],
      cxxSettings: [.headerSearchPath(".")]
    )
  ],
  cxxLanguageStandard: .cxx14
)
