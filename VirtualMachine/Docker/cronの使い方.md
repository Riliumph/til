# Dockerインスタンス上でのcron実行

docker上でのcronは結構難しかったので記すこととする。

## ことの発端

本来ならば、cronのみを行うインスタンスを用意するべきなのだろうが、ビルド環境を仮想化したので、できるだけビルドと定期ビルドは同じインスタンスで行いたい。  
というのも、ビルド環境が異なってしまう問題を避けたいからだ。  

## cronの起動
ubuntu14.04だが、一般ユーザーから`sudo cron &`を行っても、プロセスは生成されているがcrontabで設定した内容が実行されなかった。  
良く分からないが、一度スーパーユーザーへ移行すればいいようだ。  

```bash
$ sudo su
# cron &
# exit
$ 
```

## 時間が合わない問題
ubuntu14.04などのインスタンスだと時刻がUTCになっているハズだ。  
一般ユーザーで`TZ=Asia/Tokyo`を設定してJSTにしていた場合、確かにタイミングは合うのだが、ログの時刻などが合わない。  
cronコマンドはcronユーザーがログインしてくるため、タイムゾーンを変更するだけではダメなようだ。  

```Dockerfile
（省略）

# 日本語環境
# 一応、バックアップを取ります
cp /etc/sysconfig/clock /etc/sysconfig/clock.org

# viなどで編集してもよし
echo -e 'ZONE="Asia/Tokyo"\nUTC=false' > /etc/sysconfig/clock

# 一応、バックアップを取ります
cp /etc/localtime /etc/localtime.org

# timezoneファイル差し替え
ln -sf  /usr/share/zoneinfo/Asia/Tokyo /etc/localtime
```

## 補足
ここまで来たなら、いっそのこと日本語が打てない問題も解決しよう。  
localeを確認する。  

```bash
$ locale
```

内容がUTF-8じゃなかったらそりゃダメだ  
日本語の設定ファイルがそもそもないハズなので、aptから取得する。  

```
$ sudo apt-get install language-pack-ja-base language-pack-ja
```

日本語設定用ファイルが手に入ったら日本語環境に設定しよう。  

```bash
export LC_ALL=ja_JP.UTF-8
```

まぁ、こんなのはDockerfileに書くべきだと思うけどね！！

