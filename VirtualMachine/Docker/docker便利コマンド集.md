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

## dokcerのイメージを一括削除

```bash
$ docker rmi $(docker images -aq)
```
