#! /bin/bash
git checkout master

if [ ! -z "$2" ];then
    ListBranch="$2"
else
    ListBranch="begonia-r-oss-uv begonia-r-oss-uv-b begonia-r-oss-uv-c begonia-r-oss-uv-d begonia-r-oss-std begonia-r-oss-std-b begonia-r-oss-std-c begonia-r-oss-std-d begonia-r-oss-stock begonia-r-oss-stock-b begonia-r-oss-stock-c"
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
    repo="neet"
fi
git push -f "$repo" $ListBranch

git checkout master

git branch -D $ListBranch