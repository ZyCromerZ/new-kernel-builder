#! /bin/bash
KernelBranch="20210824/neutrino-phantasm-254-upCAF-B"

IncludeFiles "${MainPath}/device/vayu-r-oss.sh"
CustomUploader="Y"
IncludeFiles "${MainPath}/misc/kernel.sh" "https://${GIT_SECRET}@github.com/${GIT_USERNAME}/vayu_kernel"
# FolderUp="shared-file"
TypeBuildTag="[STOCK][MPDCL]"

# misc
# doOsdnUp=$FolderUp
# doSFUp=$FolderUp
 

CloneKernel "--depth=1"
CloneZyCFoutTeenClang
# DisableMsmP
DisableThin
EnableRELR
OptimizaForSize
CompileClangKernelLLVM && CleanOut