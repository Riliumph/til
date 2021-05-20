# templateの種類

C++のtemplateには多くの種類が存在する。  
C++11/14にてその数はかなり膨れ上がったと思う。  

今更感はあるが復習を兼ねてまとめたいと思う。  
※ルールが膨大過ぎてぜんぶ網羅するのは死んでしまうかもしれない。  

特殊化の種類

- 完全特殊化
- 部分特殊化

## templateの完全特殊化

templateはあらゆる型に適合させる機能な訳だが、実際に同じ実装を使いまわせるかどうかとは話が違う。  
その際に用いたりするのが完全特殊化である。  
この完全特殊化で作られるものは、クラス定義である。

この完全特殊化が行えるのは下記のパターンのみである。

- クラステンプレート
- 関数テンプレート

例えば、下のような２値を足し算する関数を考えてみる。  

```
template <typename T>
T sum(T v1, T v2){ return v1 + v2; }
```

このtemplate関数はchar*型の時に動いてくれるだろうか？  
結論としては動かない。なぜなら、cahr*型の+演算は言語規格で定義されていないからだ。  
※ああ、char型+演算は定義されているよ。  
　あちらは-128～127までの整数の足し算ができるからね。  

では、ここで言語規格に定義されていない「char*型同士の足し算」を独自定義してみよう。  
std::string型にちなんで連結してみるのはどうだろうか。  

```
#include <iostream>
#include <string.h>

template <typename T>
T sum(T v1, T v2){ return v1 + v2; }

template <>
char* sum(char *v1, char *v2){ return strcat(v1, v2); }

int main(void)
{
  char str1[20]={"abc"};
  char str2[10]={"def"};
  auto result = sum(str1, str2);
  std::cout << result << std::endl;
  return 0;
}
```

残念ながら、このコードでは下記のような書き方はできないので注意が必要だ。  

```
#include <iostream>
#include <string.h>

template <typename T>
T sum(T v1, T v2){ return v1 + v2; }

template <>
char* sum(char *v1, char *v2){ return strcat(v1, v2); }

/***** NGになるtemplateコード *****/
template <>
char* sum(char *v1, const char* v2){ return strcat(v1, v2); }

int main(void)
{
  char str1[20]={"abc"};
  auto result = strcat( str1, "fff");
  std::cout << result << std::end;
  return 0;
}

```

今回定義したtemaplteはT,T,T型のtemplateなので、constの値を取ることはできない。  
constは特殊な修飾子なので、別途にtemplateを用意する必要がある。  
さらに言うと、「sum(char, char)もどうせ第一引数に結果が入るならreturnしなくてもいいじゃん」とvoid型にすることもできない。  
上述したように、sumは return T型 argument T,T型であることを守らないといけない。  

**特殊化はあくまでベースのルールを守った上での特殊化である**  

これは、参照を取ったテンプレートパラメータにconst char*を与えようとしてエラーになるケースなども考えられる。  
このケースの場合でも、ベースが参照(&)にも関わらず、ポインタ(*)で特殊化しようとしたために発生するエラーとなる。  

なんども言うが、**完全特殊化はあくまでも、テンプレートパラメータの部分を具体化するだけなので、それ以外の部分い変化があるとダメ**  

# templateの部分特殊化

この完全特殊化が行えるのは下記のパターンのみである。

- クラステンプレート

あれ、関数テンプレートは(｡ωﾟ)？(ﾟ｡ ３ )？(ﾟω｡)？(ε｡ﾟ )？  
……そんな勘のいいPGは大好きだよ。  

関数テンプレートでは部分特殊化ができない代わりに、関数オーバーロードで対応することになる。

部分特殊化とは、元となる汎用なテンプレート引数のうち、一部のみを特殊化する方法である。  
そのため、部分特殊化で作られるものは完全特殊化のようなクラス定義ではなく、クラステンプレートのままである。  

<http://ppp-lab.sakura.ne.jp/ProgrammingPlacePlus/cpp/language/023.html>

```C



```
