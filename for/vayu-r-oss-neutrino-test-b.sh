#! /bin/bash
KernelBranch="20210517/neutrino-keqing"

IncludeFiles "${MainPath}/device/vayu-r-oss.sh"
CustomUploader="Y"
IncludeFiles "${MainPath}/misc/kernel.sh" "https://${GIT_SECRET}@github.com/${GIT_USERNAME}/vayu_kernel"
FolderUp="shared-file"
TypeBuildTag="[SLMK][ThinLTO][R-OSS]"

# misc
# doOsdnUp=$FolderUp
# doSFUp=$FolderUp
 

CloneKernel "--depth=1"
CloneCompiledGccTwelve && CloneDTCClang
CompileClangKernel && CleanOut
# CloneProtonClang
# CompileProtonClangKernel && CleanOut