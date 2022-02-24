#! /bin/bash
git checkout master

if [ ! -z "$2" ];then
    ListBranch="$2"
else
    ListBranch="x01bd-main-q x01bd-main-q2 x01bd-main-q3 x01bd-main-q4 x01bd-main-r x01bd-main-r2 x01bd-main-r3 x01bd-main-r4 x01bd-main-p x01bd-main-p2 x01bd-main-p3 x01bd-main-p4"
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
    Normal="N"
else
    repo="zyc"
    Normal="Y"
fi
if [ "$Normal" == "Y" ];then
    git push -f doa x01bd-main-q x01bd-main-q2 x01bd-main-q3 x01bd-main-q4 x01bd-main-p x01bd-main-p2
    git push -f dob x01bd-main-r x01bd-main-r2 x01bd-main-r3 x01bd-main-r4 x01bd-main-p3 x01bd-main-p4
else
    git push -f "$repo" $ListBranch
fi

git checkout master

git branch -D $ListBranch