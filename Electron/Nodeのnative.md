# Node.js でネイティブ拡張を作る方法

方法は３つある。

- V8 エンジンの API を利用する
- NAN(Native Abstractions for Node.js)を利用する
- N-API を利用する

とは言えど、C++のソースコードを用意して`node-gyp`でコンパイルするという形式はどれも同じ模様。

## V8 エンジンを利用する

？？？「おい、その先は地獄だぞ」

V8 エンジンは過去に後方互換性を排した破壊的変更を行った経緯を持つ。  
その際、当時使われていたネイティブコードはすべて動作しなくなり、再実装を余儀なくされた。

これはそのやり方。

V8 API は[ここ](https://v8docs.nodesource.com/node-4.8/index.html)

```C++
#include <node.h>

namespace demo {

using v8::FunctionCallbackInfo;
using v8::Isolate;
using v8::Local;
using v8::NewStringType;
using v8::Object;
using v8::String;
using v8::Value;

/**
 * 実際に公開される関数
 * API名は別途決められるため、この名前で公開されるかは分からない
 */
void Method(const FunctionCallbackInfo<Value>& args)
{
  Isolate* isolate = args.GetIsolate();
  Local<String> str = String::NewFromUtf8(isolate,
                                          "world",
                                           NewStringType::kNormal);
  args.GetReturnValue().Set(str.ToLocalChecked()); // 戻り値
}

/**
 * 外部公開用のAPIを一気に初期化する関数
 * この中にNODE_SET_METHODの形式でどんどんAPIを追加していけるハズ
 */
void Initialize(Local<Object> exports)
{
  // Method関数をhelloの名前でexportsしますよって意味
  NODE_SET_METHOD(exports,
                  "hello", // 外部公開用のAPI名
                  Method   // API名とバインドする関数名
                  );
}

NODE_MODULE(NODE_GYP_MODULE_NAME, // 最終バイナリの名前（foo.node）
            Initialize            // エントリポイント？
            )
}  // namespace demo
```

まま`node.h`を読み込んで記述していくが、よく分からんクラスばかりで困る。  
あまり解説する気が起きないのでここまで。

## N-API を利用する

N-API はネイティブアドオンを構築するための API。  
JavaScript ランタイム（V8）から独立しており、Node.js 自体の一部として維持される。  
つまり、V8 用 API を使うよりも Node.js 側で互換性を保ってくれるということ。

> ホントかどうかは知らん

```C++
#include <node_api.h>

namespace demo {

napi_value Method(napi_env env, napi_callback_info args) {
  napi_value greeting;
  napi_status status;

  status = napi_create_string_utf8(env, "world", NAPI_AUTO_LENGTH, &greeting);
  if (status != napi_ok) return nullptr;
  return greeting;
}

napi_value init(napi_env env, napi_value exports) {
  napi_status status;
  napi_value fn;

  status = napi_create_function(env, nullptr, 0, Method, nullptr, &fn);
  if (status != napi_ok) return nullptr;

  status = napi_set_named_property(env, exports, "hello", fn);
  if (status != napi_ok) return nullptr;
  return exports;
}

NAPI_MODULE(NODE_GYP_MODULE_NAME, init)

}  // namespace demo
```

まだ、こっちの方が何してるのか分かり易いな。
