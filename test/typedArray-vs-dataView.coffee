bench = require '../bench'

LittleEndian = (buffer) ->
  @uint8View_ = new Uint8Array buffer
  return
LittleEndian.prototype.getUint32 = (byteOffset) ->
  @uint8View_[byteOffset] | (@uint8View_[byteOffset + 1] << 8) |
  (@uint8View_[byteOffset + 2] << 16) | (@uint8View_[byteOffset + 3] << 24)

N = 1e6
buffer = new ArrayBuffer N << 2
view = new DataView buffer
array = new Int32Array buffer
array[i] = i for i in [0...N]
littleEndianArray = new LittleEndian buffer

a = ->
  for i in [0...N]
    littleEndianArray.getUint32 i << 2
  return

v = ->
  for i in [0...N]
    view.getUint32 i << 2, true
  return

bench.addCase 'TypedArray', a
.addCase 'DataView', v
.run 100