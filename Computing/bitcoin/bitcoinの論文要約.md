# ビットコインの論文の面白いところ

ビットコインの論文は、学術論文ではないただのホワイトペーパーである。  

## 概要部分について

> A purely peer-to-peer version of electronic cash would allow online payments to be sent directly from one party to another without going through a financial institution.  
> 完全にピア・ツー・ピア（P2P）型の電子通貨の仕組みは、金融機関を介さずに、当事者同士が直接オンラインで支払いを送受信できるようにするものである。  
> Digital signatures provide part of the solution, but the main benefits are lost if a trusted third party is still required to prevent double-spending.  
> デジタル署名はこの仕組みの一部を解決するが、二重支払いを防ぐために信頼できる第三者が必要であるなら、その主要な利点は失われてしまう。  
> We propose a solution to the double-spending problem using a peer-to-peer network.  
> 私たちは、ピア・ツー・ピアネットワークを用いた二重支払い問題の解決方法を提案する。  
> The network timestamps transactions by hashing them into an ongoing chain of hash-based proof-of-work, forming a record that cannot be changed without redoing the proof-of-work.  
> このネットワークは、取引をハッシュ化して連続する「ハッシュベースのプルーフ・オブ・ワーク」の鎖に組み込み、時刻を記録する。これにより、過去の記録を改ざんするには、そのプルーフ・オブ・ワークをやり直さなければならないため、改ざんが実質的に不可能になる。
> The longest chain not only serves as proof of the sequence of events witnessed, but proof that it came from the largest pool of CPU power.  
> 最も長い鎖は、観測された出来事の時系列を証明するだけでなく、最も多くのCPUパワーを投入した集合体によって生成されたことの証明にもなる。  
> As long as a majority of CPU power is controlled by nodes that are not cooperating to attack the network, they'll generate the longest chain and outpace attackers.  
> ネットワーク上のCPUパワーの過半数が攻撃者と協調しないノードにより支配されている限り、彼らが最も長い鎖を生成し、攻撃者を上回ることができる。  
> The network itself requires minimal structure.  
> このネットワーク自体は最小限の構造しか必要としない。  
> Messages are broadcast on a best effort basis, and nodes can leave and rejoin the network at will, accepting the longest proof-of-work chain as proof of what happened while they were gone.  
> メッセージはベストエフォートでブロードキャストされ、ノードは自由にネットワークを離脱・再参加できる。ノードが不在の間に何が起きたかは、最も長いプルーフ・オブ・ワークの鎖を受け入れることで確認できる。

## 二重支払い問題と紙幣の機能

まず、概要の面白い部分として、このビットコインは新しい通貨自体を目的に提案されたのではないことが伺える。

> We propose a solution to the double-spending problem using a peer-to-peer network.

そして、これは「我々が紙幣を用いているのは二重支払いを防ぐためであり、今の電子通貨ではその機能が無い」とも読める。  

仮に、紙幣を使わずに帳簿だけでお金を管理する世界だった場合、支払い能力以上にお金をやり取りできてしまう。  
たとえば、1万円の帳簿を以て、二人の人間から1万円の商品を買うことができてしまう。  
1万円を支払いで使うことで、次の支払いを不可能にすることが機能である。  

## 電子決済と電子通貨

とは言えど、現在の電子決済では通貨無しに支払いを行えている。  
クレジットカードやQRコード決済が良いところだろう。  
あれは「そのサービスを提供している会社が管理者として、その取引の正当性を担保する」ことを行っている。  
つまり、紙幣の持つ２重支払い防止機能を管理者が代替しているのである。  

しかし、サトシナカモトは、この一文から管理者不在のシステムを欲していることが伺える。

> A purely peer-to-peer version of electronic cash would allow online payments to be sent directly from one party to another **without going through a financial institution.**  

そのために、デジタル署名を使おうと言っている。

## ビットコインのトランザクション

「1万円を送るよ」という情報をトランザクションと呼称する。  
このトランザクションは、デジタル署名によって偽造防止する。

ビットコインは偽造防止がもてはやされているが、それはビットコインの能力ではなくてデジタル署名の能力である。  
ビットコインの特徴は、偽造不可能などではなく「トランザクションの整理」にある。  
その整理法によって、二重支払いを防止している。

### 既存の二重支払いの防止

「1万円で物を買った」というトランザクションを同時に二つ生み出した場合、どちらか片方だけを有効にする必要がある。  
このどちらかを正義にするのかの判断が難しい。  

既存の方法では、どちらかを正義にするのは「管理者」が判断を下すことで解決する。

普通の感性では、同時に発生させたことがそもそもの問題の発端なので「両方を無効とする」となりがちである。  
しかし、これは管理者の思想である。  
同時に発生したトランザクションが物理的に離れていて、そこがネットワークから切断されていた場合、互いが互いのトランザクションを認識できない問題が残る。  
つまり、A地点からはB地点でのトランザクションを知るのに時間がかかるし、B地点も同様であるということだ。

ビットコインはそれをどう解決したのか？

### ビットコインの二重支払いの防止

既存の「却下する」は、分散処理に向いていないのでその発想をまずやめた。  
ビットコインは、「どちらも一旦は有効とする」とした。  

## 参考

- [Bitcoin: A Peer-to-Peer Electronic Cash System](https://bitcoin.org/bitcoin.pdf)
- [世界一美しい論文「ビットコイン」を読む。](https://www.youtube.com/watch?v=wZJ3TFTtlSg)
- [なぜ暗号通貨は世界を変えないのか？](https://www.youtube.com/watch?v=82YdOlNgQZ8)
