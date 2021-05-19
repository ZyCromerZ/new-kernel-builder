#! /bin/bash
KernelBranch="20210405/neutrino-3"

IncludeFiles "${MainPath}/device/lancelot-q-oss.sh"
CustomUploader="Y"
IncludeFiles "${MainPath}/misc/kernel.sh" "https://${GIT_SECRET}@github.com/${GIT_USERNAME}/lancelot_kernels"
FolderUp="keqing-drive"
TypeBuildTag="[TEST][B]"

CloneKernel
CloneCompiledGccTwelve 
CloneOldDTCClang && PullLtoSlmk
CompileClangKernel && CleanOut


# cleanup stuff after done
cd "${MainPath}"
rm -rf *