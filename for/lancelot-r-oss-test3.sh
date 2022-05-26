#! /bin/bash
KernelBranch="base-r-oss-custom-release"

IncludeFiles "${MainPath}/device/lancelot-r-oss.sh"
CustomUploader="Y"
IncludeFiles "${MainPath}/misc/kernel.sh" "https://${GIT_SECRET}@github.com/${GIT_USERNAME}/lancelot_kernels"
FolderUp="shared-file"
TypeBuildTag="[950Mhz]"

CloneKernel "--depth=1"
# pullBranch "base-r-oss-custom-ALMK" "[STABLE][ALMK][950Mhz]"
# pullBranch "base-r-oss-custom-SLMK" "[TEST][SLMK][950Mhz]"
CloneGCCOld
CloneSdClangB
# DisableThin
DisableLTO
EnableRELR
OptimizaForSize
CompileClangKernelLLVMB