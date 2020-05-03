# xargsコマンドの取り扱い

## xargs: unterminated quote

単独のシングルクオート、もしくは半角スペースのファイルが存在する状態を作る。  
今回は単独のシングルクオートとする。

```bash
$ ls
hoge'fuga.txt
```

次のコマンドを入力する。

```bash
$ find ./ | xargs echo
xargs: unterminated quote
```

`xargs`コマンドにおいて、クォーテーションは必ず終始がセットになっていなければならない。  
これは、`xargs`コマンドの終端文字が以下に設定されているからである。

- 半角スペース
- 単独のクォーテーション
- 改行文字

つまり、`xargs`の終端判定を変更することで解決できる。

```bash
$ find ./ -print0 | xargs -0 echo
hoge'fuga.txt
```

- find -print0  
  ファイルのパスをNULL(''\0'')文字区切りで表示する。

- xargs -0  
  セパレータをNULL文字 (``\0'') に変更する。  
  `find`の`-print0`関数と合わせて使用されることが期待される。
