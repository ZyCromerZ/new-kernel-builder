#! /bin/bash
KernelBranch="20210824/neutrino-phantasm"

IncludeFiles "${MainPath}/device/vayu-r-oss.sh"
CustomUploader="Y"
IncludeFiles "${MainPath}/misc/kernel.sh" "https://${GIT_SECRET}@github.com/${GIT_USERNAME}/vayu_kernel"
# FolderUp="shared-file"
TypeBuildTag=""

# misc
# doOsdnUp=$FolderUp
# doSFUp=$FolderUp
 

CloneKernel "--depth=1"
# CloneGCCOld && CloneGugelClang
# CloneProtonClang
# CloneCompiledGccEleven
# CompileProtonClangKernel && CleanOut
# CompileClangKernel && CleanOut
# CloneCompiledGccEleven
# CloneSdClang
# CompileClangKernel && CleanOut
# CloneDTCClang
# CompileClangKernel && CleanOut
# DEFFCONFIG="vayu_gcc_defconfig"
# CloneThirteenGugelClang
# CompileClangKernel && CleanOut
# CloneFourteenGugelClang
# CompileClangKernel && CleanOut
# CompileGccKernel
CloneZyCMainClang
# CompileClangKernelB
CompileClangKernelB