#! /bin/bash

chmod +x ${MainPath}/misc/bot.sh

IncludeFiles ${MainPath}/misc/clang.sh
IncludeFiles ${MainPath}/misc/gcc.sh

getInfo() {
    echo -e "\e[1;32m$*\e[0m"
}

getInfoErr() {
    echo -e "\e[1;41m$*\e[0m"
}

if [ ! -z "$1" ];then
    KernelRepo="$1"
    if [ "$CustomUploader" == "Y" ];then
        git clone https://${GIT_SECRET}@github.com/${GIT_USERNAME}/uploader-kernel-private -b master "${UploaderPath}"  --depth=1
    fi
    if [ "$UseSpectrum" == "Y" ];then
        git clone https://github.com/ZyCromerZ/Spectrum -b master "${SpectrumPath}"  --depth=1 
    fi
    git clone https://github.com/ZyCromerZ/Anykernel3 -b "${AnyKernelBranch}" "${AnyKernelPath}"
    [[ -z "$ImgName" ]] && ImgName="Image.gz-dtb"
    [[ -z "$UseDtb" ]] && UseDtb="n"
    [[ -z "$UseDtbo" ]] && UseDtbo="n"
    UseZyCLLVM="n"
    UseGoldBinutils="n"
else    
    getInfoErr "KernelRepo is missing :/"
    [ ! -z "${DRONE_BRANCH}" ] && . $MainPath/misc/bot.sh "send_info" "<b>❌ Build failed</b>%0ABranch : <b>${KernelBranch}</b%0A%0ASad Boy"
    exit 1
fi

CloneKernel(){
    if [[ ! -d "${KernelPath}" ]];then
        if [ ! -z "$1" ];then
            git clone "${KernelRepo}" -b "${KernelBranch}" "${KernelPath}" "$1"
        else
            git clone "${KernelRepo}" -b "${KernelBranch}" "${KernelPath}"
        fi
        cd "${KernelPath}"
    else
        cd "${KernelPath}"
        if [ ! -z "${KernelBranch}" ];then
            getInfo "clone balik?"
            if [ ! -z "$1" ];then
                git fetch origin "${KernelBranch}" "$1"
            else
                git fetch origin "${KernelBranch}"
            fi
            git checkout FETCH_HEAD
            git branch -D "${KernelBranch}"
            git checkout -b "${KernelBranch}"
        fi
    fi
    getInfo "clone kernel done"
    KVer=$(make kernelversion)
    HeadCommitId="$(git log --pretty=format:'%h' -n1)"
    HeadCommitMsg="$(git log --pretty=format:'%s' -n1)"
    getInfo "get some main info done"
}

CompileClangKernel(){
    cd "${KernelPath}"
    SendInfoLink
    BUILD_START=$(date +"%s")
    make    -j${TotalCores}  O=out ARCH="$ARCH" "$DEFFCONFIG"
    MorePlusPlus=" "
    if [[ ! -z "$(cat $KernelPath/out/.config | grep "CONFIG_LTO=y" )" ]] || [[ ! -z "$(cat $KernelPath/out/.config | grep "CONFIG_LTO_CLANG=y" )" ]];then
        MorePlusPlus="LD=ld.lld HOSTLD=ld.lld"
    fi
    if [[ "$TypeBuilder" == *"SDClang"* ]];then
        MorePlusPlus="HOSTCC=gcc HOSTCXX=g++ $MorePlusPlus"
    fi
    if [ -d "${ClangPath}/lib64" ];then
        MAKE=(
                ARCH=$ARCH \
                SUBARCH=$ARCH \
                PATH=${ClangPath}/bin:${GCCaPath}/bin:${GCCbPath}/bin:/usr/bin:${PATH} \
                LD_LIBRARY_PATH="${ClangPath}/lib64:${LD_LIBRARY_PATH}" \
                CC=clang \
                CROSS_COMPILE=$for64- \
                CROSS_COMPILE_ARM32=$for32- \
                CLANG_TRIPLE=aarch64-linux-gnu- ${MorePlusPlus}
        )
        make    -j${TotalCores}  O=out \
                ARCH=$ARCH \
                SUBARCH=$ARCH \
                PATH=${ClangPath}/bin:${GCCaPath}/bin:${GCCbPath}/bin:/usr/bin:${PATH} \
                LD_LIBRARY_PATH="${ClangPath}/lib64:${LD_LIBRARY_PATH}" \
                CC=clang \
                CROSS_COMPILE=$for64- \
                CROSS_COMPILE_ARM32=$for32- \
                CLANG_TRIPLE=aarch64-linux-gnu- ${MorePlusPlus}
    else
        MAKE=(
                ARCH=$ARCH \
                SUBARCH=$ARCH \
                PATH=${ClangPath}/bin:${GCCaPath}/bin:${GCCbPath}/bin:/usr/bin:${PATH} \
                LD_LIBRARY_PATH="${ClangPath}/lib:${LD_LIBRARY_PATH}" \
                CC=clang \
                CROSS_COMPILE=$for64- \
                CROSS_COMPILE_ARM32=$for32- \
                CLANG_TRIPLE=aarch64-linux-gnu- ${MorePlusPlus}
        )
        make    -j${TotalCores}  O=out \
                ARCH=$ARCH \
                SUBARCH=$ARCH \
                PATH=${ClangPath}/bin:${GCCaPath}/bin:${GCCbPath}/bin:/usr/bin:${PATH} \
                LD_LIBRARY_PATH="${ClangPath}/lib:${LD_LIBRARY_PATH}" \
                CC=clang \
                CROSS_COMPILE=$for64- \
                CROSS_COMPILE_ARM32=$for32- \
                CLANG_TRIPLE=aarch64-linux-gnu- ${MorePlusPlus}
    fi
    BUILD_END=$(date +"%s")
    DIFF=$((BUILD_END - BUILD_START))
    if [[ ! -e $KernelPath/out/arch/$ARCH/boot/${ImgName} ]];then
        MSG="<b>❌ Build failed</b>%0ABranch : <b>${KernelBranch}</b>%0A- <code>$((DIFF / 60)) minute(s) $((DIFF % 60)) second(s)</code>%0A%0ASad Boy"
        . $MainPath/misc/bot.sh "send_info" "$MSG"
        exit 1
    fi
    cp -af $KernelPath/out/arch/$ARCH/boot/${ImgName} $AnyKernelPath
    KName=$(cat "${KernelPath}/arch/$ARCH/configs/$DEFFCONFIG" | grep "CONFIG_LOCALVERSION=" | sed 's/CONFIG_LOCALVERSION="-*//g' | sed 's/"*//g' )
    ZipName="[$GetBD][$TypeBuilder]${TypeBuildTag}[$CODENAME]$KVer-$KName-$HeadCommitId.zip"
    [[ ! -z "$TypeBuildFor" ]] && ZipName="[$GetBD][$TypeBuildFor][$TypeBuilder]${TypeBuildTag}[$CODENAME]$KVer-$KName-$HeadCommitId.zip"
    CompilerStatus="- <code>${ClangType}</code>%0A- <code>${gcc32Type}</code>%0A- <code>${gcc64Type}</code>"
    if [ ! -z "$1" ];then
        MakeZip "$1"
    else
        MakeZip
    fi
}

