#! /bin/bash

CloneCompiledGcc(){
    [[ "$(pwd)" != "${MainPath}" ]] && cd "${MainPath}"
    GCCaPath="$MainZipGCCaPath"
    GCCbPath="$MainZipGCCbPath"
    rm -rf ${GCCaPath}/aarch64-linux-gnu ${GCCbPath}/arm-linux-gnueabi
    [[ ! -d ${GCCaPath} ]] && mkdir "${GCCaPath}"
    [[ ! -d ${GCCbPath} ]] && mkdir "${GCCbPath}"
    rm -rf ${GCCaPath}/* ${GCCbPath}/*
    if [ ! -e "${MainPath}/arm-linux-gnueabi-10.x-gnu-20210311.tar.gz" ];then
        wget -q https://gcc-drive.zyc-files.workers.dev/0:/arm-linux-gnueabi-10.x-gnu-20210311.tar.gz
    fi
    tar -xf arm-linux-gnueabi-10.x-gnu-20210311.tar.gz -C $GCCbPath
    rm -rf arm-linux-gnueabi-10.x-gnu-20210311.tar.gz
    GCCbPath="${GCCbPath}/arm-linux-gnueabi"
    for32=arm-linux-gnueabi
    if [ ! -e "${MainPath}/aarch64-linux-gnu-10.x-gnu-20210311.tar.gz" ];then
        wget -q https://gcc-drive.zyc-files.workers.dev/0:/aarch64-linux-gnu-10.x-gnu-20210311.tar.gz
    fi
    tar -xf aarch64-linux-gnu-10.x-gnu-20210311.tar.gz -C $GCCaPath
    rm -rf aarch64-linux-gnu-10.x-gnu-20210311.tar.gz
    GCCaPath="${GCCaPath}/aarch64-linux-gnu"
    for64=aarch64-linux-gnu
    GetGccVersion
}

# CloneCompiledGccEleven(){
#     [[ "$(pwd)" != "${MainPath}" ]] && cd "${MainPath}"
#     GCCaPath="$MainZipGCCaPath"
#     GCCbPath="$MainZipGCCbPath"
#     rm -rf ${GCCaPath}/* ${GCCbPath}/*
#     [[ ! -d ${GCCaPath} ]] && mkdir "${GCCaPath}"
#     [[ ! -d ${GCCbPath} ]] && mkdir "${GCCbPath}"
#     if [ ! -e "${MainPath}/arm-zyc-linux-gnueabi-11.x-gnu-20210905.tar.gz" ];then
#         wget -q  https://github.com/ZyCromerZ/compiled-gcc/releases/download/varm-zyc-linux-gnueabi-11.x-gnu-20210905/arm-zyc-linux-gnueabi-11.x-gnu-20210905.tar.gz
#     fi
#     tar -xf arm-zyc-linux-gnueabi-11.x-gnu-20210905.tar.gz -C $GCCbPath
#     GCCbPath="${GCCbPath}/arm-zyc-linux-gnueabi"
#     for32=arm-zyc-linux-gnueabi
#     if [ ! -e "${MainPath}/aarch64-zyc-linux-gnu-11.x-gnu-20210905.tar.gz" ];then
#         wget -q https://github.com/ZyCromerZ/compiled-gcc/releases/download/vaarch64-zyc-linux-gnu-11.x-gnu-20210905/aarch64-zyc-linux-gnu-11.x-gnu-20210905.tar.gz
#     fi
#     tar -xf aarch64-zyc-linux-gnu-11.x-gnu-20210905.tar.gz -C $GCCaPath
#     GCCaPath="${GCCaPath}/aarch64-zyc-linux-gnu"
#     for64=aarch64-zyc-linux-gnu
#     GetGccVersion
# }


CloneCompiledGccEleven(){
    [[ "$(pwd)" != "${MainPath}" ]] && cd "${MainPath}"
    GCCaPath="${MainGCCaPath}"
    if [ ! -d "$GCCaPath" ];then
        git clone https://github.com/ZyCromerZ/aarch64-zyc-linux-gnu.git -b 11 $GCCaPath --depth=1
    else
        cd "${GCCaPath}"
        git fetch https://github.com/ZyCromerZ/aarch64-zyc-linux-gnu.git 11 --depth=1
        git checkout FETCH_HEAD
        [[ ! -z "$(git branch | grep 11)" ]] && git branch -D 11
        git checkout -b 11
    fi
    for64=aarch64-zyc-linux-gnu
    [[ "$(pwd)" != "${MainPath}" ]] && cd "${MainPath}"
    GCCbPath="${MainGCCbPath}"
    if [ ! -d "$GCCbPath" ];then
        git clone https://github.com/ZyCromerZ/arm-zyc-linux-gnueabi.git -b 11 $GCCbPath --depth=1
    else
        cd "${GCCbPath}"
        git fetch https://github.com/ZyCromerZ/arm-zyc-linux-gnueabi.git 11 --depth=1
        git checkout FETCH_HEAD
        [[ ! -z "$(git branch | grep 11)" ]] && git branch -D 11
        git checkout -b 11
    fi
    for32=arm-zyc-linux-gnueabi
    GetGccVersion
    TypeBuilderGcc="GCC-11"
}


CloneGCCOld(){
    [[ "$(pwd)" != "${MainPath}" ]] && cd "${MainPath}"
    GCCaPath="${MainGCCaPath}"
    if [ ! -d "$GCCaPath" ];then
        git clone https://github.com/ZyCromerZ/aarch64-linux-android-4.9.git -b android-12.0.0_r15 $GCCaPath --depth=1
    else
        cd "${GCCaPath}"
        git fetch https://github.com/ZyCromerZ/aarch64-linux-android-4.9.git android-12.0.0_r15 --depth=1
        git checkout FETCH_HEAD
        [[ ! -z "$(git branch | grep android-12.0.0_r15)" ]] && git branch -D android-12.0.0_r15
        git checkout -b android-12.0.0_r15
    fi
    for64=aarch64-linux-android
    [[ "$(pwd)" != "${MainPath}" ]] && cd "${MainPath}"
    GCCbPath="${MainGCCbPath}"
    if [ ! -d "$GCCbPath" ];then
        git clone https://github.com/ZyCromerZ/arm-linux-androideabi-4.9.git -b android-12.0.0_r15 $GCCbPath --depth=1
    else
        cd "${GCCbPath}"
        git fetch https://github.com/ZyCromerZ/arm-linux-androideabi-4.9.git android-12.0.0_r15 --depth=1
        git checkout FETCH_HEAD
        [[ ! -z "$(git branch | grep android-12.0.0_r15)" ]] && git branch -D android-12.0.0_r15
        git checkout -b android-12.0.0_r15
    fi
    for32=arm-linux-androideabi
    GetGccVersion
    ls $GCCaPath
    ls $GCCbPath
}

CloneGccten(){
    [[ "$(pwd)" != "${MainPath}" ]] && cd "${MainPath}"
    GCCaPath="$MainZipGCCaPath"
    GCCbPath="$MainZipGCCbPath"
    [[ ! -d ${GCCaPath} ]] && mkdir "${GCCaPath}"
    [[ ! -d ${GCCbPath} ]] && mkdir "${GCCbPath}"
    rm -rf ${GCCaPath}/* ${GCCbPath}/*
    if [ ! -e "${MainPath}/gcc-arm-10.2-2020.11-x86_64-arm-none-linux-gnueabihf.tar.xz" ];then
        wget -q https://armkeil.blob.core.windows.net/developer/Files/downloads/gnu-a/10.2-2020.11/binrel/gcc-arm-10.2-2020.11-x86_64-arm-none-linux-gnueabihf.tar.xz
        tar -xf gcc-arm-10.2-2020.11-x86_64-arm-none-linux-gnueabihf.tar.xz -C $GCCbPath
        rm -rf gcc-arm-10.2-2020.11-x86_64-arm-none-linux-gnueabihf.tar.xz
    fi
    GCCbPath="${GCCbPath}/gcc-arm-10.2-2020.11-x86_64-arm-none-linux-gnueabihf"
    for32=arm-none-linux-gnueabihf
    if [ ! -e "${MainPath}/gcc-arm-10.2-2020.11-x86_64-aarch64-none-elf.tar.xz" ];then
        wget -q https://armkeil.blob.core.windows.net/developer/Files/downloads/gnu-a/10.2-2020.11/binrel/gcc-arm-10.2-2020.11-x86_64-aarch64-none-elf.tar.xz
        tar -xf gcc-arm-10.2-2020.11-x86_64-aarch64-none-elf.tar.xz -C $GCCaPath
        rm -rf gcc-arm-10.2-2020.11-x86_64-aarch64-none-elf.tar.xz
    fi
    GCCaPath="${GCCaPath}/gcc-arm-10.2-2020.11-x86_64-aarch64-none-elf"
    for64=aarch64-none-elf
    GetGccVersion
}

# CloneCompiledGccTwelve(){
#     [[ "$(pwd)" != "${MainPath}" ]] && cd "${MainPath}"
#     GCCaPath="$MainZipGCCaPath"
#     GCCbPath="$MainZipGCCbPath"
#     rm -rf ${GCCaPath}/* ${GCCbPath}/*
#     [[ ! -d ${GCCaPath} ]] && mkdir "${GCCaPath}"
#     [[ ! -d ${GCCbPath} ]] && mkdir "${GCCbPath}"
#     if [ ! -e "${MainPath}/arm-zyc-linux-gnueabi-12.x-gnu-20210920.tar.gz" ];then
#         wget -q  https://github.com/ZyCromerZ/compiled-gcc/releases/download/varm-zyc-linux-gnueabi-12.x-gnu-20210920/arm-zyc-linux-gnueabi-12.x-gnu-20210920.tar.gz
#     fi
#     tar -xf arm-zyc-linux-gnueabi-12.x-gnu-20210920.tar.gz -C $GCCbPath
#     GCCbPath="${GCCbPath}/arm-zyc-linux-gnueabi"
#     for32=arm-zyc-linux-gnueabi
#     if [ ! -e "${MainPath}/aarch64-zyc-linux-gnu-12.x-gnu-20210920.tar.gz" ];then
#         wget -q https://github.com/ZyCromerZ/compiled-gcc/releases/download/vaarch64-zyc-linux-gnu-12.x-gnu-20210920/aarch64-zyc-linux-gnu-12.x-gnu-20210920.tar.gz
#     fi
#     tar -xf aarch64-zyc-linux-gnu-12.x-gnu-20210920.tar.gz -C $GCCaPath
#     GCCaPath="${GCCaPath}/aarch64-zyc-linux-gnu"
#     for64=aarch64-zyc-linux-gnu
#     GetGccVersion
# }


CloneCompiledGccTwelve(){
    [[ "$(pwd)" != "${MainPath}" ]] && cd "${MainPath}"
    GCCaPath="${MainGCCaPath}"
    if [ ! -d "$GCCaPath" ];then
        git clone https://github.com/ZyCromerZ/aarch64-zyc-linux-gnu.git -b 12 $GCCaPath --depth=1
    else
        cd "${GCCaPath}"
        git fetch https://github.com/ZyCromerZ/aarch64-zyc-linux-gnu.git 12 --depth=1
        git checkout FETCH_HEAD
        [[ ! -z "$(git branch | grep 12)" ]] && git branch -D 12
        git checkout -b 12
    fi
    for64=aarch64-zyc-linux-gnu
    [[ "$(pwd)" != "${MainPath}" ]] && cd "${MainPath}"
    GCCbPath="${MainGCCbPath}"
    if [ ! -d "$GCCbPath" ];then
        git clone https://github.com/ZyCromerZ/arm-zyc-linux-gnueabi.git -b 12 $GCCbPath --depth=1
    else
        cd "${GCCbPath}"
        git fetch https://github.com/ZyCromerZ/arm-zyc-linux-gnueabi.git 12 --depth=1
        git checkout FETCH_HEAD
        [[ ! -z "$(git branch | grep 12)" ]] && git branch -D 12
        git checkout -b 12
    fi
    for32=arm-zyc-linux-gnueabi
    GetGccVersion
    TypeBuilderGcc="GCC-12"
}

CloneCompiledGccThirteen(){
    [[ "$(pwd)" != "${MainPath}" ]] && cd "${MainPath}"
    GCCaPath="${MainGCCaPath}"
    if [ ! -d "$GCCaPath" ];then
        git clone https://github.com/ZyCromerZ/aarch64-zyc-linux-gnu.git -b 13 $GCCaPath --depth=1
    else
        cd "${GCCaPath}"
        git fetch https://github.com/ZyCromerZ/aarch64-zyc-linux-gnu.git 13 --depth=1
        git checkout FETCH_HEAD
        [[ ! -z "$(git branch | grep 13)" ]] && git branch -D 13
        git checkout -b 13
    fi
    for64=aarch64-zyc-linux-gnu
    [[ "$(pwd)" != "${MainPath}" ]] && cd "${MainPath}"
    GCCbPath="${MainGCCbPath}"
    if [ ! -d "$GCCbPath" ];then
        git clone https://github.com/ZyCromerZ/arm-zyc-linux-gnueabi.git -b 13 $GCCbPath --depth=1
    else
        cd "${GCCbPath}"
        git fetch https://github.com/ZyCromerZ/arm-zyc-linux-gnueabi.git 13 --depth=1
        git checkout FETCH_HEAD
        [[ ! -z "$(git branch | grep 13)" ]] && git branch -D 13
        git checkout -b 13
    fi
    for32=arm-zyc-linux-gnueabi
    GetGccVersion
    TypeBuilderGcc="GCC-13"
}

CloneCompiledGccFourteen(){
    [[ "$(pwd)" != "${MainPath}" ]] && cd "${MainPath}"
    GCCaPath="${MainGCCaPath}"
    if [ ! -d "$GCCaPath" ];then
        git clone https://github.com/ZyCromerZ/aarch64-zyc-linux-gnu.git -b 14 $GCCaPath --depth=1
    else
        cd "${GCCaPath}"
        git fetch https://github.com/ZyCromerZ/aarch64-zyc-linux-gnu.git 14 --depth=1
        git checkout FETCH_HEAD
        [[ ! -z "$(git branch | grep 14)" ]] && git branch -D 14
        git checkout -b 14
    fi
    for64=aarch64-zyc-linux-gnu
    [[ "$(pwd)" != "${MainPath}" ]] && cd "${MainPath}"
    GCCbPath="${MainGCCbPath}"
    if [ ! -d "$GCCbPath" ];then
        git clone https://github.com/ZyCromerZ/arm-zyc-linux-gnueabi.git -b 14 $GCCbPath --depth=1
    else
        cd "${GCCbPath}"
        git fetch https://github.com/ZyCromerZ/arm-zyc-linux-gnueabi.git 14 --depth=1
        git checkout FETCH_HEAD
        [[ ! -z "$(git branch | grep 14)" ]] && git branch -D 14
        git checkout -b 14
    fi
    for32=arm-zyc-linux-gnueabi
    GetGccVersion
    TypeBuilderGcc="GCC-14"
}

GetGccVersion()
{
    if [ -e $GCCbPath/bin/$for32-gcc ];then
        gcc32Type="$($GCCbPath/bin/$for32-gcc --version | head -n 1)"
    else
        cd ${GCCbPath}
        gcc32Type="$($GCCbPath/bin/$for32-ld --version | head -n 1)"
        cd ${MainPath}
    fi
    if [ -e $GCCaPath/bin/$for64-gcc ];then
        gcc64Type="$($GCCaPath/bin/$for64-gcc --version | head -n 1)"
    else
        cd ${GCCaPath}
        gcc64Type="$($GCCaPath/bin/$for64-ld --version | head -n 1)"
        cd ${MainPath}
    fi
}