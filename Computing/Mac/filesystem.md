# macOSのファイルシステム

## システム生合成保護　- rootless -

macOSはOS X EI Captionから[System Integrity Protection](https://ja.wikipedia.org/wiki/%E3%82%B7%E3%82%B9%E3%83%86%E3%83%A0%E6%95%B4%E5%90%88%E6%80%A7%E4%BF%9D%E8%AD%B7)を導入している。  
このセキュリティにより「たとえroot権限実行であったとしても、システム所有のファイルとディレクトリを特定の資格を持たない場合は変更できない」を実現している。  
これは、Appleの「Rootユーザーはセキュリティ面で重大なリスク」という思想から導入された。  

> Pierre-Olivier Martel  
> マルウェアが1つのパスワードでデバイスを完全に制御することが出来る、という脆弱性がある。

拡張設定は以下のファイルで管理されている。

- `/System/Library/rootless.conf`

## rootの情報を確認する

> 参考：[瀧/TAKI's Blog: macOS 10.15 Catalina](https://kohju.justplayer.com/Tips_MacOSX_calalina10.15.html)

まず、rootを見てみよう

```bash
$ ls -lahT
-rw-rw-r--    1 root  admin     0B Feb 29 15:10:13 2020 .DS_Store
drwx------    2 root  admin    64B Jun  8 08:47:52 2017 .PKInstallSandboxManager-SystemSoftware/
lrwxr-xr-x    1 root  admin    36B Apr  7 07:17:20 2020 .VolumeIcon.icns@ -> System/Volumes/Data/.VolumeIcon.icns
----------    1 root  admin     0B Feb 29 15:10:13 2020 .file
drwx------  103 root  wheel   3.2K Jul 21 08:36:19 2020 .fseventsd/
drwxr-xr-x    2 root  wheel    64B Feb 29 15:09:52 2020 .vol/
drwxrwxr-x+  47 root  admin   1.5K Aug 15 04:09:32 2020 Applications/
drwxr-xr-x   65 root  wheel   2.0K Jul 21 08:34:24 2020 Library/
drwxr-xr-x@   8 root  wheel   256B Apr  7 04:46:16 2020 System/
drwxr-xr-x    5 root  admin   160B Apr  7 04:45:13 2020 Users/
drwxr-xr-x    3 root  wheel    96B Aug 15 04:22:41 2020 Volumes/
drwxr-xr-x@  38 root  wheel   1.2K Jul 21 08:31:47 2020 bin/
drwxr-xr-x    2 root  wheel    64B Feb 29 15:11:45 2020 cores/
dr-xr-xr-x    3 root  wheel   4.3K Aug  5 03:23:35 2020 dev/
lrwxr-xr-x@   1 root  admin    11B Apr  7 07:07:13 2020 etc@ -> private/etc
lrwxr-xr-x    1 root  wheel    25B Aug  5 03:23:44 2020 home@ -> /System/Volumes/Data/home
drwxr-xr-x    2 root  wheel    64B Feb 29 15:20:23 2020 opt/
drwxr-xr-x    6 root  wheel   192B Jul 21 08:32:55 2020 private/
drwxr-xr-x@  63 root  wheel   2.0K Jul 21 08:31:47 2020 sbin/
lrwxr-xr-x@   1 root  admin    11B Apr  7 07:17:20 2020 tmp@ -> private/tmp
drwxr-xr-x@  11 root  wheel   352B Apr  7 07:17:24 2020 usr/
lrwxr-xr-x@   1 root  admin    11B Apr  7 07:17:20 2020 var@ -> private/var
```

多くのLinuxディレクトリ構成がシンボリックリンクで構成されている。

## ホームディレクトリが別の場所にある

``` bash
lrwxr-xr-x    1 root  wheel    25B Aug  5 03:23:44 2020 home@ -> /System/Volumes/Data/home
```

これから分かるように、ホームディレクトリは別のところにある。  

## ファイル配置の制限

rootlessが導入されているため、ユーザーはファイルを配置する場所を限定される。  
例えば、Linuxと同様に`/home`というディレクトリは持つが、ここにファイルを配置することはできない。

これは、マウント情報を見ることでより分かる。

```bash
$ mount -v
/dev/disk1s1 on / (apfs, local, read-only, journaled)
devfs on /dev (devfs, local, nobrowse)
/dev/disk1s2 on /System/Volumes/Data (apfs, local, journaled, nobrowse)
/dev/disk1s5 on /private/var/vm (apfs, local, journaled, nobrowse)
map auto_home on /System/Volumes/Data/home (autofs, automounted, nobrowse)
```

root(`/`)がread-onlyの設定でマウントされている。これが原因だ。

```bash
$ touch hoge.txt
touch: hoge.txt: Operation not supported
# 権限が足りない場合はこちらのエラーが出るので、マウント設定なのは明らか
# touch: hoge.txt: Permission denied
```
