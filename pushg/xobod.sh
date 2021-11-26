#! /bin/bash

GetRepo="${1}"
shift
GetBranch="${@}"
[[ -z "$GetRepo" ]] && GetRepo="dob"
[[ -z "$GetBranch" ]] && GetBranch="x01bd-main-r x01bd-main-q"
SetBranch="xobod-builder"
. pushg/vayu.sh $GetRepo $GetBranch