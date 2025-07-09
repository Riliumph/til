# outputportはレスポンス用か？

## A. 違う

`outputport`やその具象である`presenter`はレスポンスとして使われる事が多い。  
そのためこれらをレスポンス用のクラスとして認識してしまうことがある。

以下、`presenter`は`outputport`の具象なので省略する。

## outputport / presenterとは？

では、`outputport`とは何か？  
その本質は、**アプリケーションから外の世界へ出ていくデータへのインターフェイス**である。

## repositoryとは何が違うのか？

clean architectureにおいて、`UseCase`層から`Adapter`層へ出るためには、インターフェイスを使う必要がある。  
よく使われるのは以下だ。

- `outputport` / `presenter`
- `repository_if` / `repository`

この用途に違いを整理しよう。

`outputport`は、**データを外部の世界へ出す方法のインターフェイス**である。  
対して、`repository_if`は、**エンティティを永続化する方法のインターフェイス**である。

`repository_if`で外部に通信するのは、想定しているインターフェイスの使い方ではない。

だからこそ、

- `outputport`は、`adapter`層の中でも`presenter`と呼ばれ
- `repository_if`は、`adapter`層の中でも`gateway`と呼ばれる
