import CBinaryen

public final class WasmModule {
  private let ref: BinaryenModuleRef

  init(ref: BinaryenModuleRef) {
    self.ref = ref
  }

  public convenience init() {
    self.init(ref: BinaryenModuleCreate())
  }

  /// Deserialize a module from binary form.
  static func read(binary: inout [UInt8]) -> Self? {
    let count = binary.count
    guard let ref = binary.withUnsafeMutableBufferPointer({
      $0.withMemoryRebound(to: Int8.self) {
        BinaryenModuleRead($0.baseAddress, count)
      }
    }) else { return nil }

    return .init(ref: ref)
  }

  /// Parse a module in s-expression text format
  static func parse(text: String) -> Self {
    return .init(ref: text.withCString { BinaryenModuleParse($0) })
  }

  /// Print a module to stdout in s-expression text format. Useful for debugging.
  public func print() {
    BinaryenModulePrint(ref)
  }

  /// Print a module to stdout in asm.js syntax.
  public func printAsmJS() {
    BinaryenModulePrintAsmjs(ref)
  }

  /// Validate a module, showing errors on problems. Returns `true` if validation passed.
  public func validate() -> Bool {
    // 0 if an error occurred, 1 if validated succesfully
    BinaryenModuleValidate(ref) == 1
  }

  /// Runs the standard optimization passes on the module. Uses the currently set
  /// global optimize and shrink level.
  public func optimize() {
    BinaryenModuleOptimize(ref)
  }

  /// The optimization level to use. Applies to all modules, globally.
  /// 0, 1, 2 correspond to -O0, -O1, -O2 (default), etc.
  public static var optimizeLevel: Int32 {
    get { BinaryenGetOptimizeLevel() }
    set { BinaryenSetOptimizeLevel(newValue) }
  }

  /// The shrink level to use. Applies to all modules, globally.
  /// 0, 1, 2 correspond to -O0, -Os (default), -Oz.
  public static var shrinkLevel: Int32 {
    get { BinaryenGetShrinkLevel() }
    set { BinaryenSetShrinkLevel(newValue) }
  }

  /// Enables or disables debug information in emitted binaries.
  /// Applies to all modules, globally.
  public static var debugInfo: Bool {
    get { BinaryenGetDebugInfo() == 1 }
    set { BinaryenSetDebugInfo(newValue ? 1 : 0) }
  }

  /// Enable or disable coloring for the Wasm printer
  public static var isPrinterColoringEnabled: Bool {
    get { BinaryenAreColorsEnabled() == 1 }
    set { BinaryenSetColorsEnabled(newValue ? 1 : 0) }
  }

  /// Runs the specified passes on the module. Uses the currently set global
  /// optimize and shrink level.
  public func run(passes: [String]) {
    let mutablePasses = passes.map { strdup($0) }
    var immutablePasses = mutablePasses.map { UnsafePointer($0) }
    BinaryenModuleRunPasses(ref, &immutablePasses, UInt32(passes.count))
    mutablePasses.forEach { free($0) }
  }

  /// Serializes a module into binary form
  public func write() -> [UInt8] {
    let result = BinaryenModuleAllocateAndWrite(ref, nil)
    let ptr = UnsafeMutableBufferPointer(
      start: result.binary.bindMemory(to: UInt8.self, capacity: result.binaryBytes),
      count: result.binaryBytes
    )

    defer {
      free(result.binary)
      if let sourceMap = result.sourceMap {
        free(sourceMap)
      }
    }

    return .init(ptr)
  }

  /// Serialize a module in s-expression form.
  public func writeText() -> String? {
    guard let result = BinaryenModuleAllocateAndWriteText(ref) else { return nil }

    defer {
      free(result)
    }

    return String(cString: result)
  }

  public func addFunction(
    name: String,
    params: WasmType,
    result: WasmType,
    locals: [WasmType] = [],
    body: BinaryenExpressionRef
  ) -> BinaryenFunctionRef {
    name.withCString {
      BinaryenAddFunction(ref, $0, params.rawValue, result.rawValue, nil, 0, body)
    }
  }

  func getFunction(name: String) -> BinaryenFunctionRef {
    name.withCString {
      BinaryenGetFunction(ref, $0)
    }
  }

  func removeFunction(name: String) {
    name.withCString {
      BinaryenRemoveFunction(ref, $0)
    }
  }

  func addFunctionImport(
    internalName: String,
    externalModuleName: String,
    externalBaseName: String,
    params: WasmType,
    results: WasmType
  ) {
    internalName.withCString { internalName in
      externalModuleName.withCString { externalModuleName in
        externalBaseName.withCString { externalBaseName in
          BinaryenAddFunctionImport(
            ref, internalName, externalModuleName, externalBaseName, params.rawValue, results.rawValue
          )
        }
      }
    }
  }

  public func localGet(index: BinaryenIndex, type: WasmType) -> BinaryenExpressionRef {
    BinaryenLocalGet(ref, index, type.rawValue)
  }

  public func localSet(
    index: BinaryenIndex,
    value: BinaryenExpressionRef
  ) -> BinaryenExpressionRef {
    BinaryenLocalSet(ref, index, value)
  }

  public func binary(
    instruction: WasmInstruction,
    _ first: BinaryenExpressionRef,
    _ second: BinaryenExpressionRef
  ) -> BinaryenExpressionRef {
    BinaryenBinary(ref, instruction.rawValue, first, second)
  }

  deinit {
    BinaryenModuleDispose(ref)
  }
}
