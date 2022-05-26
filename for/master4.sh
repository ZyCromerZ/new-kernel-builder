#! /bin/bash
KernelBranch="r-oss-base"

IncludeFiles "${MainPath}/device/begonia-r-oss.sh"
CustomUploader="Y"
# UseSpectrum="Y"
IncludeFiles "${MainPath}/misc/kernel.sh" "https://${GIT_SECRET}@github.com/${GIT_USERNAME}/begonia_kernel"
# spectrumFile="None"
FolderUp="shared-file"
TypeBuildTag="[TEST]"


CloneKernel
cd "${KernelPath}"
git push https://${GIT_SECRET}@github.com/${GIT_USERNAME}/begonia-jun-22 $KernelBranch
# for branchx in r-oss-base-public r-oss-base-release r-oss-base-release-ALMK r-oss-base-release-SLMK r-oss-base-release-test r-oss-base-release-uv r-oss-base-release-uv-ALMK r-oss-base-release-uv-SLMK r-oss-up r-oss-up-ALMK r-oss-up-MemekuiThermal r-oss-up-SLMK
# do
#     git fetch origin $branchx
#     git checkout FETCH_HEAD
#     git checkout -b $branchx
# done
# git push --all https://${GIT_SECRET}@github.com/${GIT_USERNAME}/begonia-jun-22