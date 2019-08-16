# jupyter notebookとは

jupyter notebookとはPython環境のウェブインターフェイスを提供するフレームワークである。  
今までPythonをリモート環境で使う場合は、sshなどでターミナルにログインして操作する方法があった。  
しかし、jupyter notebookの登場でそれは変化した。  

Jupyter notebookはHTTP/HTTPSで接続してブラウザ上でPythonを動かすことができる。  

# 使い方
Jupyter notebookを下記の環境で動かして接続する場合の手順を記載する。  

[環境]  
Windows10 -(Virtual Box)-> Ubuntu 16.04  
接続元：Windows10  
接続先：Ubuntu 16.04  

Dockerとか噛ましてもっと複雑にしても面白いかもね  

## Python環境の整備

pyenvを入れて、anaconda3をインストールする。  
この手順は腐るほどweb上にあるので割愛する。  

anacondaをインストールするとjupyter notebookも同時にインストールされている。  

## ネットワークの構成
本題である。  
Virtual BoxのVMマネージャから該当イメージの設定を開く。  
ネットワークの構成を開き、アダプター１の割り当てを「NAT」に変更する。  
NAT構成にすることで、下にある「ポートフォワード」ボタンがアクティブになる。  
ポートフォワードウィンドウを開いて、下記の設定を行う。  

|名前|プロトコル|ホストIP|ホストポート|ゲストIP|ゲストポート|
|:--:|:--------:|:------:|:----------:|:------:|:----------:|
|jupyter|TCP||9999||8888|

jupyter notebookはデフォルトポート8888で動作する。  
この設定は、Windows10（ホストOS）の9999へのアクセスをubuntu16.04（ゲストOS）の8888へフックするということを行う。  

## jupyter notebookの設定

jupyterへの認証方法は下記の２つが用意されています。  

||方法|説明|
|:-:|:-:|:-:|
|1|token|平文の設定|
|2|password|暗号化して設定|

このままjuoyter notebookを起動してもアクセス自体はできる。  
しかし、jupyter v4からセキュリティが強化され、ログインにパスワードか認証トークンを要求される。  

※jupyterを動かしているubuntu16.04からのアクセスは可能である。  
　これは、設定の無いjupyterは認証トークンをハッシュのように自動生成し、それを使ってアクセスするためである。  
　認証トークンを使うため、パスワードを要求されることはない。  

下記のコマンドを用いてjupyterの設定を生成する。  

```bash
$ jupyter notebook --generate-config
```

### tokenを指定する場合

jupyterの設定ファイルに下記を追記します。  
※PATH : $HOME/.jupyter/jupyter_notebook_config.py  

```python:$HOME/.jupyter/jupyter_notebook_config.py
c.NotebookApp.token = 'your token string'
```

この設定を行った場合は、jupyterへアクセスしたときのパスワード欄にtoken値を入力するか  
下記のURLでjupyterへアクセスすればよい。  

>
> http&#58;//localhost:8888/?token=your token string  
> ポートフォワードを行っている場合は、アクセスポートを適宜変更すること。


### passwordを指定する場合

インタラクティブなPythonで下記のコードを実行する。  

```bash
$ python -c 'from notebook.auth import passwd;print(passwd())'
Enter password: xxxxxxxxxx
Verify password: xxxxxxxxxx
sha1:yyyyyyyyyy
```

その後、jupyterの設定に下記を追加する。

```python
c.NotebookApp.password='sha1:yyyyyyyyyy'
```

>（補足）  
>sha1はハッシュ値が衝突しており、Googleが解析アルゴリズムの公開を行う予定にある。  
>セキュリティ的な問題があるので使わない方がよい。  
>どうにかすれば、sha256でパスワードを暗号化できそうではあるが……  


### ipの指定
IPアドレスの設定をすることでアクセス制限を設けることができる。  
以下の設定を行い、すべてのIPからのアクセスを許可する。  

```python
# 「*」はすべてのIPからアクセスを許可する
c.NotebookApp.ip = '*'
```

※jupyter notebook 5.0.0のデフォルトでは、localhostが設定されているためjupyterのホストしかアクセスできない。  

### ディレクトリ指定
ブラウザで表示する場合のルートディレクトリを設定する。  
普通は、特定のディレクトリを割り当てて、他のディレクトリに入ったり操作することができないようにしておくべき。  

```python
c.NotebookApp.notebook_dir = '/home/username/xxxxx'
```

### ブラウザの自動起動
jupyterは起動時にブラウザを自動起動するように設定されている。  
若干ウザイのでしないようにしておく。  

```python
c.NotebookApp.open_browser = False
```

## jupyter notebookの自動起動
Dockerなどで環境を構築したなどの場合、Dockerを立ち上げたときに自動的に立ち上がってほしいことがある。  
今回もサーバーを立ち上げたときに自動的にjupyter notebookが起動されるようにする設定をする。  

### init/Upstartの人

起動時にそういう設定をするのは、下記のシステムファイルを変更する。  

```bash
$ sudo -E vim /etc/rc.local
```

```bash rc.local
#下記のコマンドを「exit 0」の前に記述する。
su - username /(pyenvまでのパス)/pyenv/shims/jupyter notebook

exit 0 # これはデフォルトで記載されている
```

ポイントは、`su - username`することである。  
単純にコマンドを指定しても、起動時のroot userで実行してしまう。  
「su - username」することで、ログインシェルを用いてユーザーを切り替えている。  
しかし、任意コマンドを実行するオプションである「-c」を使うと自動実行されなかった。  

その後、jupyter notebookを起動する。  
rc.localに記載するコマンドに、「&」が要らないということもポイントである。  

### Systemdの人

`/etc/systemd/system/jupyter.service`を作成する。

```ini /etc/systemd/system/jupyter.service
[Unit]
Description=Jupyter Notebook (seminar)

[Service]
Type=simple
WorkingDirectory=/home/user
ExecStartPre=. /home/user/anaconda3/etc/profile.d/conda.sh; conda activate seminar
ExecStart=/home/user/anaconda3/envs/seminar/bin/jupyter notebook --config=/home/user/.jupyter/jupyter_notebook_config.py
User=user
Group=user

[Install]
WantedBy=multi-user.target
```

起動確認

```bash
sudo systemctl start jupyter
sudo systemctl status jupyter
```

自動起動の有効化

```bash
sudo systemctl enable jupyter
```
