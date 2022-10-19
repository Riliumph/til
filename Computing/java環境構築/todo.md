# Java + Docker環境立ち上げ

- 環境
  - 開発環境：ホスト環境
  - 実行環境：docker環境
- Java
  - JDK: 1.8
  - ビルドツール：Gradle
  - Framework
    - spring boot

## インストール

### aptで入れられるもの

コマンド最適化はされていない

```bash
$ sudo apt update
# jdkのインストール
$ sudo apt install -y openjdk-8-jdk
$ sudo apt install -y 
```

## Javaの設定

```bash
# bashrc
export JAVA_HOME="/usr/lib/jvm/java-8-openjdk-amd64"
export PATH="$JAVA_HOME/bin:$PATH"
# 先頭_始まりは最上位権限でのオプション付け
export _JAVA_OPTIONS='-Dfile.encoding=UTF-8'
```

### gradleのインストール

**`Spring Initializr`でプロジェクトを作る場合`gradlew`というラッパーが含まれるためインストール不要！！**

> - [official](https://docs.gradle.org/current/userguide/installation.html)
> - [release](https://gradle.org/releases/)
> - [spring quick start](https://spring.pleiades.io/quickstart)

パッケージマネージャーの`sdkman`から入れるか、手動で入れるかの二択が掛かれている。  
どちらでもいい。  
`bashrc`を変更するため、ターミナルの再起動が必要であることに注意しろ

色々な物を入れたくないので`Spring Initializr`を使う

### spring bootのインストール

**`Spring Initializr`を使うと梱包されている。**

> - [spring boot starter](https://spring.pleiades.io/spring-boot/docs/current/reference/html/getting-started.html)

SDKMANを

### vscodeに入れるもの

- Spring Boot Extension Pack
- Gradle for Java

### Spring Initialzr

- Project: Gradle Project
- Language: Java
- Spring Boot: 2.7.4
- Project Metadata
  - Group: api.project.com
  - Artifact: demo
  - Name: demo
  - Description:
  - Package name: api.project.com.demo
  - Packaging: jar
  - Java: 17
- Dependencies
  - Spring Web
  - PostgreSQL Driver

## ソースの注意点

jsonで返却する挙動はSpring bootがやってくれる。  
ただし、jsonに落とし込みたいパラメータにはすべてgetter/setterが定義されてなければならない

> accessorが無いと以下の例外が発生する。  
> `org.springframework.http.converter.HttpMessageNotWritableException: No converter found for return value of type`
