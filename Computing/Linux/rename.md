# rename コマンドの使い方

## 環境差

mac(brew 版)と Linux で違うらしい。。。

## キャプチャを使う方法

キャプチャは`$n`では行われず、`\n`で行う。  
おそらく、これは`bash`の引数参照`$n`と区別がつかなくなるからだろうか。

```bash
# 先頭の「0.」や「1.」を「0_」や「1_」に変換する
rename -n "s/^[0-9]\./\1\_" *.*
```

## 桁揃えはsprintf

現在のディレクトリのすべてのファイルを対象とする場合。  
`sprintf`機能の引数には`$n`を使ってキャプチャする。  
すべてを対象とするときは`$&`を使う。

```bash
# 初めてキャプチャした数字列を3桁に直す
rename 's/(\d+)/sprintf("%03d", $1)/e' *
# すべての数字列を3桁に直す
rename 's/(\d+)/sprintf("%03d", $&)/e' *
```

## 再帰する場合

`rename`の引数に`hogehoge/*`と書きたいところだがどうもサポートされていない模様。
`find`や`ls -A`と`xargs`、`cd`を組み合わせて解決する。  

```bash
# 案１
find ./ -type d -print0 | xargs -0 -i bash -c "cd \"{}\" && rename 's/(\d+)/sprintf(\"%03d\", \$1)/e' *"
# 案２
ls -AC | xargs -i bash -c "cd \"{}\" && rename 's/(\d+)/sprintf(\"%03d\", \$1)/e' *"
```

- `sh -c`/`bash -c`  
  `xargs`が単一プロセスしか生成できないため、子プロセスとしてshellを生成する。
  コマンドが複数に跨る場合はダブルクォーテーション括る。
- `cd \"{}\"`  
  `bash -c`でダブルクォーテーションが使われているため、ダブルクォーテーションをエスケープしておくことが重要。  
  ダブルクォーテーションで括るのは`find`の結果にスペースが入っている場合に`cd`でエラーのを回避するため
- `rename`（perl版）  
  習わしでシングルクォーテーションで括る。  
  ただし、`sprintf`を内部で使う場合はダブルクォーテーションが使用されるためエスケープが必要。  
  また、`$1`はあくまで`bash`の`$1`として解釈されるため、`rename`の`$1`として解釈させるためにエスケープが必要。

### [find編]パイプするときは前段の結果に気をつけろ

`xargs`には`i`オプションを使って、パイプラインで受け取った前段の結果でコマンド内容を上書きする機能を持つ。  
これを使う際に躓いたので注意すること。

以下のコマンドはディレクトリ名をファイルの先頭に付与するrenameの使い方である。

> 02/01.txt -> 02/02_01.txt

```bash
# ワンライナーで書いているとエラー行数が参考にならない
$ find ./ -maxdepth 1 -mindepth 1 -type d -print0 | xargs -i -0 bash -c "cd {} && rename 's/(\d+)/sprintf(\"%s_%03d\", \"{}\", \$1)/e\' * -n"
Backslash found where operator expected at (eval 8) line 1, near "e\"
Unknown regexp modifier "/0" at (user-supplied code), near ""
Unknown regexp modifier "/1" at (user-supplied code), near "{
#line 1
"
```

「バックスラッシュが見つかったぞ」とあるので`\$1`の書式が誤っているかのように読めるが間違い。
これは`find`の結果が`02/`とスラッシュを含んでしまっているため、そこで`rename`の書式が崩れてしまっているのが原因。

### [ls編]パイプするときは前段の結果に気をつけろ

`ls`コマンドにも落とし穴があるので注意。  

- `-F` / `--classify`  
  ディレクトリの末尾に`/`を付与するため、`find`編と同じ問題を引き起こす
- `-x` / `--format=across` / `--format=horizontal`  
  横方向にソートして表示する。
  デフォルトは`-C`/`--format=vertical`が指定されているため。`xargs`には列データの各行のデータが一つずつ渡る。  
  しかし、`-x`が指定されていると行データ（配列）となってしまい、`xargs`には一行の「**配列データ**」が渡されることになる。  
  そのため、`cd`コマンドに大量の引数が渡ることになり`too many argument`エラーとなってしまう。

```bash
# -F / --classify
$ ls -AF | xargs -i bash -c "cd \"{}\" && rename 's/(\d+)/sprintf(\"%s_%03d\", \"{}\", \$1)/e\' * -n"
String found where operator expected at (eval 8) line 1, at end of line
        (Missing semicolon on previous line?)
Can't find string terminator '"' anywhere before EOF at (user-supplied code).
xargs: bash: exited with status 255; aborting
```

```bash
# -x / --format=across / --format=horizontal
$ ls -Ax | xargs -i bash -c "cd \"{}\" && rename 's/(\d+)/sprintf(\"%s_%03d\", \"{}\", \$1)/e\' * -n"
```

> readlineの設定で`set mark-symlinked-directories on`を有効にしていると`ls`の結果にも`/`や`@`が表示される。  
> しかし、これはあくまで表示の変更であり、`ls`コマンドの結果には影響しないので問題ない。
