# SQL スニペット

## string -> timestamp

ログに日付カラムがある場合に絞り込むのは`timestamp`や`Date`を使う。  
フォーマットが`yyyy-mm-ddThh-mm-ss.fff+09.00`などの場合、`from_iso8601_timestamp`関数を使って変換する。  
`string`->`timestamp`でおなじみの`CAST`は使えないので注意。

```SQL
select *
from "Database"."Table"
where date_parse('2020-07-07', '%Y-%m-%d') <= from_iso8601_timestamp(time)
and from_iso8601_timestamp(time) <= date_parse('2020-07-07', '%Y-%m-%d')
```

## ALB
