
function asmFunc(global, env) {
 var Math_imul = global.Math.imul;
 var Math_fround = global.Math.fround;
 var Math_abs = global.Math.abs;
 var Math_clz32 = global.Math.clz32;
 var Math_min = global.Math.min;
 var Math_max = global.Math.max;
 var Math_floor = global.Math.floor;
 var Math_ceil = global.Math.ceil;
 var Math_sqrt = global.Math.sqrt;
 var abort = env.abort;
 var nan = global.NaN;
 var infinity = global.Infinity;
 var f = -1412567121;
 var f$hi = 305419896;
 function call($0, $0$hi) {
  $0 = $0 | 0;
  $0$hi = $0$hi | 0;
 }
 
 function $1() {
  var i64toi32_i32$0 = 0;
  i64toi32_i32$0 = f$hi;
  call(f | 0, i64toi32_i32$0 | 0);
  i64toi32_i32$0 = 287454020;
  f = 1432778632;
  f$hi = i64toi32_i32$0;
 }
 
 return {
  "exp": $1
 };
}

var retasmFunc = asmFunc({
    Math,
    Int8Array,
    Uint8Array,
    Int16Array,
    Uint16Array,
    Int32Array,
    Uint32Array,
    Float32Array,
    Float64Array,
    NaN,
    Infinity
  }, {
    abort: function() { throw new Error('abort'); }
  });
export var exp = retasmFunc.exp;
