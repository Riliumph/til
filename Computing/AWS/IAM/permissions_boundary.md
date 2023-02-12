# 権限教会

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
