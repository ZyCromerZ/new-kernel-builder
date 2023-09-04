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
AddKSU="y"
MultipleDtbBranchA="muv:f2374e7f64710d6a73ac6857363df6b46b718816 muv-uc:082ce09e4efdaa3ff24880b398031ca056d352ca muv-uc-oc:3d02cfcc2bae5a2a4115982d936689eee948db39 stock:a9e55b092ea4fb40291b9731cb2ba0d47b14c880 stock-uc:ffacae093f8c49f58a446bb65c4c509f2013513d stock-uc-oc:55d21452bc14305d2f3766ee1da834e1ad1591de uv:f80e600317e48d95bedc54cf0bc0f3ba9b685ec3 uv-uc:9cca762eb7f6754f7668b2cac50e33a25c6509a7 uv-uc-oc:e11b4ac3e12b334ec8235add205a179ea0aaace8"
MultipleDtbBranchB="$MultipleDtbBranchA"
# HasOcDtb="y"
# DontInc="dtb-muv-uc-oc dtb-stock-uc-oc dtb-uv-uc-oc"