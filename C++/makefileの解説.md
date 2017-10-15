# makefile解説

全然makefile覚えられないので、解説を記録します。  
色んなところから引っ張ってきました。  


```makefile
COMPILER  = clang++
CFLAGS    = -g -MMD -MP -Wall -Wextra -Winit-self -Wno-missing-field-initializers -std=c++14
ifeq "$(shell getconf LONG_BIT)" "64"
  LDFLAGS =
else
  LDFLAGS =
endif
LIBS      = 
INCLUDE   = -I./include
TARGET    = ./bin/$(shell basename `readlink -f .`)
SRCDIR    = ./src
ifeq "$(strip $(SRCDIR))" ""
  SRCDIR  = .
endif
SOURCES   = $(wildcard $(SRCDIR)/*.cpp)
OBJDIR    = ./obj
ifeq "$(strip $(OBJDIR))" ""
  OBJDIR  = .
endif
OBJECTS   = $(addprefix $(OBJDIR)/, $(notdir $(SOURCES:.cpp=.o)))
DEPENDS   = $(OBJECTS:.o=.d)

$(TARGET): $(OBJECTS) $(LIBS)
	$(COMPILER) -o $@ $^ $(LDFLAGS)

$(OBJDIR)/%.o: $(SRCDIR)/%.cpp
	-mkdir -p $(OBJDIR)
	$(COMPILER) $(CFLAGS) $(INCLUDE) -o $@ -c $<

all: clean $(TARGET)

clean:
	-rm -f $(OBJECTS) $(DEPENDS) $(TARGET)

-include $(DEPENDS)
```

## 要素解説
の前に注意すること  
- インデントはタブ文字！！  
  半角スペースではダメ。なんなの？この謎仕様。  
- 「=」と「:=」は別物！！
  単純展開変数か再帰展開変数かどうかで書き方が違う。  


それから、Kernel用のmakefileは別に書くね  

### COMPILER - コンパイラ -
例えば、C言語の時は、gcc/clangでC++の時はg++/clang++  
C++なのにclangだとiostream系のC++クラスライブラリが見つかりませんエラーとなる。  
発生して原因が分かったとき、あなたはやる気をロストしていることでしょう  

### CFLAGS - コンパイルオプション -
- -g  
  デバッグ情報を埋め込んでビルドしてくれる
- -MMD -MP  
  ソースファイルの依存関係を中間ファイルとして出力するオプション  
  この依存関係ファイルはmakefile最後の-include文で読み込まれるため、依存しているヘッダファイルなどが変更された場合に自動的に再コンパイルされる。  
  このスクリプト考えたやつ天才か  

### LDFLAG - リンクオプション -
初期値：空  
動的ライブラリをリンクする「-l」オプションを用いる場合はここに記述することで使用できる。  
パスが通っていない場合は、「xx.so」のように書けば使用できる。  

### LIBS - ライブラリ -
初期値：空  
静的リンクするライブラリ指定する。  
静的ライブラリを用いる場合、空白区切りでファイル名を記述する。  
記述されたライブラリが更新された場合、makeコマンドは再コンパイルが必要だと認識する。

### INCLUDE - インクルードパス -
初期値：-I./include  
ソースファイル中の`#include`の検索パスを加えるオプション。  
-Iが必ず必要なので注意。  
複数のパスを指定する場合は、-Ixxx -Iyyyなどのように空白を空けて-Iオプションから記述する。  

### TARGET - 実行ファイル -
実行ファイル名を指定する。  
初期値：./bin/$(shell basename \`readlink -f .\`)  
解説  
ディレクトリ：./bin  
ファイル名：makefileが配置されているパスのディレクトリ名  

- shell
  さいきょーのshellコマンドを実行する。
- basename
  親ディレクトリ名を取得
- readlink -f .
  カレントパスを絶対パスにして取得
  readlink -fってMacにはなかった気がする……あっ  

### OBJDIR - 中間ファイルディレクトリ -
中間ファイルを配置するディレクトリ  
このフォルダにオブジェクトファイルだったり中間ファイルが生成される。  
この要素が空の場合、makefileと同じ階層に配置される。

### SOURCES - ソースコード -
コンパイル対象を指定する要素。  
初期値：$(wildcard $(SRCDIR)/*.cpp)  
SRCDIR内に存在する拡張子cppすべてをコンパイル対象とする。  
え？なに？C言語をコンパイルしたい？正気かよ……  
makefile内のcppをすべてcに変えるのと、コンパイラをgcc/clangに変えてください。  

### OBJECTS - オブジェクトファイル - 
初期値：$(addprefix $(OBJDIR)/, $(notdir $(SOURCES:.cpp=.o)))  
オブジェクトファイルの格納先は、OBJDIR  
オブジェクトファイルのルールはSOURCES内の.cpp拡張子を.oにする。  

### DEPENDS - 依存関係ファイル -
初期値：$(OBJECTS:.o=.d)  
オブジェクトファイルの拡張子を.dにしましょうねーっていう意味

## 特殊な書式について - 自動変数編 -

| 書式 | 意味 |
|:-:|---|
|$@ | ターゲットファイル名|
|$% | ターゲットがアーカイブメンバだったときのターゲットメンバ名|
|$< | 最初の依存するファイルの名前|
|$? | ターゲットより新しいすべての依存するファイル名|
|$^ | すべての依存するファイルの名前|
|$+ | Makefileと同じ順番の依存するファイルの名前|
|$* | サフィックスを除いたターゲットの名前|

## 特殊な書式について- 関数編 -
まぁ、[ここをみよ](https://www.ecoop.net/coop/translated/GNUMake3.77/make_8.jp.html)  
テキトーなのについて解説入れてみた  

| 書式 | 意味 |
|:-:|---|
|% | ワイルドカード|
|subst | 置換動作|
|patsubst | 置換動作，ワイルドカードあり|
|strip | 空白文字の削除|
|findstring | 文字列を探す|
|filter | 一致する単語の削除|
|filter-out | 一致しない単語の削除|
|sort | ソートする|
|dir | ディレクトリ部分の抽出|
|nodir | ファイル部分の抽出|
|suffix | サフィックス（拡張子）部分|
|basename | サフィックス以外|
|addsuffix | サフィックスを加える|
|addprefix | プレフィックスを加える|
|join | 単語の連結|
|word | n番目の単語を返す|
|worldlist | 単語のリストを返す|
|words | 単語数を返す|
|firstword | 最初の名前を返す|
|wildcard | ワイルドカードによりファイル名リストを返す|
|foreach | 引数を複数回展開する|
