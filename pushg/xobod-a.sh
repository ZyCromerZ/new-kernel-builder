#! /bin/bash

GetRepo="${1}"
shift
GetBranch="${@}"
[[ -z "$GetRepo" ]] && GetRepo="doa"
[[ -z "$GetBranch" ]] && GetBranch="x01bd-main-r x01bd-main-r2 x01bd-main-r3 x01bd-main-r4 x01bd-main-p x01bd-main-p2"
SetBranch="xobod-builder-a"
. pushg/vayu.sh $GetRepo $GetBranch