# rename コマンドの使い方

## 環境差

mac(brew 版)と Linux で違うらしい。。。

## キャプチャを使う方法

キャプチャは`$n`では行われない。  
おそらく、これは`bash`の引数参照`$n`と区別がつかなくなるからだろうか。

```bash
rename -n "s/^[0-9]\./\1\_" *.*
```

`\n`で行う。
