# Capsとctrlを入れ替える方法

CapsLockキーはキーボード接続端末のドライバーでキーアップ信号を消す。  
そのため、リモート先の端末でCapsLockをCtrlに書き換え、CapsLockキーを押下すると、キーアップ信号がないためずっとCtrlが押された状態となってしまう。  

その場合、本物のCtrlキーを押下することでキーアップ信号が生成されるため押しっぱなし状態を解除することができる。  
Zキーの下にCtrlがあるのがメンドウでAキーの横にCapsLockに再マップしたのに、CapsLockを押すたびにCtrlを押さないといけないのでは問題は解決していない。

## レジストリを編集する方法

`regedit`を使い、レジストリを変更する。  
この方法は、そのWindowsのすべてのユーザーに影響を与えてしまう。  
個人端末なら問題ないが、共有端末では注意すること。

> サーバーの問題は後述

`HKEY_LOCAL_MACHINE/SYSTEM/CurrentControlSet/Control/Keyboard Layout`

```reg
値の名前：Scancode Map
値のデータ：
00 00 00 00 00 00 00 00
02 00 00 00 1D 00 3A 00
00 00 00 00
```

これを設定した後は再起動が必要。  
サインアウトでは反映されなかった。

また、当然のことだが、このレジストリはキーボードからキーを受け取る際のデータを変更しているだけである。  
つまり、キーボードからの命令を直接受け取らないサーバーのレジストリを変えても無意味である。

ホスト側がcaps lockで受け取り、サーバー側にcaps lockを送るためだそうだ。  
正直、ホストが何で受け取ろうが、その値をctrlに誤認してくれればいいのだが。。。

## Powertoysを使う方法

PowerToysをインストールする

> - Microsoft Store
> - [Github](https://github.com/microsoft/PowerToys)

Keyboasrd Managerの機能からキーの再マップを行う。

|物理キー|マップ先|
|:--:|:--:|
|VK240|Ctrl(right)|
|Ctrl(right)|VK240|

> `Caps Lock`ではなく、`VK240`として認識しているようだ。

ポイントは、必ず**入れ替える**こと。  
日本語のIMEの問題で、`VK240`と`Ctrl`としてみた場合にCaps Lockキーが動作しない、もしくは押下状態が継続するというバグが発生する。  

- [Keyboard Manager bug #19787](https://github.com/microsoft/PowerToys/issues/19787)
- [[KBM] Remapped key remains actively when changing to Japanese IME #3397](https://github.com/microsoft/PowerToys/issues/3397)

## ctrl2capを使う方法

kernel空間でcaps lockのキーコードをctrlに変換してくれるMS製ソフト。  
2006年製だが、2021年現在でも通用する模様。

> Published: November 1, 2006  
> [Ctrl2CAp v2.0](https://learn.microsoft.com/en-us/sysinternals/downloads/ctrl2cap)

再起動が必要。

## RemoteCaps2Ctrlなるもの

一番上にCapsLockのキーアップ信号の特殊性を解説した。  
Remote先のキーマップのみを再配置すると発生するCtrlが押され続ける問題を解消するソフト。  
0.5sec以上、別キーが押されなかった場合にctrlキーアップ信号を発生させる。

つまり、ctrl+zは0.5sec以内に押せということだ。

<https://www.vector.co.jp/soft/winnt/util/se493270.html>
