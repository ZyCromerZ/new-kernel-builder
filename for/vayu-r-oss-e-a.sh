#! /bin/bash
KernelBranch="20210824/neutrino-phantasm-254"

IncludeFiles "${MainPath}/device/vayu-r-oss.sh"
CustomUploader="Y"
IncludeFiles "${MainPath}/misc/kernel.sh" "https://${GIT_SECRET}@github.com/${GIT_USERNAME}/vayu_kernel"
# FolderUp="shared-file"
TypeBuildTag="[FullLTO][MPDCL][FUllLLVM][GLD]"
MultipleDtbBranch=""

# misc
# doOsdnUp=$FolderUp
# doSFUp=$FolderUp
 

CloneKernel "--depth=1"
CloneCompiledGccTwelve
CloneDTCClang
# DisableMsmP
DisableThin
# EnableRELR
UseGoldBinutils="m"
UseOBJCOPYBinutils="y"
CompileClangKernel && CleanOut