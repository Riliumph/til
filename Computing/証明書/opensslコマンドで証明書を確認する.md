# コマンド

```console
$ openssl x509 -in /usr/local/share/ca-certificates/xxx.crt -noout -text
```

このコマンドは`openssl`コマンドを使って証明書の中身を表示する。  
crtファイルはBASE64であることもあるので、それをデコードしている。

```console
$ openssl x509 -in /usr/local/share/ca-certificates/xxx.crt -noout -text
Certificate:
    Data:
        Version: 3 (0x2)
        Serial Number: 78982117840579778 (0x11899d1557eecc2)
        Signature Algorithm: sha256WithRSAEncryption
        Issuer: C = US, ST = California, L = Sunnyvale, O = Fortinet, OU = Certificate Authority, CN = XXX, emailAddress = <support@fortinet.com>
        Validity
            Not Before: Feb 10 03:20:21 2022 GMT
            Not After : Feb 11 03:20:21 2032 GMT
        Subject: C = US, ST = California, L = Sunnyvale, O = Fortinet, OU = Certificate Authority, CN = XXX, emailAddress = <support@fortinet.com>
        Subject Public Key Info:
            Public Key Algorithm: rsaEncryption
                Public-Key: (2048 bit)
                Modulus:
                    xx:yy:zz:（以下略）
                Exponent: 65537 (0x10001)
        X509v3 extensions:
            X509v3 Basic Constraints:
                CA:TRUE
    Signature Algorithm: sha256WithRSAEncryption
    Signature Value:
        xx:yy:zz:（以下略）
```

## 詳細に見ていく

```cosole
Issuer: C = US, ST = California, L = Sunnyvale, O = Fortinet, OU = Certificate Authority, CN = XXX, emailAddress = <support@fortinet.com>
Subject: C = US, ST = California, L = Sunnyvale, O = Fortinet, OU = Certificate Authority, CN = XXX, emailAddress = <support@fortinet.com>
```

`Issuer`と`Subject`が同じであることで「自己署名証明書」であることが伺える。  
これは公開CA（DigiCertなど）ではない。

FortiGate SSL Deep Inspectionの典型構成である。
