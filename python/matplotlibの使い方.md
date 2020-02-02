# matplotlibの使い方

## matplotlibでアニメーションを保存したい

matplotlibでアニメーショｎを保存する場合、次のモジュールを使用する。

- matplotlib.animation

### gif画像編

どの環境でも`imagemagick`コマンドをインストールする。

```bash
$ brew install imagemagick
```

Pythonでアニメーション関数を設定して保存する。

```python
from matplotlib import animation
anim = animation.FuncAnimation(fig, draw_graph, init_func=init_graph, interval=100, frames=len(results))
anim.save('anim.gif', writer='imagemagick')
```

#### エラーが出る場合

そのままでは次のエラーが発生する場合がある。

```python
MovieWriter imagemagick unavailable; trying to use <class 'matplotlib.animation.HTMLWriter'> instead.
---------------------------------------------------------------------------
（略）
ValueError: outfile must be *.htm or *.html
```

これはmatplotlibに対してimagemagickのパスが通っていないことでコマンドが実行できないことが原因である。

まず、`imagemagick`のパスを確認する。
> imagemagick ver.7.0以上より、`convert`コマンドが`magick`コマンドに変更になっている。

```bash
$ type magick
magick は /usr/local/bin/magick です
```

matplotlibにパスを通す設定を行う。

使っている環境のmatplotlibの設定ファイルのパスは次のコマンドで知ることができる。

```python
import matplotlib
matplotlib.matplotlib_fname()
```

このファイルの中から次の設定を変更する。

```python
#animation.convert_path:   convert   ## Path to ImageMagick's convert binary.
```

```python
animation.convert_path:  /usr/local/bin/magick   ## Path to ImageMagick's convert binary.
```
