# Mac の環境構築について

## brew

インストールについては[本家](https://brew.sh/index_ja)参照。

brew の仕組みは、パスを以下の二つの役割に分けることで実現されている。

- インストールパス  
  `/usr/local/Cellar`  
  すべてのソフトウェアの実体がここの下で管理される。
- 参照パス  
  `/usr/local/bin`  
  `/usr/local/sbin`  
  インストールパスを`$PATH`環境変数に追加せず、必ず上記のパスにシンボリックリンクを用意することで間接的にインストールパスを参照する。

### Macvim のインストールについて

macvim をインストールしても、コマンドラインから実行することができない。  
参照パスが通っていない場合、次のコマンドでシンボリックリンクを作成することができる。

```bash
brew link macvim
```

macvim 以外にもシンボリックリンクをいくらか作成するようなので、手作業でやらないように。

## Terminal

### Home/End Key

iMacにおけるHome/Endキーは`Command + ←/→`である。  
MacbookにおけるHome/Endキーは`Fn + ←/→`である。  

Terminal.appにおいて、このキーはカーソルの移動ではなくscroll bufferに割り当てられている。

Actionをsend string to shellに変更し、stringを以下に変更する。

|    キー   |   キーコード  |
| :-----: | :------: |
| ↖(Home) | \\033\[F |
|  ↘(End) | \\033\[H |

> `\`の入力とかがウザすぎるのでコピペ推奨

## powerline Fontの導入

フォントコマンドの導入

```bash
brew install fontconfig
```

フォントマネージャーの導入

> brew-cask-fontsを導入

```bash
brew tap homebrew/cask-fonts
brew search powerline
```

フォントキャッシュの再構築

```bash
fc-cache -vf
```
