#! /bin/bash

GetRepo="${1}"
shift
GetBranch="${@}"
[[ -z "$SetBranch" ]] && SetBranch="my-builder"

WriteConf()
{
    echo "            - file: '${1}'" >> .github/workflows/kernel-compiler.yml
}
git reset --hard
git checkout master
git checkout -b $SetBranch

cp -af pushg2/sample-a.yml .github/workflows/kernel-compiler.yml
if [[ -z "$GetBranch" ]];then
    GetBranch="blank"
fi
for ngentot in $GetBranch;do
    WriteConf "$ngentot"
done
echo "$(cat pushg2/sample-b.yml)" >> .github/workflows/kernel-compiler.yml
git add .github/workflows/kernel-compiler.yml && git commit -s -m 'Go build'

[[ -z "$GetRepo" ]] && GetRepo="doa"

pushNow()
{
    git push -f $GetRepo $SetBranch || pushNow
}
pushNow

git checkout master
git branch -D $SetBranch