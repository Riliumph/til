# AWS CLIの初期化

## 最初の確認

```console
$ ls ~/.aws/
cli/  login/
```

この状態で現在使用しているAWSの認証情報（IAMユーザーやロール）のアカウントIDやARNを確認するためのコマンドを実行してみる。

```console
$ aws sts get-caller-identity

aws: [ERROR]: An error occurred (NoCredentials): Unable to locate credentials. You can configure credentials by running "aws login".
```

当然、情報はないので見えない。

## ユーザーの登録

アクセスキーを用いるのであれば、以下のコマンドを実行する。

```console
$ aws configure
```

今回は、アクセスキーではなくWEB経由のログインを行う。

```console
$ aws login
No AWS region has been configured. The AWS region is the geographic location of your AWS resources.

If you have used AWS before and already have resources in your account, specify which region they were created in. If you have not created resources in your account before, you can pick the region closest to you: https://docs.aws.amazon.com/global-infrastructure/latest/regions/aws-regions.html.

You are able to change the region in the CLI at any time with the command "aws configure set region NEW_REGION".
AWS Region [us-east-1]: ap-northeast-1
Attempting to open your default browser. If the browser does not open, open the following URL.
If you are unable to open the URL on this device, run this command again with the '--remote' option.

Updated profile default to use arn:aws:iam::<your-account-id>:user/<your-user-name> credentials.
```

## 生成物の確認

```console
$ cat ~/.aws/config 
[default]
login_session = arn:aws:iam::<your-account-id>:user/<your-user-name>
region = ap-northeast-1
```

```console
cat 162213fc62ff0eb7aef274a04b6de6c6a26fdc8ceef18c0d88e6446b406e75e5.json | jq .
{
  "accessToken": {
    "accessKeyId": "<access-key-id>",
    "secretAccessKey": "<secret-access-key-id>",
    "sessionToken": "<sesstion-token>",
    "accountId": "<account-id>",
    "expiresAt": "2026-09-15T08:48:45Z"
  },
  "tokenType": "urn:aws:params:oauth:token-type:access_token_sigv4",
  "clientId": "arn:aws:signin:::devtools/same-device",
  "refreshToken": "<refresh-token>",
  "idToken": "<id-token>",
  "dpopKey": "-----BEGIN EC PRIVATE KEY-----\n<your-private-key-base64>\n-----END EC PRIVATE KEY-----\n"
}
```

## 現在のユーザーから認証情報を取得

```console
$ aws configure list
NAME       : VALUE                    : TYPE             : LOCATION
profile    : <not set>                : None             : None
access_key : ****************Z2BL     : login            : 
secret_key : ****************3ImF     : login            : 
region     : ap-northeast-1           : config-file      : ~/.aws/config
```

`TYPE login`になっていることから、アクセスキーとシークレットキーはログインセッション中でのみ有効な自動生成キーであることが分かる。

```console
$ aws sts get-caller-identity
{
    "UserId": "<user-id>",
    "Account": "<account-id>",
    "Arn": "arn:aws:iam::<account-id>:user/<user-name>"
}
```
