# ALBのログをAthenaでさらう

参考

- [[新機能]Amazon Athena ルールベースでパーティションプルーニングを自動化する Partition Projection の徹底解説](https://dev.classmethod.jp/articles/20200627-amazon-athena-partition-projection/)

-

## Glueの課題

メリット

メタデータストアがパーティション情報を保持する。  
そのため、データストア（S3）などをスキャンすることなくパーティションをプルーニングすることができる。

デメリット

パーティションを自動的に作成されないため、一定期間ごとの手動オペレーションが必要になる。  
また、パーティションが大量に存在する場合、Glue Data Catalogのパーティション取得API(GetPartitions)のコールコストが高くなる。

## パーティション射影 - Partition Projection -

パーティション管理を自動化する機能。  
パーティション射影ではPartition Projection設定を基に演算されるため、Glue Data CatalogのAPIをコールしない。  
Partition Projectionはインメモリ計算であるため、リモートAPIコールのGlueよりも高速に動作する。

## パーティション構造

参考：[パーティション射影のサポートされている型](https://docs.aws.amazon.com/ja_jp/athena/latest/ug/partition-projection-supported-types.html)

項目は各型によって異なるため、公式ドキュメントを読むこと。

## SQL

```SQL
CREATE EXTERNAL TABLE IF NOT EXISTS alb_logs (
    type string,
    time string,
    elb string,
    client_ip string,
    client_port int,
    target_ip string,
    target_port int,
    request_processing_time double,
    target_processing_time double,
    response_processing_time double,
    elb_status_code string,
    target_status_code string,
    received_bytes bigint,
    sent_bytes bigint,
    request_verb string,
    request_url string,
    request_proto string,
    user_agent string,
    ssl_cipher string,
    ssl_protocol string,
    target_group_arn string,
    trace_id string,
    domain_name string,
    chosen_cert_arn string,
    matched_rule_priority string,
    request_creation_time string,
    actions_executed string,
    redirect_url string,
    lambda_error_reason string,
    target_port_list string,
    target_status_code_list string,
    new_field string
    )
    PARTITIONED BY(
        `order_date` string
    )
    ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.RegexSerDe'
    WITH SERDEPROPERTIES (
        'serialization.format' = '1',
        'input.regex' = '([^ ]*) ([^ ]*) ([^ ]*) ([^ ]*):([0-9]*) ([^ ]*)[:-]([0-9]*) ([-.0-9]*) ([-.0-9]*) ([-.0-9]*) (|[-0-9]*) (-|[-0-9]*) ([-0-9]*) ([-0-9]*) \"([^ ]*) ([^ ]*) (- |[^ ]*)\" \"([^\"]*)\" ([A-Z0-9-]+) ([A-Za-z0-9.-]*) ([^ ]*) \"([^\"]*)\" \"([^\"]*)\" \"([^\"]*)\" ([-.0-9]*) ([^ ]*) \"([^\"]*)\" \"([^\"]*)\" \"([^ ]*)\" \"([^\s]+?)\" \"([^\s]+)\"(.*)'
    )
    LOCATION 's3://your-alb-logs-directory/AWSLogs/<ACCOUNT-ID>/elasticloadbalancing/<REGION>/'
    TBLPROPERTIES (
        'projection.enabled' = 'true',
        'projection.order_date.type' = 'date',
        'projection.order_date.range' = 'NOW-365DAYS,NOW',
        'projection.order_date.format' = 'yyyy/MM/dd',
        'projection.order_date.interval' = '1',
        'projection.order_date.interval.unit' = 'DAYS',
        'storage.location.template' = 's3://your-alb-logs-directory/AWSLogs/<ACCOUNT-ID>/elasticloadbalancing/<REGION>/$(date)',
        'classification' = 'json',
        'compressionType' = 'gzip',
        'typeOfData' = 'file'
    )
```
