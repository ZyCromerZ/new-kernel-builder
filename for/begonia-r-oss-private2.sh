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
CloneZyCFifTeenClang
OptimizaForPerf
CloneCompiledGccTwelve
CompileGccKernel && CleanOut
TypeBuildTag="[TEST][ZyCLLVM]"
CompileGccKernelB && CleanOut
UseZyCLLVM="y"
CloneSdClangB
CloneGCCOld
CompileClangKernelLLVMB && CleanOut

 