#! /bin/bash
KernelBranch="base-r-oss-custom-release"

IncludeFiles "${MainPath}/device/merlin-r-oss.sh"
CustomUploader="Y"
IncludeFiles "${MainPath}/misc/kernel.sh" "https://${GIT_SECRET}@github.com/${GIT_USERNAME}/lancelot_kernels"
FolderUp="shared-file"
TypeBuildTag="[1000Mhz]"

CloneKernel "--depth=1"
# pullBranch "base-r-oss-custom-ALMK" "[STABLE][ALMK][1000Mhz]"
# pullBranch "base-r-oss-custom-SLMK" "[TEST][SLMK][1000Mhz]"
CloneCompiledGccTwelve
DisableLTO
OptimizeForSize
# DisableMsmP
CompileGccKernel