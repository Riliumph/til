# Vim の filetype 設定

## 概要

Vim はバッファ毎にロードした内容の種類(\*1)を記憶している。

> \*1:Python/C など

その情報は`filetype`というオプションで表される。  
Vim には Filetype plugin という`filetype`に応じた機能を提供するスクリプトが存在する。

Vim は標準で多数の filetype plugin が同梱されている。  
例えば、Python のインデント情報が知りたけれな下記のコマンドを vim 上で実行する。

```vim:vim terminal
:edit $VIMRUNTIME/ftplugin/
:help ft-python-indent
```

Vim filetype plugin は、Emacs の major/minor mode とニアな存在であるとも言える。

## filetype plugin のポイント

### filetype plugin はバッファローカル

バッファが持つ情報を操作するためバッファローカルでなければならない。  
具体的には、以下の３点ぐらいがある。

- option を指定する場合、`setlocal`にすること
- key mappings を行う場合、`<buffer>`を指定すること
- Ex コマンドを定義する場合、`-buffer`を指定すること
- etc...

### filetype plugin の無効化

ユーザー側で特定の filetype plugin をスキップしたい場合などに使う無効化の手段がある。  
要領はインクルードガードと同じである。  
自作のスクリプトの上部に以下の記述を行う。

```vim:vim
if exitsts('b:did_ftplugin')
  finish
endif
let b:did_ftplugin = 1
```

`b:did_ftplugin`変数は**標準の filetype plugin に用いられている管理変数**である。  
それを共通して使うことで意図的にスキップすることができる。

### 設定のキャンセル

設定をキャンセル、リセットするには下記のスクリプトを記述する。

```vim:vim
" expandtab設定をリセットする
let b:undo_ftplugin='setlocal expandtab<'
```

### filetype plugin の種類

filetype plugin には２種類の書き方がある。

- Normal filetype plugin  
  .vim/ftplugin/に配置する
- Additional filetype plugin  
  .vim/after/ftplugin/に配置する

### 新たな filetype についての filetype plugin を作る

Normal filetype plugin に配置するのが望ましい

### 標準の filetype plugin を上書きする

Normal filetype plugin に配置するのが望ましい  
filetype plugin の無効化手段としてインクルードガードを使うべき。  
理由は、自身の filetype plugin の後に標準の filetype plugin が読み込まれて設定が上書きされるのを防止するため。

### 標準の filetype plugin に追加する

Additional filetype plugin に配置するのが望ましい。  
標準の ftplugin がロード済みであるため、b:did_ftplugin のチェックとセットは行ってはならない。  
ただし、ロードチェックを行う必要はあるため、別の変数を使って（b:did_ftplugin_py_flag など）チェックすること。
