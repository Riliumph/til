# Volume 機能について

Docker にはホストとゲストの共有ディレクトリ機能として「ボリューム」と呼ばれる機能が提供されている。  
ここではこのボリューム機能での権限についての落とし穴を紹介する。

## AWS Fargate

ことは AWS Fargate にて Docker を使って仮想マシンを立ち上げた時。

```Dcokerfile
FROM ubuntu

ENV /var/log/hoge
RUN mkdir -p $ENV \
 && chmod 777 $ENV \
 && chwon user $ENV

User user
ENTRYPOINT ["/var/lib/hoge/bin/exe"]
```

このシステムは`/var/log/hoge`にログを出力するようになっている。  
ことのとき、システムが起動すると「Permission denied」で終了してしまう問題が発生した。

## ローカルで Docker を試験

```host
docker run -name hoge -it-rm -v $HOME/Documents/hoge/share:/home/hoge/share hoge
```

このコマンドでオリュームを作成したところ、以下の内容がわかった。

```HOST
$ ls -la $HOME/Documents/hoge
drwxr-xr-x 2 user user share
```

```GUEST
$ ls -la /home/hoge/
drwxrwxrwx 2 user root share
```

Dockerfile 内で設定したパーミッション設定はゲスト VM 内から見たそのディレクトリの権限であること。  
Docker のホストがボリュームしているディレクトリは 755 のアクセス権限が付与されていること。

## 結果

Dockerfile 内で 777 に設定したディレクトリにログを出力しようとしていたが、実はホストから見たディレクトリのアクセス権限は 755 であった。
