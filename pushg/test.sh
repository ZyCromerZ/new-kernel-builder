#! /bin/bash

GetRepo="${1}"
shift
GetBranch="${@}"
[[ -z "$GetRepo" ]] && GetRepo="doa"
[[ -z "$GetBranch" ]] && GetBranch="begonia-r-oss-stock-main"
SetBranch="bego-r-builder"
. pushg/vayu.sh $GetRepo $GetBranch