#! /bin/bash

GetRepo="${1}"
shift
GetBranch="${@}"
[[ -z "$SetBranch" ]] && SetBranch="vayu-builder"
WriteConf()
{
    echo "--- " >>.drone.yml
    echo "clone: " >>.drone.yml
    echo "  depth: 1" >>.drone.yml
    echo "kind: pipeline" >>.drone.yml
    echo "name: ZyCPipeline-$1" >>.drone.yml
    echo "concurrency:" >>.drone.yml
    echo "  limit: 6" >>.drone.yml
    echo "steps: " >>.drone.yml
    echo "  - " >>.drone.yml
    echo "    commands: " >>.drone.yml
    echo '      - "bash main.sh '$1'"' >>.drone.yml
    echo "    environment: " >>.drone.yml
    echo "      BOT_TOKEN:" >>.drone.yml
    echo "        from_secret: BOT_TOKEN" >>.drone.yml
    echo "      GIT_SECRET:" >>.drone.yml
    echo "        from_secret: GIT_SECRET" >>.drone.yml
    echo "      GIT_SECRETB:" >>.drone.yml
    echo "        from_secret: GIT_SECRETB" >>.drone.yml
    echo "      GIT_USERNAME:" >>.drone.yml
    echo "        from_secret: GIT_USERNAME" >>.drone.yml
    echo "      ZIP_PASS:" >>.drone.yml
    echo "        from_secret: ZIP_PASS" >>.drone.yml
    echo "    image: zycromerz/kerneldocker:v3" >>.drone.yml
    echo "    name: ZyC-Build-$1" >>.drone.yml
    echo "    trigger: " >>.drone.yml
    echo "      branch: " >>.drone.yml
    echo "        - unified-tes" >>.drone.yml
    echo "" >>.drone.yml
}
git checkout -b $SetBranch

if [[ -z "$GetBranch" ]];then
    GetBranch="vayu-r-oss-c-a vayu-r-oss-c-b vayu-r-oss-c-c vayu-r-oss-d-a vayu-r-oss-d-b vayu-r-oss-d-c"
fi
for ngentot in $GetBranch;do
    WriteConf "$ngentot"
done
git add .drone.yml && git commit -s -m 'Go build'

[[ -z "$GetRepo" ]] && GetRepo="zero"

pushNow()
{
    git push -f $GetRepo $SetBranch || pushNow
}
pushNow

git checkout master
git branch -D $SetBranch