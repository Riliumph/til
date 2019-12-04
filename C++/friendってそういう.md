# friend宣言

friend宣言を使うタイミングを学んだ。  
なるほどー。そういう時に使うのか。

```C++
#include <iostream>

class storage
{
public:
  storage(const int d):data_(d){};
  storage(){};
  ~storage(){};
  int data() const {return data_;};
  void data(const int d) { data_ = d; };
  // クラス外実装故にprivateに触れないのでfriend化
  friend std::ostream& operator<<(std::ostream&,
                                  const storage&);
private:
  int data_;
};


std::ostream& operator<<(std::ostream& os,
                         const storage& d)
{
  os << d.data_;
  return os;
};


int main()
{
  storage data(20);
  std::cout << data << std::endl;
  return 0;
}
```

## 参考

https://ja.cppreference.com/w/cpp/language/friend