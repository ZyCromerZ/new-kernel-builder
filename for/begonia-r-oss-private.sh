#! /bin/bash
KernelBranch="r-oss-base-release-test"

IncludeFiles "${MainPath}/device/begonia-r-oss.sh"
CustomUploader="Y"
# UseSpectrum="Y"
IncludeFiles "${MainPath}/misc/kernel.sh" "https://${GIT_SECRET}@github.com/${GIT_USERNAME}/begonia_kernel"
# spectrumFile="None"
FolderUp="begonia"
TypeBuildTag="[TEST]"

CloneKernel "--depth=1"
CloneZyCFoutTeenClang
CompileClangKernelLLVM && CleanOut
CloneDTCClang
CloneCompiledGccTwelve
CompileClangKernelLLVMB && CleanOut
CloneSdClang
CloneGCCOld
CompileClangKernelLLVMB && CleanOut

# cleanup stuff after done
cd "${MainPath}"
rm -rf *