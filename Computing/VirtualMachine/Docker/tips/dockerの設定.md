# Docker のデフォルト設定の違い

Docker のデフォルト設定は/etc/default/docker を変更する。

- DOCKER_OPTS=xxx  
  upstart を使う場合のオプション
- OPTIONS=xxx  
  systemd を使う場合のオプション

まぁ、/etc/default/docker よりも、\$HOME/.docker を弄った方が良さそうだけど