CompileGccKernel(){
    cd "${KernelPath}"
    DisableLTO
    SendInfoLink
    BUILD_START=$(date +"%s")
    make    -j${TotalCores}  O=out ARCH="${ARCH}" "${DEFFCONFIG}"
    MAKE=(
        ARCH=$ARCH \
        SUBARCH=$ARCH \
        PATH=${GCCaPath}/bin:${GCCbPath}/bin:/usr/bin:${PATH} \
        CROSS_COMPILE=$for64- \
        CROSS_COMPILE_ARM32=$for32-
    )
    make    -j${TotalCores}  O=out \
            ARCH=$ARCH \
            SUBARCH=$ARCH \
            PATH=${GCCaPath}/bin:${GCCbPath}/bin:/usr/bin:${PATH} \
            CROSS_COMPILE=$for64- \
            CROSS_COMPILE_ARM32=$for32-
    
    BUILD_END=$(date +"%s")
    DIFF=$((BUILD_END - BUILD_START))
    if [[ ! -e $KernelPath/out/arch/$ARCH/boot/${ImgName} ]];then
        MSG="<b>❌ Build failed</b>%0ABranch : <b>${KernelBranch}</b>%0A- <code>$((DIFF / 60)) minute(s) $((DIFF % 60)) second(s)</code>%0A%0ASad Boy"
        . $MainPath/misc/bot.sh "send_info" "$MSG"
        exit 1
    fi
    cp -af $KernelPath/out/arch/$ARCH/boot/${ImgName} $AnyKernelPath
    KName=$(cat "${KernelPath}/arch/${ARCH}/configs/${DEFFCONFIG}" | grep "CONFIG_LOCALVERSION=" | sed 's/CONFIG_LOCALVERSION="-*//g' | sed 's/"*//g' )
    ZipName="[$GetBD][GCC]${TypeBuildTag}[$CODENAME]$KVer-$KName-$HeadCommitId.zip"
    [[ ! -z "$TypeBuildFor" ]] && ZipName="[$GetBD][$TypeBuildFor][GCC]${TypeBuildTag}[$CODENAME]$KVer-$KName-$HeadCommitId.zip"
    CompilerStatus="- <code>${gcc32Type}</code>%0A- <code>${gcc64Type}</code>"
    if [ ! -z "$1" ];then
        MakeZip "$1"
    else
        MakeZip
    fi

}

