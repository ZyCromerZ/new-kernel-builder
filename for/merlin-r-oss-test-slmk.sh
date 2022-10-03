#! /bin/bash
KernelBranch="base-r-oss-custom-release-SLMK"

IncludeFiles "${MainPath}/device/merlin-r-oss.sh"
CustomUploader="Y"
IncludeFiles "${MainPath}/misc/kernel.sh" "https://${GIT_SECRET}@github.com/${GIT_USERNAME}/lancelot_kernels"
FolderUp="shared-file"
TypeBuildTag="[SLMK][1000Mhz]"

CloneKernel "--depth=1"
ChangeConfigData
# pullBranch "base-r-oss-custom-ALMK" "[STABLE][ALMK][1000Mhz]"
# pullBranch "base-r-oss-custom-SLMK" "[TEST][SLMK][1000Mhz]"
CloneZyCMainClang
OptimizeForSize
# DisableMsmP
DisableThin
EnableRELR
CompileClangKernelLLVM && CleanOut