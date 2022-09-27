# １つのStream系クラスから複数回の読み込みを行う

## サンプルコード

```go
func ParamItem(ctx echo.Context) (result []zap.Field{}){
  // Query String
  query := ctx.QueryParam()
  result = append(result, zap.Any("QueryString", query))

  // Body Param
  var body map[string]interface{}
  e := json.NewDecoder(ctx.Request().Body).Decode(&body) // BodyへのアクセスでBodyが自動Closeされる
  if e != nil {
    logger.Error("decode error")
  }
  return
}

func (controller *DataController) PutData(ctx echo.Context){
  logger.Debug("show parameter", ParamItem(ctx))
  var newData = model.Data
  err := ctx.Bind(&newData) // BodyがCloseされてしまっているため空文字しか取得できず、エラーが発生する
  if err != nil {
    return controller.presenter.Error()
  }
}
```

こういうコードの場合、`ParamItem`メソッドで変数`ctx`がshallow copyされてstream reader越しにデータを取得する。  
stream readerは元のデータを削除してしまうため、`PutData`メソッドの`ctx.Bind`の段階で変数`ctx`からデータが消えてしまっていて、空文字を`model.Data`にバインドしようとして失敗する。

## 解決策

### httputil.DumpRequestでstring返却する

```go
func (controller *DataController) PutData(ctx echo.Context){
  // もうメンドウなのでhttp.Requestをダンプする
  logger.Debug("show parameter", zap.Field("Request", httputil.DumpRequest(ctx.Request(), true)))
  var newData = model.Data
  err := ctx.Bind(&newData)
  if err != nil {
    return controller.presenter.Error()
  }
}
-----
{
  "loglevel": "DEBUG"
  "time": "yyyy-mm-ddThh:mm:ss.msec",
  "caller": "logger/applogger.go:10",
  "msg": "show parameter",
  "details": {
    "Request": "POST /api/path HTTP/1.1
                HOST: api.host.ap-northeast-1.amazonaws.com
                Accept: application/json, text/plain, */*
                Accept-Encoding: gzip, deflate, br
                Accept-Language: ja,en-US
                Authorization: Bearer <YOYR_TOKEN>
                Content-Type: application/json
                Origin: https://hoge.cloudfront.net
                Referer: https://hoge.cloudfront.net/
                Sec-Fetch-Dest: empty
                Sec-Fetch-Mode: cors
                Sec-Fetch-Site: cross-site
                User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:105.0) Gecko/20100101 Firefox/105.0
                X-Amzn-Trace-Id: Root=x-xxxxx-xxxx
                X-Forwarded-For: x.xxx.xxx.xxx
                X-Forwarded-Port: 443
                X-Forwarded-Proto: https
                {\"hoge\": \"hoge\", \"fuga\": \"fuga\"}"
   }
}
```

### httputil.DumpRequestと同じように処理してMap返却する

```go
// CloneRequest http.Requestをクローンする
// @param original: 内部変数を書き換えるためポインタで受け取る（参照型なので値でも問題ない）
// @description:
// io.ReadCloser型のhttp.Request.Bodyは、Read後に自動Closeが行われる。
// そのため、一度読み取るだけでhttp.Request構造体の中のBodyは空文字になってしまい、二度とアクセスできない。
// httputil.DumpRequestと同じ手法でクローンする
// - io.ReadCloser: Readメソッド内でdefer closeが記述されているため、実行後に自動でCloseされる。
// - ioutil.NopCloser: ReadメソッドはReadするだけなので、自動Closeしない
func CloneRequest(original *http.Request) *http.Request {
  // shallow copyで出来るだけコピーする
  dumped := *origin
  var bodyBuf bytes.Buffer
  // このタイミングでdumped.Bodyが消失する。※dumpedはoriginalの参照なので、original側のBodyも消失する
  _, _ = bodyBuf.ReadFrom(dumped.Body)
  // オリジナル側にBodyを入れる
  // ※追加で、次のアクセス以降にもBodyが消えないようにNopCloserで元に戻している
  original.Body = iotuil.NopCloser(&bodyBuf)
  // クローン側にもBodyを入れる
  // bodyBufとは切り離すため新しいio.Readerを生成する必要がある。
  // ※追加で、次のアクセス以降にもBodyが消えないようにNopCloserで元に戻している
  dumped.Body = ioutil.NopCloser(bytes.NewReader(bodyBuf.Bytes()))
  return &dumped
}

func ParamItem(ctx echo.Context) (result []zap.Field{}){
  // Query String
  query := ctx.QueryParam()
  result = append(result, zap.Any("QueryString", query))

  // Body Param
  dumpedRequest := CloneRequest(ctx.Request())
  var body map[string]interface{}
  e := json.NewDecoder(dumpedRequest.Body).Decode(&body)
  if e != nil {
    logger.Error("decode error")
  }
  result = append(result, zap.Any("Body", body))
  return
}

func (controller *DataController) PutData(ctx echo.Context){
  logger.Debug("show parameter", ParamItem(ctx))
  var newData = model.Data
  err := ctx.Bind(&newData) // 自動Close後に、Bodyを入れ直しているため取得できる
  if err != nil {
    return controller.presenter.Error()
  }
}
-----
{
  "loglevel": "DEBUG"
  "time": "yyyy-mm-ddThh:mm:ss.msec",
  "caller": "logger/applogger.go:10",
  "msg": "show parameter",
  "details": {
    "QueryString": {},
    "Body": {
      "hoge": "hoge",
      "fuga": "fuga",
    }
  }
}
```

> 参考
>
> - [http.Request.Clone() is not deep clone](https://stackoverflow.com/questions/62017146/http-request-clone-is-not-deep-clone)
> - [net/http: Request.Clone() does not deep copy Body contrary to its docs (using GetBody works though) #36095](https://github.com/golang/go/issues/36095)
