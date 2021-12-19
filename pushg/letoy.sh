#! /bin/bash

GetRepo="${1}"
shift
GetBranch="${@}"
[[ -z "$GetRepo" ]] && GetRepo="doa"
[[ -z "$GetBranch" ]] && GetBranch="lancelot-r-oss-test4 lancelot-r-oss-test3 lancelot-r-oss-test2 lancelot-r-oss-test-uv4 lancelot-r-oss-test lancelot-r-oss-test-uv3 lancelot-r-oss-test-uv2 lancelot-r-oss-test-uv"
SetBranch="letoy-builder"
. pushg/vayu.sh $GetRepo $GetBranch