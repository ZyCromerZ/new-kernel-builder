#! /bin/bash
KernelBranch="base-r-oss-custom-release-uv"

IncludeFiles "${MainPath}/device/merlin-r-oss.sh"
CustomUploader="Y"
IncludeFiles "${MainPath}/misc/kernel.sh" "https://${GIT_SECRET}@github.com/${GIT_USERNAME}/lancelot_kernels"
FolderUp="shared-file"
TypeBuildTag="[STABLE][Stock][1000Mhz]"

CloneKernel
# pullBranch "base-r-oss-custom-release-ALMK" "[STABLE][ALMK][1000Mhz]"
pullBranch "base-r-oss-custom-SLMK" "[TEST][SLMK][1000Mhz]"
CloneZyCFoutTeenClang
CloneCompiledGccEleven
CompileGccKernel && CleanOut
TypeBuildTag="[TEST][ZyCLLVM]"
CompileGccKernelB && CleanOut
UseZyCLLVM="y"
CloneSdClang
CloneGCCOld
CompileClangKernelLLVMB && CleanOut

 
