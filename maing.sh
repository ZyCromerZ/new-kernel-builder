#! /bin/bash
export DEBIAN_FRONTEND=noninteractive
export KBUILD_BUILD_USER="ZyCromerZ"
TotalCores="$(nproc --all)"
# TotalCores="$(($TotalCores*4))"
# TotalCores="$(($TotalCores+1))"
DoSudo=""
if [ ! -z "${CIRCLE_BRANCH}" ];then
    export KBUILD_BUILD_HOST="Circleci-server"
    # rbranch="${CIRCLE_BRANCH}"
elif [ ! -z "${DRONE_BRANCH}" ];then
    export KBUILD_BUILD_HOST="Droneci-server"
    # rbranch="${DRONE_BRANCH}"
elif [ ! -z "${GITHUB_REF}" ];then
    export KBUILD_BUILD_HOST="Github-server"
    # rbranch="${GITHUB_REF/"refs/heads/"/""}"
    # TotalCores="4"
    # DoSudo="sudo"
fi
rbranch="$1"

MainPath="$(pwd)"
MainClangPath="${MainPath}/Clang-$rbranch"
MainClangZipPath="${MainPath}/Clang-zip-$rbranch"
MainGCCaPath="${MainPath}/GCC64-$rbranch"
MainGCCbPath="${MainPath}/GCC32-$rbranch"
MainZipGCCaPath="${MainPath}/GCC64-zip-$rbranch"
MainZipGCCbPath="${MainPath}/GCC32-zip-$rbranch"
KernelPath="${MainPath}/Kernel-$rbranch"
AnyKernelPath="${MainPath}/Anykernel-$rbranch"
CustomUploader="N-$rbranch"
UploaderPath="${MainPath}/Uploader-$rbranch"
FolderUp=""
ExFolder=""
UseSpectrum="N"
SpectrumPath="${MainPath}/Spectrum-$rbranch"
spectrumFile="None"
KernelDownloader='N'
KDpath="${MainPath}/Kernel-Downloader-$rbranch"
KDType=""

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
    IncludeFiles "$MainPath/for/${rbranch}.sh"
    # cleanup stuff after done
    cd "${MainPath}"
    git push -d origin $rbranch 2>/dev/null
    rm -rf *
fi