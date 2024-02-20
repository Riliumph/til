# Cosmos for Postgres

## どんなもの？

[衛星経由で監視されてるハムスター🐹@rioriost](https://x.com/rioriost/status/1727711963604762731)

Azure Cosmos DB for PostgreSQLは、PostgreSQLにCitusエクステンションを追加してスケールアウトが出来るPostgreSQLで、完全にOSS。

旧称はAzure Database for PostgreSQL Hyperscale(Citus)。

Cosmosブランドに移行したけど、Cosmos DB for NoSQL APIとはプラットフォームから異なってて、むしろ、「Azure Database for PostgreSQL Flexible Serverのクラスター」と考える方が近い。（ただしFlexよりプラットフォームが1世代新しいはず）

なので、Cosmos for NoSQLとfor PostgreSQLではSLAが異なる。前者は99.999、後者はHA込みでも99.99

前者はマルチマスターライトできるけど、後者はできん。

今のCitusはDDLを除けば、Coordinator / Workerを問わずクエリー出来るけど、Distributed Tableを書き込むのはいずれかのWorkerだけだから、マルチマスターライトとは言えない。

でも、Reference Tableだと全Workerに書き込むから、話がややこしいw

Reference Tableは、シャードIDが1つしか無い、特殊なDistributed Table。

通常のDistributedは

シャードカラムの値を32ビットハッシュ化  
→ハッシュ値のシャードのレンジ（デフォは32シャード）でID確定  
→IDでWorker確定  

だけど、Referenceは同じシャードIDが全Workerにマップされちょるだけ。
