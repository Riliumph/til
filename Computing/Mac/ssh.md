# SSH関連

## localeを引き継ぐ

> macOSのロケールは基本的に以下である。
>
> ```bash
> $ locale
> LANG=""
> LC_COLLATE="C"
> LC_CTYPE="UTF-8"
> LC_MESSAGES="C"
> LC_MONETARY="C"
> LC_NUMERIC="C"
> LC_TIME="C"
> LC_ALL=
> ```

macOSのsshは特殊である。  
たとえば、AmazonLinuxの環境変数LANGはデフォルトでは`en_US.UTF-8`が設定されている。  
そのままsshを接続しても日本語の表示はできないはずである。

実際、何の設定もしなければ日本語は文字コードに変更されて表示される。  
しかし、以下の設定を施すことで**ssh先の設定依存にも関わらず、日本語を表示できる**。

```bash
$ export LANG=ja_JP.UTF-8
$ export LC_ALL=$LANG
```

このカラクリはmacOS環境のsshの設定に関係する。  
以下のssh_configにmacOS環境の環境変数を引き継ぐような設定が施されている。

```bash
$ cat /etc/ssh/ssh_config
# $OpenBSD: ssh_config,v 1.34 2019/02/04 02:39:42 dtucker Exp $

# This is the ssh client system-wide configuration file.  See
# ssh_config(5) for more information.  This file provides defaults for
# users, and the values can be changed in per-user configuration files
# or on the command line.

# Configuration data is parsed as follows:
#  1. command line options
#  2. user-specific file
#  3. system-wide file
# Any configuration value is only changed the first time it is set.
# Thus, host-specific definitions should be at the beginning of the
# configuration file, and defaults at the end.

# Site-wide defaults for some commonly used options.  For a comprehensive
# list of available options, their meanings and defaults, please see the
# ssh_config(5) man page.

# Host *
#   ForwardAgent no
#   ForwardX11 no
#   PasswordAuthentication yes
#   HostbasedAuthentication no
#   GSSAPIAuthentication no
#   GSSAPIDelegateCredentials no
#   BatchMode no
#   CheckHostIP yes
#   AddressFamily any
#   ConnectTimeout 0
#   StrictHostKeyChecking ask
#   IdentityFile ~/.ssh/id_rsa
#   IdentityFile ~/.ssh/id_dsa
#   IdentityFile ~/.ssh/id_ecdsa
#   IdentityFile ~/.ssh/id_ed25519
#   Port 22
#   Ciphers aes128-ctr,aes192-ctr,aes256-ctr,aes128-cbc,3des-cbc
#   MACs hmac-md5,hmac-sha1,umac-64@openssh.com
#   EscapeChar ~
#   Tunnel no
#   TunnelDevice any:any
#   PermitLocalCommand no
#   VisualHostKey no
#   ProxyCommand ssh -q -W %h:%p gateway.example.com
#   RekeyLimit 1G 1h

Host *
 SendEnv LANG LC_*
```

これにより、macOS側のロケール設定がAWS側にも反映され、日本語が表示できる。  
サーバの設定が動的に変わるため、本番環境では注意が必要かもしれない。
