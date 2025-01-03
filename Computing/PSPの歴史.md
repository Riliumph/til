# PSPの歴史

2000年代にハッキングされていたPSPが何をしていたのか

## PSPのセキュリティとは？

PS3やPSPで動作する公式プログラムには電子署名が入っている。  
この電子署名をチェックする処理が公式FW（以下、OFW）に入っており、起動時に自作プログラムを弾くようになっている。

この電子署名には公開鍵暗号が採用されていたため、当時の計算量では解析はほぼ不可能であった。  
つまり、SONY署名を偽装することはできない。  
そこで、ハッカーはチェックアルゴリズムをスキップすることに焦点を当てて攻撃をした。

## Custom Firmware / HEN

OFWには署名チェック処理が入っているため、このままでは使えない。  
そこで、ハッカーは自作のカスタムFW（以下、CFW）を導入して自作プログラムを動かすようになる。

## どうやってやるか？

PSPには以下の二つの動作モードを持つ。

- カーネルモード
- ユーザーモード

ユーザーモードは動いているプログラムが読み取れるメモリが制限されている。（仮想メモリみたいなもの）  
そのため、ハッカーは全メモリを読み取れるカーネルモードへ何とかして入るようにkernel exploit攻撃を試みる。

最初のPSPでは、tiff形式の画像を読み取る処理にバグが存在し、そのバグを使って任意コード実行を行ってカーネルモードへ移行した。

### Kernel Exploit攻撃は何をしているか？

PSPにはカーネルとユーザーの両モードを監視して保護しているDDRプロテクションがある。  
このDDR保護によりメモリーアクセスの制限が行われる。

DDR保護の設定は、DDR保護用のハードウェアレジスタの中身によって決定されている。  
このレジスタのカーネルメモリーへのアクセスを許可する制御ビットを有効にする。

このDDRプロテクションを突破することで、ユーザープログラムはカーネル特権を取得でき、カーネルモード同様にあらゆるメモリへとアクセスできるようになる。

```C
// kernel2.8用の攻撃コード
#include 
#include 
#include 
/* Define the module info section */
PSP_MODULE_INFO("CONTROLTEST", 0, 1, 1);
/* Define the main thread's attribute value (optional) */
PSP_MAIN_THREAD_ATTR(THREAD_ATTR_USER | THREAD_ATTR_VFPU);
/* Define printf, just to make typing easier */
#define printf pspDebugScreenPrintf
int done = 0;
int main(void)
{
pspDebugScreenInit();
printf("starting the exploit..\n");
sceRegOpenRegistry(0, 0, (void *) 0xbc000000); // この関数にバグあり
sceRegOpenRegistry(0, 0, (void *) 0xbc000004); // 最後の引数は整数へのポインタを期待している。
sceRegOpenRegistry(0, 0, (void *) 0xbc000008); // しかし、保護レジスタなどの明らかに誤った値でも
sceRegOpenRegistry(0, 0, (void *) 0xbc00000c); // ハンドラは有効なポインタおして値を書き込んでしまう。
sceRegOpenRegistry(0, 0, (void *) 0xbc000010); // よって、ハッカーは好みのアドレスに0xffffffを書き込めてしまう
sceRegOpenRegistry(0, 0, (void *) 0xbc000014); // そのため、0xBC000000（DDRレジスタアドレス）以降をすべて0xffffffで埋める
sceRegOpenRegistry(0, 0, (void *) 0xbc000018); // この脆弱性からPSPの一挙手一投足まで解析されて行ってしまった。
sceRegOpenRegistry(0, 0, (void *) 0xbc00001c);
int fd = sceIoOpen("ms0:/kmem.bin",PSP_O_CREAT|PSP_O_WRONLY,0777);
sceIoWrite(fd,(void*)0x08000000,4*1024*1024);
sceIoClose(fd);
printf("done see ms0:/kmem.bin!!\n");
sceKernelSleepThreadCB();
return 0;
}
```

## 参考

- [PS3/PSPへのハッキングはなぜ可能だったか](http://blog.livedoor.jp/hiroumauma/archives/1381888.html)
