# nプロセスperコンテナの方法

Dockerは１コンテナ１プロセスを基本概念としている。  
だからこそ、ENTRYPOINTは複数用意できないし、CMDも複数用意できない。

## nプロセス

たとえば、`logrotate`を使いたい場合はどうするか？  
もちろん、サイドカーという概念を取り込んでもいい。  
つまり、動かしたいソフトと`logrotate`の２つのコンテナを用意し、お互いが同じホストの共有ボリュームを参照するということだ。

しかし、次のようなbootシェルを作って、 DockerのENTRYPOINTにしてもいい

```bash
# bootup.sh
#!/bin/bash

cp -f /etc/periodic/daily/logrotate /etc/periodic/15min
crond restart

/var/lib/bin/hoge $@
```

```Dockerfile
（省略）
ENTRYPOINT ["/usr/local/bin/bootup"]

```

## bootupシェルの問題点

ENTRYPOINTを立ち上げ用のbootupシェルにしたことで対処できなかった問題点もある。

### SIGNALが正しく届かない

たとえば、AWSのFargateにおいてscale in/outはDockerへのSIGNALで実現される。

> AWSにおいては、scale inする場合、まずは`SIGTERM`が送信され、30sec後に生きていた場合`SIGKILL`が送信される

このような状況退いて、`SIGTERM`はどこに送られるかと言うと、ENTRYPOINTに送られる。  
つまり、`logrotate`が時間を検知して`SIGHUP`のシグナルをプロセスに通知してファイルのリオープンを行うような想定でもENTRYPOINTに`SIGHUP`が送信されてしまう。  
`trap`コマンドなどを使って、対象のプロセスへSIGNALをリスローする必要がある。
