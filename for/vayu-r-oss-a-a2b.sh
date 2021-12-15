#! /bin/bash
KernelBranch="20210824/neutrino-flamescion2"

IncludeFiles "${MainPath}/device/vayu-r-oss.sh"
CustomUploader="Y"
IncludeFiles "${MainPath}/misc/kernel.sh" "https://${GIT_SECRET}@github.com/${GIT_USERNAME}/vayu_kernel"
# FolderUp="shared-file"
TypeBuildTag="[Stable][FullLTO][MPDCL][2][2]"

# misc
# doOsdnUp=$FolderUp
# doSFUp=$FolderUp
 

CloneKernel "--depth=1"
CloneZyCFoutTeenLabClang
[[ "$(pwd)" != "${KernelPath}" ]] && cd "${KernelPath}"
git fetch origin 328fc06aae5f561f6aa37a724a441c1fde619237 --depth=1
git reset --hard 328fc06aae5f561f6aa37a724a441c1fde619237
# DisableMsmP
DisableThin
OptimizaForSize
CompileClangKernelLLVM && CleanOut