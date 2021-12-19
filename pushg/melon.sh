#! /bin/bash

GetRepo="${1}"
shift
GetBranch="${@}"
[[ -z "$GetRepo" ]] && GetRepo="dob"
[[ -z "$GetBranch" ]] && GetBranch="merlin-r-oss-test4 merlin-r-oss-test3 merlin-r-oss-test2 merlin-r-oss-test-uv4 merlin-r-oss-test merlin-r-oss-test-uv3 merlin-r-oss-test-uv2 merlin-r-oss-test-uv"
SetBranch="melon-builder"
. pushg/vayu.sh $GetRepo $GetBranch