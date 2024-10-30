---
title: SSHのポートに対してスキャンされた場合にOpenSSHのバージョンを知られたくない
tags: Nmap SSH sshd nc sshd_config
author: akase244
slide: false
---
nmap/ncコマンドでSSHのポートに対して接続を試みようとすると、このようにOpenSSHのバナーが表示され、利用しているOpenSSHのバージョン番号がバレてしまいます。

```:CentOS7の場合
$ echo "" |nc localhost 22
SSH-2.0-OpenSSH_7.4
Protocol mismatch.
```

```:CentOS7の場合
$ nmap -A -p 22 localhost 

Starting Nmap 6.40 ( http://nmap.org ) at 2022-07-07 06:13 UTC
Nmap scan report for localhost (127.0.0.1)
Host is up (0.000028s latency).
Other addresses for localhost (not scanned): 127.0.0.1
PORT   STATE SERVICE VERSION
22/tcp open  ssh     OpenSSH 7.4 (protocol 2.0)
| ssh-hostkey: 2048 XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX (RSA)
|_256 XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX (ECDSA)

Service detection performed. Please report any incorrect results at http://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 0.19 seconds
```

```:20.04.3 LTS (Focal Fossa)の場合
$ echo "" |nc localhost 22
SSH-2.0-OpenSSH_8.2p1 Ubuntu-4ubuntu0.3
Invalid SSH identification string.
```

```:20.04.3 LTS (Focal Fossa)の場合
$ nmap -A -p 22 localhost 
Starting Nmap 7.80 ( https://nmap.org ) at 2022-07-07 06:13 UTC
Nmap scan report for localhost (127.0.0.1)
Host is up (0.000059s latency).

PORT   STATE SERVICE VERSION
22/tcp open  ssh     OpenSSH 8.2p1 Ubuntu 4ubuntu0.3 (Ubuntu Linux; protocol 2.0)
Service Info: OS: Linux; CPE: cpe:/o:linux:linux_kernel

Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 0.41 seconds
```

Apacheだったら「 `ServerTokens Prod` 」、Nginxだったら「 `server_tokens off;` 」、PHPだったら「 `expose_php = Off` 」みたいなのがあるじゃないですか。
あんな感じで、攻撃者に情報を与えないためにバージョン情報を隠したいのですが、「 `/etc/ssh/sshd_config` 」の「 `Banner` 」の設定項目では非表示にすることができません。
この項目は「ssh」コマンドでログイン前に表示するメッセージを指定する項目なので、「nmap/nc」コマンドの実行時には効かないのです。
（バージョン番号を隠せたとしても攻撃者はこんなとこ見てないだろうことはわかってはいるんですが、設定ファイルで隠せないとなるとなんだか意地でも隠したくなる気持ちがわいてきたりするじゃないですか）

```
$ grep Banner /etc/ssh/sshd_config 
#Banner none
```

nmap/ncコマンド実行時に表示される情報はどこにあるかというと、sshdコマンドのバイナリファイルの中にあるようです。

```:CentOS7の場合
$ strings `which sshd` |grep "OpenSSH_7.4"
OpenSSH_7.4p1-RHEL7-7.4p1-21
OpenSSH_7.4
OpenSSH_7.4p1
```

```:20.04.3 LTS (Focal Fossa)の場合
$ strings `which sshd` |grep "OpenSSH_8.2"
OpenSSH_8.2p1 Ubuntu-4ubuntu0.3
OpenSSH_8.2
OpenSSH_8.2p1
```

---

### ※ここから以降の操作は自己責任でお願いします。最悪の場合、SSHログインできなくなります。

では、どうやってOpenSSHのバージョン番号を非表示にするのか？
そうです。sshdコマンドのバイナリファイルを直接修正して、バナー表示されている文字列を削除してしまえばいいじゃないですか。ということでやってみましょう。

まず、変更前のsshdコマンドのバックアップを取っておきます。

```
$ which sshd   
/usr/sbin/sshd
$ sudo cp /usr/sbin/sshd /usr/sbin/sshd.orig
```

次に、sshdコマンドの中でバナー表示されている文字列の位置を探します。
hexdumpコマンドに `-C` オプションを指定することで、右側にアスキー文字が表示されるので、検索にはこれを利用します。
CentOS7の場合、ncコマンドで表示されている文字列は「SSH-2.0-OpenSSH_7.4」ですが、 `hexdump -C` の右側のアスキー文字は改行されている可能性があるので「H_7」のような短い文字列で検索してみます。

検索を実行してみると以下の3箇所が該当しました。表示された３箇所の中で今回は「823c0」の行に当たりをつけてみます。

```:CentOS7の場合
$ hexdump -C /usr/sbin/sshd |grep "H_7"
000823a0  78 65 63 00 4f 70 65 6e  53 53 48 5f 37 2e 34 70  |xec.OpenSSH_7.4p|
000823c0  00 4f 70 65 6e 53 53 48  5f 37 2e 34 00 70 72 69  |.OpenSSH_7.4.pri|
00082490  6e 53 53 48 5f 37 2e 34  70 31 00 25 73 2c 20 25  |nSSH_7.4p1.%s, %|
```
vimを使って、 `/usr/sbin/sshd` をバイナリモードで開きます。

