# X as a service

## クラウド事業者が管理する範囲

||SaaS|PaaS|IaaS|
|:--|:--:|:--:|:--:|
|APP|〇|||
|MW|〇|〇||
|OS|〇|〇||
|HW|〇|〇|〇|

## Infra as a Service

ネットワーク、ストレージ、仮想サーバーなどの基盤となるインフラをオンデマンドで提供する。

e.g.

- Amazon Web Service
- Google Cloud Platform
- Microsoft Azure
- Oracle Cloud Infrastructure
- IBM Cloud
- Alibaba Cloud

## Platform as a Service

アプリケーションの開発、テスト、実行を支援するプラットフォームを提供する。

- AWS Elastic Beanstalk
- Google App Engine
- Microsoft Azure App Service
- Heroku
- Salesforce Platform

## Service as a Service

アプリケーションをクラウド上で提供する。

- Google Workspace (旧G Suite)
- Microsoft 365
- Salesforce
- Dropbox
- Slack
- Zoom
- Spotify

## Function as a Service

イベント駆動型のサーバーレスアーキテクチャを提供する。  
顧客は必要なときに関数を実行するだけで、サーバーの管理や保守を行う必要がない。

- AWS Lambda
- Google Cloud Functions
- Microsoft Azure Functions
- IBM Cloud Functions
- Oracle Functions

## Desktop as a Service

仮想デスクトップをサービスとして提供する。

- Amazon WorkSpaces  
  AWSが提供するDaaSサービスです。  
  WindowsとLinuxの両方をサポートし、ユーザーはインターネット経由でアクセスすることができる。
- Microsoft Windows Virtual Desktop  
  Azureの一部であり、Windows 10およびWindows ServerをサポートするDaaSサービス。  
- VMware Horizon Cloud  
  VMwareが提供するDaaSサービスで、多くのOSをサポートしている。
- Citrix Virtual Apps and Desktops Service
  Citrixが提供するDaaSサービスで、WindowsおよびLinuxをサポートしている。

## Disaster Recovery as a Service

災害発生時のデータ復旧をクラウド上で行うサービスモデルであり、企業が自社のデータセンターを管理する必要がなく、リスクを軽減することができます。

- AWS Disaster Recovery  
  AWSリージョン間での自動フェールオーバーや手動フェールオーバーをサポートするサービス。  
  このサービスは、スナップショットやレプリケーションを使用して、データ復旧を行う。
- Microsoft Azure Site Recovery  
  Azure上で実行されるVMwareやHyper-V仮想マシンのバックアップと復旧をサポートするサービスです。
- IBM Cloud Disaster Recovery  
  IBM Cloud上でバックアップと復旧を行うサービスです。
- VMware Site Recovery  
  VMware上で実行される仮想マシンのバックアップと復旧をサポートするサービスです。

## Backend as a Service

アプリケーションのバックエンド処理をサポートするクラウドベースのサービスモデルです。以下は、BaaSの代表的なサービスの例です。

- Firebase
  Googleが提供するBaaSサービスです。  
  リアルタイムデータベース、認証、ストレージ、ホスティング、クラウドメッセージングなど、多くの機能を提供しています。
- AWS Amplify  
  AWSが提供するBaaSサービスで、モバイルアプリケーションの開発に特化しています。  
  Amplifyは、データストレージ、認証、API、プッシュ通知などの機能を提供しています。

## Monitoring as a Service

クラウドベースのサービスモデルの1つで、システムやアプリケーションの監視を自動化するためのソフトウェアとハードウェアを提供する。

- Datadog  
  クラウド環境の監視と分析を提供するSaaSサービス。  
  Datadogは、サーバー、アプリケーション、ネットワーク、ログなどの監視を行い、異常を検知することができます。
- Nagios XI  
  Linux上で動作するオープンソースの監視ソフトウェア。  
  Nagios XIは、ネットワーク、サーバー、アプリケーション、データベースなどの監視を行い、異常を検知することができます。
- New Relic  
  クラウドアプリケーションのパフォーマンス監視とトラブルシューティングを行うSaaSサービスです。  
  New Relicは、サーバー、アプリケーション、データベースなどの監視を行い、異常を検知することができます。
- Zabbix  
  Zabbixは、オープンソースの監視ソフトウェアで、ネットワーク、サーバー、アプリケーション、データベースなどの監視を行い、異常を検知することができます。
