#! /bin/bash

GetRepo="${1}"
shift
GetBranch="${@}"
[[ -z "$GetRepo" ]] && GetRepo="doa"
[[ -z "$GetBranch" ]] && GetBranch="merlin-r-oss-test merlin-r-oss-test-uv"
SetBranch="melon-builder"
. pushg/vayu.sh $GetRepo $GetBranch