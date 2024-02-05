# 依存しないならstaticにしろ

[Tsugawa/CubeSoft, Inc.@tt_clown 2023年12月5日](https://twitter.com/tt_clown/status/1731875171256943049)

単にクラス内での可読性のためだけの理由で private メソッドを定義すると、割と「static にできるから static にしろ」って指導が入るな。実際、どうなんだろう（やっても良いような気もするけど、何かモヤモヤとしたものが）。

---

[yoh@yohhoy 2023年12月5日](https://twitter.com/yohhoy/status/1732048405328019753)

（TPOによるけど）staticメソッド化できるならそうしておきたい派かも。処理が"thisに依存しない"という表明は結構大きいと思うんですよね。
