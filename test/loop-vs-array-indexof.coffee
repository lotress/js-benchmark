bench = require '../bench'
N = 1e6
arr = [1..N]
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

p = => pattern = ((Math.random() * N) | 0 for i in [1..5])

bench.setPrepare p
.addCase 'while loop', a
.addCase 'Array indexOf', b
.run 100