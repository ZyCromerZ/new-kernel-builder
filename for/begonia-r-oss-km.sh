#! /bin/bash
KernelBranch="twelve"

IncludeFiles "${MainPath}/device/begonia-r-oss.sh"
CustomUploader="Y"
# UseSpectrum="Y"
IncludeFiles "${MainPath}/misc/kernel.sh" "https://github.com/KangMonkey/kernel_xiaomi_mt6785"
# spectrumFile="None"
FolderUp="begonia"
TypeBuildTag="[Test]"

CloneKernel "--depth=1"
CloneCompiledGccEleven
CloneDTCClang
cd "${KernelPath}"
sed "s/-perf/-KangMonkey-v12/" -i arch/arm64/configs/begonia_user_defconfig
git add . && git commit -sm 'defconfig: update localversion'
CompileClangKernel

# cleanup stuff after done
cd "${MainPath}"
rm -rf *