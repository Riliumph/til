# CPUを減らす方法

## CPUを確認する

```console
$ nproc
16
```

色んなコマンドで確認できるが、この環境は論理コアが16個確認できた。

### 詳細な情報

CPUの詳細情報は`/sys/devices/system/cpu/`の中で管理されている。  
CPUの1番の情報を見てみる。

```console
$ ls /sys/devices/system/cpu/cpu1/
cache/  driver@  firmware_node@  hotplug/  subsystem@  topology/  online  uevent
```

色んな情報を持っていることが確認できる。

### onlineファイル

LinuxがCPUが有効であることを管理しているファイルである。

```console
$ cat /sys/devices/system/cpu/cpu1/online
1
```

## CPUをオフラインにしてみる

`online`ファイルの中身を0にしてみる

> WSL上では、管理がWindowsだからかできなかった。
>
> ```console
> root: /sys/devices/system/cpu/cpu1# echo 0 > online
> bash: echo: write error: Device or resource busy
> ```
>
