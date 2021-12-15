#! /bin/bash
KernelBranch="q-oss-base-release"

IncludeFiles "${MainPath}/device/begonia-q-oss.sh"
CustomUploader="Y"
# UseSpectrum="Y"
IncludeFiles "${MainPath}/misc/kernel.sh" "https://${GIT_SECRET}@github.com/${GIT_USERNAME}/begonia_kernel"
# spectrumFile="bego-on-p.rc"
FolderUp="begonia"
TypeBuildTag="[Stable][806Mhz]"

CloneKernel "--depth=1"
# CloneCompiledGccTwelve
CloneZyCFoutTeenLabClang
CompileClangKernelB && CleanOut
CloneCompiledGccEleven
CloneDTCClang
CompileClangKernel && CleanOut
# CloneProtonClang
# CompileClangKernel && CleanOut
CompileGccKernel

 