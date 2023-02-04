#! /bin/bash
KernelBranch="20220412/Flata+"

IncludeFiles "${MainPath}/device/vayu-r-oss.sh"
CustomUploader="Y"
IncludeFiles "${MainPath}/misc/kernel.sh" "https://${GIT_SECRET}@github.com/${GIT_USERNAME}/vayu_kernel"
# FolderUp="shared-file"
TypeBuildTag="[MPDCL][FL]"
MultipleDtbBranch="$MultipleDtbBranchA"

# misc
# doOsdnUp=$FolderUp
# doSFUp=$FolderUp
 

CloneKernel "--depth=1"
# CloneCompiledGccTwelve
# CloneDTCClang
# DisableMsmP
# DisableThin
# EnableRELR
# UseGoldBinutils="m"
# UseOBJCOPYBinutils="y"
# CloneZyCMainClang
# CompileClangKernelB && CleanOut
# CloneGCCOld
# CloneSdClang
DisableLTO
# CompileClangKernel && CleanOut
CloneCompiledGccTwelve
CompileGccKernelB