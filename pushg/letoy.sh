#! /bin/bash

GetRepo="${1}"
shift
GetBranch="${@}"
[[ -z "$GetRepo" ]] && GetRepo="doa"
[[ -z "$GetBranch" ]] && GetBranch="lancelot-r-oss-test-uv lancelot-r-oss-test-uv2 lancelot-r-oss-test-uv3"
SetBranch="letoy-builder"
. pushg/vayu.sh $GetRepo $GetBranch