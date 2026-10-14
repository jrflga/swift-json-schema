// swift-tools-version: 6.1

import CompilerPluginSupport
import PackageDescription

let package = Package(
  name: "swift-json-schema",
  platforms: [
    .macOS(.v13),
    .iOS(.v16),
    .watchOS(.v9),
    .tvOS(.v16),
    .macCatalyst(.v16),
    .visionOS(.v1),
  ],
  products: [
    .library(
      name: "OrderedJSON",
      targets: ["OrderedJSON"]
    ),
    .library(
      name: "JSONSchema",
      targets: ["JSONSchema"]
    ),
    .library(
      name: "JSONSchemaBuilder",
      targets: ["JSONSchemaBuilder"]
    ),
    .executable(
      name: "JSONSchemaClient",
      targets: ["JSONSchemaClient"]
    ),
    .library(
      name: "JSONSchemaConversion",
      targets: ["JSONSchemaConversion"]
    ),
  ],
  dependencies: [
    // Fork do jrflga: só Apple e swiftlang, numa versão exata. As
    // dependências de documentação e de teste de foto saíram (FORK.md).
    .package(url: "https://github.com/swiftlang/swift-syntax.git", exact: "604.0.0"),
    .package(url: "https://github.com/apple/swift-collections.git", exact: "1.7.3"),
  ],
  targets: [
    // Ordered, RFC-8259-conformant JSON value type, parser, and serializer.
    // Self-contained and reusable independently of JSON Schema. Eligible
    // for promotion to a separate package if outside demand materializes.
    .target(
      name: "OrderedJSON",
      dependencies: [
        .product(name: "OrderedCollections", package: "swift-collections")
      ]
    ),
    .testTarget(
      name: "OrderedJSONTests",
      dependencies: ["OrderedJSON"],
      resources: [
        .copy("JSONTestSuite")
      ]
    ),

    // Library that defines the JSON schema related types.
    .target(
      name: "JSONSchema",
      dependencies: [
        "OrderedJSON",
        .product(name: "OrderedCollections", package: "swift-collections"),
      ],
      resources: [
        .process("Resources")
      ]
    ),
    .testTarget(
      name: "JSONSchemaTests",
      dependencies: ["JSONSchema"],
      resources: [
        .copy("JSON-Schema-Test-Suite")
      ]
    ),

    // Library for building JSON schemas with Swift's result builders.
    .target(
      name: "JSONSchemaBuilder",
      dependencies: [
        "JSONSchema",
        "JSONSchemaMacro",
      ]
    ),
    .testTarget(
      name: "JSONSchemaBuilderTests",
      dependencies: [
        "JSONSchemaBuilder"
      ]
    ),

    // Macro implementation that preforms the source transformation of a macro.
    .macro(
      name: "JSONSchemaMacro",
      dependencies: [
        .product(name: "SwiftSyntax", package: "swift-syntax"),
        .product(name: "SwiftParser", package: "swift-syntax"),
        .product(name: "SwiftParserDiagnostics", package: "swift-syntax"),
        .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
        .product(name: "SwiftCompilerPlugin", package: "swift-syntax"),
        .product(name: "SwiftBasicFormat", package: "swift-syntax"),
        .product(name: "SwiftDiagnostics", package: "swift-syntax"),
        .product(name: "SwiftSyntaxBuilder", package: "swift-syntax"),
      ]
    ),
    .testTarget(
      name: "JSONSchemaMacroTests",
      dependencies: [
        "JSONSchemaMacro",
        .product(name: "SwiftSyntax", package: "swift-syntax"),
        .product(name: "SwiftSyntaxBuilder", package: "swift-syntax"),
        .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
        .product(name: "SwiftSyntaxMacroExpansion", package: "swift-syntax"),
        .product(name: "SwiftSyntaxMacrosGenericTestSupport", package: "swift-syntax"),
        .product(name: "SwiftParser", package: "swift-syntax"),
        .product(name: "SwiftParserDiagnostics", package: "swift-syntax"),
        .product(name: "SwiftBasicFormat", package: "swift-syntax"),
        .product(name: "SwiftDiagnostics", package: "swift-syntax"),
      ]
    ),

    // A client of the library, which is able to use the macro in its own code.
    .executableTarget(
      name: "JSONSchemaClient",
      dependencies: [
        "JSONSchema",
        "JSONSchemaBuilder",
        "JSONSchemaMacro",
        "JSONSchemaConversion",
      ]
    ),

    // Library for custom conversions for JSONSchemaBuilder.
    .target(
      name: "JSONSchemaConversion",
      dependencies: [

        "JSONSchemaBuilder"
      ]
    ),
    .testTarget(
      name: "JSONSchemaConversionTests",
      dependencies: [
        "JSONSchemaConversion"
      ]
    ),
  ],
  swiftLanguageModes: [.v6]
)
