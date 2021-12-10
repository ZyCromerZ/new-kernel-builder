#! /bin/bash

GetRepo="${1}"
shift
GetBranch="${@}"
[[ -z "$GetRepo" ]] && GetRepo="dob"
[[ -z "$GetBranch" ]] && GetBranch="merlin-r-oss-test-uv merlin-r-oss-test-uv2 merlin-r-oss-test-uv3"
SetBranch="melon-builder"
. pushg/vayu.sh $GetRepo $GetBranch