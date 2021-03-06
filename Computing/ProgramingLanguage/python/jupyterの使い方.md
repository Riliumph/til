# jupyter notebook とは

jupyter notebook とは Python 環境のウェブインターフェイスを提供するフレームワークである。  
今まで Python をリモート環境で使う場合は、ssh などでターミナルにログインして操作する方法があった。  
しかし、jupyter notebook の登場でそれは変化した。

jupyter notebook は HTTP/HTTPS で接続してブラウザ上で Python を動かすことができる。

## 環境構築

jupyter notebook を下記の環境で動かして接続する場合の手順を記載する。

[環境]  
Windows10 -(Virtual Box)-> Ubuntu 16.04  
接続元：Windows10  
接続先：Ubuntu 16.04

Docker とか噛ましてもっと複雑にしても面白いかもね

### Python 環境の整備

pyenv を入れて、anaconda3 をインストールする。  
この手順は腐るほど web 上にあるので割愛する。

anaconda をインストールすると jupyter notebook も同時にインストールされている。

### ネットワークの構成

本題である。  
Virtual Box の VM マネージャから該当イメージの設定を開く。  
ネットワークの構成を開き、アダプター１の割り当てを「NAT」に変更する。  
NAT 構成にすることで、下にある「ポートフォワード」ボタンがアクティブになる。  
ポートフォワードウィンドウを開いて、下記の設定を行う。

|  名前   | プロトコル | ホスト IP | ホストポート | ゲスト IP | ゲストポート |
| :-----: | :--------: | :-------: | :----------: | :-------: | :----------: |
| jupyter |    TCP     |           |     9999     |           |     8888     |

jupyter notebook はデフォルトポート 8888 で動作する。  
この設定は、Windows10（ホスト OS）の 9999 へのアクセスを ubuntu16.04（ゲスト OS）の 8888 へフックするということを行う。

## jupyter notebook の設定

jupyter への認証方法は下記の２つが用意されています。

|     |   方法   |      説明      |
| :-: | :------: | :------------: |
|  1  |  token   |   平文の設定   |
|  2  | password | 暗号化して設定 |

このまま jupyter notebook を起動してもアクセス自体はできる。  
しかし、jupyter v4 からセキュリティが強化され、ログインにパスワードか認証トークンを要求される。

※jupyter を動かしている ubuntu16.04 からのアクセスは可能である。  
　これは、設定の無い jupyter は認証トークンをハッシュのように自動生成し、それを使ってアクセスするためである。  
　認証トークンを使うため、パスワードを要求されることはない。

下記のコマンドを用いて jupyter の設定を生成する。

```bash
jupyter notebook --generate-config
```

### token を指定する場合

jupyter の設定ファイルに下記を追記します。  
※PATH : \$HOME/.jupyter/jupyter_notebook_config.py

```python:$HOME/.jupyter/jupyter_notebook_config.py
c.NotebookApp.token = 'your token string'
```

この設定を行った場合は、jupyter へアクセスしたときのパスワード欄に token 値を入力するか  
下記の URL で jupyter へアクセスすればよい。

> http&#58;//localhost:8888/?token=your token string  
> ポートフォワードを行っている場合は、アクセスポートを適宜変更すること。

### password を指定する場合

インタラクティブな Python で下記のコードを実行する。

```bash
$ python -c 'from notebook.auth import passwd;print(passwd())'
Enter password: xxxxxxxxxx
Verify password: xxxxxxxxxx
sha1:yyyyyyyyyy
```

その後、jupyter の設定に下記を追加する。

```python
c.NotebookApp.password='sha1:yyyyyyyyyy'
```

> （補足）  
> sha1 はハッシュ値が衝突しており、Google が解析アルゴリズムの公開を行う予定にある。  
> セキュリティ的な問題があるので使わない方がよい。  
> どうにかすれば、sha256 でパスワードを暗号化できそうではあるが……

### ip の指定

IP アドレスの設定をすることでアクセス制限を設けることができる。  
以下の設定を行い、すべての IP からのアクセスを許可する。

```python
# 「*」はすべてのIPからアクセスを許可する
c.NotebookApp.ip = '*'
```

> jupyter notebook 5.0.0 のデフォルトでは、`localhost`が設定されているため jupyter のホストしかアクセスできない。

### ディレクトリ指定

ブラウザで表示する場合のルートディレクトリを設定する。  
普通は、特定のディレクトリを割り当てて、他のディレクトリに入ったり操作することができないようにしておくべき。

```python
c.NotebookApp.notebook_dir = '/home/username/xxxxx'
```

> Macの場合は`/Users/username/xxxxx`なので注意

### ブラウザの自動起動

jupyter は起動時にブラウザを自動起動するように設定されている。  
若干ウザイのでしないようにしておく。

```python
c.NotebookApp.open_browser = False
```

## jupyter notebook の自動起動

Docker などで環境を構築したなどの場合、Docker を立ち上げたときに自動的に立ち上がってほしいことがある。  
今回もサーバーを立ち上げたときに自動的に`jupyter notebook`が起動されるようにする設定をする。

### init/Upstart の人

起動時にそういう設定をするのは、下記のシステムファイルを変更する。

```bash
sudo -E vim /etc/rc.local
```

```bash rc.local
#下記のコマンドを「exit 0」の前に記述する。
su - username /(pyenvまでのパス)/pyenv/shims/jupyter notebook

exit 0 # これはデフォルトで記載されている
```

ポイントは、`su - username`することである。  
単純にコマンドを指定しても、起動時の root user で実行してしまう。  
`su - username`することで、ログインシェルを用いてユーザーを切り替えている。  
しかし、任意コマンドを実行するオプションである「-c」を使うと自動実行されなかった。

その後、jupyter notebook を起動する。  
rc.local に記載するコマンドに、「&」が要らないということもポイントである。

### Systemd の人

`/etc/systemd/system/jupyter.service`を作成する。

```ini /etc/systemd/system/jupyter.service
[Unit]
Description=Jupyter Notebook

[Service]
Type=simple
WorkingDirectory=/home/user
ExecStartPre=. /home/user/anaconda3/etc/profile.d/conda.sh
ExecStartPre=conda activate #jupyterのconda環境名#
ExecStart=/home/user/anaconda3/envs/seminar/bin/jupyter notebook --config=/home/user/.jupyter/jupyter_notebook_config.py
User=user
Group=user

[Install]
WantedBy=multi-user.target
```

`ExeStartPre`で Anaconda の環境にスイッチする。  
`ExeStart`で jupyter を実際に実行する。

起動確認

```bash
sudo systemctl start jupyter
sudo systemctl status jupyter
```

自動起動の有効化

```bash
sudo systemctl enable jupyter
```
