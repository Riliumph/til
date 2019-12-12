# Join-Path は二つしか繋げない！？！？！？！？

下記のコマンドをサンプルとして作ったがうまく動かなかった。

```powershell
ls -File .\ | % { Join-Path $_.DirectoryName "result" $_.Name }
```

`%`は`ForEach-Object`へのエイリアスなのでそこの解説はスキップする。

どうやら、Join-Path は引数を二つまでしか取れないようだ。  
C#と同じ.NET が使えるというのに、Path.Combine()に劣るとは……。

なので、Join-Path は連打するしかない。

```powershell
ls -File .\ | % { (Join-Path ( Join-Path $_.DirectoryName "result" ) $_.Name ) }
```

## 補足

変数`$_`の型が知りたいって人は下のコマンドを使ってみてね。

```powershell
ls -File .\ | %{ echo $_.GetType().FullName }
```

ls には他のオプションもあってこういう名前の取り出し方もある。

```powershell
ls -File -Name .\ | % { echo &_.GetType().FullName }
```

これがどんな型かは想像がつくと思うが。
