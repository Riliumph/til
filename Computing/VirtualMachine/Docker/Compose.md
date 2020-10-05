# Docker Composeとの兼ね合い

DockerComposeはDockerのオーケストレーションツールであるが、その違いを文章化しておく。

## Docker ComposeはDockerに命令を出すコマンド

`docker-compose`コマンドはあくまでも複数の`docker`を制御するコマンドである。

## DockerComposeで立ち上げたコンテナに入る

基本的に以下のコマンドで`/bin/bash`プロセスを生成することで入ることができる。

```bash
$ docker exec -it <container-id> bash
```

## DockerComposeのrunとup

通常、`ENTRYPOINT ["/bin/bash"]`を実行しているコンテナであれば、通常は以下のコマンドでも入ることができる。

```bash
$ docker attach <container-id>
```

しかし、`docker-compose up -d`で立ち上げたコンテナには入ることはできてもコマンドを実行することができない。

```bash
$ docker-compose up -d
$ docker attach <container-id>
container# pwd
（無反応）
```

これは`docker-compose up`と`docker-compose run`における**ttyの扱い方の違い**によるもの。  
結論のみを言うと

- `docker-compose up`の場合、stdin/stdoutが同じttyに繋がらないため対話形式にならない
- `docker-compose run`の場合、stdin/stdoutが同じttyに繋がるため対話形式になる

### docker-compose upはサービス全体の立ち上げ

`docker-compose up`は**docker-compose.yaml**に記述された内容を基に、すべてのコンテナをビルド・起動・アタッチを行う。  
気をつけるべきは起動コンテナの出力(stdout)は**統合される**ということです。

また、`docker-compose up`は複数のdockerを一斉に制御するコマンドであるため、個別にターミナル制御オプションなどは付けれないようになっています。  
それらはすべて`docker-compose.yaml`に記載する必要があります。

```docker-compose.yaml
version: '3'
x-common: &common
  tty: true         # docker run -t相当
  stdin_open: true  # docker run -i相当

services:
  SERVICE_NAME:
    <<<: *common
```

しかし、注意するべきは以下の差です。  

- ttyの使用 -> tty: trueで指定
- stdinの使用 -> stdin_openで指定
- stdoutの使用 -> 全コンテナが統合

つまり、たとえttyとstdinを有効化したところでstdoutは別制御になっているためttyは**インタラクティブにならず、コマンドを応答させることはできない**。

### docker-compose runは個別の立ち上げ

対して、`docker-compose run`は記述したコンテナを臨時にビルド・起動させる。  
通常は１つのコンテナを制御することになるため、`docker-compose.yaml`に記述されたサービス名を指定する必要がある。

```bash
$ docker-compose run SERVICE_NAME
```

この`docker-compose run`コマンドはデフォルトでtty系の以下のオプションが有効化されている。

- -t
- -i

また、stdoutも統合化せず単一のコンテナに紐づくため、stdin/stdoutが同じttyに繋がり、通常の`docker`同様**ttyがインタラクティブになり、コマンドｗ応答させることができる。**  
よって、`docker attach`で接続して操作することができる。
