#! /bin/bash

chmod +x "${MainPath}"/misc/bot.sh

IncludeFiles "${MainPath}"/misc/clang.sh
IncludeFiles "${MainPath}"/misc/gcc.sh

git config --global pull.rebase false

getInfo() {
    echo -e "\e[1;32m$*\e[0m"
}

getInfoErr() {
    echo -e "\e[1;41m$*\e[0m"
}

if [ ! -z "$1" ];then
    KernelRepo="$1"
    if [ "$CustomUploader" == "Y" ];then
        git clone https://"${GIT_SECRET}"@github.com/"${GIT_USERNAME}"/uploader-kernel-private -b master "${UploaderPath}"  --depth=1
    fi
    if [ "$UseSpectrum" == "Y" ];then
        git clone https://github.com/ZyCromerZ/Spectrum -b master "${SpectrumPath}"  --depth=1 
    fi
    git clone https://github.com/ZyCromerZ/Anykernel3 -b "${AnyKernelBranch}" "${AnyKernelPath}"
    [[ -z "$ImgName" ]] && ImgName="Image.gz-dtb"
    [[ -z "$UseDtb" ]] && UseDtb="n"
    [[ -z "$UseDtbo" ]] && UseDtbo="n"
    [[ -z "$AddKSU" ]] && AddKSU="n"
    [[ -z "$NoLTO" ]] && NoLTO="n"
    UseZyCLLVM="n"
    UseGCCLLVM="n"
    UseGoldBinutils="n"
    UseOBJCOPYBinutils="n"
    SDLTOFix="n"
    [ -z "$UseLLD" ] && UseLLD="y"
    MAKE=()
    [ -z "$DontInc" ] && DontInc=""
    [ -z "$DoSubModules" ] && DoSubModules="n"
    export CLANG_TRIPLE=aarch64-linux-gnu-
else    
    getInfoErr "KernelRepo is missing :/"
    [ ! -z "${DRONE_BRANCH}" ] && . "$MainPath"/misc/bot.sh "send_info" "<b>❌ Build failed</b>%0ABranch : <b>${KernelBranch}</b%0A%0ASad Boy"
    exit 1
fi

addToConf()
{
    local path="$1"
    local val="$2"
    if [[ ! -z "$(cat "$path" | grep "$val")" ]];then
        sed -i "s/# $val is not set/$val=y/" "$path"
    else
        echo "$val=y" >> "$path"
    fi
}

GetKsuSource(){
    curl -LSs "https://raw.githubusercontent.com/tiann/KernelSU/main/kernel/setup.sh" | bash -s main || GetKsuSource
}

CloneKSUSource()
{
    git clone https://github.com/tiann/KernelSU -b main || CloneKSUSource
}

CloneKernel(){
    if [[ ! -d "${KernelPath}" ]];then
        local args="${@}"
        if [ ! -z "$args" ];then
            git clone "${KernelRepo}" -b "${KernelBranch}" "${KernelPath}" "${args}"
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
    if [[ "$DoSubModules" == "y" ]];then
        git submodule update --init --recursive
        git submodule update --remote --recursive
        getInfo "get submodule done"
    fi

    if [ "$AddKSU" == "y" ]; then
        GetKsuSource
        addToConf "arch/${ARCH}/configs/${DEFFCONFIG}" "CONFIG_KPROBES"
        addToConf "arch/${ARCH}/configs/${DEFFCONFIG}" "CONFIG_HAVE_KPROBES"
        addToConf "arch/${ARCH}/configs/${DEFFCONFIG}" "CONFIG_KPROBE_EVENTS"
        addToConf "arch/${ARCH}/configs/${DEFFCONFIG}" "CONFIG_OVERLAY_FS"
        git add arch/"${ARCH}"/configs/"${DEFFCONFIG}" && git commit -sm 'defconfig: update for ksu'
        # re clone again
        rm -rf KernelSU 
        CloneKSUSource
        getInfo "get KernelSU done"
    fi
}

