#! /bin/bash
KernelBranch="20220412/main-y-up"

IncludeFiles "${MainPath}/device/vayu-r-oss.sh"
CustomUploader="Y"
IncludeFiles "${MainPath}/misc/kernel.sh" "https://${GIT_SECRET}@github.com/${GIT_USERNAME}/vayu_kernel"
# FolderUp="shared-file"
TypeBuildTag="[MPDCL][FULL]"
MultipleDtbBranch="$MultipleDtbBranchA"

# misc
# doOsdnUp=$FolderUp
# doSFUp=$FolderUp
 

CloneKernel "--depth=1"
CloneCompiledGccThirteen
CloneDTCClang
# DisableMsmP
DisableThin
# EnableRELR
# UseGoldBinutils="m"
UseOBJCOPYBinutils="y"
EnableRELR
CompileClangKernelLLVMB && CleanOut