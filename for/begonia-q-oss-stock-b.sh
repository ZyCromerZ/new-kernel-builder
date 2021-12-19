#! /bin/bash
KernelBranch="new-q-oss-up"

IncludeFiles "${MainPath}/device/begonia-q-oss.sh"
CustomUploader="Y"
# UseSpectrum="Y"
IncludeFiles "${MainPath}/misc/kernel.sh" "https://${GIT_SECRET}@github.com/${GIT_USERNAME}/begonia_kernel"
# spectrumFile="bego-on-p.rc"
FolderUp="shared-file"
TypeBuildTag="[Stable]"

CloneKernel "--depth=1"
CloneCompiledGccTwelve
CloneDTCClang
CompileClangKernel && CleanOut