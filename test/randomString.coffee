bench = require '../bench'
crypto = require 'crypto'

N = 1e4
length = 30

c = ->
  for i in [1..N]
    b = crypto.randomBytes length
  return

r = ->
  a = new Uint8Array length
  for i in [1..N]
    a[j] = Math.floor(Math.random() * 256) for j in [0...length]
    b = Buffer.from a
  return

bench.addCase 'crypto.randomBytes', c
.addCase 'Math.random', r
.run 100