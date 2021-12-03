#! /bin/bash
KernelBranch="r-oss-base-release-test"

IncludeFiles "${MainPath}/device/begonia-r-oss.sh"
CustomUploader="Y"
# UseSpectrum="Y"
IncludeFiles "${MainPath}/misc/kernel.sh" "https://${GIT_SECRET}@github.com/${GIT_USERNAME}/begonia_kernel"
# spectrumFile="None"
FolderUp="begonia"
TypeBuildTag="[Test]"

CloneKernel "--depth=1"
CloneZyCFoutTeenClang
# CompileClangKernelB && CleanOut
# CloneCompiledGccEleven
# CompileClangKernelB
CompileClangKernelLLVM

# cleanup stuff after done
cd "${MainPath}"
rm -rf *