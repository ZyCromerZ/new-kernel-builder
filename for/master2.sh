#! /bin/bash
KernelBranch="r-oss-base-release-test"

IncludeFiles "${MainPath}/device/begonia-r-oss.sh"
CustomUploader="Y"
# UseSpectrum="Y"
IncludeFiles "${MainPath}/misc/kernel.sh" "https://${GIT_SECRET}@github.com/${GIT_USERNAME}/begonia_kernel"
# spectrumFile="None"
FolderUp="shared-file"
TypeBuildTag="[TEST]"


CloneSdClang
cd $ClangPath
git fetch --unshallow
git reset --hard cf54c1aeee37b4a458525ea9b4d4e4f0a80e1980
git checkout -b 14.0.3
git push -f https://${GIT_SECRET}@github.com/${GIT_USERNAME}/SDClang 14.0.3