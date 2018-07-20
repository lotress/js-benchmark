bench = require '../bench'
N = 1e6
arr = [1..N]
set = new Set arr
map = new Map arr.map (x) => [x, x]
obj = {}
arr.forEach (x) => obj[x] = x
pattern = null

a = =>
  for x in pattern
    i = N
    while i-- and x isnt arr[i]
      undefined
    if x is arr[i] then i else -1

b = =>
  for x in pattern
    arr.indexOf x

forEach = =>
  res = []
  for x in pattern
    arr.forEach (y, i) =>
      if x is y
        res.push i
        false

some = =>
  for x in pattern
    arr.some (y) => x is y

includes = =>
  for x in pattern
    arr.includes x

has = =>
  for x in pattern
    set.has x

get = =>
  for x in pattern
    map.get x

property = =>
  for x in pattern
    obj[x]

p = => pattern = ((Math.random() * N) | 0 for i in [1..5])

bench.setPrepare p
.addCase 'while loop', a
.addCase 'Array indexOf', b
.addCase 'Array forEach', forEach
.addCase 'Array some', some
.addCase 'Array includes', includes
.addCase 'Set has', has
.addCase 'Map get', get
.addCase 'Object property', property
.run 100