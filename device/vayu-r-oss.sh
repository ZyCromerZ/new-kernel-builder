#! /bin/bash

DEVICE="Poco X3 pro"
CODENAME="Vayu"
SaveChatID="-1001301538740"
ARCH="arm64"
TypeBuild="Stable"
DEFFCONFIG="vayu_defconfig"
GetBD=$(date +"%m%d")
GetCBD=$(date +"%Y-%m-%d")
# TypeBuildTag="[R-OSS]"
FolderUp="shared-file"
ExFolder="Vayu-kernels-TEST"
AnyKernelBranch="master-vayu"
FirstSendInfoLink="N"
ImgName="Image"
AfterDTS="qcom"
BASE_DTB_NAME="sm8150-v2"
UseDtb="y"
UseDtbo="y"
TypeBuildFor="R-OSS"
MultipleDtbBranchA="20210824/neutrino-phantasm-254-A-muv:muv 20210824/neutrino-phantasm-254-A-muv-oc:muv-uc-oc 20210824/neutrino-phantasm-254-A-muv-uc:muv-uc 20210824/neutrino-phantasm-254-A-stock:stock 20210824/neutrino-phantasm-254-A-stock-oc:stock-uc-oc 20210824/neutrino-phantasm-254-A-stock-uc:stock-uc 20210824/neutrino-phantasm-254-A-uv:uv 20210824/neutrino-phantasm-254-A-uv-oc:uv-uc-oc 20210824/neutrino-phantasm-254-A-uv-uc:uv-uc"
MultipleDtbBranchB="20210824/neutrino-phantasm-254-B-muv:muv 20210824/neutrino-phantasm-254-B-muv-oc:muv-uc-oc 20210824/neutrino-phantasm-254-B-muv-uc:muv-uc 20210824/neutrino-phantasm-254-B-stock:stock 20210824/neutrino-phantasm-254-B-stock-oc:stock-uc-oc 20210824/neutrino-phantasm-254-B-stock-uc:stock-uc 20210824/neutrino-phantasm-254-B-uv:uv 20210824/neutrino-phantasm-254-B-uv-oc:uv-uc-oc 20210824/neutrino-phantasm-254-B-uv-uc:uv-uc"
# HasOcDtb="y"
# DontInc="dtb-muv-uc-oc dtb-stock-uc-oc dtb-uv-uc-oc"