CompileClangKernel(){
    cd "${KernelPath}" 
    [[ -d "${KernelPath}/KernelSU" ]] && [[ "$(cat arch/"$ARCH"/configs/"$DEFFCONFIG")" == "CONFIG_THINLTO=y" ]] && DisableLTO
    [[ "$NoLTO" != "n" ]] && DisableLTO
    SendInfoLink
    MorePlusPlus=" "
    if [[ "$UseGoldBinutils" == "y" ]];then
        MorePlusPlus="LD=$for64-ld.gold LDGOLD=$for64-ld.gold HOSTLD=${ClangPath}/bin/ld $MorePlusPlus"
        MorePlusPlus="LD_COMPAT=${GCCbPath}/bin/$for32-ld $MorePlusPlus"
        DisableRELR
    elif [[ "$UseGoldBinutils" == "m" ]];then
        MorePlusPlus="LD=$for64-ld LDGOLD=$for64-ld.gold HOSTLD=${ClangPath}/bin/ld $MorePlusPlus"
        MorePlusPlus="LD_COMPAT=${GCCbPath}/bin/$for32-ld $MorePlusPlus"
        DisableRELR
    else
        MorePlusPlus="LD=${ClangPath}/bin/ld.lld HOSTLD=${ClangPath}/bin/ld.lld LD_COMPAT=${ClangPath}/bin/ld.lld $MorePlusPlus"
    fi
    if [[ "$TypeBuilder" == *"SDClang"* ]];then
        MorePlusPlus="HOSTCC=gcc HOSTCXX=g++ $MorePlusPlus"
    fi
    if [[ "$SDLTOFix" == "y" ]];then
        MorePlusPlus="NM=${ClangPath}/bin/llvm-nm OBJCOPY=${ClangPath}/bin/llvm-objcopy $MorePlusPlus"
    fi
    if [ -d "${ClangPath}/lib64" ];then
        MAKE=(
                ARCH=$ARCH \
                SUBARCH=$ARCH \
                PATH=${ClangPath}/bin:${GCCaPath}/bin:${GCCbPath}/bin:/usr/bin:${PATH} \
                LD_LIBRARY_PATH="${ClangPath}/lib64:${GCCaPath}/lib:${GCCbPath}/lib:${LD_LIBRARY_PATH}" \
                CC=clang \
                CROSS_COMPILE=$for64- \
                CROSS_COMPILE_ARM32=$for32- \
                CLANG_TRIPLE=aarch64-linux-gnu- ${MorePlusPlus}
        )
    else
        MAKE=(
                ARCH=$ARCH \
                SUBARCH=$ARCH \
                PATH=${ClangPath}/bin:${GCCaPath}/bin:${GCCbPath}/bin:/usr/bin:${PATH} \
                LD_LIBRARY_PATH="${ClangPath}/lib:${GCCaPath}/lib:${GCCbPath}/lib:${LD_LIBRARY_PATH}" \
                CC=clang \
                CROSS_COMPILE=$for64- \
                CROSS_COMPILE_ARM32=$for32- \
                CLANG_TRIPLE=aarch64-linux-gnu- ${MorePlusPlus}
        )
    fi
    CompileNow ${@}
}

CompileGccKernel(){
    cd "${KernelPath}" 
    DisableLTO
    DisableRELR
    MorePlusPlus=" "
    [[ "$UseLLD" == "y" ]] && [[ -f ${GCCaPath}/bin/$for64-ld.lld ]] && MorePlusPlus="LD=${GCCaPath}/bin/$for64-ld.lld HOSTLD=${GCCaPath}/bin/$for64-ld.lld"
    if [[ "$UseLLD" == "y" ]] && [[ -f ${GCCbPath}/bin/$for32-ld.lld ]];then
        MorePlusPlus="LD_COMPAT=${GCCbPath}/bin/$for32-ld.lld $MorePlusPlus"
    else
        MorePlusPlus="LD_COMPAT=${GCCbPath}/bin/$for32-ld $MorePlusPlus"
    fi
    echo "MorePlusPlus : $MorePlusPlus"
    SendInfoLink
    MAKE=(
        ARCH=$ARCH \
        SUBARCH=$ARCH \
        PATH="${GCCaPath}/bin:${GCCbPath}/bin:/usr/bin:${PATH}" \
        LD_LIBRARY_PATH="${GCCaPath}/lib:${GCCbPath}/lib:${LD_LIBRARY_PATH}" \
        CROSS_COMPILE=$for64- \
        CROSS_COMPILE_ARM32=$for32- ${MorePlusPlus}
    )
    TypeBuilderOld="$TypeBuilder"
    TypeBuilder="GCC"
    [[ ! -z "$TypeBuilderGcc" ]] && TypeBuilder="$TypeBuilderGcc"
    CompileNow ${@}
    TypeBuilder="$TypeBuilderOld"

}

