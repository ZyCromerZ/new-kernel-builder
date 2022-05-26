#! /bin/bash
KernelBranch="base-r-oss"

IncludeFiles "${MainPath}/device/merlin-r-oss.sh"
CustomUploader="Y"
# UseSpectrum="Y"
IncludeFiles "${MainPath}/misc/kernel.sh" "https://${GIT_SECRET}@github.com/${GIT_USERNAME}/lancelot_kernels"
# spectrumFile="None"
FolderUp="shared-file"
TypeBuildTag="[TEST]"


CloneKernel
cd "${KernelPath}"
git push https://${GIT_SECRET}@github.com/${GIT_USERNAME}/meloyletoy-jun-22 $KernelBranch
# for branchx in base-r-oss-custom base-r-oss-custom-ALMK base-r-oss-custom-SLMK base-r-oss-custom-release base-r-oss-custom-release-ALMK base-r-oss-custom-release-SLMK base-r-oss-custom-release-public base-r-oss-custom-release-uv base-r-oss-custom-release-uv-ALMK base-r-oss-custom-release-uv-SLMK base-r-oss-custom-release-uv-public base-r-oss-upstream
# do
#     git fetch origin $branchx
#     git checkout FETCH_HEAD
#     git checkout -b $branchx
# done
# git push --all https://${GIT_SECRET}@github.com/${GIT_USERNAME}/meloyletoy-jun-22