CompileGccKernelB(){
    cd "${KernelPath}"
    DisableLTO
    SendInfoLink
    PrefixDir="${MainClangZipPath}-zyc/bin/"
    BUILD_START=$(date +"%s")
    make    -j${TotalCores}  O=out ARCH="${ARCH}" "${DEFFCONFIG}"
    MAKE=(
        ARCH=$ARCH \
        SUBARCH=$ARCH \
        PATH=${GCCaPath}/bin:${GCCbPath}/bin:/usr/bin:${PATH} \
        CROSS_COMPILE=$for64- \
        CROSS_COMPILE_ARM32=$for32- \
        LD=${PrefixDir}ld.lld \
        AR=${PrefixDir}llvm-ar \
        NM=${PrefixDir}llvm-nm \
        STRIP=${PrefixDir}llvm-strip \
        OBJCOPY=${PrefixDir}llvm-objcopy \
        OBJDUMP=${PrefixDir}llvm-objdump \
        READELF=${PrefixDir}llvm-readelf \
        HOSTAR=${PrefixDir}llvm-ar \
        HOSTLD=${PrefixDir}ld.lld ${MorePlusPlus}
    )
    make    -j${TotalCores}  O=out \
            ARCH=$ARCH \
            SUBARCH=$ARCH \
            PATH=${GCCaPath}/bin:${GCCbPath}/bin:/usr/bin:${PATH} \
            CROSS_COMPILE=$for64- \
            CROSS_COMPILE_ARM32=$for32- \
            LD=${PrefixDir}ld.lld \
            AR=${PrefixDir}llvm-ar \
            NM=${PrefixDir}llvm-nm \
            STRIP=${PrefixDir}llvm-strip \
            OBJCOPY=${PrefixDir}llvm-objcopy \
            OBJDUMP=${PrefixDir}llvm-objdump \
            READELF=${PrefixDir}llvm-readelf \
            HOSTAR=${PrefixDir}llvm-ar \
            HOSTLD=${PrefixDir}ld.lld ${MorePlusPlus}
    
    BUILD_END=$(date +"%s")
    DIFF=$((BUILD_END - BUILD_START))
    if [[ ! -e $KernelPath/out/arch/$ARCH/boot/${ImgName} ]];then
        MSG="<b>❌ Build failed</b>%0ABranch : <b>${KernelBranch}</b>%0A- <code>$((DIFF / 60)) minute(s) $((DIFF % 60)) second(s)</code>%0A%0ASad Boy"
        . $MainPath/misc/bot.sh "send_info" "$MSG"
        exit 1
    fi
    cp -af $KernelPath/out/arch/$ARCH/boot/${ImgName} $AnyKernelPath
    KName=$(cat "${KernelPath}/arch/${ARCH}/configs/${DEFFCONFIG}" | grep "CONFIG_LOCALVERSION=" | sed 's/CONFIG_LOCALVERSION="-*//g' | sed 's/"*//g' )
    ZipName="[$GetBD][GCC]${TypeBuildTag}[$CODENAME]$KVer-$KName-$HeadCommitId.zip"
    [[ ! -z "$TypeBuildFor" ]] && ZipName="[$GetBD][$TypeBuildFor][GCC]${TypeBuildTag}[$CODENAME]$KVer-$KName-$HeadCommitId.zip"
    CompilerStatus="- <code>${gcc32Type}</code>%0A- <code>${gcc64Type}</code>"
    if [ ! -z "$1" ];then
        MakeZip "$1"
    else
        MakeZip
    fi

}

CompileClangKernelB(){
    cd "${KernelPath}"
    SendInfoLink
    BUILD_START=$(date +"%s")
    make    -j${TotalCores}  O=out ARCH="$ARCH" "$DEFFCONFIG"
    MorePlusPlus=" "
    if [[ ! -z "$(cat $KernelPath/out/.config | grep "CONFIG_LTO=y" )" ]] || [[ ! -z "$(cat $KernelPath/out/.config | grep "CONFIG_LTO_CLANG=y" )" ]];then
        MorePlusPlus="LD=ld.lld HOSTLD=ld.lld"
    fi
    if [[ "$TypeBuilder" == *"SDClang"* ]];then
        MorePlusPlus="HOSTCC=gcc HOSTCXX=g++ $MorePlusPlus"
    fi
    if [ -d "${ClangPath}/lib64" ];then
        MAKE=(
                ARCH=$ARCH \
                SUBARCH=$ARCH \
                PATH=${ClangPath}/bin:/usr/bin:${PATH} \
                LD_LIBRARY_PATH="${ClangPath}/lib64:${LD_LIBRARY_PATH}" \
                CC=clang \
                CROSS_COMPILE=aarch64-linux-gnu- \
                CROSS_COMPILE_ARM32=arm-linux-gnueabi- \
                CLANG_TRIPLE=aarch64-linux-gnu- ${MorePlusPlus}
        )
        make    -j${TotalCores}  O=out \
                ARCH=$ARCH \
                SUBARCH=$ARCH \
                PATH=${ClangPath}/bin:/usr/bin:${PATH} \
                LD_LIBRARY_PATH="${ClangPath}/lib64:${LD_LIBRARY_PATH}" \
                CC=clang \
                CROSS_COMPILE=aarch64-linux-gnu- \
                CROSS_COMPILE_ARM32=arm-linux-gnueabi- \
                CLANG_TRIPLE=aarch64-linux-gnu- ${MorePlusPlus}
    else
        MAKE=(
                ARCH=$ARCH \
                SUBARCH=$ARCH \
                PATH=${ClangPath}/bin:/usr/bin:${PATH} \
                LD_LIBRARY_PATH="${ClangPath}/lib:${LD_LIBRARY_PATH}" \
                CC=clang \
                CROSS_COMPILE=aarch64-linux-gnu- \
                CROSS_COMPILE_ARM32=arm-linux-gnueabi- \
                CLANG_TRIPLE=aarch64-linux-gnu- ${MorePlusPlus}
        )
        make    -j${TotalCores}  O=out \
                ARCH=$ARCH \
                SUBARCH=$ARCH \
                PATH=${ClangPath}/bin:/usr/bin:${PATH} \
                LD_LIBRARY_PATH="${ClangPath}/lib:${LD_LIBRARY_PATH}" \
                CC=clang \
                CROSS_COMPILE=aarch64-linux-gnu- \
                CROSS_COMPILE_ARM32=arm-linux-gnueabi- \
                CLANG_TRIPLE=aarch64-linux-gnu- ${MorePlusPlus}
    fi
    BUILD_END=$(date +"%s")
    DIFF=$((BUILD_END - BUILD_START))
    if [[ ! -e $KernelPath/out/arch/$ARCH/boot/${ImgName} ]];then
        MSG="<b>❌ Build failed</b>%0ABranch : <b>${KernelBranch}</b>%0A- <code>$((DIFF / 60)) minute(s) $((DIFF % 60)) second(s)</code>%0A%0ASad Boy"
        . $MainPath/misc/bot.sh "send_info" "$MSG"
        exit 1
    fi
    cp -af $KernelPath/out/arch/$ARCH/boot/${ImgName} $AnyKernelPath
    KName=$(cat "${KernelPath}/arch/$ARCH/configs/$DEFFCONFIG" | grep "CONFIG_LOCALVERSION=" | sed 's/CONFIG_LOCALVERSION="-*//g' | sed 's/"*//g' )
    ZipName="[$GetBD][$TypeBuilder]${TypeBuildTag}[$CODENAME]$KVer-$KName-$HeadCommitId.zip"
    [[ ! -z "$TypeBuildFor" ]] && ZipName="[$GetBD][$TypeBuildFor][$TypeBuilder]${TypeBuildTag}[$CODENAME]$KVer-$KName-$HeadCommitId.zip"
    CompilerStatus="- <code>${ClangType}</code>%0A- <code>${gcc32Type}</code>%0A- <code>${gcc64Type}</code>"
    if [ ! -z "$1" ];then
        MakeZip "$1"
    else
        MakeZip
    fi
}