CompileGccKernelB(){
    cd "${KernelPath}" 
    DisableLTO
    DisableRELR
    MorePlusPlus=" "
    [[ "$UseLLD" == "y" ]] && [[ -f ${GCCaPath}/bin/$for64-ld.lld ]] && MorePlusPlus="LD=${GCCaPath}/bin/$for64-ld.lld HOSTLD=${GCCaPath}/bin/$for64-ld.lld"
    if [[ "$UseLLD" == "y" ]] && [[ -f ${GCCbPath}/bin/$for32-ld.lld ]];then
        MorePlusPlus="LD_COMPAT=${GCCbPath}/bin/$for32-ld.lld $MorePlusPlus"
    else
        MorePlusPlus="LD_COMPAT=${GCCbPath}/bin/$for32-ld $MorePlusPlus"
    fi
    [[ -f ${GCCaPath}/bin/llvm-ar ]] && MorePlusPlus="AR=${GCCaPath}/bin/llvm-ar $MorePlusPlus"
    [[ -f ${GCCaPath}/bin/llvm-nm ]] && MorePlusPlus="NM=${GCCaPath}/bin/llvm-nm $MorePlusPlus"
    [[ -f ${GCCaPath}/bin/llvm-strip ]] && MorePlusPlus="STRIP=${GCCaPath}/bin/llvm-strip $MorePlusPlus"
    [[ -f ${GCCaPath}/bin/llvm-objcopy ]] && MorePlusPlus="OBJCOPY=${GCCaPath}/bin/llvm-objcopy $MorePlusPlus"
    [[ -f ${GCCaPath}/bin/llvm-objdump ]] && MorePlusPlus="OBJDUMP=${GCCaPath}/bin/llvm-objdump $MorePlusPlus"
    [[ -f ${GCCaPath}/bin/llvm-readelf ]] && MorePlusPlus="READELF=${GCCaPath}/bin/llvm-readelf $MorePlusPlus"
    [[ -f ${GCCaPath}/bin/llvm-ar ]] && MorePlusPlus="HOSTAR=${GCCaPath}/bin/llvm-ar $MorePlusPlus"
    echo "MorePlusPlus : $MorePlusPlus"

    SendInfoLink
    BUILD_START=$(date +"%s")
    make    -j"${TotalCores}"  O=out ARCH="${ARCH}" "${DEFFCONFIG}"
    MAKE=(
        ARCH=$ARCH \
        SUBARCH=$ARCH \
        PATH="${GCCaPath}/bin:${GCCbPath}/bin:/usr/bin:${PATH}" \
        LD_LIBRARY_PATH="${GCCaPath}/lib:${GCCbPath}/lib:${LD_LIBRARY_PATH}" \
        CROSS_COMPILE=$for64- \
        CROSS_COMPILE_ARM32=$for32- ${MorePlusPlus}
    )
    TypeBuilderOld="$TypeBuilder"
    TypeBuilder="GCC"
    [[ ! -z "$TypeBuilderGcc" ]] && TypeBuilder="$TypeBuilderGcc"
    CompileNow ${@}
    TypeBuilder="$TypeBuilderOld"
}

CompileClangKernelB(){
    cd "${KernelPath}" 
    [[ -d "${KernelPath}/KernelSU" ]] && [[ "$(cat arch/"$ARCH"/configs/"$DEFFCONFIG")" == "CONFIG_THINLTO=y" ]] && DisableLTO
    [[ "$NoLTO" != "n" ]] && DisableLTO
    SendInfoLink
    MorePlusPlus=" "
    if [[ ! -z "$(cat "$KernelPath"/out/.config | grep "CONFIG_LTO=y" )" ]] || [[ ! -z "$(cat "$KernelPath"/out/.config | grep "CONFIG_LTO_CLANG=y" )" ]] || [[ "$UseLLD" == "y" ]];then
        MorePlusPlus="LD=ld.lld HOSTLD=ld.lld LD_COMPAT=ld.lld $MorePlusPlus"
    else
        DisableRELR
        if [[ -f ${ClangPath}/bin/arm-linux-gnueabi-ld.lld ]];then
            MorePlusPlus="LD_COMPAT=${ClangPath}/bin/arm-linux-gnueabi-ld.lld $MorePlusPlus"
        else
            MorePlusPlus="LD_COMPAT=${ClangPath}/bin/arm-linux-gnueabi-ld $MorePlusPlus"
        fi
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
    fi
    CompileNow ${@}
}

