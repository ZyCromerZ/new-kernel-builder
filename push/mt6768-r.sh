#! /bin/bash
git checkout master

if [ ! -z "$2" ];then
    ListBranch="$2"
else
    ListBranch="lancelot-r-oss-test merlin-r-oss-test lancelot-r-oss-test-uv merlin-r-oss-test-uv"
fi

for Branch in $ListBranch
do
    git checkout master 
    git branch -D $Branch 
    git checkout -b $Branch 
    git commit --amend -s -m "up for '$Branch'"
done

if [ ! -z "$1" ];then
    repo="$1"
git push -f "$repo" $ListBranch
else
    git push -f "doa" lancelot-r-oss-test merlin-r-oss-test
    git push -f "dob" lancelot-r-oss-test-uv merlin-r-oss-test-uv
fi

git checkout master

git branch -D $ListBranch