# watchコマンド

## リダイレクトはシングルクオートで囲め

`watch`コマンドは定期的にコマンド実行してくれる非常に便利なコマンドツールだ。  
この`watch`を結果をログとして取りたいとき、以下のようなコードにしてしまいがちだ。

```bash
$ watch -n 1 -p nvidia-smi --format=csv | tee -a watch.log
```

このコマンドの解釈はこうなる。

- `watch`が`nvidia-smi`を実行する
- `watch`の結果を`tee`に渡す

`watch`のはエスケープ文字列が含まれているため、ログが非常に大変なことになる。

次のように、ログ出力までを`watch`で行うようにすると解決する。

```bash
$ watch -n 1 -p 'nvidia-smi --format=csv | tee -a watch.log'
```