CompileClangKernelLLVM(){
    cd "${KernelPath}" 
    [[ -d "${KernelPath}/KernelSU" ]] && [[ "$(cat arch/"$ARCH"/configs/"$DEFFCONFIG")" == "CONFIG_THINLTO=y" ]] && DisableLTO
    [[ "$NoLTO" != "n" ]] && DisableLTO
    SendInfoLink
    MorePlusPlus=" "
    PrefixDir=""
    if [[ "$UseZyCLLVM" == "y" ]];then
        PrefixDir="${MainClangZipPath}-zyc/bin/"
    else
        PrefixDir="${ClangPath}/bin/"
    fi
    if [[ "$TypeBuilder" != *"SDClang"* ]];then
        MorePlusPlus="HOSTCC=clang HOSTCXX=clang++"
    else
        MorePlusPlus="HOSTCC=gcc HOSTCXX=g++"
    fi
    if [[ "$UseGoldBinutils" == "y" ]];then
        MorePlusPlus="LD=aarch64-linux-gnu-ld.gold LDGOLD=aarch64-linux-gnu-ld.gold HOSTLD=${PrefixDir}ld $MorePlusPlus"
        DisableRELR
    elif [[ "$UseGoldBinutils" == "m" ]];then
        MorePlusPlus="LD=aarch64-linux-gnu-ld LDGOLD=aarch64-linux-gnu-ld.gold HOSTLD=${PrefixDir}ld $MorePlusPlus"
        DisableRELR
    else
        MorePlusPlus="LD=${PrefixDir}ld.lld HOSTLD=${PrefixDir}ld.lld $MorePlusPlus"
    fi
    if [[ "$UseOBJCOPYBinutils" == "y" ]];then
        MorePlusPlus="OBJCOPY=aarch64-linux-gnu-objcopy $MorePlusPlus"
    else
        MorePlusPlus="OBJCOPY=${PrefixDir}llvm-objcopy $MorePlusPlus"
    fi
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
                OBJDUMP=${PrefixDir}llvm-objdump \
                READELF=${PrefixDir}llvm-readelf \
                HOSTAR=${PrefixDir}llvm-ar ${MorePlusPlus} LLVM=1
        )
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
                OBJDUMP=${PrefixDir}llvm-objdump \
                READELF=${PrefixDir}llvm-readelf \
                HOSTAR=${PrefixDir}llvm-ar ${MorePlusPlus} LLVM=1
        )
    fi
    CompileNow ${@}
}

CompileClangKernelLLVMB(){
    cd "${KernelPath}" 
    [[ -d "${KernelPath}/KernelSU" ]] && [[ "$(cat arch/"$ARCH"/configs/"$DEFFCONFIG")" == "CONFIG_THINLTO=y" ]] && DisableLTO
    [[ "$NoLTO" != "n" ]] && DisableLTO
    SendInfoLink
    MorePlusPlus=" "
    PrefixDir=""
    if [[ "$UseZyCLLVM" == "y" ]];then
        PrefixDir="${MainClangZipPath}-zyc/bin/"
    elif [[ "$UseGCCLLVM" == "y" ]];then
        PrefixDir="${GCCaPath}/bin/"
    else
        PrefixDir="${ClangPath}/bin/"
    fi
    if [[ "$TypeBuilder" != *"SDClang"* ]];then
        MorePlusPlus="HOSTCC=clang HOSTCXX=clang++"
    else
        MorePlusPlus="HOSTCC=gcc HOSTCXX=g++"
    fi
    if [[ "$UseGoldBinutils" == "y" ]];then
        MorePlusPlus="LD=$for64-ld.gold LDGOLD=$for64-ld.gold HOSTLD=${PrefixDir}ld $MorePlusPlus"
        [[ "$UseGCCLLVM" == "y" ]] && MorePlusPlus="LD_COMPAT=$for32-ld.gold $MorePlusPlus"
        DisableRELR
    elif [[ "$UseGoldBinutils" == "m" ]];then
        MorePlusPlus="LD=$for64-ld LDGOLD=$for64-ld.gold HOSTLD=${PrefixDir}ld $MorePlusPlus"
        [[ "$UseGCCLLVM" == "y" ]] && MorePlusPlus="LD_COMPAT=$for32-ld $MorePlusPlus"
        DisableRELR
    else
        MorePlusPlus="LD=${PrefixDir}ld.lld HOSTLD=${PrefixDir}ld.lld $MorePlusPlus"
        [[ "$UseGCCLLVM" == "y" ]] && MorePlusPlus="LD_COMPAT=ld.lld $MorePlusPlus"
    fi
    if [[ "$UseOBJCOPYBinutils" == "y" ]];then
        MorePlusPlus="OBJCOPY=$for64-objcopy $MorePlusPlus"
    else
        MorePlusPlus="OBJCOPY=${PrefixDir}llvm-objcopy $MorePlusPlus"
    fi
    if [ -d "${ClangPath}/lib64" ];then
        MAKE=(
                ARCH=$ARCH \
                SUBARCH=$ARCH \
                PATH=${ClangPath}/bin:${GCCaPath}/bin:${GCCbPath}/bin:/usr/bin:${PATH} \
                LD_LIBRARY_PATH="${ClangPath}/lib64:${GCCaPath}/lib:${GCCbPath}/lib:${LD_LIBRARY_PATH}" \
                CC=clang \
                CROSS_COMPILE=$for64- \
                CROSS_COMPILE_ARM32=$for32- \
                CLANG_TRIPLE=aarch64-linux-gnu- \
                AR=${PrefixDir}llvm-ar \
                NM=${PrefixDir}llvm-nm \
                STRIP=${PrefixDir}llvm-strip \
                OBJDUMP=${PrefixDir}llvm-objdump \
                READELF=${PrefixDir}llvm-readelf \
                HOSTAR=${PrefixDir}llvm-ar ${MorePlusPlus} LLVM=1
        )
    else
        MAKE=(
                ARCH=$ARCH \
                SUBARCH=$ARCH \
                PATH=${ClangPath}/bin:${GCCaPath}/bin:${GCCbPath}/bin:/usr/bin:${PATH} \
                LD_LIBRARY_PATH="${ClangPath}/lib:${GCCaPath}/lib:${GCCbPath}/lib:${LD_LIBRARY_PATH}" \
                CC=clang \
                CROSS_COMPILE=$for64- \
                CROSS_COMPILE_ARM32=$for32- \
                CLANG_TRIPLE=aarch64-linux-gnu- \
                AR=${PrefixDir}llvm-ar \
                NM=${PrefixDir}llvm-nm \
                STRIP=${PrefixDir}llvm-strip \
                OBJDUMP=${PrefixDir}llvm-objdump \
                READELF=${PrefixDir}llvm-readelf \
                HOSTAR=${PrefixDir}llvm-ar ${MorePlusPlus} LLVM=1
        )
    fi
    CompileNow ${@}
}

