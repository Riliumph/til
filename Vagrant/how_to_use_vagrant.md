# Vagrantの使い方

# 環境について
ubuntu18.04
virtualbox 5.0.2
vagrant 2.02

# インストール

ubuntu14.04からは`apt-get`じゃなくて`apt`が推奨されてるのでそっちを使います。  
※aptitude君は忘れ去れらてしまったのだ。  

```bash
$ sudo apt update
$ sudo apt install virtualbox=5.2.18-dfsg-2~ubuntu18.04.3
$ sudo apt install vagrant=2.0.2+dfsg-2ubuntu8
```

バージョンなんてなんでもいいぜって人はバージョン抜きで実行して最新版を入れてください。  
バージョンを確認したいぜって人は以下のコマンドで確認できます。  

```bash:version check
$ apt policy vagrant
vagrant:
  インストールされているバージョン: 2.0.2+dfsg-2ubuntu8
  候補:               2.0.2+dfsg-2ubuntu8
  バージョンテーブル:
 *** 2.0.2+dfsg-2ubuntu8 500
        500 http://jp.archive.ubuntu.com/ubuntu bionic/universe amd64 Packages
        500 http://jp.archive.ubuntu.com/ubuntu bionic/universe i386 Packages
        100 /var/lib/dpkg/status
```

……まさかのバージョンテーブルが１つしかない。  
他にも候補があれば、そのバージョンが表示されるはずです。  

# 