readline = require 'readline'
time = process.hrtime

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

addCase = (description, func) =>
  cases.push {description, func}
  bench

exec = (item) =>
  start = time.bigint()
  item.func()
  end = time.bigint()
  item.samples.push end - start

toFixed3 = (x) => x.toFixed(3)

getStdPersent = (item) => toFixed3 100 * item.std / item.avg

printResult = (item) =>
  console.log "Bench #{item.description}:"
  result = ['', 'average time:', "#{toFixed3(item.avg / 1e6)}ms",
    "±#{getStdPersent item}%"]
  result.push switch item.rank
    when 1
      'fastest'
    when 2
      'slowest'
  console.log result.join '\t'

run = (samples = 32) =>
  if not (samples > 0)
    throw new Error 'Sample counts need > 0'
  cases.forEach (item) =>
    item.rank = 0
    item.samples = []
  for i in [1..samples]
    readline.clearLine process.stdout, 0
    console.log "Sampling ##{i}"
    cases.forEach exec
    readline.moveCursor process.stdout, 0, -1
  times = cases.map (item) => sum item.samples
  if samples > 1
    cases[argmin times].rank = 1
    cases[argmax times].rank = 2
  cases.forEach (item, i) =>
    item.avg = parseFloat(times[i]) / samples
    item.std = sampleStd item.samples
  readline.clearLine process.stdout, 0
  cases.forEach printResult
  bench

bench = {addCase, run}
module.exports = bench