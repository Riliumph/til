# Git vs SVN

SVNなんていう古代兵器を使っているプロジェクトがあったので比較を書いておく

git|svn
:--|:--
git clone \<repository url\>|svn co \<repository url\>
git checkout .|svn revert -R .
git checkout .|svn status | grep ^M | awk '{print $2}' | xargs svn revert
git checkout -b xxx|svn copy <http://url/trunk/src/> <http://url/branches/branch_name> -m "message"
