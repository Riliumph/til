# psコマンドの使い方

## プロセスと端末

プロセスは端末デバイスに結びついているという仕組みの理解が必要。  
`ps`コマンドの出力結果のTTYフィールドを見てみる

> TTY: TeleTYpewriter

```console
$ ps -aux
  PID TTY          TIME CMD
 1947 pts/9    00:00:00 bash
 3294 pts/9    00:00:00 ps
```

ターミナルとして開いた`bash`とその上で実行した`ps`が`pts/9`という端末に紐づいていることが確認できる。  

## デバイスファイル

PID:1947のプロセスを見てみる。

> `bash`自身のPIDは特殊変数`$$`や`$BASHPID`で取得できる。  
> `$$`と`$BASHPID`はサブシェルでの評価結果が違うので注意すること。

```console
$ \ls -l /proc/$$/fd
0 -> /dev/pts/9 # 標準入力
1 -> /dev/pts/9 # 標準出力
2 -> /dev/pts/9 # 標準エラー出力
22 -> /dev/ptmx
255 -> /dev/pts/9
```

`ps`コマンドの結果通り、`/dev/pts/9`に紐づいていることが確認できる。

## 他の端末に出力してみる

ターミナルを二つ用意してみる。

```console
$ tty
/dev/pts/9
```

```console
$ tty
/dev/pts/7
```

では、`pts/9`のデバイスから`pts/7`へ書き込んでみる

```console
$ echo hello > /dev//pts/7
```

`pts/7`に繋がっているターミナルに`hello`が入力されたハズである。
