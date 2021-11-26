#! /bin/bash

GetRepo="${1}"
shift
GetBranch="${@}"
[[ -z "$GetRepo" ]] && GetRepo="dob"
[[ -z "$GetBranch" ]] && GetBranch="begonia-r-oss-uv begonia-r-oss-std begonia-r-oss-stock"
SetBranch="bego-r-builder"
. pushg/vayu.sh $GetRepo $GetBranch