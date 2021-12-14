#! /bin/bash

GetRepo="${1}"
shift
GetBranch="${@}"
[[ -z "$GetRepo" ]] && GetRepo="doa"
[[ -z "$GetBranch" ]] && GetBranch="x01bd-main-r x01bd-main-r2 x01bd-main-r3 x01bd-main-r4"
SetBranch="xobod-builder-a"
. pushg/vayu.sh $GetRepo $GetBranch