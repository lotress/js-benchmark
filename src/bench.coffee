resetLine = do =>
  if process?.stdout
    readline = require 'readline'
    => readline.moveCursor process.stdout, 0, -1
  else
    => return

now = do => if t = process?.hrtime
  if t.bigint
    console.log 'Using process.hrtime.bigint as timer'
    => parseFloat(t.bigint()) * 1e-6
  else
    console.log 'Using process.hrtime as timer'
    (time) =>
      diff = process.hrtime time
      if time
        parseFloat diff[0] * 1e3 + diff[1] * 1e-6
      else diff
else if performance?.now
  console.log 'Using performance.now as timer'
  performance.now.bind performance
else
  console.warn 'Not found any High Resolution Timer,
  using Date as a less precise baseline.'
  Date.now

compare = (a, b) => a - b
r = (c) => (res, x, i) => if c(res.x, x) < 0 then res else {x, i}
argmin = (arr, c = compare) =>
  arr.reduce r(c), {x: arr[0], i: 0}
  .i
argmax = (arr, c = compare) =>
  _c = (a, b) => - c a, b
  argmin arr, _c

sum = (data) =>
  if data?.length
    data.reduce (sum, x) => sum + x
  else 0

avg = (data) =>
  n = data?.length
  if n then parseFloat(sum data) / n
  else 0

sampleStd = (data) =>
  n = data.length
  if n < 2 then 0
  else
    a = avg data
    residualSqr = data.map (x) =>
      r = parseFloat(x) - a
      r * r
    stdN = sum residualSqr
    Math.sqrt stdN / (n - 1)

cases = []
prepare = => undefined
p = Promise.resolve()

addCase = (description, func) =>
  cases.push {description, func}
  bench

exec = (item) =>
  start = now()
  await do item.func
  end = now start
  item.samples.push end - start

toFixed3 = (x) => x.toFixed 3

getStdPersent = (item) => toFixed3 100 * item.std / item.avg

printResult = (item) =>
  console.log "Bench #{item.description}:"
  result = ['', 'average time:', "#{toFixed3(item.avg)}ms",
    "±#{getStdPersent item}%"]
  result.push switch item.rank
    when 1
      'fastest'
    when 2
      'slowest'
  console.log result.join '\t'

runSamples = (samples) =>
  for i in [1..samples]
    console.log "Sampling ##{i}"
    await do prepare
    for item in cases
      await exec item
    resetLine()

run = (samples = 32) =>
  if not (samples > 0)
    throw new Error 'Sample counts need > 0'
  cases.forEach (item) =>
    item.rank = 0
    item.samples = []
  p = p.then runSamples.bind null, samples
  .catch console.error.bind console
  .then =>
    times = cases.map (item) => sum item.samples
    if samples > 1
      cases[argmin times].rank = 1
      cases[argmax times].rank = 2
    cases.forEach (item, i) =>
      item.avg = parseFloat(times[i]) / samples
      item.std = sampleStd item.samples
    cases.forEach printResult
  bench

setPrepare = (f) =>
  prepare = f
  bench

bench = {addCase, run, setPrepare}
module.exports = bench