#! /bin/bash
KernelBranch="thirteen-up-f2fs"

IncludeFiles "${MainPath}/device/begonia-r-oss.sh"
CustomUploader="Y"
# UseSpectrum="Y"
IncludeFiles "${MainPath}/misc/kernel.sh" "https://${GIT_SECRET}@github.com/${GIT_USERNAME}/begonia_kernel"
# spectrumFile="bego-on-p.rc"
FolderUp="shared-file"
TypeBuildTag="[806Mhz]"

CloneKernel "--depth=1"
CloneZyCFiveTeenClang
# OptimizeForSize
# DisableMsmP
# DisableThin
# EnableRELR
CompileClangKernelB && CleanOut