#! /bin/bash
KernelBranch="new-q-oss"

IncludeFiles "${MainPath}/device/begonia-q-oss.sh"
CustomUploader="Y"
# UseSpectrum="Y"
IncludeFiles "${MainPath}/misc/kernel.sh" "https://${GIT_SECRET}@github.com/${GIT_USERNAME}/begonia_kernel"
# spectrumFile="None"
FolderUp="shared-file"
TypeBuildTag="[TEST]"


CloneKernel
cd "${KernelPath}"
git push https://${GIT_SECRET}@github.com/${GIT_USERNAME}/begonia-jul-22 $KernelBranch
# for branchx in new-q-oss-up new-q-oss-up-ALMK new-q-oss-up-SLMK q-oss-base q-oss-base-public q-oss-base-release q-oss-base-release-ALMK q-oss-base-release-SLMK q-oss-base-release-uv q-oss-base-release-uv-ALMK q-oss-base-release-uv-SLMK q-oss-base-uv
# do
#     git fetch origin $branchx
#     git checkout FETCH_HEAD
#     git checkout -b $branchx
# done
# git push --all https://${GIT_SECRET}@github.com/${GIT_USERNAME}/begonia-jun-22