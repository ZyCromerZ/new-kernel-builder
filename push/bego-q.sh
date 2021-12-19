#! /bin/bash
git checkout master

if [ ! -z "$2" ];then
    ListBranch="$2"
else
    ListBranch="begonia-q-oss-uv begonia-q-oss-uv-b begonia-q-oss-uv-c begonia-q-oss-uv-d begonia-q-oss-std begonia-q-oss-std-b begonia-q-oss-std-c begonia-q-oss-std-d begonia-q-oss-stock begonia-q-oss-stock-b begonia-q-oss-stock-c"
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
else
    repo="zyc"
fi
git push -f "$repo" $ListBranch

git checkout master

git branch -D $ListBranch