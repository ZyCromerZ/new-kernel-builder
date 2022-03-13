#! /bin/bash
KernelBranch="20210824/neutrino-phantasm-254-A"

IncludeFiles "${MainPath}/device/vayu-r-oss.sh"
CustomUploader="Y"
IncludeFiles "${MainPath}/misc/kernel.sh" "https://${GIT_SECRET}@github.com/${GIT_USERNAME}/vayu_kernel"
# FolderUp="shared-file"
TypeBuildTag="[STOCK][MPDCL]"
MultipleDtbBranch="${MultipleDtbBranchA}"

# misc
# doOsdnUp=$FolderUp
# doSFUp=$FolderUp
 

CloneKernel "--depth=1"
CloneGCCOld
CloneSdClang
# DisableLTO
# CompileClangKernel
# DisableMsmP
DisableThin
EnableRELR
CompileClangKernelLLVMB