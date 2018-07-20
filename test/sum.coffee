bench = require '../bench'
N = 1e6
arr = (Math.random() for i in [1..N])
a = => arr.reduce (sum, x) => sum + x
b = =>
  i = arr.length
  sum = 0
  while i--
    sum += arr[i]
  sum
c = =>
  sum = 0
  arr0 = arr[0..]
  while (t = arr0.pop()) isnt undefined
    sum += t
  sum
d = =>
  sum = 0
  arr.forEach (x) => sum += x
  sum
e = =>
  sum = 0
  arr0 = arr[0..]
  while (t = arr0.shift()) isnt undefined
    sum += t
  sum
f = =>
  sum = 0
  it = do arr[Symbol.iterator]
  t = it.next()
  while not t.done
    sum += t.value
    t = it.next()
  sum
g = =>
  sum = 0
  for x from arr
    sum += x
  sum
h = =>
  sum = 0
  for x in arr
    sum += x
  sum

bench.addCase 'Array reduce', a
.addCase 'Array forEach', d
.addCase 'loop', b
.addCase 'pop loop', c
#.addCase 'shift loop', e // too slow, skipped
.addCase 'iterator', f
.addCase 'for of', g
.addCase 'for in', h
.run 100