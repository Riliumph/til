# dockerignoreとは

dockerは別のサーバーにデプロイ先がある前提で設計されている。  
そのため、ビルドコンテキストのルートからすべてのファイルをdocker daemonに送信してしまっている。

これがビルドの足を引っ張っている原因かもしれない。

## 確認方法

以下のログはdocker daemonに201Bのデータを送信している事が読める。

```console
=> [internal] load build context
=> => transferring context: 201B
```

## 解決方法

`.dockerignore`を配置してみる。

```console
project/
├── .devcontainer/
│ ├── Dockerfile
│ └── devcontainer.json
├── src/
├── package.json
└── .dockerignore ← ここ
```

devcontainerは
