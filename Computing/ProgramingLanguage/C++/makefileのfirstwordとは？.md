# Makefileの:=と=の違いについて

## 単純展開（:=）

:=を単純展開変数という。
変数を定義したときの値がそのまま代入されます。

## 再起展開（=）

=(コロンが付かないイコール)を再帰展開変数といいます。
同じ名前の変数が定義され値が上書きされると再帰的にその値が参照されます。

# 確認

それでは実験してみましょう。

以下のようにMakefileを作ります。

```makefile
#再帰展開変数
aaa = "test"
bbb = $(aaa)
aaa = "testtest"

#単純展開変数
ccc := "exam"
ddd := $(ccc)
ccc := "examexam"

all:
   @echo $(aaa)
   @echo $(bbb)
   @echo $(ccc)
   @echo $(ddd)
```

以下の結果となります。

```bash
$ make
testtest
testtest
examexam
exam
```

再帰展開変数では両方ともtesttestになる。

単純展開変数では代入した値がそのまま表示されました。これが単純展開です。