CompileClangKernelLLVM(){
    cd "${KernelPath}"
    SendInfoLink
    MorePlusPlus=" "
    PrefixDir=""
    if [[ "$UseZyCLLVM" == "y" ]];then
        PrefixDir="${MainClangZipPath}-zyc/bin/"
    fi
    if [[ "$TypeBuilder" != *"SDClang"* ]];then
        MorePlusPlus="HOSTCC=clang HOSTCXX=clang++"
    else
        MorePlusPlus="HOSTCC=gcc HOSTCXX=g++"
    fi
    if [[ "$UseGoldBinutils" == "y" ]];then
        MorePlusPlus="LD=aarch64-linux-gnu-ld.gold HOSTLD=aarch64-linux-gnu-ld.gold $MorePlusPlus"
    else
        MorePlusPlus="LD=${PrefixDir}ld.lld HOSTLD=${PrefixDir}ld.lld $MorePlusPlus"
    fi
    BUILD_START=$(date +"%s")
    make    -j${TotalCores}  O=out ARCH="$ARCH" "$DEFFCONFIG"
    if [ -d "${ClangPath}/lib64" ];then
        MAKE=(
                ARCH=$ARCH \
                SUBARCH=$ARCH \
                PATH=${ClangPath}/bin:${PATH} \
                LD_LIBRARY_PATH="${ClangPath}/lib64:${LD_LIBRARY_PATH}" \
                CC=clang \
                CROSS_COMPILE=aarch64-linux-gnu- \
                CROSS_COMPILE_ARM32=arm-linux-gnueabi- \
                CLANG_TRIPLE=aarch64-linux-gnu- \
                AR=${PrefixDir}llvm-ar \
                NM=${PrefixDir}llvm-nm \
                STRIP=${PrefixDir}llvm-strip \
                OBJCOPY=${PrefixDir}llvm-objcopy \
                OBJDUMP=${PrefixDir}llvm-objdump \
                READELF=${PrefixDir}llvm-readelf \
                HOSTAR=${PrefixDir}llvm-ar ${MorePlusPlus} LLVM=1
        )
        make    -j${TotalCores}  O=out \
                ARCH=$ARCH \
                SUBARCH=$ARCH \
                PATH=${ClangPath}/bin:${PATH} \
                LD_LIBRARY_PATH="${ClangPath}/lib64:${LD_LIBRARY_PATH}" \
                CC=clang \
                CROSS_COMPILE=aarch64-linux-gnu- \
                CROSS_COMPILE_ARM32=arm-linux-gnueabi- \
                CLANG_TRIPLE=aarch64-linux-gnu- \
                AR=${PrefixDir}llvm-ar \
                NM=${PrefixDir}llvm-nm \
                STRIP=${PrefixDir}llvm-strip \
                OBJCOPY=${PrefixDir}llvm-objcopy \
                OBJDUMP=${PrefixDir}llvm-objdump \
                READELF=${PrefixDir}llvm-readelf \
                HOSTAR=${PrefixDir}llvm-ar ${MorePlusPlus} LLVM=1
    else
        MAKE=(
                ARCH=$ARCH \
                SUBARCH=$ARCH \
                PATH=${ClangPath}/bin:${PATH} \
                LD_LIBRARY_PATH="${ClangPath}/lib:${LD_LIBRARY_PATH}" \
                CC=clang \
                CROSS_COMPILE=aarch64-linux-gnu- \
                CROSS_COMPILE_ARM32=arm-linux-gnueabi- \
                CLANG_TRIPLE=aarch64-linux-gnu- \
                AR=${PrefixDir}llvm-ar \
                NM=${PrefixDir}llvm-nm \
                STRIP=${PrefixDir}llvm-strip \
                OBJCOPY=${PrefixDir}llvm-objcopy \
                OBJDUMP=${PrefixDir}llvm-objdump \
                READELF=${PrefixDir}llvm-readelf \
                HOSTAR=${PrefixDir}llvm-ar ${MorePlusPlus} LLVM=1
        )
        make    -j${TotalCores}  O=out \
                ARCH=$ARCH \
                SUBARCH=$ARCH \
                PATH=${ClangPath}/bin:${PATH} \
                LD_LIBRARY_PATH="${ClangPath}/lib:${LD_LIBRARY_PATH}" \
                CC=clang \
                CROSS_COMPILE=aarch64-linux-gnu- \
                CROSS_COMPILE_ARM32=arm-linux-gnueabi- \
                CLANG_TRIPLE=aarch64-linux-gnu- \
                AR=${PrefixDir}llvm-ar \
                NM=${PrefixDir}llvm-nm \
                STRIP=${PrefixDir}llvm-strip \
                OBJCOPY=${PrefixDir}llvm-objcopy \
                OBJDUMP=${PrefixDir}llvm-objdump \
                READELF=${PrefixDir}llvm-readelf \
                HOSTAR=${PrefixDir}llvm-ar ${MorePlusPlus} LLVM=1
    fi
    BUILD_END=$(date +"%s")
    DIFF=$((BUILD_END - BUILD_START))
    if [[ ! -e $KernelPath/out/arch/$ARCH/boot/${ImgName} ]];then
        MSG="<b>❌ Build failed</b>%0ABranch : <b>${KernelBranch}</b>%0A- <code>$((DIFF / 60)) minute(s) $((DIFF % 60)) second(s)</code>%0A%0ASad Boy"
        . $MainPath/misc/bot.sh "send_info" "$MSG"
        exit 1
    fi
    cp -af $KernelPath/out/arch/$ARCH/boot/${ImgName} $AnyKernelPath
    KName=$(cat "${KernelPath}/arch/$ARCH/configs/$DEFFCONFIG" | grep "CONFIG_LOCALVERSION=" | sed 's/CONFIG_LOCALVERSION="-*//g' | sed 's/"*//g' )
    ZipName="[$GetBD][$TypeBuilder]${TypeBuildTag}[$CODENAME]$KVer-$KName-$HeadCommitId.zip"
    [[ ! -z "$TypeBuildFor" ]] && ZipName="[$GetBD][$TypeBuildFor][$TypeBuilder]${TypeBuildTag}[$CODENAME]$KVer-$KName-$HeadCommitId.zip"
    CompilerStatus="- <code>${ClangType}</code>%0A- <code>${gcc32Type}</code>%0A- <code>${gcc64Type}</code>"
    if [ ! -z "$1" ];then
        MakeZip "$1"
    else
        MakeZip
    fi
}

