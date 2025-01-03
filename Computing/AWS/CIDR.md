# AWSサービスで固定のCIDR

> 一部の AWS サービスは、172.17.0.0/16 CIDR 範囲を使用します。将来競合が発生しないように、VPC を作成するときはこの範囲を使用しないでください

Cloud9やSageMakerが使ってるので被らないように

## 参考

- [VPC CIDR ブロック](https://docs.aws.amazon.com/ja_jp/vpc/latest/userguide/vpc-cidr-blocks.html)
