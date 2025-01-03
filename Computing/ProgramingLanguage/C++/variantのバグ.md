# std::variantの中でstringがintに変換される問題

GCC9.3.0とclang9.0.1まで発生する。

`std::variant<std::string, int> ok = "hoge";`は`hoge`と出力されるが、  
`std::variant<std::string, bool> ng = "fuga";`は`1`と出力されてしまう。

`bool`型が悪さをしてしまっている。

## コード

```c++
#include <iostream>
#include <variant>

template<typename T0, class... Ts>
std::ostream&
operator<<(std::ostream& os, const std::variant<T0, Ts...>& lv)
{
  std::visit([&](const auto& x) { os << x; }, lv);
  return os;
}

int main()
{
    std::variant<std::string, int> ok = "hoge";
    std::cout << ok << std::endl;
    std::variant<std::string, bool> ng = "fuga";
    std::cout << ng << std::endl;
}
```

```console
hoge
1
```

## 参考

- [Wnadbox](https://wandbox.org/permlink/O2OSlYCqFIlGiDoV)
