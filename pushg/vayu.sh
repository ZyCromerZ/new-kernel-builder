#! /bin/bash

GetRepo="${1}"
shift
GetBranch="${@}"
[[ -z "$SetBranch" ]] && SetBranch="vayu-builder"
WriteConf()
{
    echo "  build-$1:" >>.github/workflows/kernel-compiler.yml
    echo "" >>.github/workflows/kernel-compiler.yml
    echo "    runs-on: ubuntu-latest" >>.github/workflows/kernel-compiler.yml
    # echo "" >>.github/workflows/kernel-compiler.yml
    # echo "    container:" >>.github/workflows/kernel-compiler.yml
    # echo "      image: zycromerz/kerneldocker:v3" >>.github/workflows/kernel-compiler.yml
    echo "" >>.github/workflows/kernel-compiler.yml
    echo "    steps:" >>.github/workflows/kernel-compiler.yml
    echo "      - name: Checkout" >>.github/workflows/kernel-compiler.yml
    echo "        uses: actions/checkout@v2" >>.github/workflows/kernel-compiler.yml
    echo "" >>.github/workflows/kernel-compiler.yml
    echo "      - name: initialize" >>.github/workflows/kernel-compiler.yml
    echo "        run: |" >>.github/workflows/kernel-compiler.yml
    echo "          chmod +x misc/initialize.sh" >>.github/workflows/kernel-compiler.yml
    echo "          sudo bash misc/initialize.sh" >>.github/workflows/kernel-compiler.yml
    echo "" >>.github/workflows/kernel-compiler.yml
    echo "      - name: Set Swap Space" >>.github/workflows/kernel-compiler.yml
    # echo "        uses: pierotofy/set-swap-space@master" >>.github/workflows/kernel-compiler.yml
    # echo "        with:" >>.github/workflows/kernel-compiler.yml
    # echo "            swap-size-gb: 12" >>.github/workflows/kernel-compiler.yml
    echo "        run: |" >>.github/workflows/kernel-compiler.yml
    echo "          chmod +x misc/setswap.sh" >>.github/workflows/kernel-compiler.yml
    echo "          sudo bash misc/setswap.sh 14" >>.github/workflows/kernel-compiler.yml
    echo "" >>.github/workflows/kernel-compiler.yml
    echo "      - name: Compile Kernel" >>.github/workflows/kernel-compiler.yml
    echo "        run: |" >>.github/workflows/kernel-compiler.yml
    echo "          chmod +x maing.sh" >>.github/workflows/kernel-compiler.yml
    echo "          bash maing.sh '$1'" >>.github/workflows/kernel-compiler.yml
    echo "" >>.github/workflows/kernel-compiler.yml
}
git checkout -b $SetBranch

cp -af pushg/sample.yml .github/workflows/kernel-compiler.yml
if [[ -z "$GetBranch" ]];then
    GetBranch="vayu-r-oss-c-d"
fi
for ngentot in $GetBranch;do
    WriteConf "$ngentot"
done
git add .github/workflows/kernel-compiler.yml && git commit -s -m 'Go build'

[[ -z "$GetRepo" ]] && GetRepo="doa"

git push -f $GetRepo $SetBranch

git checkout master
git branch -D $SetBranch