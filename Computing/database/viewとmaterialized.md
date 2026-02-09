# ViewとMaterialized Viewの違い

- Viewはクエリ
- Materialized Viewはキャッシュ

これが大きな違い。

Viewテーブルは、Selectクエリを保存してViewテーブル参照時に保存されたクエリを発行して結果を差し替えている。  
つまり、最新のデータが取れるし、CPUも食べる。

対して、Materialized Viewは実際にSelectした結果を持っている。  
つまり、更新しないと古いデータである可能性が高い。

## Viewの作り方

[ドキュメント](https://www.postgresql.jp/document/17/html/sql-createview.html)

```sql
CREATE VIEW v_ab AS
SELECT ...
FROM A
JOIN B ON ...
;
```

まぁ、Select文を持ってるのでこれが実行される。

## Materialized Viewの作り方

[ドキュメント](https://www.postgresql.jp/document/17/html/rules-materializedviews.html)

```sql
CREATE MATERIALIZED VIEW mymatview AS
SELECT * 
FROM mytab;
```
