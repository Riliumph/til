# python の swap は特殊

python に標準ライブラリの swap 関数はない。  
※C/C++なら std::swap()関数が存在する。  
しかし、機能的にないわけではない。

```python
a = 10
b = 20
a, b = b, a
```

ああ、確かに Python らしいな
