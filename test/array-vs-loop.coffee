bench = require '../bench'
N = 1e6
a = => Array.from { length: N }, (_, i) => i
b = => [...Array N].map (_, i) => i
c = =>
  arr = []
  for i in [(N-1)..0]
    arr[i] = i
d = =>
  i = N
  arr = []
  while i--
    arr[i] = i
e = =>
  i = N
  arr = []
  while i--
    arr.push i
f = =>
  Array N
  .fill()
  .map (_, i) => i
numbers = ->
  i = 0
  while i < N
    yield i++
  return
g = =>
  [...numbers()]
h = =>
  arr = []
  for i from numbers()
    arr[i] = i
  arr
typed = =>
  arr = new Uint32Array N
  for i in [0...N]
    arr[i] = i
  arr
bench.addCase 'Array.from', a
.addCase 'Array splat', b
.addCase 'Array fill', f
.addCase 'for-loop', c
.addCase 'while-loop', d
.addCase 'while push', e
.addCase 'Generator', g
.addCase 'Generator for-loop', h
.addCase 'Uint32Array', typed
.run 100
