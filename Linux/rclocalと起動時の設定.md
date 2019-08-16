# /etc/rc.localとはなんぞや？

結論を書くと  
**起動時に自動的に実行するコマンド羅列**  
らしい  
$HOME/.bashrcとかのshell起動時ではなくて、OS起動時にしてくれるのがミソ  

> Systemdになってからは通用しなくなった気がする。残念！！

# 起動時にやってくれたらうれしい設定

まともにメモリを積んでるマシンだったらswap設定っていらないと思う。  
こう書いておくと、ちょっと幸せになれるかも  

``` bash
sudo vim /etc/rc.local
```

```bash rc.local
#!/bin/sh -e
#
# rc.local
#
# This script is executed at the end of each multiuser runlevel.
# Make sure that the script will "exit 0" on success or any other
# value on error.
#
# In order to enable or disable this script just change the execution
# bits.
#
# By default this script does nothing.
swapoff -a
exit 0
```
