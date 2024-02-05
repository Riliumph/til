# インターネットGW vs NAT-GW

インターネットGWもNAT-GWも広義にはNATである。

## 機能の違い

||IGW|NAT-GW|
|機能|NAT、インターネットの接続|NAT|
|NATの種類|Static NAT|Dynamic NAPT|
|配置場所|VPC|public subnet|
|速度制限|なし|5～45Gbps|

## インターネットGW

StaticNATが使われ、プライベートIPとパブリックIPが一対一で変換される。  
StaticNATなので、NATテーブルには通信前から「プライベートIPとパブリックIPの変換ルール」は定義されていて、それにより一対一変換が行われる。

## NAT-GW

DynamicNAPTが使われ、プライベートIPとパブリックIPが多対一で変換される。  
複数のプライベートIPを１つのパブリックIPに変換してしまった場合、戻りの通信において、どの戻りが元のプライベートIPになのか分からなくなる問題が発生する。  
そこで、TCP/UDPポート番号も変換することで問題を回避する。

この変換方法を動的NAPTという。

また、動的なため、NATテーブルの初期状態は空である。  
プライベートIPがパブリックIPへ変換されるタイミングで同時にNATエントリが動的生成される。  

## 参考

- [【図解/AWS】インターネットGWとNAT-GWの違い〜各メリット、パブリックサブネットとは〜](https://milestone-of-se.nesuke.com/sv-advanced/aws/internet-nat-gateway/)
