#! /bin/bash
KernelBranch="begonia-13-base"

IncludeFiles "${MainPath}/device/begonia-r-oss.sh"
CustomUploader="Y"
# UseSpectrum="Y"
IncludeFiles "${MainPath}/misc/kernel.sh" "https://${GIT_SECRET}@github.com/${GIT_USERNAME}/begonia_kernel"
# spectrumFile="bego-on-p.rc"
FolderUp="shared-file"
TypeBuildTag="[R-OSS][TEST-BASE]"

CloneKernel "--depth=1"
CloneZyCThirdteenClang
OptimizeForSize
DisableLTO
# DisableMsmP
# DisableThin
EnableRELR
DebugMissBypass
CompileClangKernelB && CleanOut