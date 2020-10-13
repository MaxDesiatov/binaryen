// swift-tools-version:5.2
import PackageDescription

let package = Package(
  name: "binaryen",
  products: [
    .executable(name: "binaryen-test", targets: ["binaryen-test"]),
    .library(name: "Binaryen", targets: ["Binaryen"])
  ],
  targets: [
    .target(name: "binaryen-test", dependencies: ["Binaryen"]),
    .target(name: "Binaryen", dependencies: ["CBinaryen"]),
    .target(
      name: "CBinaryen",
      path: "src",
      exclude: ["tools"],
      cxxSettings: [.headerSearchPath(".")]
    )
  ],
  cxxLanguageStandard: .cxx14
)
