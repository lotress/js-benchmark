// Generated by CoffeeScript 2.3.1
var addCase, argmax, argmin, avg, bench, cases, compare, exec, getStdPersent, now, p, prepare, printResult, r, resetLine, run, runSamples, sampleStd, setPrepare, sum, toFixed3;

resetLine = (() => {
  var readline;
  if (typeof process !== "undefined" && process !== null ? process.stdout : void 0) {
    readline = require('readline');
    return () => {
      return readline.moveCursor(process.stdout, 0, -1);
    };
  } else {
    return () => {};
  }
})();

now = (() => {
  var t;
  if (t = typeof process !== "undefined" && process !== null ? process.hrtime : void 0) {
    if (t.bigint) {
      console.log('Using process.hrtime.bigint as timer');
      return () => {
        return parseFloat(t.bigint()) * 1e-6;
      };
    } else {
      console.log('Using process.hrtime as timer');
      return (time) => {
        var diff;
        diff = process.hrtime(time);
        if (time) {
          return parseFloat(diff[0] * 1e3 + diff[1] * 1e-6);
        } else {
          return diff;
        }
      };
    }
  } else if (typeof performance !== "undefined" && performance !== null ? performance.now : void 0) {
    console.log('Using performance.now as timer');
    return performance.now.bind(performance);
  } else {
    console.warn('Not found any High Resolution Timer, using Date as a less precise baseline.');
    return Date.now;
  }
})();

compare = (a, b) => {
  return a - b;
};

r = (c) => {
  return (res, x, i) => {
    if (c(res.x, x) < 0) {
      return res;
    } else {
      return {x, i};
    }
  };
};

argmin = (arr, c = compare) => {
  return arr.reduce(r(c), {
    x: arr[0],
    i: 0
  }).i;
};

argmax = (arr, c = compare) => {
  var _c;
  _c = (a, b) => {
    return -c(a, b);
  };
  return argmin(arr, _c);
};

sum = (data) => {
  if (data != null ? data.length : void 0) {
    return data.reduce((sum, x) => {
      return sum + x;
    });
  } else {
    return 0;
  }
};

avg = (data) => {
  var n;
  n = data != null ? data.length : void 0;
  if (n) {
    return parseFloat(sum(data)) / n;
  } else {
    return 0;
  }
};

sampleStd = (data) => {
  var a, n, residualSqr, stdN;
  n = data.length;
  if (n < 2) {
    return 0;
  } else {
    a = avg(data);
    residualSqr = data.map((x) => {
      r = parseFloat(x) - a;
      return r * r;
    });
    stdN = sum(residualSqr);
    return Math.sqrt(stdN / (n - 1));
  }
};

cases = [];

prepare = () => {
  return void 0;
};

p = Promise.resolve();

addCase = (description, func) => {
  cases.push({description, func});
  return bench;
};

exec = async(item) => {
  var end, start;
  start = now();
  await item.func();
  end = now(start);
  return item.samples.push(end - start);
};

toFixed3 = (x) => {
  return x.toFixed(3);
};

getStdPersent = (item) => {
  return toFixed3(100 * item.std / item.avg);
};

printResult = (item) => {
  var result;
  console.log(`Bench ${item.description}:`);
  result = ['', 'average time:', `${toFixed3(item.avg)}ms`, `±${getStdPersent(item)}%`];
  result.push((function() {
    switch (item.rank) {
      case 1:
        return 'fastest';
      case 2:
        return 'slowest';
    }
  })());
  return console.log(result.join('\t'));
};

runSamples = async(samples) => {
  var i, item, j, k, len, ref, results;
  results = [];
  for (i = j = 1, ref = samples; (1 <= ref ? j <= ref : j >= ref); i = 1 <= ref ? ++j : --j) {
    console.log(`Sampling #${i}`);
    await prepare();
    for (k = 0, len = cases.length; k < len; k++) {
      item = cases[k];
      await exec(item);
    }
    results.push(resetLine());
  }
  return results;
};

run = (samples = 32) => {
  if (!(samples > 0)) {
    throw new Error('Sample counts need > 0');
  }
  cases.forEach((item) => {
    item.rank = 0;
    return item.samples = [];
  });
  p = p.then(runSamples.bind(null, samples)).catch(console.error.bind(console)).then(() => {
    var times;
    times = cases.map((item) => {
      return sum(item.samples);
    });
    if (samples > 1) {
      cases[argmin(times)].rank = 1;
      cases[argmax(times)].rank = 2;
    }
    cases.forEach((item, i) => {
      item.avg = parseFloat(times[i]) / samples;
      return item.std = sampleStd(item.samples);
    });
    return cases.forEach(printResult);
  });
  return bench;
};

setPrepare = (f) => {
  prepare = f;
  return bench;
};

bench = {addCase, run, setPrepare};

module.exports = bench;
