#! /bin/bash
KernelBranch="20210824/neutrino-flamescion"

IncludeFiles "${MainPath}/device/vayu-r-oss.sh"
CustomUploader="Y"
IncludeFiles "${MainPath}/misc/kernel.sh" "https://${GIT_SECRET}@github.com/${GIT_USERNAME}/vayu_kernel"
# FolderUp="shared-file"
TypeBuildTag="[Stable][FullLTO][MPDCL][2][1]"

# misc
# doOsdnUp=$FolderUp
# doSFUp=$FolderUp
 

CloneKernel "--depth=1" 
CloneZyCFoutTeenLabClang
[[ "$(pwd)" != "${KernelPath}" ]] && cd "${KernelPath}"
git fetch origin 6cd51416d8f6a02bd735c95363c881fdfd1dd2a9 --depth=1
git reset --hard 6cd51416d8f6a02bd735c95363c881fdfd1dd2a9
# DisableMsmP
DisableThin
OptimizaForSize
CompileClangKernelLLVM && CleanOut