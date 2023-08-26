# all関数は空でもtrueを返すべき？

とあるリストを受け取ってすべて偶数であることを確認する関数があるとする。  
この関数は、受け取ったリストが空だった場合、Trueを返すべきかFalseを返すべきか？

## 答え：Trueを返すべき

これは明確な答えが存在する。

データ１(2,4,6,8)とデータ２(空)が存在するとする。  
このデータに対して２つの評価方法で結果を比較してみる。

### 一つ目の演算方式

それぞれのデータを演算してその結果を`&&`で評価する方法である。

データ１単体でどうなのか？データ２単体でどうなのか？  
その結果、データ１とデータ２の積を取る方法である。

### 二つ目の演算方式

それぞれのデータを連結して、そのデータを演算した結果を評価する方法である。

データ１とデータ２をあらかじめ連結したデータ３を作り、それを評価する方法である。

## サンプル実装(Python)

```python
def is_odd(d):
    return True if d % 2 == 0 else False

def is_odd_all_1(data:list):
    if data is None or not data:
        print(f"list is empty")
        return True
    for d in data:
        if not is_odd(d):
            return False
    return True

def is_odd_all_2(data: list):
    if data is None or not data:
        print(f"list is empty")
        return False
    for d in data:
        if not is_odd(d):
            return False
    return True

d1 = [2,4,6,8]
d2 = []
print("correct")
print(f"d1 and d2: {is_odd_all_1(d1) and is_odd_all_1(d2)}")
print(f"d1  +  d2: {is_odd_all_1(d1+d2)}")

print("fail")
print(f"d1 and d2: {is_odd_all_2(d1) and is_odd_all_2(d2)}")
print(f"d1  +  d2: {is_odd_all_2(d1+d2)}")
```

## 実行結果

```console
correct
list is empty
d1 and d2: True
d1  +  d2: True
fail
list is empty
d1 and d2: False
d1  +  d2: True
```

なんと、空配列をFalseで返し実装だと、評価方法によって答えが変わってしまうではないか。  
これは間違いなくダメな実装である。  
空配列はTrueを返すようにしよう
