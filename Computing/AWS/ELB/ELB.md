# Elastic Load Balancer

AWSには以下の種類のロードバランサー（以下、LB）が存在する。

## ALB - Application Load Balancer -

L7（アプリケーション）で動作するLB。
HTTPやHTTPSなどのプロトコルで振り分けすることができる。

分散アルゴリズムが不明

このLBにはヘルスチェック機能を持っている。  
このLBがヘルスチェックで異常がLBの閾値を超えた場合、以下の手順でタスクをkillする。

- initial: 初期起動状態
- healthy: 正常な状態
- unhealthy: 異常度が閾値未満
- draining: 異常値が閾値を超えたため、バランシング対象から切り離し

## NLB - Network Load Balancer -

L4（ネットワーク）で動作するロードバランサー。  
TCPプロトコルしか喋れないので、API-GWなどのヘルスチェックは行えない。  

- healthy: 正常な状態
- unhealthy: 異常度が閾値未満
- draining: 異常値が閾値を超えたため、バランシング対象から切り離し

## CLB - Classic Load Balancer -

使うな

**使　う　な**
