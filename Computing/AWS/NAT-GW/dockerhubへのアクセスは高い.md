# PrivateSubnetからNAT-GW経由でのDockerHubは高い

これは結構有名な事例ですので記事化はしてませんが、ECS を PrivateSubnet に配置、コンテナ起動の際に DockerHub からのイメージ取得を NatGateway 経由で行うと転送量が跳ね上がる事象です

特に ECS のタスクスケジューリング等で細かなバッチ処理を複数回実施するようなケースは要注意です

## 参考

- [にっくす🌸パリピ@インフラ](https://twitter.com/___nix___/status/1744718014908670232)
