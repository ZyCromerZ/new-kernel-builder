#! /bin/bash
KernelBranch="base-r-oss-custom-release-uv"

IncludeFiles "${MainPath}/device/merlin-r-oss.sh"
CustomUploader="Y"
IncludeFiles "${MainPath}/misc/kernel.sh" "https://${GIT_SECRET}@github.com/${GIT_USERNAME}/lancelot_kernels"
FolderUp="shared-file"
TypeBuildTag="[STABLE][Stock][1000Mhz]"

CloneKernel
CloneZyCFoutTeenClang
CompileClangKernelB
pullBranch "base-r-oss-custom-release-ALMK" "[STABLE][ALMK][1000Mhz]"
CompileClangKernelB
pullBranch "base-r-oss-custom-release-SLMK" "[STABLE][SLMK][1000Mhz]"
CompileClangKernelB


# cleanup stuff after done
cd "${MainPath}"
rm -rf *