CompileNow()
{
    BUILD_START=$(date +"%s")
    make -j"${TotalCores}"  O=out ARCH="$ARCH" "$DEFFCONFIG"
    getInfo "script : 'make -j${TotalCores} O=out ${MAKE[@]} LLVM_IAS=1'"
    make -j"${TotalCores}" O=out ${MAKE[@]} LLVM_IAS=1
    BUILD_END=$(date +"%s")
    DIFF=$((BUILD_END - BUILD_START))
    if [[ ! -e $KernelPath/out/arch/$ARCH/boot/${ImgName} ]];then
        MSG="<b>❌ Build failed</b>%0ABranch : <b>${KernelBranch}</b>%0ABuilder : <b>${rbranch}</b>%0A%0A- <code>$((DIFF / 60)) minute(s) $((DIFF % 60)) second(s)</code>%0A%0ASad Boy"
        . "$MainPath"/misc/bot.sh "send_info" "$MSG"
        exit 1
    fi
    cp -af "$KernelPath"/out/arch/"$ARCH"/boot/"${ImgName}" "$AnyKernelPath"
    KName=$(cat "${KernelPath}/arch/$ARCH/configs/$DEFFCONFIG" | grep "CONFIG_LOCALVERSION=" | sed 's/CONFIG_LOCALVERSION="-*//g' | sed 's/"*//g' )
    KName="${KName/'+'/'plus'}"
    ZipName="[$GetBD][$TypeBuilder]${TypeBuildTag}[$CODENAME]$KVer-$KName-$HeadCommitId.zip"
    [[ ! -z "$TypeBuildFor" ]] && ZipName="[$GetBD][$TypeBuildFor][$TypeBuilder]${TypeBuildTag}[$CODENAME]$KVer-$KName-$HeadCommitId.zip"
    if [[ "$TypeBuilder" == "GCC" ]];then
        CompilerStatus="- <code>${gcc32Type}</code>%0A- <code>${gcc64Type}</code>"
    elif [[ -z "$gcc64Type" ]] && [[ -z "$gcc32Type" ]];then
        CompilerStatus="- <code>${ClangType}</code>"
    else
        CompilerStatus="- <code>${ClangType}</code>%0A- <code>${gcc32Type}</code>%0A- <code>${gcc64Type}</code>"
    fi
    if [ ! -z "$1" ];then
        MakeZip "$1"
    else
        MakeZip
    fi
}

