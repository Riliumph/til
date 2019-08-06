# Vimのfiletype設定

## 概要
Vimはバッファ毎にロードした内容の種類(*1)を記憶している。  
*1:Python/Cなど  
その情報は`filetype`というオプションで表される。  
VimにはFiletype pluginという`filetype`に応じた機能を提供するスクリプトが存在する。  

Vimは標準で多数のfiletype pluginが同梱されている。  
例えば、Pythonのインデント情報が知りたけれな下記のコマンドをvim上で実行する。  

```vim:vim terminal
:edit $VIMRUNTIME/ftplugin/
:help ft-python-indent
```

Vim filetype pluginは、Emacsのmajor/minor modeとニアな存在であるとも言える。  


## filetype pluginのポイント

### filetype pluginはバッファローカル

バッファが持つ情報を操作するためバッファローカルでなければならない。  
具体的には、以下の３点ぐらいがある。  

- optionを指定する場合、setlocalにすること
- key mappingsを行う場合、<buffer>を指定すること
- Exコマンドを定義する場合、-bufferを指定すること
- etc...


### filetype pluginの無効化

ユーザー側で特定のfiletype pluginをスキップしたい場合などに使う無効化の手段がある。  
要領はインクルードガードと同じである。  
自作のスクリプトの上部に以下の記述を行う。  

```vim:vim
if exitsts('b:did_ftplugin')
  finish
endif
let b:did_ftplugin = 1
```

`b:did_ftplugin`変数は**標準のfiletype pluginに用いられている管理変数**である。  
それを共通して使うことで意図的にスキップすることができる。  

### 設定のキャンセル
設定をキャンセル、リセットするには下記のスクリプトを記述する。  

``` vim:vim
" expandtab設定をリセットする
let b:undo_ftplugin='setlocal expandtab<'
```

### filetype pluginの種類

filetype pluginには２種類の書き方がある。  
- Normal filetype plugin  
  .vim/ftplugin/に配置する  
- Additional filetype plugin  
  .vim/after/ftplugin/に配置する  

### 新たなfiletypeについてのfiletype pluginを作る
Normal filetype pluginに配置するのが望ましい  

### 標準のfiletype pluginを上書きする
Normal filetype pluginに配置するのが望ましい  
filetype pluginの無効化手段としてインクルードガードを使うべき。  
理由は、自身のfiletype pluginの後に標準のfiletype pluginが読み込まれて設定が上書きされるのを防止するため。  

### 標準のfiletype pluginに追加する
Additional filetype pluginに配置するのが望ましい。  
標準のftpluginがロード済みであるため、b:did_ftpluginのチェックとセットは行ってはならない。  
ただし、ロードチェックを行う必要はあるため、別の変数を使って（b:did_ftplugin_py_flagなど）チェックすること。  

