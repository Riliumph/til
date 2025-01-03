# NaNとInfを扱えない

## サンプルコード

```python
import json
# NaN, Infinity, -Infinity の値を用意

test_values = {
    "NaN": float("nan"),
    "Infinity": float("inf"),
    "-Infinity": float("-inf"),
}

f_inf = float('inf')
f_minf = float('-inf')
f_nan = float('nan')
print(f"NaN: {f_nan}({type(f_nan)}) Infinity: {f_inf}({type(f_inf)} -Infinity: {f_minf}({type(f_minf)})")

# JSONに変換を試みる
result = {}
for key, value in test_values.items():
    try:
        result[key] = json.dumps({"value": value})
    except (TypeError, ValueError) as e:
        result[key] = f"Error: {e}"
print(result)
print(f"NaN: {result['NaN']}({type(result['NaN'])})")
```

```console
NaN: nan(<class 'float'>) Infinity: inf(<class 'float'> -Infinity: -inf(<class 'float'>)
{'NaN': '{"value": NaN}', 'Infinity': '{"value": Infinity}', '-Infinity': '{"value": -Infinity}'}
NaN: {"value": NaN}(<class 'str'>)
```

Pythonでは`inf`などは`float`として認識される。  
しかし、`json.dump()`をかませると`str`となってしまう。

## これは意図通り？

> [Douglas Crockford](https://www.crockford.com/nota.html)  
> Nota maintains JSON's design philosophy of being at the intersection of most programming languages and most data types.  
> The representation of numbers is completely independent of problematic number formats like IEEE 754.

NaNやinfを禁止にすれば、環境に依存せずにどんなデータでも扱える。  
よってstring扱いする！

って感じ？

## 参考

- [はすじょい (hsjoihs)](https://x.com/hsjoihs/status/1859173427946705300)
