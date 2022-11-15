#! /bin/bash
KernelBranch="20210824/neutrino-phantasm-254-B"

IncludeFiles "${MainPath}/device/vayu-r-oss.sh"
CustomUploader="Y"
IncludeFiles "${MainPath}/misc/kernel.sh" "https://${GIT_SECRET}@github.com/${GIT_USERNAME}/vayu_kernel"
# FolderUp="shared-file"
TypeBuildTag="[STOCK][MPDCL]"
MultipleDtbBranch="${MultipleDtbBranchB}"

# misc
# doOsdnUp=$FolderUp
# doSFUp=$FolderUp
 

CloneKernel "--depth=1"
CloneZyCMainClang
# DisableMsmP
DisableThin
EnableRELR
OptimizeForSize
CompileClangKernelB && CleanOut