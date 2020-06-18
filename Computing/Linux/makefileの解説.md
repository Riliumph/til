# makefile 解説

Linux kernel の makefile は C/C++と若干違うみたい。

## サンプル実装

```makefile
obj-m := sample.o
sample-objs := test_driver.o
PWD := $(shell pwd)

KERNEL_DIR = /lib/modules/$(shell uname -r)/build
MODULE_DIR = $(shell pwd)

all:
	make -C $(KERNEL_DIR) M=$(PWD) modules
install:
	insmod driverModule.ko
uninstall:
	rmmod driverModule.ko
clean:
	rm -f *.o *.ko *.mod.c Module.* module* *~
```

### obj-m

生成するモジュールオブジェクト名。  
以下、\<Module 名>と書くこととする。

### \<Module 名>-y

カーネル組み込み形式のコードを記憶する変数。  
カーネルイメージに組み込まれる。

### \<Module 名>-objs

\<Module 名>-objs にモジュールを構成するオブジェクト一覧を列挙する。

### PWD

## make のオプション

all を実行する際の make コマンドのオプションを解説する。

### C

Kernel のソースツリーを指定する。  
ただし、このツリーはランタイム環境の Kernel バージョンと同じでなければならない。  
コンパイル時に使用したソースツリーの Kernel バージョンや一部の Config（SMP, Preempt など）の vermagic に埋め込まれて Loading 時にチェックされる。  
Kernel は vermagic が不一致だと Loading を受け付けないので注意が必要。

あと、カレントディレクトリが Kernel のソースツリーの場合、このオプションは不要である。

### M

なかなか情報が出てこなくて戸惑った……  
これは、make コマンドに渡す名前付き変数的なモノで、ローダブルモジュールのディレクトリを指定するようだ。  
基本的にソースコードの直下で make するわけだから、pwd コマンドを書いている。

※
M='pwd'だと pwd のコマンド結果になる  
今回は、PWD 変数に\$(shell pwd)を使って pwd コマンドの結果を格納している。

### SUBDIR

モジュールのソースがあるディレクトリを指定する。

### KBUILD_VERVOSE

コンパイル時のメッセージ出力を制御する。  
0 で OFF  
1 で ON

### modules

make の最後には modules の文字を使うこと。  
コンパイルターゲットを modules にすることができる。
