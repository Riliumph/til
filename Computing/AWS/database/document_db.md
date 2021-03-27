# Document DB

## Read Replica

```aws
readPreference = secondaryPreferred
```

この設定値を設定すると、読み込み命令は Read Replica へ優先して振り分けるようになる。  
よって、AZ-a が Primary、AZ-c/d が Read Replica のとき、AZ-c/d のコネクション数が増加する。