CompileClangKernelLLVMB(){
    cd "${KernelPath}"
    SendInfoLink
    MorePlusPlus=" "
    PrefixDir=""
    if [[ "$UseZyCLLVM" == "y" ]];then
        PrefixDir="${MainClangZipPath}-zyc/bin/"
    fi
    if [[ "$TypeBuilder" != *"SDClang"* ]];then
        MorePlusPlus="HOSTCC=clang HOSTCXX=clang++"
    else
        MorePlusPlus="HOSTCC=gcc HOSTCXX=g++"
    fi
    if [[ "$UseGoldBinutils" == "y" ]];then
        MorePlusPlus="LD=$for64-ld.gold HOSTLD=$for64-ld.gold $MorePlusPlus"
    else
        MorePlusPlus="LD=${PrefixDir}ld.lld HOSTLD=${PrefixDir}ld.lld $MorePlusPlus"
    fi
    BUILD_START=$(date +"%s")
    make    -j${TotalCores}  O=out ARCH="$ARCH" "$DEFFCONFIG"
    if [ -d "${ClangPath}/lib64" ];then
        MAKE=(
                ARCH=$ARCH \
                SUBARCH=$ARCH \
                PATH=${ClangPath}/bin:${GCCaPath}/bin:${GCCbPath}/bin:/usr/bin:${PATH} \
                LD_LIBRARY_PATH="${ClangPath}/lib64:${LD_LIBRARY_PATH}" \
                CC=clang \
                CROSS_COMPILE=$for64- \
                CROSS_COMPILE_ARM32=$for32- \
                CLANG_TRIPLE=aarch64-linux-gnu- \
                AR=${PrefixDir}llvm-ar \
                NM=${PrefixDir}llvm-nm \
                STRIP=${PrefixDir}llvm-strip \
                OBJCOPY=${PrefixDir}llvm-objcopy \
                OBJDUMP=${PrefixDir}llvm-objdump \
                READELF=${PrefixDir}llvm-readelf \
                HOSTAR=${PrefixDir}llvm-ar ${MorePlusPlus} LLVM=1
        )
        make    -j${TotalCores}  O=out \
                ARCH=$ARCH \
                SUBARCH=$ARCH \
                PATH=${ClangPath}/bin:${GCCaPath}/bin:${GCCbPath}/bin:/usr/bin:${PATH} \
                LD_LIBRARY_PATH="${ClangPath}/lib64:${LD_LIBRARY_PATH}" \
                CC=clang \
                CROSS_COMPILE=$for64- \
                CROSS_COMPILE_ARM32=$for32- \
                CLANG_TRIPLE=aarch64-linux-gnu- \
                AR=${PrefixDir}llvm-ar \
                NM=${PrefixDir}llvm-nm \
                STRIP=${PrefixDir}llvm-strip \
                OBJCOPY=${PrefixDir}llvm-objcopy \
                OBJDUMP=${PrefixDir}llvm-objdump \
                READELF=${PrefixDir}llvm-readelf \
                HOSTAR=${PrefixDir}llvm-ar ${MorePlusPlus} LLVM=1
    else
        MAKE=(
                ARCH=$ARCH \
                SUBARCH=$ARCH \
                PATH=${ClangPath}/bin:${GCCaPath}/bin:${GCCbPath}/bin:/usr/bin:${PATH} \
                LD_LIBRARY_PATH="${ClangPath}/lib:${LD_LIBRARY_PATH}" \
                CC=clang \
                CROSS_COMPILE=$for64- \
                CROSS_COMPILE_ARM32=$for32- \
                CLANG_TRIPLE=aarch64-linux-gnu- \
                AR=${PrefixDir}llvm-ar \
                NM=${PrefixDir}llvm-nm \
                STRIP=${PrefixDir}llvm-strip \
                OBJCOPY=${PrefixDir}llvm-objcopy \
                OBJDUMP=${PrefixDir}llvm-objdump \
                READELF=${PrefixDir}llvm-readelf \
                HOSTAR=${PrefixDir}llvm-ar \
                HOSTLD=${PrefixDir}ld.lld ${MorePlusPlus} LLVM=1
        )
        make    -j${TotalCores}  O=out \
                ARCH=$ARCH \
                SUBARCH=$ARCH \
                PATH=${ClangPath}/bin:${GCCaPath}/bin:${GCCbPath}/bin:/usr/bin:${PATH} \
                LD_LIBRARY_PATH="${ClangPath}/lib:${LD_LIBRARY_PATH}" \
                CC=clang \
                CROSS_COMPILE=$for64- \
                CROSS_COMPILE_ARM32=$for32- \
                CLANG_TRIPLE=aarch64-linux-gnu- \
                AR=${PrefixDir}llvm-ar \
                NM=${PrefixDir}llvm-nm \
                STRIP=${PrefixDir}llvm-strip \
                OBJCOPY=${PrefixDir}llvm-objcopy \
                OBJDUMP=${PrefixDir}llvm-objdump \
                READELF=${PrefixDir}llvm-readelf \
                HOSTAR=${PrefixDir}llvm-ar \
                HOSTLD=${PrefixDir}ld.lld ${MorePlusPlus} LLVM=1
    fi
    BUILD_END=$(date +"%s")
    DIFF=$((BUILD_END - BUILD_START))
    if [[ ! -e $KernelPath/out/arch/$ARCH/boot/${ImgName} ]];then
        MSG="<b>❌ Build failed</b>%0ABranch : <b>${KernelBranch}</b>%0A- <code>$((DIFF / 60)) minute(s) $((DIFF % 60)) second(s)</code>%0A%0ASad Boy"
        . $MainPath/misc/bot.sh "send_info" "$MSG"
        exit 1
    fi
    cp -af $KernelPath/out/arch/$ARCH/boot/${ImgName} $AnyKernelPath
    KName=$(cat "${KernelPath}/arch/$ARCH/configs/$DEFFCONFIG" | grep "CONFIG_LOCALVERSION=" | sed 's/CONFIG_LOCALVERSION="-*//g' | sed 's/"*//g' )
    ZipName="[$GetBD][$TypeBuilder]${TypeBuildTag}[$CODENAME]$KVer-$KName-$HeadCommitId.zip"
    [[ ! -z "$TypeBuildFor" ]] && ZipName="[$GetBD][$TypeBuildFor][$TypeBuilder]${TypeBuildTag}[$CODENAME]$KVer-$KName-$HeadCommitId.zip"
    CompilerStatus="- <code>${ClangType}</code>%0A- <code>${gcc32Type}</code>%0A- <code>${gcc64Type}</code>"
    if [ ! -z "$1" ];then
        MakeZip "$1"
    else
        MakeZip
    fi
}

