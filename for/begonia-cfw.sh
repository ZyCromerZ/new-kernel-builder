#! /bin/bash
KernelBranch="cfw-main"

IncludeFiles "${MainPath}/device/begonia-cfw.sh"
CustomUploader="Y"
# UseSpectrum="Y"
IncludeFiles "${MainPath}/misc/kernel.sh" "https://${GIT_SECRET}@github.com/${GIT_USERNAME}/begonia_kernel"
# spectrumFile="bego-on-p.rc"
FolderUp="shared-file"
TypeBuildTag="[Test][ThinLTO][806Mhz]"

CloneKernel "--depth=1"
CloneCompiledGccThirteen
CloneDTCClang
# DisableMsmP
# DisableThin
EnableRELR
CompileClangKernel && CleanOut