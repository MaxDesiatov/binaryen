import CBinaryen

extension BinaryenType {
  static var int32: Self { BinaryenTypeInt32() }
}

extension BinaryenOp {
  static var addI32: Self { BinaryenAddInt32() }
}

extension BinaryenType: ExpressibleByArrayLiteral {
  public init(arrayLiteral elements: BinaryenType...) {
    var elements = elements
    self = BinaryenTypeCreate(&elements, UInt32(elements.count))
  }
}

final class BinaryenModule {
  private let ref = BinaryenModuleCreate()

  func addFunction(
    name: String,
    params: BinaryenType,
    result: BinaryenType,
    locals: [BinaryenType] = [],
    body: BinaryenExpressionRef
  ) -> BinaryenFunctionRef {
    name.withCString {
      BinaryenAddFunction(ref, $0, params, result, nil, 0, add)
    }
  }

  func localGet(index: BinaryenIndex, type: BinaryenType) -> BinaryenExpressionRef {
    BinaryenLocalGet(ref, index, type)
  }

  func binary(
    op: BinaryenOp,
    _ first: BinaryenExpressionRef,
    _ second: BinaryenExpressionRef
  ) -> BinaryenExpressionRef {
    BinaryenBinary(ref, op, first, second)
  }

  func print() {
    BinaryenModulePrint(ref)
  }

  deinit {
    BinaryenModuleDispose(ref)
  }
}

let module = BinaryenModule()

let first = module.localGet(index: 0, type: .int32)
let second = module.localGet(index: 1, type: .int32)

let add = module.binary(op: .addI32, first, second)

let adder = module.addFunction(name: "adder", params: [.int32, .int32], result: .int32, body: add)

module.print()