CleanOut()
{
    cd "${KernelPath}"
    git reset --hard "${HeadCommitId}"
    rm -rf "${KernelPath}/out"
    ccache -c
    ccache -C
}

MakeZip(){
    cd $AnyKernelPath
    if [ ! -z "$spectrumFile" ] && [ "$UseSpectrum" == "Y" ];then
        cp -af $SpectrumPath/$spectrumFile init.spectrum.rc && sed -i "s/persist.spectrum.kernel.*/persist.spectrum.kernel $KName/g" init.spectrum.rc
    fi
    cp -af anykernel-real.sh anykernel.sh && sed -i "s/kernel.string=.*/kernel.string=$KName-$HeadCommitId by ZyCromerZ/g" anykernel.sh
    [[ "$UseDtbo" == "y" ]] && cp -af "$KernelPath/out/arch/$ARCH/boot/dtbo.img" "$AnyKernelPath/dtbo.img"
    if [[ "$UseDtb" == "y" ]];then
        ( find "$KernelPath/out/arch/$ARCH/boot/dts/$AfterDTS" -name "*.dtb" -exec cat {} + > $AnyKernelPath/dtb )
        [[ ! -e "$AnyKernelPath/dtb" ]] && [[ ! -z "$BASE_DTB_NAME" ]] && cp $KernelPath/out/arch/$ARCH/boot/dts/$AfterDTS/$BASE_DTB_NAME $AnyKernelPath/dtb
    fi
    # remove placeholder file
    for asu in `find . -name placeholder`
    do
        rm -rf "$asu"
    done
    # update zip name :v
    ZipName=${ZipName/"--"/"-"}
    zip -r9 "$ZipName" * -x .git README.md anykernel-real.sh .gitignore *.zip

    # remove dtb file after make a zip
    KernelFiles="$(pwd)/$ZipName"

    if [ ! -z "$1" ];then
        UploadKernel "$1"
    else
        UploadKernel "$1"
    fi
    
}

