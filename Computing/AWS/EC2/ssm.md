# セッションマネージャーの使い方

- AWS CLIを設定する
- EC2にロールを付与する
- EC2がアウトバウンド通信ができる設定にする
- EC2にSSM Agentをインストールする

## AWS CLIを設定する

### AWS CLIのインストール

```console
$ sudo apt install awscli
```

### AWS CLIのアクセスキー設定

```console
$ aws configure
AWS Access Key ID [None]: XXX
AWS Secret Access Key [None]: XXX
Default region name [None]: ap-northeast-1
Default output format [None]: json
```

```console
$ cd ~/aws/
$ ls
config*  credentials*
```

## EC2にロールを付与する

### EC2用のIAMロールを作成する

IAMロール`ssm_enabled`を作成する。  
`AmazonSSMManagedInstanceCore`ポリシーを付与する。

### EC2にIAMロールを付与する

EC2のコンソールの【アクション】-【セキュリティ】-【IAMロールを変更】からIAMロールを付与する。

## EC2がアウトバウンド通信できるように設定する

### HTTPSの接続を許可する

セキュリティグループ（以下、SG）のアウトバウンド通信にHTTPSを許可する。

### NATゲートウェイが存在する

EC2がpublic subnetに存在し、ElasticIPが付与されている場合は直接アクセスできるため設定不要。  
EC2がprivate subnetに存在する場合、NAT Gateway経由でアウトバウンド通信する必要があるため、NAT Gatewayを確認する。

## SSM Agentのインストール

面倒なのでデフォルトで入っているAmazon Linuxを使え
