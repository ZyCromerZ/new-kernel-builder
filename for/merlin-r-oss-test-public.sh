#! /bin/bash
KernelBranch="base-r-oss-custom-release-public"

IncludeFiles "${MainPath}/device/merlin-r-oss.sh"
CustomUploader="Y"
IncludeFiles "${MainPath}/misc/kernel.sh" "https://${GIT_SECRET}@github.com/${GIT_USERNAME}/lancelot_kernels"
FolderUp="shared-file"
TypeBuildTag="[STABLE]"

CloneKernel
CloneCompiledGccEleven 
# CloneDTCClang
# CloneProtonClang

# CompileClangKernel && CleanOut
# CloneDTCClang
CloneThirteenGugelClang
pullBranch "base-r-oss-custom-release-public-ALMK" "[STABLE][ALMK]"
CompileClangKernel && CleanOut
# CompileGccKernel

# cleanup stuff after done
cd "${MainPath}"
rm -rf *
