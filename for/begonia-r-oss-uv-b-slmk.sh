#! /bin/bash
KernelBranch="r-oss-base-release-uv-SLMK"

IncludeFiles "${MainPath}/device/begonia-r-oss.sh"
CustomUploader="Y"
# UseSpectrum="Y"
IncludeFiles "${MainPath}/misc/kernel.sh" "https://${GIT_SECRET}@github.com/${GIT_USERNAME}/begonia_kernel"
# spectrumFile="bego-on-p.rc"
FolderUp="shared-file"
TypeBuildTag="[SLMK][806Mhz]"

CloneKernel "--depth=1"
CloneCompiledGccThirteen
CloneDTCClang
# DisableMsmP
# DisableThin
EnableRELR
CompileClangKernel && CleanOut