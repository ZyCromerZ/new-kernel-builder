#! /bin/bash
KernelBranch="r-oss-base-release-test"

IncludeFiles "${MainPath}/device/begonia-r-oss.sh"
CustomUploader="Y"
# UseSpectrum="Y"
IncludeFiles "${MainPath}/misc/kernel.sh" "https://${GIT_SECRET}@github.com/${GIT_USERNAME}/begonia_kernel"
# spectrumFile="None"
FolderUp="shared-file"
TypeBuildTag="[TEST]"


ClonePrepSdClangC
CloneGCCOld
# GCCbPath="${GCCbPath}/arm-linux-gnueabi"
# GCCaPath="${GCCaPath}/aarch64-linux-gnu"
cd $ClangPath
# cd opt/qcom/Qualcomm_Snapdragon_LLVM_ARM_Toolchain_OEM/12.1.3.0
# git init
# git remote add origin https://${GIT_SECRETB}@github.com/ZyCromerZ/SDClang
# git checkout -b 12

apt-get install -y xxhash

find . -type f -exec file {} \; \
    | grep "x86" \
    | grep "not strip" \
    | grep -v "relocatable" \
        | tr ':' ' ' | awk '{print $1}' | while read file; do
            echo "strip $file" && strip $file
done

find . -type f -exec file {} \; \
    | grep "ARM" \
    | grep "aarch64" \
    | grep "not strip" \
    | grep -v "relocatable" \
        | tr ':' ' ' | awk '{print $1}' | while read file; do echo "$GCCaPath/bin/aarch64-linux-android-strip $file" && $GCCaPath/bin/aarch64-linux-android-strip $file
done

find . -type f -exec file {} \; \
    | grep "ARM" \
    | grep "32.bit" \
    | grep "not strip" \
    | grep -v "relocatable" \
        | tr ':' ' ' | awk '{print $1}' | while read file; do echo "$GCCbPath/bin/arm-linux-androideabi-strip $file" && $GCCbPath/bin/arm-linux-androideabi-strip $file
done

find * -type f -size +1M -exec xxhsum {} + > list
awk '{print $1}' list | uniq -c | sort -g
rm list

chmod a+x bin/ld*

cd $MainPath
# git clone https://${GIT_SECRET}@github.com/${GIT_USERNAME}/SDClang -b 12 $MainPath/ClangRepo
(mkdir $MainPath/ClangRepo && cd $MainPath/ClangRepo && git init && git remote add origin https://${GL_N}:${GL_S}@gitlab.com/${GIT_USERNAME}/sdclang-16.1.0.1 && git checkout -b main)
cd $MainPath/ClangRepo
# git reset --hard e5d2db459c1145ccccd5fe731e96fb7e95f0a8f4
# rm -fr ./*
cp -af $ClangPath/* .
git add . && git commit -sm "$(cat $MainPath/getC.md)"
git push --all origin -f
. $MainPath/misc/bot.sh "send_info" "SDClang 16.1.0.1 uploaded to https://gitlab.com/ZyCromerZ/sdclang-16.1.0.1"