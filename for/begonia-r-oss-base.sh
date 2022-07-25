#! /bin/bash
KernelBranch="r-oss-base"

IncludeFiles "${MainPath}/device/begonia-r-oss.sh"
CustomUploader="Y"
# UseSpectrum="Y"
IncludeFiles "${MainPath}/misc/kernel.sh" "https://${GIT_SECRET}@github.com/${GIT_USERNAME}/begonia_kernel"
# spectrumFile="None"
FolderUp="shared-file"
TypeBuildTag="[806Mhz][15]"

CloneKernel "--depth=1"
CloneZyCFifTeenClang
OptimizeForSize
# DisableMsmP
# DisableThin
EnableRELR
CompileClangKernelLLVM && CleanOut