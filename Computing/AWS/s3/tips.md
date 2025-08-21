# Tips

## S3Syncは結構遅い

FargateのログをEFSに吐き出し、S3へ転送する。  
転送にはFluentdとかではなく、AWS APIのS3Syncを用いる。  
このS3Syncがなかなかに重い。248Bの7000ファイルを送るのに30分ほどかかっている。  
本来は、CloudWatch+Firehoseを使ったりするのだろうが、こういう構成になった場合は注意せよ

> 普通にFirehose使ってS3なりElasticsearchに入れれば？

## 小さなオブジェクトをコンパクションすることによるストレージコストとクエリパフォーマンスの最適化

[小さなオブジェクトをコンパクションすることによるストレージコストとクエリパフォーマンスの最適化](https://aws.amazon.com/jp/blogs/news/optimizing-storage-costs-and-query-performance-by-compacting-small-objects/)
