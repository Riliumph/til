# win11

## CSM - Compatibility Supported Module -

> セキュアブートと排他設定である

URFIに従来のBIOSをエミュレートさせて互換性を高める仕組み。  
HWの互換性もそうだが、MBRを認識させるのもこの項目。

この項目をOFFにすると、MBRの起動パーティションが見えなくなる。  

## セキュアブート

> CSMと排他設定である

セキュアブートはEFIパーティションを見て起動させるため、GPTフォーマットである必要がある。

## 回復パーティション

> - 参考
>   - [UEFI/GPT ベースのハード ドライブ パーティション](https://learn.microsoft.com/ja-jp/windows-hardware/manufacture/desktop/configure-uefigpt-based-hard-drive-partitions?view=windows-11)

回復パーティションはTypeIDが固定であることに注意

TypeID: `DE94BBA4-06D1-4D40-A16A-BFD50179D6AC`