```
$ sudo vim -b /usr/sbin/sshd
```

「 `:%!xxd` 」と入力すると、画面の右側にアスキー文字が表示されます。

```
0000000: 7f45 4c46 0201 0100 0000 0000 0000 0000  .ELF............
0000010: 0300 3e00 0100 0000 25fc 0000 0000 0000  ..>.....%.......
0000020: 4000 0000 0000 0000 38fc 0c00 0000 0000  @.......8.......
0000030: 0000 0000 4000 3800 0900 4000 1d00 1c00  ....@.8...@.....
```

「 `/823c0` 」と入力して先程当たりをつけた位置に移動すると「 `OpenSSH_7.4` 」と右側に表示されています。

```
00823c0: 004f 7065 6e53 5348 5f37 2e34 0070 7269  .OpenSSH_7.4.pri
```

今回、「 `OpenSSH_7.4pri` 」を「 `OpenSSH    pri` 」に変更したいので、xxdコマンドを使って変換後の文字列を調べます。
※「0a」は改行文字なので無視します。

```
$ echo "OpenSSH    " |xxd -p
4f70656e535348202020200a
```

これにより、 `/usr/sbin/sshd` の以下の部分を

```
004f 7065 6e53 5348 5f37 2e34 0070 7269
```

このように変更することでバージョン番号を隠せそうです。

```
004f 7065 6e53 5348 2020 2020 0070 7269
```

vimに戻って、「823c0」の行を以下のように変更します。

```
00823c0: 004f 7065 6e53 5348 2020 2020 0070 7269  .OpenSSH_7.4.pri
```

「 `:%!xxd -r` 」と入力してバイナリ表示に戻り、「 `:wq` 」でファイルを保存して、vimを終了します。


sshdを再起動します。

```
$ sudo systemctl restart sshd.service 
```

ncコマンドを実行すると、OpenSSHのバージョン番号が表示されなくなりました！

```
$ echo "" |nc localhost 22
SSH-2.0-OpenSSH    
Protocol mismatch.
```

nmapコマンドも同様にバージョン番号が表示されなくなりました！（ですが、何やら不穏なメッセージも表示されています）

```
$ nmap -A -p 22 localhost

Starting Nmap 6.40 ( http://nmap.org ) at 2022-07-07 06:55 UTC
Nmap scan report for localhost (127.0.0.1)
Host is up (0.000072s latency).
Other addresses for localhost (not scanned): 127.0.0.1
PORT   STATE SERVICE VERSION
22/tcp open  ssh     (protocol 2.0)
| ssh-hostkey: 2048 XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX (RSA)
|_256 XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX (ECDSA)
1 service unrecognized despite returning data. If you know the service/version, please submit the following fingerprint at http://www.insecure.org/cgi-bin/servicefp-submit.cgi :
SF-Port22-TCP:V=6.40%I=7%D=7/7%Time=62C6834D%P=x86_64-redhat-linux-gnu%r(N
SF:ULL,15,"SSH-2\.0-OpenSSH\x20\x20\x20\x20\r\n");

Service detection performed. Please report any incorrect results at http://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 6.21 seconds
```

上記の修正後、サーバーからログアウトしてSSHログインを試みると一応ログインはできましたが、sshdのバイナリファイルを直接修正しているので、いつ何が影響してログインできなくなるかはわかりません。。。

ちなみにUbuntuの場合は `/etc/ssh/sshd_config` に「 `DebianBanner` 」の項目を指定することで、

```
$ sudo vim /etc/ssh/sshd_config
$ grep DebianBanner /etc/ssh/sshd_config
DebianBanner no
$ sudo systemctl restart sshd.service 
```

以下のようにUbuntuに関する情報については非表示化されます。

```
$ echo "" |nc localhost 22
SSH-2.0-OpenSSH_8.2p1
Invalid SSH identification string.
```

```
$ nmap -A -p 22 localhost 
Starting Nmap 7.80 ( https://nmap.org ) at 2022-07-07 07:06 UTC
Nmap scan report for localhost (127.0.0.1)
Host is up (0.000067s latency).

PORT   STATE SERVICE VERSION
22/tcp open  ssh     OpenSSH 8.2p1 (protocol 2.0)

Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 0.53 seconds
```

---

- 参考URL
    - [Hide OpenSSH Version Banner](http://kb.ictbanking.net/article.php?id=666)
    - [SSH 接続時（ログイン前）のメッセージ表示を任意に変更する（sshd）](https://qiita.com/KEINOS/items/e6da8ed42167fa632c84)
    - [DebianBanner no](https://artisan.hatenablog.com/entry/20130829/1377789510)
    - [vimでバイナリを編集する](https://qiita.com/urakarin/items/337a0433a41443731ad0)




