# Alpineには注意しろ

> - 参考：
>   - [軽量Dockerイメージに安易にAlpineを使うのはやめたほうがいいという話](https://blog.inductor.me/entry/alpine-not-recommended)
>   - [Why is the Alpine Docker image over 50% slower than the Ubuntu image?](https://superuser.com/questions/1219609/why-is-the-alpine-docker-image-over-50-slower-than-the-ubuntu-image)
>   - [GoogleContainerTools/distroless](https://github.com/GoogleContainerTools/distroless)

Alpineは2018年ぐらいまで軽量イメージの定番だったのは事実である。  
しかし、2020年辺りからGoogleが軽量イメージを管理し始め、別にAlpineでなくても軽いイメージは出てきた。

さらに、Alpineは独自の`glibc`を採用していることからRuby / Python / Node.jsなどのモジュールでパフォーマンスが低下する問題が発生し始める。

2020年において、代替となるイメージは以下

- Debian Slim
- gcr.io/distroless/static-debian10
- gcr.io/distroless/base-debian10
- gcr.io/distroless/java-debian10
- gcr.io/distroless/cc-debian10
- gcr.io/distroless/nodejs-debian10
