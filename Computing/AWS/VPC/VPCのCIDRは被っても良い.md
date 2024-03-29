# VPCのCIDRは被っても良い

VPCには固有にVPC CIDRを指定することが出来る。  
これにより、VPCが使用するアドレス帯を固定することが出来る。

たとえば、以下のVPCを作るとする。

```terraform
resource "aws_vpc" "proxy_vpc" {
  cidr_block          = ["10.10.10.0/24". "10.10.20.0/24", "10.10.30.0/24"]
  enable_dns_support  = true
  enable_dns_hostname = true
}
```

さて、このVPCはPRD環境で使うモノとして、DEV環境用にこの環境をクローンするとする。  
その際に、このCIDRはDEV用に値を変える必要があるか否か？

答えは否である。

VPCが持つCIDR BLOCKはVPC内で使われるIPアドレス帯である。  
つまり、外環境からは見えないPrivateIPアドレスとして振る舞う。

よって、CIDR BLOCKが一致しても問題はない。

## 何事にも例外はある

しかし、例外事項は存在する。  
たとえば、VPC Peeringを使うとする。

VPC PeeringはELBを介さずともIPアドレス指定で通信を可能とするサービスである。
この仕組みは単に「VPCの名前空間を共有すること」で成り立っている。

つまり、VPCのCIDR BLOCKも共有してしまうため被っていればバッティングが起きてしまいPeeringを貼ることができない。

TransitGatewayを使う場合も同じだろう。（未検証）  
あれもルートテーブルでどのアドレスからのアクセスをどこへ許可するかを指定している。  
そのため、ルートテーブルが破綻してしまう可能性がある。
