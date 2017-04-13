# sudo で alias が使いたい
通常、sudoするとaliasは無効になる。  
どうにかこれを解決する方法はないモノかと探したところ、こうすればいいらしい  

``` bash
# 最後に半角スペースを入れるのがポイント
alias sudo='sudo '
```

なんでじゃ？ってなる訳だけど、Bashのマニュアルにあった  

>The first word of each simple command, if unquoted, is checked to see if it has an alias. […] If the last character of the alias value is a space or tab character, then the next command word following the alias is also checked for alias expansion.

雑訳すると
最初のコマンドが引用符で囲まれていない場合に alias を確認する。alias の値がスペースかタブで終わっていればその次のコマンドも確認する  

なるほどー(´･_･`)  
