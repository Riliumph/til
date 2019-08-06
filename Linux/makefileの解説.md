# makefile解説

Linux kernelのmakefikeはC/C++と若干違うみたい。  

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
以下、<Module名>と書くこととする。  

### <Module名>-y
カーネル組み込み形式のコードを記憶する変数。  
カーネルイメージに組み込まれる。  

### <Module名>-objs
<Module名>-objsにモジュールを構成するオブジェクト一覧を列挙する。  

### PWD


# makeのオプション

allを実行する際のmakeコマンドのオプションを解説する。

## C
Kernelのソースツリーを指定する。  
ただし、このツリーはランタイム環境のKernelバージョンと同じでなければならない。  
コンパイル時に使用したソースツリーのKernelバージョンや一部のConfig（SMP, Preemptなど）のvermagicに埋め込まれてLoading時にチェックされる。  
Kernelはvermagicが不一致だとLoadingを受け付けないので注意が必要。  

あと、カレントディレクトリがKernelのソースツリーの場合、このオプションは不要である。  

## M
なかなか情報が出てこなくて戸惑った……  
これは、makeコマンドに渡す名前付き変数的なモノで、ローダブルモジュールのディレクトリを指定するようだ。  
基本的にソースコードの直下でmakeするわけだから、pwdコマンドを書いている。  
  
※
M='pwd'だとpwdのコマンド結果になる  
今回は、PWD変数に$(shell pwd)を使ってpwdコマンドの結果を格納している。  


## SUBDIR
モジュールのソースがあるディレクトリを指定する。

## KBUILD_VERVOSE
コンパイル時のメッセージ出力を制御する。  
0でOFF  
1でON  

## modules
makeの最後にはmodulesの文字を使うこと。  
コンパイルターゲットをmodulesにすることができる。  


