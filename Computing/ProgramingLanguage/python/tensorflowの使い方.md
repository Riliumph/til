# tensorflow の使い方

tensorflow にはいろんなメンバが存在する。  
それらの使い方というか、何をする子たちなのかを記していきます。

【環境】
Windows10  
Python 3.5  
tensorflow 1.1.0

## まずメンドーなワーニングを抑制する

### 環境変数で抑制する

FreeBSD/Mac や Linux の環境なら下記の環境変数を加えるだけでよい。

```bash:bashrc
export TF_CPP_MIN_LOG_LEVEL=2
```

Windows でもやってみたが無理だった。  
どうせ、Windows 環境なら Visual Studio を使っているだろう？  
下記参照してくれたまえ。

### Python スクリプトから抑制する

ソースコード上に下記のコードを追記することでもできる。  
Python は実行中の OS 空間に環境変数を追記できるのだ。

```python
import os
os.environ['TF_CPP_MIN_LOG_LEVEL'] = '2'
```

Visual Studio を使っている場合はスクリプト自体に環境変数を埋め込む必要はない。  
Visual Studio の設定に環境変数があるので、そちらに追記しよう。

[プロジェクト]-[（任意名）のプロパティ]を開く。  
左の項目欄を Debug に合わせると[Run]グループの中に[Environment Variables:]という項目がある。  
そこに`TF_CPP_MIN_LOG_LEVEL=2`と記述すればいい。
