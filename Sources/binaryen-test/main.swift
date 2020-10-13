import Binaryen

let module = WasmModule()

let first = module.localGet(index: 0, type: .int32)
let second = module.localGet(index: 1, type: .int32)

let add = module.binary(op: .addInt32, first, second)

let adder = module.addFunction(name: "adder", params: [.int32, .int32], result: .int32, body: add)

module.print()
