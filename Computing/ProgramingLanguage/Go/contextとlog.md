# context と log

[Using Go's 'context' library for making your logs make sense](https://blog.gopheracademy.com/advent-2016/context-logging/)

今度、翻訳してみよう

## context

Go 言語の`context`は２つの役割を持つ。

- 共通の Cancel 機構  
  ただしくスレッドを終了させるように終了処理を引き回す意味を持つ
- 値の共有機構  
  コンテキスト内で共有する変数

基本的にコンテキストには次のルールが存在する。

- Anti-Pattern
  - Passing required arguments a long way
  - Optional function arguments
  - Passing true globals through context
  - Holding contexts around too long
  - Storing values under regular string/integer keys
- Good-Pattern
  - Database Transaction Handles
  - Per-transaction Object Caches
  - Side effect buffers
  - Application Tracing & Performance

## log

では、ログをコンテキストに持つことはどうか？

上記の例で行くと、DB の`statement`を保存していることからいいのではないか？

```go
func ApplyContextTx(ctx context.Context, stmt *sql.Stmt) *sql.Stmt {
    if tx, ok := TxFromContext(ctx); ok {
        return tx.Stmt(stmt)
    }
    return stmt
}
```

uber-zap はかなり便利に運用できる。
システム用のアプリ横断ログは当然使えるし、API-GW などの WEB アプリとしても使える。
WEB のリクエスト・レスポンスの間は、どのリクエストが成功・失敗したのか`Request ID`で判断したい。

この場合、リクエスト ID をコンテキスト内に持つのは当然として、リクエスト ID に対応したロガーを持つことで任意のログを履けるようにできる。  
特に、Uber-Zap はロガーの設定を変更する場合は、一度作り直す必要があるので、システムのロガーにリクエスト ID の設定をしたものを保持することで解決する。  
また、コンテキストはリクエスト毎に作られるため、シングルトンにしなくてもいい。もちろん、ロガーの sink はスレッドセーフである必要があるが、Uber-Zap はちゃんとやってくれている。
