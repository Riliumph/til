# Tips

## ECRの削除権限は剥奪するべき

ECRの削除権限を持っている場合、ECRのイメージを削除できる。  
これ自体は、現在動いているFargateに対しては特に問題はない。  
ただ、Fargateのオートスケール設定によりスケールアウトする場合、新しいタスクはECRのイメージを改めて拾いに行くためイメージを引っ張ることができず、スケールアウトに失敗する。

よって、本番環境への削除権限は剥奪しておくことが望ましい。