import CBinaryen

public extension BinaryenType {
  static var none: Self { BinaryenTypeNone() }
  static var int32: Self { BinaryenTypeInt32() }
  static var int64: Self { BinaryenTypeInt64() }
  static var float32: Self { BinaryenTypeFloat32() }
  static var float64: Self { BinaryenTypeFloat64() }
  static var vec128: Self { BinaryenTypeVec128() }
  static var funcRef: Self { BinaryenTypeFuncref() }
  static var externRef: Self { BinaryenTypeExternref() }
  static var exnRef: Self { BinaryenTypeExnref() }
  static var anyRef: Self { BinaryenTypeAnyref() }
  static var eqRef: Self { BinaryenTypeEqref() }
  static var i31Ref: Self { BinaryenTypeI31ref() }
  static var auto: Self { BinaryenTypeAuto() }

  var arity: UInt32 { BinaryenTypeArity(self) }
}
