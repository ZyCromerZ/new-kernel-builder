#! /bin/bash

CloneGugelClang(){
    ClangPath=${MainClangPath}
    [[ "$(pwd)" != "${MainPath}" ]] && cd "${MainPath}"
    if [ ! -d "${ClangPath}" ];then
        git clone https://github.com/ZyCromerZ/google-clang -b 9.0.4-r353983d "${ClangPath}" --depth=1
    else
        cd "${ClangPath}"
        git fetch https://github.com/ZyCromerZ/google-clang 9.0.4-r353983d --depth=1
        git checkout FETCH_HEAD
        [[ ! -z "$(git branch | grep 9.0.4-r353983d)" ]] && git branch -D 9.0.4-r353983d
        git checkout -b 9.0.4-r353983d
    fi
    TypeBuilder="CLANG"
    ClangType="$(${ClangPath}/bin/clang --version | head -n 1)"
}

CloneThirteenGugelClang(){
    ClangPath=${MainClangZipPath}
    [[ "$(pwd)" != "${MainPath}" ]] && cd "${MainPath}"
    [[ ! -d ${MainClangZipPath} ]] && mkdir $ClangPath
    rm -rf $ClangPath/*
    if [ ! -e "${MainPath}/clang-r433403b.tar.gz" ];then
        wget -q  https://android.googlesource.com/platform/prebuilts/clang/host/linux-x86/+archive/3a785d33320c48b09f7d6fcf2a37fed702686fdc/clang-r433403b.tar.gz -O "clang-r433403b.tar.gz"
    fi
    tar -xf clang-r433403b.tar.gz -C $ClangPath
    rm -rf clang-r433403b.tar.gz
    TypeBuilder="GCLANG-13"
    ClangType="$(${ClangPath}/bin/clang --version | head -n 1)"
}

CloneFourteenGugelClang(){
    ClangPath=${MainClangZipPath}
    [[ "$(pwd)" != "${MainPath}" ]] && cd "${MainPath}"
    [[ ! -d ${MainClangZipPath} ]] && mkdir $ClangPath
    rm -rf $ClangPath/*
    if [ ! -e "${MainPath}/clang-r437112.tar.gz" ];then
        wget -q  https://android.googlesource.com/platform/prebuilts/clang/host/linux-x86/+archive/3a785d33320c48b09f7d6fcf2a37fed702686fdc/clang-r437112.tar.gz -O "clang-r437112.tar.gz"
    fi
    tar -xf clang-r437112.tar.gz -C $ClangPath
    rm -rf clang-r437112.tar.gz
    TypeBuilder="GCLANG-14"
    ClangType="$(${ClangPath}/bin/clang --version | head -n 1)"
}

CloneOldDTCClang(){
    ClangPath=${MainClangPath}
    [[ "$(pwd)" != "${MainPath}" ]] && cd "${MainPath}"
    if [ ! -d "${ClangPath}" ];then
        git clone https://github.com/nibaji/DragonTC-8.0 -b master "${ClangPath}" --depth=1
    else
        cd "${ClangPath}"
        git fetch https://github.com/nibaji/DragonTC-8.0 master --depth=1
        git checkout FETCH_HEAD
        [[ ! -z "$(git branch | grep master)" ]] && git branch -D master
        git checkout -b master
    fi
    TypeBuilder="DTC-OLD"
    ClangType="$(${ClangPath}/bin/clang --version | head -n 1)"
}

CloneDTCClang(){
    ClangPath=${MainClangPath}
    [[ "$(pwd)" != "${MainPath}" ]] && cd "${MainPath}"
    if [ ! -d "${ClangPath}" ];then
        git clone https://github.com/NusantaraDevs/DragonTC -b 10.0 "${ClangPath}" --depth=1
    else
        cd "${ClangPath}"
        git fetch https://github.com/NusantaraDevs/DragonTC 10.0 --depth=1
        git checkout FETCH_HEAD
        [[ ! -z "$(git branch | grep 10.0)" ]] && git branch -D 10.0
        git checkout -b 10.0
    fi
    TypeBuilder="DTC"
    ClangType="$(${ClangPath}/bin/clang --version | head -n 1)"
}

CloneProtonClang(){
    ClangPath=${MainClangPath}
    [[ "$(pwd)" != "${MainPath}" ]] && cd "${MainPath}"
    if [ ! -d "${ClangPath}" ];then
        git clone https://github.com/kdrag0n/proton-clang -b master "${ClangPath}" --depth=1
    else
        cd "${ClangPath}"
        git fetch https://github.com/kdrag0n/proton-clang master --depth=1
        git checkout FETCH_HEAD
        [[ ! -z "$(git branch | grep master)" ]] && git branch -D master
        git checkout -b master
    fi
    TypeBuilder="Proton"
    ClangType="$(${ClangPath}/bin/clang --version | head -n 1)"
}

# CloneSdClang(){
#     ClangPath=${MainClangZipPath}
#     Fail="n"
#     [[ "$(pwd)" != "${MainPath}" ]] && cd "${MainPath}"
#     [[ ! -d ${MainClangZipPath} ]] && mkdir $ClangPath
#     rm -rf $ClangPath/*
#     if [ ! -e "${MainPath}/SDClang.zip" ];then
#         wget -q  https://github.com/ZyCromerZ/Clang/releases/download/sdclang-14-release/SDClang-14.0.0.zip -O "SDClang.zip"
#     fi
#     unzip -P ${ZIP_PASS} SDClang.zip -d $ClangPath || Fail="y"
#     rm -rf SDClang.zip
#     TypeBuilder="SDClang"
#     ClangType="$(${ClangPath}/bin/clang --version | head -n 1)"
#     [[ -z "${ZIP_PASS}" ]] && Fail="y"
#     if [[ "$Fail" == "y" ]];then
#         getInfo "Clone SD clang failed, cloning ZyC Clang instead"
#         CloneZyCFoutTeenClang
#     fi
#     Fail=""
# }

ClonePrepSdClang(){
    ClangPath=${MainClangZipPath}
    Fail="n"
    [[ "$(pwd)" != "${MainPath}" ]] && cd "${MainPath}"
    [[ ! -d ${MainClangZipPath} ]] && mkdir $ClangPath
    rm -rf $ClangPath/*
    if [ ! -e "${MainPath}/SDClang-14.1.5.0.zip" ];then
        wget -q  https://github.com/ZyCromerZ/Clang/releases/download/sdclang-14-release/SDClang-14.1.5.0.zip -O "SDClang-14.1.5.0.zip"
    fi
    unzip -P ${ZIP_PASS} SDClang-14.1.5.0.zip -d $ClangPath
    TypeBuilder="SDClang"
    ClangType="$(${ClangPath}/bin/clang --version | head -n 1)"
    [[ -z "${ZIP_PASS}" ]] && Fail="y"
    if [[ "$Fail" == "y" ]];then
        getInfo "Clone SD clang failed, cloning ZyC Clang instead"
        CloneZyCFoutTeenClang
    fi
    Fail=""
}

ClonePrepSdClangB(){
    ClangPath=${MainClangZipPath}
    Fail="n"
    [[ "$(pwd)" != "${MainPath}" ]] && cd "${MainPath}"
    [[ ! -d ${MainClangZipPath} ]] && mkdir $ClangPath
    rm -rf $ClangPath/*
    if [ ! -e "${MainPath}/SDClang-16.0.2.0.zip" ];then
        wget -q  https://github.com/ZyCromerZ/Clang/releases/download/sdclang-14-release/SDClang-16.0.2.0.zip -O "SDClang-16.0.2.0.zip"
    fi
    unzip -P ${ZIP_PASS} SDClang-16.0.2.0.zip -d $ClangPath
    TypeBuilder="SDClang"
    ClangType="$(${ClangPath}/bin/clang --version | head -n 1)"
    [[ -z "${ZIP_PASS}" ]] && Fail="y"
    if [[ "$Fail" == "y" ]];then
        getInfo "Clone SD clang failed, cloning ZyC Clang instead"
        CloneZyCFoutTeenClang
    fi
    Fail=""
}

CloneSdClang(){
    ClangPath=${MainClangPath}
    [[ "$(pwd)" != "${MainPath}" ]] && cd "${MainPath}"
    if [ ! -d "${ClangPath}" ];then
        git clone https://${GIT_SECRET}@github.com/ZyCromerZ/SDClang -b 14 "${ClangPath}" --depth=1
    else
        cd "${ClangPath}"
        git fetch https://${GIT_SECRET}@github.com/ZyCromerZ/SDClang 14 --depth=1
        git checkout FETCH_HEAD
        [[ ! -z "$(git branch | grep 14)" ]] && git branch -D 14
        git checkout -b 14
    fi
    TypeBuilder="SDClang-14"
    ClangType="$(${ClangPath}/bin/clang --version | head -n 1)"
}

CloneSdClangB(){
    ClangPath=${MainClangPath}
    [[ "$(pwd)" != "${MainPath}" ]] && cd "${MainPath}"
    if [ ! -d "${ClangPath}" ];then
        git clone https://${GIT_SECRET}@github.com/ZyCromerZ/SDClang -b 14.0.3 "${ClangPath}" --depth=1
    else
        cd "${ClangPath}"
        git fetch https://${GIT_SECRET}@github.com/ZyCromerZ/SDClang 14.0.3 --depth=1
        git checkout FETCH_HEAD
        [[ ! -z "$(git branch | grep 14.0.3)" ]] && git branch -D 14.0.3
        git checkout -b 14.0.3
    fi
    TypeBuilder="SDClang-14"
    ClangType="$(${ClangPath}/bin/clang --version | head -n 1)"
}

CloneSdClangL(){
    ClangPath=${MainClangPath}
    [[ "$(pwd)" != "${MainPath}" ]] && cd "${MainPath}"
    if [ ! -d "${ClangPath}" ];then
        git clone https://gitlab.com/ZyCromerZ/sdclang-16.0.2.0 -b main "${ClangPath}" --depth=1
    else
        cd "${ClangPath}"
        git fetch https://gitlab.com/ZyCromerZ/sdclang-16.0.2.0 main --depth=1
        git checkout FETCH_HEAD
        [[ ! -z "$(git branch | grep main)" ]] && git branch -D main
        git checkout -b main
    fi
    TypeBuilder="SDClang-16"
    ClangType="$(${ClangPath}/bin/clang --version | head -n 1)"
}

CloneOldSdClang(){
    ClangPath=${MainClangPath}
    [[ "$(pwd)" != "${MainPath}" ]] && cd "${MainPath}"
    if [ ! -d "${ClangPath}" ];then
        git clone https://${GIT_SECRET}@github.com/ZyCromerZ/SDClang -b 12 "${ClangPath}" --depth=1
    else
        cd "${ClangPath}"
        git fetch https://${GIT_SECRET}@github.com/ZyCromerZ/SDClang 12 --depth=1
        git checkout FETCH_HEAD
        [[ ! -z "$(git branch | grep 12)" ]] && git branch -D 12
        git checkout -b 12
    fi
    TypeBuilder="SDClang-12"
    ClangType="$(${ClangPath}/bin/clang --version | head -n 1)"
}

CloneZyCFoutThirdteenClang()
{
    ClangPath=${MainClangZipPath}-zyc
    [[ "$(pwd)" != "${MainPath}" ]] && cd "${MainPath}"
    [[ ! -d ${MainClangZipPath} ]] && mkdir $ClangPath
    rm -rf $ClangPath/*
    if [ ! -e "${MainPath}/ZyC-Clang-13.tar.gz" ];then
        wget -q  $(curl https://raw.githubusercontent.com/ZyCromerZ/Clang/main/Clang-13-link.txt 2>/dev/null) -O "ZyC-Clang-13.tar.gz"
    fi
    tar -xf ZyC-Clang-13.tar.gz -C $ClangPath
    rm -rf ZyC-Clang-13.tar.gz
    TypeBuilder="CLANG-13"
    ClangType="$(${ClangPath}/bin/clang --version | head -n 1)"
}

CloneZyCFoutTeenClang()
{
    ClangPath=${MainClangZipPath}-zyc
    [[ "$(pwd)" != "${MainPath}" ]] && cd "${MainPath}"
    [[ ! -d ${MainClangZipPath} ]] && mkdir $ClangPath
    rm -rf $ClangPath/*
    if [ ! -e "${MainPath}/ZyC-Clang-14.tar.gz" ];then
        wget -q  $(curl https://raw.githubusercontent.com/ZyCromerZ/Clang/main/Clang-14-link.txt 2>/dev/null) -O "ZyC-Clang-14.tar.gz"
    fi
    tar -xf ZyC-Clang-14.tar.gz -C $ClangPath
    rm -rf ZyC-Clang-14.tar.gz
    TypeBuilder="CLANG-14"
    ClangType="$(${ClangPath}/bin/clang --version | head -n 1)"
}

CloneZyCMainClang()
{
    ClangPath=${MainClangZipPath}-zyc
    [[ "$(pwd)" != "${MainPath}" ]] && cd "${MainPath}"
    [[ ! -d ${MainClangZipPath} ]] && mkdir $ClangPath
    rm -rf $ClangPath/*
    if [ ! -e "${MainPath}/ZyC-Clang-main.tar.gz" ];then
        wget -q  $(curl https://raw.githubusercontent.com/ZyCromerZ/Clang/main/Clang-main-link.txt 2>/dev/null) -O "ZyC-Clang-main.tar.gz"
    fi
    tar -xf ZyC-Clang-main.tar.gz -C $ClangPath
    rm -rf ZyC-Clang-main.tar.gz
    TypeBuilder="CLANG-main"
    ClangType="$(${ClangPath}/bin/clang --version | head -n 1)"
}

CloneZyCFoutTeenLabClang()
{
    ClangPath=${MainClangPath}
    [[ "$(pwd)" != "${MainPath}" ]] && cd "${MainPath}"
    if [ ! -d "${ClangPath}" ];then
        git clone https://git@gitlab.com/ZyCromerZ/clang.git -b 14.0.0 "${ClangPath}" --depth=1
    else
        cd "${ClangPath}"
        git fetch https://git@gitlab.com/ZyCromerZ/clang.git 14.0.0 --depth=1
        git checkout FETCH_HEAD
        [[ ! -z "$(git branch | grep 14.0.0)" ]] && git branch -D 14.0.0
        git checkout -b 14.0.0
    fi
    TypeBuilder="CLANG-14"
    ClangType="$(${ClangPath}/bin/clang --version | head -n 1)"
}