CreateMultipleDtb()
{
    if [[ ! -z "$MultipleDtbBranch" ]];then
        cd "${KernelPath}" 
        rm -rf "$AnyKernelPath"/dtb
        # git fetch origin "$KernelBranch" --unshallow
        for Ngesot in $MultipleDtbBranch
        do
            filename=$(echo "$Ngesot" | awk -F ':' '{print $1}')
            thecomm=$(echo "$Ngesot" | awk -F ':' '{print $2}')
            git reset --hard "$KernelBranch"
            git fetch origin "$thecomm" --depth=2
            git cherry-pick "$thecomm"
            make "${MAKE[@]}" O=out "$DEFFCONFIG" dtbo.img
            ( find "$KernelPath/out/arch/$ARCH/boot/dts/$AfterDTS" -name "*.dtb" -exec cat {} + > "$AnyKernelPath"/dtb-"$filename" )
            [[ ! -e "$AnyKernelPath/dtb-$filename" ]] && [[ ! -z "$BASE_DTB_NAME" ]] && cp "$KernelPath"/out/arch/"$ARCH"/boot/dts/"$AfterDTS"/"$BASE_DTB_NAME" "$AnyKernelPath"/dtb-"$filename"
        done
        cd "$AnyKernelPath"
    else
        if [[ "$UseDtb" == "y" ]];then
            ( find "$KernelPath/out/arch/$ARCH/boot/dts/$AfterDTS" -name "*.dtb" -exec cat {} + > "$AnyKernelPath"/dtb )
            [[ ! -e "$AnyKernelPath/dtb" ]] && [[ ! -z "$BASE_DTB_NAME" ]] && cp "$KernelPath"/out/arch/"$ARCH"/boot/dts/"$AfterDTS"/"$BASE_DTB_NAME" "$AnyKernelPath"/dtb
        fi
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
    cd "$AnyKernelPath" 
    if [ ! -z "$spectrumFile" ] && [ "$UseSpectrum" == "Y" ];then
        cp -af "$SpectrumPath"/"$spectrumFile" init.spectrum.rc && sed -i "s/persist.spectrum.kernel.*/persist.spectrum.kernel $KName/g" init.spectrum.rc
    fi
    cp -af anykernel-real.sh anykernel.sh && sed -i "s/kernel.string=.*/kernel.string=$KName-$HeadCommitId by ZyCromerZ/g" anykernel.sh
    [[ "$UseDtbo" == "y" ]] && cp -af "$KernelPath/out/arch/$ARCH/boot/dtbo.img" "$AnyKernelPath/dtbo.img"
    CreateMultipleDtb
    # remove placeholder file
    for asu in $(find . -name placeholder)
    do
        rm -rf "$asu"
    done
    # update zip name :v
    ZipName=${ZipName/"--"/"-"}
    if [ ! -z "$HasOcDtb" ];then
        zip -r9 "$ZipName-OC.zip" * -x .git README.md anykernel-real.sh .gitignore *.zip
        cp -af "$ZipName-OC.zip" ../"$ZipName-OC.zip" && rm -rf "$ZipName-OC.zip"
        KernelFilesOc="$(pwd)/../$ZipName-OC.zip"
    fi
    zip -r9 "$ZipName" * -x .git README.md anykernel-real.sh .gitignore *.zip "$DontInc"

    # remove dtb file after make a zip
    KernelFiles="$(pwd)/$ZipName"

    if [ ! -z "$1" ];then
        UploadKernel "$1"
    else
        UploadKernel
    fi
    
}

UploadKernel(){
    MD5CHECK=$(md5sum "${KernelFiles}" | cut -d' ' -f1)
    SHA1CHECK=$(sha1sum "${KernelFiles}" | cut -d' ' -f1)
    MSG="✅ <b>Build Success</b>%0A- <code>$((DIFF / 60)) minute(s) $((DIFF % 60)) second(s) </code>%0A%0A<b>MD5 Checksum</b>%0A- <code>$MD5CHECK</code>%0A%0A<b>SHA1 Checksum</b>%0A- <code>$SHA1CHECK</code>%0A%0A<b>Under Commit Id : Message</b>%0A- <code>${HeadCommitId}</code> : <code>${HeadCommitMsg}</code>%0A%0A<b>Compilers</b>%0A$CompilerStatus%0A%0A<b>Zip Name</b>%0A- <code>$ZipName</code>"

    [ ! -z "${DRONE_BRANCH}" ] && doOsdnUp="" && doSFUp=""

    if [ "${CustomUploader}" == "Y" ];then
        cd "$UploaderPath" 
        chmod +x "${UploaderPath}/run.sh"
        . "${UploaderPath}/run.sh" "$KernelFiles" "$FolderUp" "$GetCBD" "$ExFolder"
        if [ ! -z "$HasOcDtb" ];then
            . "${UploaderPath}/run.sh" "$KernelFilesOc" "$FolderUp" "$GetCBD" "$ExFolder"
        fi
        if [ ! -z "$1" ];then
            . "${MainPath}"/misc/bot.sh "send_info" "$MSG" "$1"
        else
            . "${MainPath}"/misc/bot.sh "send_info" "$MSG"
        fi
    else
        if [ ! -z "$1" ];then
            if [ ! -z "$HasOcDtb" ];then
                . "${MainPath}"/misc/bot.sh "send_files" "$KernelFilesOc" "$MSG" "$1"
            fi
            . "${MainPath}"/misc/bot.sh "send_files" "$KernelFiles" "$MSG" "$1"
        else
            if [ ! -z "$HasOcDtb" ];then
                . "${MainPath}"/misc/bot.sh "send_files" "$KernelFilesOc" "$MSG"
            fi
            . "${MainPath}"/misc/bot.sh "send_files" "$KernelFiles" "$MSG"
        fi
    fi
    if [ "$KernelDownloader" == "Y" ] && [ ! -z "${KDType}" ];then
        git clone https://"$GIT_SECRETB"@github.com/"$GIT_USERNAME"/kernel-download-generator "$KDpath"
        cd "$KDpath" 
        chmod +x "${KDpath}/update.sh"
        . "${KDpath}/update.sh" "${KDType}"
        cd "$MainPath" 
        rm -rf "$KDpath"
    fi
    
    # always remove after push kernel zip
    for FIleName in Image Image-dtb Image.gz Image.gz-dtb dtb dtb.img dt dt.img dtbo dtbo.img init.spectrum.rc dtb-*
    do
        rm -rf "$AnyKernelPath"/"$FIleName"
    done
    rm -rf "$KernelFilesOc"
    # remove kernel zip
    rm -rf "$AnyKernelPath/$ZipName"
    rm -rf "$KernelPath"/out/arch/"$ARCH"/boot/dtbo.img "$KernelPath"/out/arch/"$ARCH"/boot/dtbo.img "$KernelPath"/out/arch/"$ARCH"/boot/"${ImgName}"
    
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
        . "$MainPath"/misc/bot.sh "send_info" "$MSG"
        FirstSendInfoLink="Y"
    fi
}

