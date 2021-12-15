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
DisableThin
CompileClangKernelLLVM && CleanOut
# CloneDTCClang
# CloneCompiledGccTwelve
# CompileClangKernelLLVMB && CleanOut
# UseZyCLLVM="y"
# TypeBuildTag="[TEST][ZyCLLVM]"
# CompileClangKernelLLVMB && CleanOut

 