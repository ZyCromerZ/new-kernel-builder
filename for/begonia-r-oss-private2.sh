#! /bin/bash
KernelBranch="r-oss-base-release-test"

IncludeFiles "${MainPath}/device/begonia-r-oss.sh"
CustomUploader="Y"
# UseSpectrum="Y"
IncludeFiles "${MainPath}/misc/kernel.sh" "https://${GIT_SECRET}@github.com/${GIT_USERNAME}/begonia_kernel"
# spectrumFile="None"
FolderUp="shared-file"
TypeBuildTag="[TEST]"

CloneKernel "--depth=1"
CloneZyCFoutTeenLabClang
CloneCompiledGccEleven
CompileGccKernel && CleanOut
TypeBuildTag="[TEST][ZyCLLVM]"
CompileGccKernelB && CleanOut
UseZyCLLVM="y"
CloneSdClang
CloneGCCOld
CompileClangKernelLLVMB && CleanOut

 