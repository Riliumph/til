# Dockerのデフォルト設定の違い
Dockerのデフォルト設定は/etc/default/dockerを変更する。  

- DOCKER_OPTS=xxx  
  upstartを使う場合のオプション
- OPTIONS=xxx  
  systemdを使う場合のオプション


まぁ、/etc/default/dockerよりも、$HOME/.dockerを弄った方が良さそうだけど
