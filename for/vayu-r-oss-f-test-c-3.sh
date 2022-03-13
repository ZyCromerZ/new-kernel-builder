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
git fetch origin 5af06df00d9ba5f742cf5706187441b3c7646c05 --depth=1 && git reset --hard 5af06df00d9ba5f742cf5706187441b3c7646c05
CloneCompiledGccTwelve
CloneDTCClang
# DisableMsmP
# DisableThin
DisableLTO
EnableRELR
CompileClangKernelLLVMB && CleanOut