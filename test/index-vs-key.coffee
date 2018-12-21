bench = require '../bench'
N = 1e6
length = 100003
buffer = new Uint32Array length
arr = null
map = new Map()
obj = {}

a = =>
  c = 0
  l = 0
  for i in [1..N]
    if l is length
      console.error 'full'
    c += 1 while arr[c % length]
    arr[c % length] = i
    l += 1
    ac = (N % i) % length
    x = arr[ac]
    if x
      l -= 1
    arr[ac] = 0
  return x

b = =>
  c = 0
  l = 0
  for i in [1..N]
    if l is length
      console.error 'full'
    c += 1 while buffer[c % length]
    buffer[c % length] = i
    l += 1
    ac = (N % i) % length
    x = buffer[ac]
    if x
      l -= 1
    buffer[ac] = 0
  return x

get = =>
  for i in [1..N]
    map.set i, i
    x = map.get N % i
    map.delete N % i
  return x

property = =>
  for i in [1..N]
    obj[i] = i
    x = obj[N % i]
    delete obj[N % i]
  return x

p = ->
  map = new Map()
  obj = {}
  arr = (0 for i in [1..length])
  for i in [0...length]
    buffer[i] = 0
  return

bench.setPrepare p
.addCase 'Array index', a
.addCase 'TypedArray', b
.addCase 'Map get', get
.addCase 'Object property', property
.run 100