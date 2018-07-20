# common-node
----
## What's this?
A collection of some javascript benchmarks.

## Requirements
Node.js >= v10.7
CoffeeScript >= v2.3

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

const benchCase = => {
  // do some heavy computing
}

const case2 = => {
  // do some heavy computing
}

bench.addCase("bench description", benchCase)
.addCase("bench case 2", case2)
.run(32) // Run each case 32 times, then print results to console
```
