#! /bin/bash

GetRepo="${1}"
shift
GetBranch="${@}"
WriteConf()
{
    echo "  build-$1:" >>.github/workflows/kernel-compiler.yml
    echo "" >>.github/workflows/kernel-compiler.yml
    echo "    runs-on: ubuntu-latest" >>.github/workflows/kernel-compiler.yml
    echo "" >>.github/workflows/kernel-compiler.yml
    echo "    container:" >>.github/workflows/kernel-compiler.yml
    echo "      image: zycromerz/kerneldocker:v3" >>.github/workflows/kernel-compiler.yml
    echo "" >>.github/workflows/kernel-compiler.yml
    echo "    steps:" >>.github/workflows/kernel-compiler.yml
    echo "    - uses: actions/checkout@v2" >>.github/workflows/kernel-compiler.yml
    echo "    - name: Compile Kernel" >>.github/workflows/kernel-compiler.yml
    echo "      run: |" >>.github/workflows/kernel-compiler.yml
    echo "        chmod +x maing.sh" >>.github/workflows/kernel-compiler.yml
    echo "        bash maing.sh '$1'" >>.github/workflows/kernel-compiler.yml
    echo "" >>.github/workflows/kernel-compiler.yml
}
git checkout -b vayu-builder

cp -af pushg/sample.yml .github/workflows/kernel-compiler.yml
if [[ -z "$GetBranch" ]];then
    GetBranch="vayu-r-oss-test vayu-r-oss-test-2"
fi
for ngentot in $GetBranch;do
    WriteConf "$ngentot"
done
git add .github/workflows/kernel-compiler.yml && git commit -s -m 'Go build'

[[ -z "$GetRepo" ]] && GetRepo="doa"

git push -f $GetRepo vayu-builder

git checkout master
git branch -D vayu-builder