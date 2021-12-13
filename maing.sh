#! /bin/bash
MainPath="$(pwd)"
MainClangPath="${MainPath}/Clang"
MainClangZipPath="${MainPath}/Clang-zip"
MainGCCaPath="${MainPath}/GCC64"
MainGCCbPath="${MainPath}/GCC32"
MainZipGCCaPath="${MainPath}/GCC64-zip"
MainZipGCCbPath="${MainPath}/GCC32-zip"
KernelPath="${MainPath}/Kernel"
AnyKernelPath="${MainPath}/Anykernel"
CustomUploader="N"
UploaderPath="${MainPath}/Uploader"
FolderUp=""
ExFolder=""
UseSpectrum="N"
SpectrumPath="${MainPath}/Spectrum"
spectrumFile="None"
KernelDownloader='N'
KDpath="${MainPath}/Kernel-Downloader"
KDType=""

export DEBIAN_FRONTEND=noninteractive
export KBUILD_BUILD_USER="ZyCromerZ"
TotalCores="$(nproc --all)"
DoSudo=""
if [ ! -z "${CIRCLE_BRANCH}" ];then
    export KBUILD_BUILD_HOST="Circleci-server"
    # branch="${CIRCLE_BRANCH}"
elif [ ! -z "${DRONE_BRANCH}" ];then
    export KBUILD_BUILD_HOST="Droneci-server"
    # branch="${DRONE_BRANCH}"
elif [ ! -z "${GITHUB_REF}" ];then
    export KBUILD_BUILD_HOST="Github-server"
    # branch="${GITHUB_REF/"refs/heads/"/""}"
    TotalCores="4"
    DoSudo="sudo"
fi
branch="$1"
# just fix for dtc clang
check=$(ls /usr/lib/x86_64-linux-gnu | grep libisl.so -m1)
if [ ! -z "$check" ]; then if [ "$check" != "libisl.so.15" ]; then $DoSudo cp -af /usr/lib/x86_64-linux-gnu/$check /usr/lib/x86_64-linux-gnu/libisl.so.15; fi; fi
check=$(ls /usr/lib/x86_64-linux-gnu | grep libz3.so -m1)
if [ ! -z "$check" ]; then if [ "$check" != "libz3.so.4.8" ]; then $DoSudo cp -af /usr/lib/x86_64-linux-gnu/$check /usr/lib/x86_64-linux-gnu/libz3.so.4.8; fi; fi
check=""

IncludeFiles(){
    chmod +x "$1"
    if [ ! -z "$4" ];then
        . "$1" "$2" "$3" "$4"
    elif [ ! -z "$3" ];then
        . "$1" "$2" "$3"
    elif [ ! -z "$2" ];then
        . "$1" "$2"
    else
        . "$1"
    fi
}
apt-get -y install cpio libtinfo5 curl zip unzip

git config --global user.name "ZyCromerZ"
git config --global user.email "neetroid97@gmail.com"

if [[ -z "${GIT_SECRETB}" ]] || [[ -z "${GIT_SECRET}" ]] || [[ -z "${BOT_TOKEN}" ]] || [[ -z "${GIT_USERNAME}" ]];then
    echo "some needed files missing, just skip compile kernels"
else
    IncludeFiles "$MainPath/for/${branch}.sh"
    # cleanup stuff after done
    cd "${MainPath}"
    git push -d origin $branch 2>/dev/null
    rm -rf *
fi