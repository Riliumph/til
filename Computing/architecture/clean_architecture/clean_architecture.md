# Clean Architecture

## 背景

インターフェイスを使って、依存関係を極限まで失くしたお手本アーキテクチャ。  
なので、綺麗という意味でcleanとか言われてる。

## 概念図

処理の流れはこんな感じ

![概念図](./img/cleanarchutecture.drawio.svg)

## どこに誰がいるか？

| 層 | 登場人物（役割）    | 抽象 or 具象 |
|:---|:--------|:----------|
| **Frameworks&Drivers** | WebフレームワークのController | 具象 |
|                        | DBドライバ, ORM             | 具象 |
|                        | 外部APIクライアント           | 具象 |
| **Interface Adapters** | Web Controller（UI入力変換） | 具象 |
|                        | Presenter実装（UI出力変換）   | 具象 |
|                        | Repository実装             | 具象 |
|                        | Mapper（DTO ↔ Entity変換）  | 具象 |
| **Use Cases**          | UseCase実装（ビジネスロジック） | 具象 |
|                        | 入力ポート（IUseCase）       | 抽象 |
|                        | 出力ポート（IPresenter）     | 抽象 |
|                        | IRepository               | 抽象 |
| **Entities**           | ドメインモデル（User,Order）  | 具象 |
|                        | ドメインサービス              | 具象 |