pullBranch(){
    [[ "$(pwd)" != "${KernelPath}" ]] && cd "${KernelPath}" 
    git reset --hard "$HeadCommitId"
    git fetch origin "$1"
    git pull --no-commit origin "$1"
    git commit -s -m "Pull branch $1"
    TypeBuildTag="$2"
}

pullBranchAgain(){
    [[ "$(pwd)" != "${KernelPath}" ]] && cd "${KernelPath}" 
    git fetch origin "$1"
    git pull --no-commit origin "$1"
    git commit -s -m "Pull branch $1"
    TypeBuildTag="$2"
}

DisableLTO(){
    [[ "$(pwd)" != "${KernelPath}" ]] && cd "${KernelPath}" 
    sed -i "s/CONFIG_LTO=y/CONFIG_LTO=n/" arch/"$ARCH"/configs/"$DEFFCONFIG"
    sed -i "s/CONFIG_LTO_CLANG=y/CONFIG_LTO_CLANG=n/" arch/"$ARCH"/configs/"$DEFFCONFIG"
    git add arch/"$ARCH"/configs/"$DEFFCONFIG" && git commit -sm 'defconfig: Disable LTO'
}

DisableThin(){
    [[ "$(pwd)" != "${KernelPath}" ]] && cd "${KernelPath}" 
    sed -i "s/CONFIG_THINLTO=y/CONFIG_THINLTO=n/" arch/"$ARCH"/configs/"$DEFFCONFIG"
    git add arch/"$ARCH"/configs/"$DEFFCONFIG" && git commit -sm 'defconfig: Disable THINLTO'
}

EnableWalt(){
    [[ "$(pwd)" != "${KernelPath}" ]] && cd "${KernelPath}" 
    sed -i "s/# CONFIG_SCHED_WALT is not set/CONFIG_SCHED_WALT=y/" arch/"$ARCH"/configs/"$DEFFCONFIG"
    git add arch/"$ARCH"/configs/"$DEFFCONFIG" && git commit -sm 'defconfig: Enable WALT'
}

DisableWalt(){
    [[ "$(pwd)" != "${KernelPath}" ]] && cd "${KernelPath}" 
    sed -i "s/CONFIG_SCHED_WALT=y/CONFIG_SCHED_WALT=n/" arch/"$ARCH"/configs/"$DEFFCONFIG"
    git add arch/"$ARCH"/configs/"$DEFFCONFIG" && git commit -sm 'defconfig: Disable WALT'
}

DisableMsmP(){
    [[ "$(pwd)" != "${KernelPath}" ]] && cd "${KernelPath}" 
    sed -i "s/CONFIG_MSM_PERFORMANCE=y/CONFIG_MSM_PERFORMANCE=n/" arch/"$ARCH"/configs/"$DEFFCONFIG"
    git add arch/"$ARCH"/configs/"$DEFFCONFIG" && git commit -sm 'defconfig: Disable MSM_PERFORMANCE'   
}

DisableKCAL(){
    [[ "$(pwd)" != "${KernelPath}" ]] && cd "${KernelPath}" 
    sed -i "s/CONFIG_DRM_MSM_KCAL_CTRL=y/CONFIG_DRM_MSM_KCAL_CTRL=n/" arch/"$ARCH"/configs/"$DEFFCONFIG"
    git add arch/"$ARCH"/configs/"$DEFFCONFIG" && git commit -sm 'defconfig: Disable DRM_MSM_KCAL_CTRL' 
}

