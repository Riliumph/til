# HEAD

以下のコミット履歴があるとする。

- 2020-08-03: 3rd commit
- 2020-08-02: 2nd commit
- 2020-08-01: 1st commit

## show

`git show`で`HEAD`を使うとどうなるか？

command|ポインタ
:--:|:--
`HEAD`|3rd commit
`HEAD~1`|2nd commit
`HEAD~2`|1st commit

## rebase

`git rebase -i`で`HEAD`を使うとどうなるか  
今のコミットから`HEAD~n`までを対象とするコマンドである

command|ポインタ
:--:|:--
`HEAD`|noop（対象無し）
`HEAD~1`|pick commit id 3rd commit
`HEAD~2`|pick commit id 2nd commit
`HEAD~3`|pick commit id 1st commit
