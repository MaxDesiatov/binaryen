import CBinaryen

public struct WasmFeatures: RawRepresentable, OptionSet {
  public let rawValue: BinaryenFeatures

  public init(rawValue: BinaryenFeatures) { self.rawValue = rawValue }

  public static var mvp: Self { .init(rawValue: BinaryenFeatureMVP()) }
  public static var atomics: Self { .init(rawValue: BinaryenFeatureAtomics()) }
  public static var bulkMemory: Self { .init(rawValue: BinaryenFeatureBulkMemory()) }
  public static var mutableGlobals: Self { .init(rawValue: BinaryenFeatureMutableGlobals()) }
  public static var nontrappingFPToInt: Self { .init(rawValue: BinaryenFeatureNontrappingFPToInt()) }
  public static var signExt: Self { .init(rawValue: BinaryenFeatureSignExt()) }
  public static var simd128: Self { .init(rawValue: BinaryenFeatureSIMD128()) }
  public static var exceptionHandling: Self { .init(rawValue: BinaryenFeatureExceptionHandling()) }
  public static var tailCall: Self { .init(rawValue: BinaryenFeatureTailCall()) }
  public static var referenceTypes: Self { .init(rawValue: BinaryenFeatureReferenceTypes()) }
  public static var multivalue: Self { .init(rawValue: BinaryenFeatureMultivalue()) }
  public static var garbageCollection: Self { .init(rawValue: BinaryenFeatureGC()) }
  public static var memory64: Self { .init(rawValue: BinaryenFeatureMemory64()) }
  public static var all: Self { .init(rawValue: BinaryenFeatureAll()) }
}
