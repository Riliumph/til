# Tips os OpenCV

## 型違いのndarrayはconcat出来ない

以下のようなコードを書いたとする

```python
import cv2
import numpy as np

if __name__ == "__main__":
    bgr = cv2.imread("hoge.jpg")
    gray = cv2.cvtColor(bgr, cv2.COLOR_BGR2GRAY)
    edge_x = cv2.Sobel(gray, cv2.CV_32F, 1, 0, ksize=3)
    edge_y = cv2.Sobel(gray, cv2.CV_32F, 0, 1, ksize=3)
    edge = np.sqrt(edge_x**2 + edge_y**2)
    img = cv2.hconcat([bgr, edge])
    cv2.imwrite("huga.jpg", img)
```

このコードでは`cv2.hconcat`は補足のエラーが発生して実行できない。

> ```bash
> cv2.error: OpenCV(4.x.x) /opencv-python/opencv/modules/core/src/matric_operation.cpp:68: (-215:Assertion failed) src[i].dims <= 2 && src[i].rows == src[0].rows && src[i].type() == src[0].type() in function 'cv::hconcat'
> ```

このエラーは以下の条件を満たさないといけない

- `src[i].dims <= 2`：各画像の次元数が二次元以下であること
- `src[i].rows == src[0].rows`：各画像の横線数（高さの意味）が同じであること
- `src[i].type() == src[0].type()`：各画像の型が同じであること

よく落とし穴として落ちるのは３つ目の条件かと思われる。  
たとえば、上記コードのように、オリジナル画像と微分フィルタをかけた画像を`hconcat`するときなどがそうだ。  
この二つでは保存している情報が違うことが原因だ。

|関数|代表的な型|具体的な型|保存している情報|
|:--:|:--:|:--:|:--|
|`imread()`|`UINT8`|`np.uint8`|pixelの画素情報（0～255）|
|`Sobel()`|`FLOAT32/64`|`np.float`|画像の濃淡を表現する色の勾配情報|

> 微分フィルタの保存する勾配情報
>
> - 白から黒（0 -> 255）は正の微分値で保存する
> - 黒から白（255 -> 0）は負の微分地で保存する

しかし、勾配情報といえどあくまで差分でしかない。白から黒の情報では表示するべきは黒だし、黒から白の情報では白である。  
つまり、+255は255だし、-255も255である。

よって、以下のコードを挟むことで解決できる

```python
import cv2
import numpy as np

if __name__ == "__main__":
    bgr = cv2.imread("hoge.jpg")
    gray = cv2.cvtColor(bgr, cv2.COLOR_BGR2GRAY)
    edge_x = cv2.Sobel(gray, cv2.CV_32F, 1, 0, ksize=3)
    edge_y = cv2.Sobel(gray, cv2.CV_32F, 0, 1, ksize=3)
    edge = np.sqrt(edge_x**2 + edge_y**2)   # あくまで色の勾配情報
    edge_u8 = np.uint8(np.abs(edge))        # 勾配情報を画素情報に変換
    img = cv2.hconcat([bgr, edge_u8])
    cv2.imwrite("huga.jpg", img)
```
