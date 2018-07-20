bench = require '../bench'
N = 1e6
a = do =>
  data = [0]
  f = (i) => data[0] = i
  {f}
b = do =>
  data = [0]
  f = (i) -> data[0] = i
  {f}
c = new class
  constructor: -> @data = [0]
  f: (i) -> @data[0] = i
run = (o) => =>
  o.f i for i in [1..N]
bench.addCase 'fat arrow function\'s closure', run a
.addCase 'closure', run b
.addCase 'class', run c
.run 200
