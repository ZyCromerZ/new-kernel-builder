#! /bin/bash
KernelBranch="base-r-oss-custom-release-temp"

IncludeFiles "${MainPath}/device/merlin-r-oss.sh"
CustomUploader="Y"
IncludeFiles "${MainPath}/misc/kernel.sh" "https://${GIT_SECRET}@github.com/${GIT_USERNAME}/lancelot_kernels"
FolderUp="shared-file"
TypeBuildTag="[STABLE]"

CloneKernel
CloneCompiledGccTwelve
CompileGccKernel

 
