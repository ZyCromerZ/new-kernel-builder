#! /bin/bash
KernelBranch="20210413/r/main-for-p"

IncludeFiles "${MainPath}/device/x01bd.sh"
CustomUploader="Y"
UseSpectrum="Y"
IncludeFiles "${MainPath}/misc/kernel.sh" "https://${GIT_SECRET}@github.com/${GIT_USERNAME}/x01bd_kernel"
EnableFolderUp="shared-file"
# doSFUp=$FolderUp
TypeBuildFor="P"
spectrumFile="xobod-base.rc"

CloneKernel "--depth=1"
# CloneZyCFifTeenClang
# CompileClangKernelB && CleanOut
CloneCompiledGccTwelve
CloneDTCClang
CompileClangKernel && CleanOut
# CloneCompiledGccEleven
# CompileGccKernel && CleanOut
# CloneGCCOld
# CloneSdClang
# CompileClangKernel && CleanOut