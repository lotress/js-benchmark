MyClass = ->
  @a = 0
  return
MyClass.prototype.add = -> @a += 1
my_class_inst = new MyClass()
bound = ->
  @a += 1
.bind my_class_inst
context = => my_class_inst.a += 1
bench = require '../bench'
N = 1e7

a = =>
  for i in [1..N]
    bound()
  my_class_inst.a = 0

b = =>
  for i in [1..N]
    context()
  my_class_inst.a = 0

c = =>
  for i in [1..N]
    my_class_inst.add()
  my_class_inst.a = 0

bench.addCase 'bounded function', a
.addCase 'context function', b
.addCase 'method', c
.run 100