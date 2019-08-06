# Systemd環境

ubuntu18.04辺りから完全にinitがSystemdに移行しました。  
/tmpをtmpfsにするには以下の方法を取る。

# /etc/fstabの修正
tmpfs   /tmp         tmpfs   nodev,nosuid,size=2G          0  0

一応、サイズを2Gにしているが、Thin Provisioningに似た方式を取っている。  
そのため、最大サイズの意味合いであり2G即座に使用する訳ではない。  
必要に応じてリソースが増減する。  


# 確認1

```bash
$ sudo systemctl status tmp.mount
● tmp.mount - /tmp
   Loaded: loaded (/etc/fstab; generated)
   Active: active (mounted) since Thu 2019-03-21 21:27:39 JST; 2min 35s ago
    Where: /tmp
     What: tmpfs
     Docs: man:fstab(5)
           man:systemd-fstab-generator(8)
  Process: 272 ExecMount=/bin/mount tmpfs /tmp -t tmpfs -o nodev,nosuid,size=2G (code=exited, status=0/SUCCESS)
    Tasks: 0 (limit: 4662)
   CGroup: /system.slice/tmp.mount

 3月 21 21:27:39 Riliumph systemd[1]: tmp.mount: Directory /tmp to mount over is not empty, mounting anyway.
 3月 21 21:27:39 Riliumph systemd[1]: Mounting /tmp...
 3月 21 21:27:39 Riliumph systemd[1]: Mounted /tmp.
```

# 確認2

```bash
$ df -T
Filesystem     Type     Inodes IUsed IFree IUse% Mounted on
tmpfs          tmpfs      494K    23  494K    1% /tmp
```
