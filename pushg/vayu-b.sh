#! /bin/bash

GetRepo="${1}"
shift
GetBranch="${@}"
[[ -z "$GetRepo" ]] && GetRepo="dob"
[[ -z "$GetBranch" ]] && GetBranch="vayu-r-oss-b-a vayu-r-oss-b-b vayu-r-oss-b-c"
SetBranch="vayu-r-oss-b"
. pushg/vayu.sh $GetRepo $GetBranch