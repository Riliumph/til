# Docker解説

[Reference documentation](https://docs.docker.com/reference/)

## Command

2017年1月18日にリリースされた Docker v1.13 以降で、命令体系がリメイクされて、かなりシステマチックなコマンドとなった。  
理由は、docker以下のコマンド（トップレベル・コマンド）が40を越えてしまったため。

適当によく使われる内容を見繕ってみた。

```bash
docker
├ container
│  ├ attach  = docker attach
│  ├ exec    = docker exec
│  ├ ls      = docker ps
│  ├ run     = docker run
│  ├ start   = docker start
│  ├ stop    = docker stop
│  └ etc...
│
├ image
│  ├ build   = docker build
│  ├ ls      = docker images
│  ├ pull    = docker pull
│  ├ push    = docker push
│  ├ rm      = docker rmi
│  ├ tag     = docker tag
│  └ etc...
│
├ volume
│  ├ create
│  ├ inspect
│  ├ ls
│  ├ prune
│  ├ rm
│  └ etc...
│
├ network
│  ├ create
│  ├ connect
│  ├ disconnect
│  ├ inspect
│  ├ ls
│  ├ prune
│  └ rm
│
└ compose
   ├ build
   ├ create
   ├ down
   ├ images
   ├ ls
   ├ restart
   ├ stop
   ├ up
   └ etc...
```

## Volume

[volume.md](./docker_volume.md)

## Compose

[compose.md](./docker_compose.md)
