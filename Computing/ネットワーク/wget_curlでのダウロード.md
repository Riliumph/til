# Forbidden

`curl -OL`や`wget`でWEBから直接画像をダウンロードすることができる。  

```bash
url="https://hogehoge/1.jpg"
curl -OL ${url}
wget https ${url}
```

ただし、firefoxなどのブラウザでは取得できるが、コマンドでは`403`が返却される場合がある。

**サーバーがUser-Agentを見ているのだ**

```bash
url="https://hogehoge/1.jpg"
curl -OL -A "curl" ${url}
wget -U "wget" https ${url}
```
