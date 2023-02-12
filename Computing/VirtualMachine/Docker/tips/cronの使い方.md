# Docker インスタンス上での cron 実行

docker 上での cron は結構難しかったので記すこととする。

## ことの発端

本来ならば、cron のみを行うインスタンスを用意するべきなのだろうが、ビルド環境を仮想化したので、できるだけビルドと定期ビルドは同じインスタンスで行いたい。  
というのも、ビルド環境が異なってしまう問題を避けたいからだ。

## cron の起動

ubuntu14.04 だが、一般ユーザーから`sudo cron &`を行っても、プロセスは生成されているが crontab で設定した内容が実行されなかった。  
良く分からないが、一度スーパーユーザーへ移行すればいいようだ。

```bash
$ sudo su
# cron &
# exit
```

## 時間が合わない問題

ubuntu14.04 などのインスタンスだと時刻が UTC になっているハズだ。  
一般ユーザーで`TZ=Asia/Tokyo`を設定して JST にしていた場合、確かにタイミングは合うのだが、ログの時刻などが合わない。  
cron コマンドは cron ユーザーがログインしてくるため、タイムゾーンを変更するだけではダメなようだ。

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
locale を確認する。

```bash
$ locale
```

内容が UTF-8 じゃなかったらそりゃダメだ  
日本語の設定ファイルがそもそもないハズなので、apt から取得する。

```bash
$ sudo apt-get install language-pack-ja-base language-pack-ja
```

日本語設定用ファイルが手に入ったら日本語環境に設定しよう。

```bash
export LC_ALL=ja_JP.UTF-8
```

まぁ、こんなのは Dockerfile に書くべきだと思うけどね！！
