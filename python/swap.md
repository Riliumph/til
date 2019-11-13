# pythonのswapは特殊

pythonに標準ライブラリのswap関数はない。  
※C/C++ならstd::swap()関数が存在する。  
しかし、機能的にないわけではない。  

``` python
a = 10
b = 20
a, b = b, a
```

ああ、確かにPythonらしいな
