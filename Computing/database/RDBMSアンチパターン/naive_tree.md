# SQLアンチパターン

出典

- [SQLアンチパターン](https://www.oreilly.co.jp/books/9784873115894/)
- [「SQLアンチパターン」まとめ](https://qiita.com/taiteam/items/33aebded2842808e0391)

## naive tree（素朴な木）

|id|next|foo|
|:--:|:--:|:--:|
|1|2|a|
|2|3|b|
|3||c|
|4|5|d|
|5|2|e|

このテーブルは、C言語のポインタを使った単方向リスト構造と同じである。  
子供nextを持つのか親prevを持つのかは設計次第だが、どちらかの情報を知っている。  
以下の流れを表現している。

- 1 -> 2 -> 3
- 4 -> 5 -> 2 -> 3

こういったツリー状の階層構造を、1テーブルで表現してはいけない。  
解決策としては、代替ツリーモデルを使用する。

- 経路列挙
- 入れ子集合
- 閉包テーブル

naive treeを愚直にリストにするには、Common Table Expressionを使う。  
単純に言うと、with句によるselectの無限ループを組むこと。

### CTE

|項目|CTE|一時テーブル|
|:--|:--:|:--:|
|TempDBへの保存|されない|される|
|indexの作成|できない|できる|
|制約の定義|できない|できる|
||本質的に使い捨てビュー|他のクエリまたはサブプロシージャで参照できる|
|寿命|次のクエリが実行されるまで|現在の接続の存続期間中|

> 一時テーブルとは、create文を使って本当に一時的なテーブルを作ることである。

```sql
-- {}を使って変数を表現しておくと、pythonで読みだして値を入れるときに便利！！
with recursive cte as (
  select
    t.id,
    t.next_id,
    t.disabled,
    t.created_at,
    t.updated_at
  from
    table_name as t
  where
    t.id = { } -- ここにはスタート地点のidを入れること。
  union
  all
  select
    t.id,
    t.next_id,
    t.disabled,
    t.created_at,
    t.updated_at
  from
    cte
    inner join id as t1 on cte.next_id = t.id
  where
    t.disabled != 1
)
select
  id,
  next_id,
  foo,
  disabled,
  created_at,
  updated_at
from
  cte;
```