UploadKernel(){
    MD5CHECK=$(md5sum "${KernelFiles}" | cut -d' ' -f1)
    SHA1CHECK=$(sha1sum "${KernelFiles}" | cut -d' ' -f1)
    MSG="✅ <b>Build Success</b>%0A- <code>$((DIFF / 60)) minute(s) $((DIFF % 60)) second(s) </code>%0A%0A<b>MD5 Checksum</b>%0A- <code>$MD5CHECK</code>%0A%0A<b>SHA1 Checksum</b>%0A- <code>$SHA1CHECK</code>%0A%0A<b>Under Commit Id : Message</b>%0A- <code>${HeadCommitId}</code> : <code>${HeadCommitMsg}</code>%0A%0A<b>Compilers</b>%0A$CompilerStatus%0A%0A<b>Zip Name</b>%0A- <code>$ZipName</code>"

    [ ! -z "${DRONE_BRANCH}" ] && doOsdnUp="" && doSFUp=""

    if [ "${CustomUploader}" == "Y" ];then
        cd $UploaderPath
        chmod +x "${UploaderPath}/run.sh"
        . "${UploaderPath}/run.sh" "$KernelFiles" "$FolderUp" "$GetCBD" "$ExFolder"
        if [ ! -z "$1" ];then
            UploadKernel "$1"
            . ${MainPath}/misc/bot.sh "send_info" "$MSG" "$1"
        else
            . ${MainPath}/misc/bot.sh "send_info" "$MSG"
        fi
    else
        if [ ! -z "$1" ];then
            . ${MainPath}/misc/bot.sh "send_files" "$KernelFiles" "$MSG" "$1"
        else
            . ${MainPath}/misc/bot.sh "send_files" "$KernelFiles" "$MSG"
        fi
    fi
    if [ "$KernelDownloader" == "Y" ] && [ ! -z "${KDType}" ];then
        git clone https://$GIT_SECRETB@github.com/$GIT_USERNAME/kernel-download-generator "$KDpath"
        cd "$KDpath"
        chmod +x "${KDpath}/update.sh"
        . "${KDpath}/update.sh" "${KDType}"
        cd "$MainPath"
        rm -rf "$KDpath"
    fi
    
    # always remove after push kernel zip
    for FIleName in Image Image-dtb Image.gz Image.gz-dtb dtb dtb.img dt dt.img dtbo dtbo.img init.spectrum.rc
    do
        rm -rf $AnyKernelPath/$FIleName
    done
    # remove kernel zip
    rm -rf "$AnyKernelPath/$ZipName"
    rm -rf $KernelPath/out/arch/$ARCH/boot/dtbo.img $KernelPath/out/arch/$ARCH/boot/dtbo.img $KernelPath/out/arch/$ARCH/boot/${ImgName}
    
}

SendInfoLink(){
    if [ "$FirstSendInfoLink" == "N" ];then
        if [ ! -z "${CIRCLE_BRANCH}" ];then
            BuildNumber="${CIRCLE_BUILD_NUM}"
            GenLink="${CIRCLE_BUILD_URL}"
        fi
        if [ ! -z "${DRONE_BRANCH}" ];then
            BuildNumber="${DRONE_BUILD_NUMBER}"
            GenLink="https://cloud.drone.io/${DRONE_REPO}/${DRONE_BUILD_NUMBER}/1/2"
        fi
        if [ ! -z "${GITHUB_REPOSITORY}" ];then
            BuildNumber="$GITHUB_RUN_NUMBER"
            GenLink="$GITHUB_SERVER_URL/$GITHUB_REPOSITORY/actions/runs/$GITHUB_RUN_ID"
        fi
        MSG="🔨 New Kernel On The Way%0A%0ADevice: <code>${DEVICE}</code>%0A%0ACodename: <code>${CODENAME}</code>%0A%0ABranch: <code>${KernelBranch}</code>%0A%0ABuild Date: <code>${GetCBD}</code>%0A%0ABuild Number: <code>${BuildNumber}</code>%0A%0AHost Core Count : <code>${TotalCores} cores</code>%0A%0AKernel Version: <code>${KVer}</code>%0A%0ABuild Link Progress : ${GenLink}"
        . $MainPath/misc/bot.sh "send_info" "$MSG"
        FirstSendInfoLink="Y"
    fi
}

pullBranch(){
    [[ "$(pwd)" != "${KernelPath}" ]] && cd "${KernelPath}"
    git reset --hard $HeadCommitId
    git fetch origin $1
    git pull --no-commit origin $1
    git commit -s -m "Pull branch $1"
    TypeBuildTag="$2"
}

pullBranchAgain(){
    [[ "$(pwd)" != "${KernelPath}" ]] && cd "${KernelPath}"
    git fetch origin $1
    git pull --no-commit origin $1
    git commit -s -m "Pull branch $1"
    TypeBuildTag="$2"
}

