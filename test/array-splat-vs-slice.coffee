bench = require '../bench'
N = 1e6
arr = (Math.random() for i in [1..N])
a = => arr[0..]
b = => [...arr]

bench.addCase 'Array slice', a
.addCase 'Array splat', b
.run 100