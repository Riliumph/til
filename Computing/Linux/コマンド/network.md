dnsutils / bind-utils

DNS確認用
dig が使えるようになる
dig google.com
dig 対象サイトのドメイン

mtr

ping + traceroute の連続版
経路上のどこで遅延・ロスが出るか確認
mtr google.com
mtr 対象サイトのドメイン

iproute2

ルーティング確認
ip route
ip addr

net-tools

古いが便利なネットワーク確認コマンド
netstat -rn
ifconfig

tcpdump

実際の通信パケットを見る
sudo tcpdump -i any host google.com

openssl

HTTPS(TLS)接続確認
openssl s_client -connect example.com:443
