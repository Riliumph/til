# Dockerで便利なコマンド

## dockerのイメージを一括停止する

```bash
$ docker stop $(docker ps -q)
```

## dockerのコンテナを一括削除する

```bash
$ docker rm $(docker ps -aq)
$ docker container prune
```

## dockerのイメージを一括削除

```bash
$ docker rmi $(docker images -aq)
```

## 強制ROOTユーザーログイン

非rootユーザーのコンテナにrootユーザーでログイン  
ホストであるマシンからは何でも可能なのだ

```bash
$ docker exec --user="root" -it <container_name> /bin/bash
```
