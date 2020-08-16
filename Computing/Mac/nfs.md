# NFSv3

## macOSをサーバーとして利用する

MacをNFSサーバーとして設定し、同じMacの別ディレクトリでマウントすることにする。  
正直、意味はない。

### 1.マウント設定

NFSサーバーが見るマウント設定を配置する。

```bash
$ sudo touch /etc/exports
```

### 2.設定値

macOSのファイルシステムは特殊になっている。  
たとえば、

- `/home`以下にファイルを配置することができない
- 実際のhome directoryは`/System/Volumes/Data/Users/username`

などなど。  
しかも、これがファイルシステムレベルで設定されているときたもんだ。  
Apple、お前はBSDを使ってるんだからBSDベースに合わせろボケと言いたくなる。

このホームディレクトリの違いにつまづくことが多いので注意すること。

という訳で、`/etc/exports`には以下の設定が必要になる。

```bash
$ echo "/System/Volumes/Data/Users/username/ localhost -alldirs -maproot=username" > /etc/exports
```

公開するべきはシンボリックリンクではダメなのだ。必ず、実ディレクトリを公開すること。

### 3. マウント設定のリロード

設定リロードは以下のどちらかを実行する

```bash
# NFSをリスタートする方法
$ sudo nfsd restart
# SIGHUPにより再読み込みさせる方法
$ kill -s HUP $(cat /var/run/mountd.pid)
```

マウント再設定を確認する

```bash
$ showmount -e localhost
/System/Volumes/Data/Users/username
```

### Macでマウントする場合

Macの制約はNFSサーバーとして使う時もそうだが、マウントする側でも同じだ。

```bash
$ sudo mount -t nfs 127.0.0.1:/System/Volumes/Data/Users/username /System/Volumes/Data/Users/username2/user1/
```
