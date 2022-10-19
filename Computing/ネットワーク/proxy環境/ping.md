# Proxy環境下でのping

proxyサーバー背後の環境の場合、`ping`を使うことは一般的にはできない。  
`ping`を繋ぐにはIPレベルで接続されていないとダメ。

登場するprotocolと利用例を太字で示す。

|OSI model|protocol|概要|利用例|
|:--:|:--|:--|:--|
|Application|**http**, DNS|個々のAPP|**proxy**|
|Presentation|ftp, telnet|データの表現形式|HTML|
|Session|TLS, NetBIOS|通信手段|HTTPS|
|Transport|TCP, UDP|エンド間の通信制御|TCP, UDP|
|Network|**IP**, ARP, RARP|データを送る相手を決め最適な経路で送信する|**ping**|
|Data link|PPP, Ethernet|隣接する機器同士の通信|Ethernet|
|Physical|UTP, 無線|物理的な接続|光ファイバー|

`ping`はNetwork層で動くため、IPレベルでの直接的なネットワーク接続が必要である。  
対して、proxyはApplication層で動く。

`ping`はproxyまで到達して外部のネットワークに出ていったとしても、ターゲットが返す時のIPアドレスはあくまでproxyサーバーである。  
そのため、proxy背後にいる端末は`ping`の結果を受け取ることができない。

HEADリクエストをWEBサーバーに送信することで`ping`の代替コマンドである`httping`が存在する。
