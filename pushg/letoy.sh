#! /bin/bash

GetRepo="${1}"
shift
GetBranch="${@}"
[[ -z "$GetRepo" ]] && GetRepo="doa"
[[ -z "$GetBranch" ]] && GetBranch="lancelot-r-oss-test lancelot-r-oss-test-uv"
SetBranch="letoy-builder"
. pushg/vayu.sh $GetRepo $GetBranch