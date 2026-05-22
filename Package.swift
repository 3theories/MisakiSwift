// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "MisakiSwift",
  platforms: [
    .iOS(.v18), .macOS(.v15)
  ],
  products: [
    // Static library — see the equivalent comment in
    // `../kokoro-ios/Package.swift`. Avoids the "Embed & Sign"
    // dance in the Avyra Xcode project. Local-only diff.
    .library(
      name: "MisakiSwift",
      targets: ["MisakiSwift"]
    ),
  ],
  dependencies: [
    // Pin relaxed from upstream's `.exact("0.30.2")` so MisakiSwift
    // resolves alongside Aria's `mlx-swift-lm` (which requires
    // mlx-swift 0.31.x). MisakiSwift uses only MLX + MLXNN, both
    // stable across 0.30 → 0.31. Local-only diff.
    .package(url: "https://github.com/ml-explore/mlx-swift", "0.30.0"..<"1.0.0"),
    .package(url: "https://github.com/mlalma/MLXUtilsLibrary.git", "0.0.6"..<"1.0.0")
  ],
  targets: [
    .target(
      name: "MisakiSwift",
      dependencies: [
        .product(name: "MLX", package: "mlx-swift"),
        .product(name: "MLXNN", package: "mlx-swift"),
        .product(name: "MLXUtilsLibrary", package: "MLXUtilsLibrary")
     ],
     // Flatten resources to bundle root (see kokoro-ios sibling for
     // the full explanation). Listing each file explicitly via
     // `.process` avoids the macOS-style `Resources/` subdirectory
     // that breaks iOS codesign. Local-only diff vs upstream.
     resources: [
      .process("../../Resources/gb_bart_config.json"),
      .process("../../Resources/gb_bart.safetensors"),
      .process("../../Resources/gb_gold.json"),
      .process("../../Resources/gb_silver.json"),
      .process("../../Resources/us_bart_config.json"),
      .process("../../Resources/us_bart.safetensors"),
      .process("../../Resources/us_gold.json"),
      .process("../../Resources/us_silver.json")
     ]
    ),
    .testTarget(
      name: "MisakiSwiftTests",
      dependencies: ["MisakiSwift"]
    ),
  ]
)
