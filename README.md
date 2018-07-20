# Javascript Benchmarks
----
## What's this?
A collection of some javascript benchmarks.

## Requirements
- Node.js >= v10.7

- CoffeeScript >= v2.3

## Install
```bash
git clone https://github.com/lotress/js-benchmark.git
```

## Usage
Run tests under [test](./test) folder.

```bash
coffee ./test/<test name>.coffee
```

A benchmark framework is included as [bench.js](./bench.js).

```javascript
import bench from './bench'

const N = 1e6
var arr = Array.from({ length: N }, (_, i) => i)
const p = () => {
  // do something each sample before all cases
}

const case1 = () => arr.slice(0) // do some heavy computing

const case2 = () => [...arr]

bench.setPrepare(p)
.addCase("Array slice", case1)
.addCase("Array splat", case2)
.run(100) // Run each case 100 times, then print results to console, returns bench itself
/*
Bench Array slice:
        average time:   4.247ms ±19.910%       fastest
Bench Array splat:
        average time:   31.657ms        ±9.583%        slowest
*/
```
