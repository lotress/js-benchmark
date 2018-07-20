bench = require '../bench'
N = 1e6
b = =>
  arr = new Uint32Array(N)
  i = N
  while i--
    arr[i] = i
a = =>
  i = N
  arr = []
  while i--
    arr.push i
bench.addCase 'Array', a
.addCase 'Uint32Array', b
.run 100