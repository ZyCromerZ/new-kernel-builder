#! /bin/bash
KernelBranch="r-oss-base-release-uv"

IncludeFiles "${MainPath}/device/begonia-r-oss.sh"
CustomUploader="Y"
# UseSpectrum="Y"
IncludeFiles "${MainPath}/misc/kernel.sh" "https://${GIT_SECRET}@github.com/${GIT_USERNAME}/begonia_kernel"
# spectrumFile="None"
FolderUp="begonia"
TypeBuildTag="[R-OSS][806Mhz][Stable]"

CloneKernel "--depth=1"
# CloneCompiledGccTwelve
CloneCompiledGccEleven
CloneDTCClang
CompileClangKernel && CleanOut
# CloneProtonClang
# CompileClangKernel && CleanOut
# CompileGccKernel

# cleanup stuff after done
cd "${MainPath}"
rm -rf *