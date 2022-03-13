#! /bin/bash
KernelBranch="20210824/neutrino-phantasm-254-upstream-A"

IncludeFiles "${MainPath}/device/vayu-r-oss.sh"
CustomUploader="Y"
IncludeFiles "${MainPath}/misc/kernel.sh" "https://${GIT_SECRET}@github.com/${GIT_USERNAME}/vayu_kernel"
# FolderUp="shared-file"
TypeBuildTag="[Up][MPDCL]"
MultipleDtbBranch=""

# misc
# doOsdnUp=$FolderUp
# doSFUp=$FolderUp
 

CloneKernel "--depth=1"
[ "$(pwd)" != "${KernelPath}" ]] && cd "${KernelPath}"
git fetch origin a49cef8e9dc49dbeedb2e197af02c6b0a3607895 --depth=1 && git reset --hard a49cef8e9dc49dbeedb2e197af02c6b0a3607895
CloneCompiledGccTwelve
CloneDTCClang
# DisableMsmP
# DisableThin
DisableLTO
EnableRELR
CompileClangKernelLLVMB && CleanOut