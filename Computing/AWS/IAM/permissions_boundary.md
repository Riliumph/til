# 権限境界

## 概要

Permissions Boundaryは、IAMユーザーに対して「付与可能な権限範囲」を定義したもの。  
その内、IAMポリシーで実際に付与された権限がPermissions Boundary内に収まっているなら権限が与えられる。

たとえば、以下のような関係だったとしよう。

|type|Permissions Boundary|IAM Policy|
|:--:|:--:|:--:|
|EC2|〇|〇|
|RDS|〇|〇|
|ECS|〇|-|
|IAM|×|〇|

Permissions Boundaryとしては、EC2/RDS/ECSのみが許可されている。IAMは許可されていない。  
IAM Policyには、EC2/RDS/IAMが付与された。

この場合、このユーザーに実際に付与される権限はEC2/RDSのみとなる。  
ECSは許可されているが、付与されていないので持ちえず、  
IAMは付与されてはいるが、許可されていないので持ちえない。

## 実運用

チームリーダーが部下に権限を与えたいとする。  

仕事では何が必要か分からないので、できるだけやり取りが発生しないように広範囲な権限を付与したい。  
しかし、`AdministratorAccess`で本当になんでも許可すると、誤ってアカウント削除みたいなことが発生しかねないのでそれは防ぎたい。  

その場合に、Permissions Boundaryでは`PowerUser`+`IAM`を許可しておくと便利かもしれない。  
IAMを持っていることから、メンバー追加時の作業もチームに任せられる。  
しかし、本当にやってほしくない`account:*`や`organizations:*`には触れることはできない。

## 適切な権限付与

Access Analyzerを使え
