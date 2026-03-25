# OpenSSLコマンド

```console
$ openssl s_client -connect github.com:443 -servername github.com </dev/null
```

Q. これは何をしているコマンドか？  
A. `github.com`に対してTLS(HTTPS)接続を行い、サーバー証明書や暗号方式などの詳細を確認するコマンド

接続を切るために`/dev/null`をリダイレクトしている。

## 結果（正常のとき）

```console
$ openssl s_client -connect github.com:443 -servername github.com </dev/null
CONNECTED(00000003)
depth=2 DC = local, DC = YOUR-DOMAIN, CN = YOUR-CA
verify return:1
depth=1 C = JP, ST = Tokyo, O = "YOUR-ORGANIZATION-NAME", CN = YOUR-ICA
verify return:1
depth=0 CN = github.com
verify return:1
---
Certificate chain
 0 s:CN = github.com
   i:C = JP, ST = Tokyo, O = "YOUR-ORGANIZATION-NAME", CN = YOUR-ICA
   a:PKEY: id-ecPublicKey, 256 (bit); sigalg: RSA-SHA256
   v:NotBefore: Mar  6 00:00:00 2026 GMT; NotAfter: Jun  3 23:59:59 2026 GMT
 1 s:C = JP, ST = Tokyo, O = "YOUR-ORGANIZATION-NAME", CN = YOUR-ICA
   i:DC = local, DC = YOUR-DOMAIN, CN = YOUR-CA
   a:PKEY: rsaEncryption, 2048 (bit); sigalg: RSA-SHA256
   v:NotBefore: Mar 24 08:49:56 2025 GMT; NotAfter: Apr 12 05:46:37 2029 GMT
---
Server certificate
-----BEGIN CERTIFICATE-----
（省略）
-----END CERTIFICATE-----
subject=CN = github.com
issuer=C = JP, ST = Tokyo, O = "YOUR-ORGANIZATION-NAME", CN = YOUR-ICA
---
No client certificate CA names sent
Peer signing digest: SHA256
Peer signature type: ECDSA
Server Temp Key: X25519, 253 bits
---
SSL handshake has read 2812 bytes and written 376 bytes
Verification: OK
---
New, TLSv1.3, Cipher is TLS_AES_128_GCM_SHA256
Server public key is 256 bit
Secure Renegotiation IS NOT supported
Compression: NONE
Expansion: NONE
No ALPN negotiated
Early data was not sent
Verify return code: 0 (ok)
---
DONE
```

### 正常系を詳しく見る

```console
CONNECTED(00000003)
depth=2 DC = local, DC = XXX, CN = YOUR-CA
verify return:1
depth=1 C = JP, ST = Tokyo, O = "YOUR-ORGANIZATION-NAME", CN = YOUR-ICA
verify return:1
depth=0 CN = github.com
verify return:1
```

- `DC` = `Domain Name`  
  DCがlocal, XXXであることから`XXX.local`というActive Directoryドメインであることが分かる。  
  そして、これが出てくるということはRoot CAがADに参加していることが分かる。  
  公共のWeb証明書ではDCはほとんど出てこない。
- `CN` = `Common Name`  
  CAの名前が書かれることがある。チェインしているならICAの場合もある。

まず、ここまでで以下の通信経路であることが割り出せる。

1. `github.com`への通信は直接行われていない。
2. 組織内のHTTPSインスペクションが働いている
3. 社内CAが
   - `github.com`用の証明書を即席で発効
   - 中身を復号・検査
   - 最暗号化してクライアントへ返却

```console
Certificate chain
 0 s:CN = github.com
   i:C = JP, ST = Tokyo, O = "YOUR-ORGANIZATION-NAME", CN = YOUR-ICA
   a:PKEY: id-ecPublicKey, 256 (bit); sigalg: RSA-SHA256
   v:NotBefore: Mar  6 00:00:00 2026 GMT; NotAfter: Jun  3 23:59:59 2026 GMT
 1 s:C = JP, ST = Tokyo, O = "YOUR-ORGANIZATION-NAME", CN = YOUR-ICA
   i:DC = local, DC = YOUR-DOMAIN, CN = YOUR-CA
   a:PKEY: rsaEncryption, 2048 (bit); sigalg: RSA-SHA256
   v:NotBefore: Mar 24 08:49:56 2025 GMT; NotAfter: Apr 12 05:46:37 2029 GMT
```

