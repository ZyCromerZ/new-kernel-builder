#! /bin/bash
KernelBranch="20220412/main"

IncludeFiles "${MainPath}/device/vayu-r-oss.sh"
CustomUploader="Y"
IncludeFiles "${MainPath}/misc/kernel.sh" "https://${GIT_SECRET}@github.com/${GIT_USERNAME}/vayu_kernel"
# spectrumFile="None"
FolderUp="shared-file"
TypeBuildTag="[TEST]"


CloneKernel
cd "${KernelPath}"
git push https://${GIT_SECRET}@github.com/${GIT_USERNAME}/vayu-jun-22 $KernelBranch
# for branchx in 20220412/Flata 20220412/Flata+ 20220412/RutuF 20220412/main-x-up 20220412/main-caf 20220412/main-f2fs 20220412/main-upstream
# do
#     git fetch origin $branchx
#     git checkout FETCH_HEAD
#     git checkout -b $branchx
# done
# git push --all https://${GIT_SECRET}@github.com/${GIT_USERNAME}/vayu-jun-22