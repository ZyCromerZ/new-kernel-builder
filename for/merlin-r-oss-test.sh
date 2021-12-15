#! /bin/bash
KernelBranch="base-r-oss-custom-release"

IncludeFiles "${MainPath}/device/merlin-r-oss.sh"
CustomUploader="Y"
IncludeFiles "${MainPath}/misc/kernel.sh" "https://${GIT_SECRET}@github.com/${GIT_USERNAME}/lancelot_kernels"
FolderUp="shared-file"
TypeBuildTag="[STABLE][Stock][1000Mhz]"

CloneKernel
CloneZyCFoutTeenLabClang
CompileClangKernelB
pullBranch "base-r-oss-custom-release-ALMK" "[STABLE][ALMK][1000Mhz]"
CompileClangKernelB
pullBranch "base-r-oss-custom-release-SLMK" "[STABLE][SLMK][1000Mhz]"
CompileClangKernelB

 