`0`が実際にサーバーとして名乗った証明書を示す。（エンドエンティティ証明書）  
`1`が0番の証明書を発行した中間CAを示す。（Intermediate CA）  

ブラウザやopensslは、このチェーンをたどり、「最終的に信頼できるRootCAに行き着くか？」を検証する。

- `0`について
  - `s`は`github.com`。この証明書は`github.com`を名乗っている。
  - `i`は発行者のCN。名前は自由だが今回は親切にも「ICA」と書かれていて中間CAであることが伺える。
- `1`について
  - `s`は中間CA。実際に`github.com`用証明書を発行したCA。日常的に大量の証明書を発行している。
  - `i`は`YOUR-DOMAIN.local`というActive Direcotryドメイン。CNもCAなのでRoot CAであることが伺える。

Root CAは4年間もの証明書を持ち、漏洩すると大変である。  
そこで90日の短命な証明書を作る中間CAを導入している。

> DiciCertなどと同じ設計思想である。

## 結果（エラーのとき）

```console
$ openssl s_client -connect github.com:443 -servername github.com </dev/null
CONNECTED(00000003)
depth=1 C = JP, ST = Tokyo, O = "YOUR ORGANIZATION NAME", CN = <YOUR COMMON NAME>
verify error:num=20:unable to get local issuer certificate
verify return:1
depth=0 CN = github.com
verify return:1
---
Certificate chain
 0 s:CN = github.com
   i:C = JP, ST = Tokyo, O = "YOUR ORGANIZATION NAME", CN = <YOUR COMMON NAME>
   a:PKEY: id-ecPublicKey, 256 (bit); sigalg: RSA-SHA256
   v:NotBefore: Mar  6 00:00:00 2026 GMT; NotAfter: Jun  3 23:59:59 2026 GMT
 1 s:C = JP, ST = Tokyo, O = "YOUR ORGANIZATION NAME", CN = <YOUR COMMON NAME>
   i:DC = local, DC = YOUR-DOMAIN, CN = <YOUR COMMON NAME>
   a:PKEY: rsaEncryption, 2048 (bit); sigalg: RSA-SHA256
   v:NotBefore: Mar 24 08:49:56 2025 GMT; NotAfter: Apr 12 05:46:37 2029 GMT
---
Server certificate
-----BEGIN CERTIFICATE-----
（省略）
-----END CERTIFICATE-----
subject=CN = github.com
issuer=C = JP, ST = Tokyo, O = "YOUR ORGANIZATION NAME", CN = <YOUR COMMON NAME>
---
No client certificate CA names sent
Peer signing digest: SHA256
Peer signature type: ECDSA
Server Temp Key: X25519, 253 bits
---
SSL handshake has read 2813 bytes and written 376 bytes
Verification error: unable to get local issuer certificate
---
New, TLSv1.3, Cipher is TLS_AES_128_GCM_SHA256
Server public key is 256 bit
Secure Renegotiation IS NOT supported
Compression: NONE
Expansion: NONE
No ALPN negotiated
Early data was not sent
Verify return code: 20 (unable to get local issuer certificate)
---
DONE
```

### 詳細に見ていく

見方は正常系で見たので、エラー部分を詳細に見ていきたい。

```console
CONNECTED(00000003)
depth=1 C = JP, ST = Tokyo, O = "YOUR ORGANIZATION NAME", CN = <YOUR COMMON NAME>
verify error:num=20:unable to get local issuer certificate
... ... ...
... ...
...
```

エラーが出ている。  
`verify error:num=20:unable to get local issuer certificate`  
「その証明書を検証するための発行元CA証明書が、ローカルに存在しない」

会社や学校等といった施設で行われているSSLインスペクション用の証明書を`trust store`に入れていないことが分かる。