DisableLTO(){
    [[ "$(pwd)" != "${KernelPath}" ]] && cd "${KernelPath}"
    sed -i "s/CONFIG_LTO=y/CONFIG_LTO=n/" arch/$ARCH/configs/$DEFFCONFIG
    sed -i "s/CONFIG_LTO_CLANG=y/CONFIG_LTO_CLANG=n/" arch/$ARCH/configs/$DEFFCONFIG
    git add arch/$ARCH/configs/$DEFFCONFIG && git commit -sm 'defconfig: Disable LTO'
}

DisableThin(){
    [[ "$(pwd)" != "${KernelPath}" ]] && cd "${KernelPath}"
    sed -i "s/CONFIG_THINLTO=y/CONFIG_THINLTO=n/" arch/$ARCH/configs/$DEFFCONFIG
    git add arch/$ARCH/configs/$DEFFCONFIG && git commit -sm 'defconfig: Disable THINLTO'
}

EnableWalt(){
    [[ "$(pwd)" != "${KernelPath}" ]] && cd "${KernelPath}"
    sed -i "s/# CONFIG_SCHED_WALT is not set/CONFIG_SCHED_WALT=y/" arch/$ARCH/configs/$DEFFCONFIG
    git add arch/$ARCH/configs/$DEFFCONFIG && git commit -sm 'defconfig: Enable WALT'
}

DisableWalt(){
    [[ "$(pwd)" != "${KernelPath}" ]] && cd "${KernelPath}"
    sed -i "s/CONFIG_SCHED_WALT=y/CONFIG_SCHED_WALT=n/" arch/$ARCH/configs/$DEFFCONFIG
    git add arch/$ARCH/configs/$DEFFCONFIG && git commit -sm 'defconfig: Disable WALT'
}

DisableMsmP(){
    [[ "$(pwd)" != "${KernelPath}" ]] && cd "${KernelPath}"
    sed -i "s/CONFIG_MSM_PERFORMANCE=y/CONFIG_MSM_PERFORMANCE=n/" arch/$ARCH/configs/$DEFFCONFIG
    git add arch/$ARCH/configs/$DEFFCONFIG && git commit -sm 'defconfig: Disable MSM_PERFORMANCE'   
}

DisableKCAL(){
    [[ "$(pwd)" != "${KernelPath}" ]] && cd "${KernelPath}"
    sed -i "s/CONFIG_DRM_MSM_KCAL_CTRL=y/CONFIG_DRM_MSM_KCAL_CTRL=n/" arch/$ARCH/configs/$DEFFCONFIG
    git add arch/$ARCH/configs/$DEFFCONFIG && git commit -sm 'defconfig: Disable DRM_MSM_KCAL_CTRL' 
}

OptimizaForSize()
{
    [[ "$(pwd)" != "${KernelPath}" ]] && cd "${KernelPath}"
    sed -i "s/# CONFIG_CC_OPTIMIZE_FOR_SIZE is not set/CONFIG_CC_OPTIMIZE_FOR_SIZE=y/" arch/$ARCH/configs/$DEFFCONFIG
    sed -i "s/CONFIG_CC_OPTIMIZE_FOR_PERFORMANCE=y/# CONFIG_CC_OPTIMIZE_FOR_PERFORMANCE is not set/" arch/$ARCH/configs/$DEFFCONFIG
    git add arch/$ARCH/configs/$DEFFCONFIG && git commit -sm 'defconfig: Optimize for size' 
}

OptimizaForPerf()
{
    [[ "$(pwd)" != "${KernelPath}" ]] && cd "${KernelPath}"
    sed -i "s/# CONFIG_CC_OPTIMIZE_FOR_PERFORMANCE is not set/CONFIG_CC_OPTIMIZE_FOR_PERFORMANCE=y/" arch/$ARCH/configs/$DEFFCONFIG
    sed -i "s/CONFIG_CC_OPTIMIZE_FOR_SIZE=y/# CONFIG_CC_OPTIMIZE_FOR_SIZE is not set/" arch/$ARCH/configs/$DEFFCONFIG
    git add arch/$ARCH/configs/$DEFFCONFIG && git commit -sm 'defconfig: Optimize for Performance' 
}

EnableSCS()
{
    [[ "$(pwd)" != "${KernelPath}" ]] && cd "${KernelPath}"
    sed -i "s/# CONFIG_SHADOW_CALL_STACK is not set/CONFIG_SHADOW_CALL_STACK=y/" arch/$ARCH/configs/$DEFFCONFIG
    echo "" >> arch/$ARCH/configs/$DEFFCONFIG
    echo "CONFIG_SHADOW_CALL_STACK_VMAP=y" >> arch/$ARCH/configs/$DEFFCONFIG
    git add arch/$ARCH/configs/$DEFFCONFIG && git commit -sm 'defconfig: enable SCS' 
}

EnableRELR()
{
    [[ "$(pwd)" != "${KernelPath}" ]] && cd "${KernelPath}"
    sed -i "s/# CONFIG_TOOLS_SUPPORT_RELR is not set/CONFIG_TOOLS_SUPPORT_RELR=y/" arch/$ARCH/configs/$DEFFCONFIG
    git add arch/$ARCH/configs/$DEFFCONFIG && git commit -sm 'defconfig: enable TOOLS_SUPPORT_RELR'  
}