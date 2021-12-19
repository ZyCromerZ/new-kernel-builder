#! /bin/bash
KernelBranch="base-r-oss-custom-release-uv"

IncludeFiles "${MainPath}/device/lancelot-r-oss.sh"
CustomUploader="Y"
IncludeFiles "${MainPath}/misc/kernel.sh" "https://${GIT_SECRET}@github.com/${GIT_USERNAME}/lancelot_kernels"
FolderUp="shared-file"
TypeBuildTag="[Stable][950Mhz]"

CloneKernel "--depth=1"
# pullBranch "base-r-oss-custom-ALMK" "[STABLE][ALMK][950Mhz]"
# pullBranch "base-r-oss-custom-SLMK" "[TEST][SLMK][950Mhz]"
CloneCompiledGccEleven
DisableLTO
OptimizaForPerf
# DisableMsmP
CompileGccKernel