#! /bin/bash
KernelBranch="20210824/neutrino-flamescion"

IncludeFiles "${MainPath}/device/vayu-r-oss.sh"
CustomUploader="Y"
IncludeFiles "${MainPath}/misc/kernel.sh" "https://${GIT_SECRET}@github.com/${GIT_USERNAME}/vayu_kernel"
# FolderUp="shared-file"
TypeBuildTag="[MPDCL][DFDYD][CIBE]"

# misc
# doOsdnUp=$FolderUp
# doSFUp=$FolderUp
 

CloneKernel "--depth=1"
CloneZyCMainClang
DisableThin
EnableRELR
CompileClangKernelB && CleanOut
CloneCompiledGccTwelve
CloneDTCClang
DisableThin
EnableRELR
CompileClangKernel && CleanOut
CloneGCCOld
CloneSdClang
DisableThin
EnableRELR
CompileClangKernel && CleanOut