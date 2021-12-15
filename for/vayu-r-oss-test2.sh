#! /bin/bash
KernelBranch="20210824/neutrino-flamescion"

IncludeFiles "${MainPath}/device/vayu-r-oss.sh"
CustomUploader="Y"
IncludeFiles "${MainPath}/misc/kernel.sh" "https://${GIT_SECRET}@github.com/${GIT_USERNAME}/vayu_kernel"
# FolderUp="shared-file"
TypeBuildTag="[TEST]"

# misc
# doOsdnUp=$FolderUp
# doSFUp=$FolderUp
 

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