OptimizeForSize()
{
    [[ "$(pwd)" != "${KernelPath}" ]] && cd "${KernelPath}" 
    sed -i "s/# CONFIG_CC_OPTIMIZE_FOR_SIZE is not set/CONFIG_CC_OPTIMIZE_FOR_SIZE=y/" arch/"$ARCH"/configs/"$DEFFCONFIG"
    sed -i "s/CONFIG_CC_OPTIMIZE_FOR_PERFORMANCE=y/# CONFIG_CC_OPTIMIZE_FOR_PERFORMANCE is not set/" arch/"$ARCH"/configs/"$DEFFCONFIG"
    git add arch/"$ARCH"/configs/"$DEFFCONFIG" && git commit -sm 'defconfig: Optimize for size' 
}

OptimizeForPerf()
{
    [[ "$(pwd)" != "${KernelPath}" ]] && cd "${KernelPath}" 
    sed -i "s/# CONFIG_CC_OPTIMIZE_FOR_PERFORMANCE is not set/CONFIG_CC_OPTIMIZE_FOR_PERFORMANCE=y/" arch/"$ARCH"/configs/"$DEFFCONFIG"
    sed -i "s/CONFIG_CC_OPTIMIZE_FOR_SIZE=y/# CONFIG_CC_OPTIMIZE_FOR_SIZE is not set/" arch/"$ARCH"/configs/"$DEFFCONFIG"
    git add arch/"$ARCH"/configs/"$DEFFCONFIG" && git commit -sm 'defconfig: Optimize for Performance' 
}

EnableSCS()
{
    [[ "$(pwd)" != "${KernelPath}" ]] && cd "${KernelPath}" 
    sed -i "s/# CONFIG_SHADOW_CALL_STACK is not set/CONFIG_SHADOW_CALL_STACK=y/" arch/"$ARCH"/configs/"$DEFFCONFIG"
    echo "" >> arch/"$ARCH"/configs/"$DEFFCONFIG"
    echo "CONFIG_SHADOW_CALL_STACK_VMAP=y" >> arch/"$ARCH"/configs/"$DEFFCONFIG"
    git add arch/"$ARCH"/configs/"$DEFFCONFIG" && git commit -sm 'defconfig: enable SCS' 
}

EnableRELR()
{
    [[ "$(pwd)" != "${KernelPath}" ]] && cd "${KernelPath}" 
    sed -i "s/# CONFIG_TOOLS_SUPPORT_RELR is not set/CONFIG_TOOLS_SUPPORT_RELR=y/" arch/"$ARCH"/configs/"$DEFFCONFIG"
    git add arch/"$ARCH"/configs/"$DEFFCONFIG" && git commit -sm 'defconfig: enable TOOLS_SUPPORT_RELR'  
}

DisableRELR()
{
    [[ "$(pwd)" != "${KernelPath}" ]] && cd "${KernelPath}" 
    sed -i "s/CONFIG_TOOLS_SUPPORT_RELR=y/# CONFIG_TOOLS_SUPPORT_RELR is not set/" arch/"$ARCH"/configs/"$DEFFCONFIG"
    git add arch/"$ARCH"/configs/"$DEFFCONFIG" && git commit -sm 'defconfig: disable TOOLS_SUPPORT_RELR'  
}

ChangeConfigData()
{
    [[ "$(pwd)" != "${KernelPath}" ]] && cd "${KernelPath}" 
    if [[ ! -z "$DEFFCONFIGB" ]] && [[ -f "arch/arm64/configs/$DEFFCONFIGB" ]];then
        sed -i "s/\$(KCONFIG_CONFIG)/arch\/arm64\/configs\/$DEFFCONFIGB/" kernel/Makefile
        git add kernel/Makefile && git commit -sm "kernel: Makefile: change defconfig for /proc/config.gz"
    fi
}

DebugMissBypass()
{
    [[ "$(pwd)" != "${KernelPath}" ]] && cd "${KernelPath}" 
    addToConf "arch/${ARCH}/configs/${DEFFCONFIG}" "CONFIG_DEBUG_SECTION_MISMATCH"
    addToConf "arch/${ARCH}/configs/${DEFFCONFIG}" "CONFIG_SECTION_MISMATCH_WARN_ONLY"
    git add "arch/${ARCH}/configs/${DEFFCONFIG}" && git commit -sm 'enable CONFIG_DEBUG_SECTION_MISMATCH CONFIG_SECTION_MISMATCH_WARN_ONLY'
}