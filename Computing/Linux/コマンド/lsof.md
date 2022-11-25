# lsofによる探偵ごっこ

## ソケットを使ってるプロセスの特定

片方のターミナルで定期的にlsofを実行する

```bash
$ watch n 1 lsof -i -P
Every 1s: lsof -i -P                                                        riliumph-win: Sat Nov 26 02:16:24 2022

COMMAND   PID     USER   FD   TYPE  DEVICE SIZE/OFF NODE NAME
node     2758 riliumph   18u  IPv4  963681      0t0  TCP localhost:43327 (LISTEN)
node     2758 riliumph   21u  IPv4 5254719      0t0  TCP localhost:43327->localhost:52298 (CLOSE_WAIT)
node     2758 riliumph   23u  IPv4 5777029      0t0  TCP localhost:43327->localhost:52398 (ESTABLISHED)
node     2758 riliumph   25u  IPv4 1001497      0t0  TCP localhost:43327->localhost:49342 (CLOSE_WAIT)
node     2758 riliumph   27u  IPv4 1001499      0t0  TCP localhost:43327->localhost:49344 (CLOSE_WAIT)
node     2758 riliumph   33u  IPv4 1486828      0t0  TCP localhost:43327->localhost:52132 (CLOSE_WAIT)
node     2758 riliumph   34u  IPv4 1486830      0t0  TCP localhost:43327->localhost:52134 (CLOSE_WAIT)
node     2758 riliumph   36u  IPv4 5254721      0t0  TCP localhost:43327->localhost:52300 (CLOSE_WAIT)
node     5547 riliumph   18u  IPv4  933625      0t0  TCP localhost:49342->localhost:43327 (FIN_WAIT2)
node     5556 riliumph   18u  IPv4  998601      0t0  TCP localhost:49344->localhost:43327 (FIN_WAIT2)
node     6219 riliumph   18u  IPv4 1630367      0t0  TCP localhost:52132->localhost:43327 (FIN_WAIT2)
node     6228 riliumph   18u  IPv4 1607660      0t0  TCP localhost:52134->localhost:43327 (FIN_WAIT2)
node    18194 riliumph   18u  IPv4 5332590      0t0  TCP localhost:52298->localhost:43327 (FIN_WAIT2)
node    18203 riliumph   18u  IPv4 5332601      0t0  TCP localhost:52300->localhost:43327 (FIN_WAIT2)
node    27121 riliumph   18u  IPv4 5779882      0t0  TCP localhost:52398->localhost:43327 (ESTABLISHED)
node    27130 riliumph   18u  IPv4 5782795      0t0  TCP localhost:52400->localhost:43327 (ESTABLISHED)
node    27150 riliumph   19u  IPv4 5777034      0t0  TCP localhost:43327->localhost:52400 (ESTABLISHED)
```

もう片方のターミナルでプロセスを特定する

```bash
$ ps aux | peco
OR
$ ps aux | grep 2758
USER       PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
riliumph  2758  0.1  0.3 948660 103468 pts/2   Sl+  Nov24   4:13 /home/riliumph/.vscode-server/bin/62.../node /home/riliumph/.vscode-server/bin/62.../out/server-main.js --host=127.0.0.1 --port=0 --connection-token=33...-30...-10...-11... --use-host-proxy --without-browser-env-var --disable-websocket-compression --accept-server-license-terms --telemetry-level=all
```

vscode serverめっちゃポート開くやん
