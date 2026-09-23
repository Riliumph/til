# WSLのエラー

## 環境編

### エラーログ

```log
[2026-09-23T04:57:08.163Z] Start: Run in container: echo ~
[2026-09-23T04:57:08.165Z] userEnvProbe: not found in cache
[2026-09-23T04:57:08.166Z] userEnvProbe shell: /bin/bash
[2026-09-23T04:57:08.172Z] Start: Run in container: # Test for /home/vscode/.ssh/known_hosts and ssh
[2026-09-23T04:57:08.183Z] Start: Run in Host: gpg-connect-agent updatestartuptty /bye
[2026-09-23T04:57:08.194Z] 
[2026-09-23T04:57:08.197Z] 
[2026-09-23T04:57:08.199Z] Stop (27 ms): Run in container: # Test for /home/vscode/.ssh/known_hosts and ssh
[2026-09-23T04:57:08.200Z] Start: Run in container: # Copy C:\Users\riliu\.ssh\known_hosts to /home/vscode/.ssh/known_hosts
[2026-09-23T04:57:08.204Z] Stop (21 ms): Run in Host: gpg-connect-agent updatestartuptty /bye
[2026-09-23T04:57:08.209Z] 
[2026-09-23T04:57:08.211Z] 
[2026-09-23T04:57:08.213Z] Exit code 1
[2026-09-23T04:57:08.215Z] Stop (15 ms): Run in container: # Copy C:\Users\riliu\.ssh\known_hosts to /home/vscode/.ssh/known_hosts
[2026-09-23T04:57:08.217Z] Start: Run in container: command -v git >/dev/null 2>&1 && git config --system --replace-all credential.helper '!f() { /home/vscode/.vscode-server/bin/7debcd0e2acdea1c52de81bf9ee1620444407dda/node /tmp/vscode-remote-containers-8630e3ae-f969-4309-adfc-87da32d04d3e.js git-credential-helper $*; }; f' || true
[2026-09-23T04:57:08.219Z] Host server: packet-stream asked to read after closed { value: { code: 0, signal: null }, end: false, req: -16 }
[2026-09-23T04:57:08.221Z] Stop (1174 ms): Run in Host: docker exec -i -u root 31da23dc7694bc06311ead97c87e5aef9ffb903001c4c4a698830b191de6acd6 /bin/sh -c echo "New container started. Keep-alive process started." ; export VSCODE_REMOTE_CONTAINERS_SESSION=30c78be9-9ea4-4992-91f5-a65ffbd0b97c1790139418471 ; /bin/sh
[2026-09-23T04:57:08.222Z] Stop (1055 ms): Run in Host: docker exec -i -u vscode -e VSCODE_REMOTE_CONTAINERS_SESSION=30c78be9-9ea4-4992-91f5-a65ffbd0b97c1790139418471 31da23dc7694bc06311ead97c87e5aef9ffb903001c4c4a698830b191de6acd6 /bin/sh
[2026-09-23T04:57:08.224Z] Stop (387 ms): Run in Host: docker exec -i -u root 31da23dc7694bc06311ead97c87e5aef9ffb903001c4c4a698830b191de6acd6 /bin/sh
[2026-09-23T04:57:08.225Z] Stop (95 ms): Run in Host: docker exec -i -u vscode 31da23dc7694bc06311ead97c87e5aef9ffb903001c4c4a698830b191de6acd6 /bin/sh
[2026-09-23T04:57:08.233Z] unexpected end of parent stream
[2026-09-23T04:57:08.238Z] Keep-alive process ended.
[2026-09-23T04:57:08.241Z] Error reading shell environment.
[2026-09-23T04:57:08.242Z] Shell server failed: Error: unexpected end of parent stream
    at Ui.destroy (c:\Users\riliu\.vscode\extensions\ms-vscode-remote.remote-containers-0.469.0\dist\extension\extension.js:12:26685)
    at Ui.write (c:\Users\riliu\.vscode\extensions\ms-vscode-remote.remote-containers-0.469.0\dist\extension\extension.js:12:27426)
    at c:\Users\riliu\.vscode\extensions\ms-vscode-remote.remote-containers-0.469.0\dist\extension\extension.js:12:29530
    at c:\Users\riliu\.vscode\extensions\ms-vscode-remote.remote-containers-0.469.0\dist\extension\extension.js:12:14883
    at c:\Users\riliu\.vscode\extensions\ms-vscode-remote.remote-containers-0.469.0\dist\extension\extension.js:12:17569
    at c:\Users\riliu\.vscode\extensions\ms-vscode-remote.remote-containers-0.469.0\dist\extension\extension.js:12:23935
    at r (c:\Users\riliu\.vscode\extensions\ms-vscode-remote.remote-containers-0.469.0\dist\extension\extension.js:12:17517)
    at c:\Users\riliu\.vscode\extensions\ms-vscode-remote.remote-containers-0.469.0\dist\extension\extension.js:12:17562
    at Object.cb (c:\Users\riliu\.vscode\extensions\ms-vscode-remote.remote-containers-0.469.0\dist\extension\extension.js:12:24046)
    at l (c:\Users\riliu\.vscode\extensions\ms-vscode-remote.remote-containers-0.469.0\dist\extension\extension.js:12:22041)
    at u (c:\Users\riliu\.vscode\extensions\ms-vscode-remote.remote-containers-0.469.0\dist\extension\extension.js:12:22303)
    at c:\Users\riliu\.vscode\extensions\ms-vscode-remote.remote-containers-0.469.0\dist\extension\extension.js:12:22386
    at s (c:\Users\riliu\.vscode\extensions\ms-vscode-remote.remote-containers-0.469.0\dist\extension\extension.js:15:5377)
    at Socket.<anonymous> (c:\Users\riliu\.vscode\extensions\ms-vscode-remote.remote-containers-0.469.0\dist\extension\extension.js:15:5478)
    at Socket.emit (node:events:509:28)
    at addChunk (node:internal/streams/readable:563:12)
    at readableAddChunkPushByteMode (node:internal/streams/readable:514:3)
    at Readable.push (node:internal/streams/readable:394:5)
    at Pipe.onStreamRead (node:internal/stream_base_commons:189:23)
```

#### 問題自体の説明

Dev Containers がコンテナを起動した後、

- /home/vscode/.ssh/known_hosts を確認
- ホストの C:\Users\riliu\.ssh\known_hosts をコンテナへコピー
- user environment を取得

という処理をしています。

この known_hosts 周辺の処理の直後に `shell server` が死んでいます。

Microsoft の [Issue #11480](https://github.com/microsoft/vscode-remote-release/issues/11480) では、まさに

```console
# Test for /home/user/.ssh/known_hosts and ssh
...
# Copy /home/xyz/.ssh/known_hosts to /home/user/.ssh/known_hosts
...
unexpected end of parent stream
```

という同じ流れになっています。さらに、その Issue では known_hosts にダミーの1行を入れることで再現しなくなったと報告されています。

#### 解決策

```console
$ mkdir -p ~/.ssh
$ printf '# Dev Containers\n' > ~/.ssh/known_hosts
$ chmod 700 ~/.ssh
$ chmod 600 ~/.ssh/known_hosts
```
