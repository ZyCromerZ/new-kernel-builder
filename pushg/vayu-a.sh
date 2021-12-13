#! /bin/bash

GetRepo="${1}"
shift
GetBranch="${@}"
[[ -z "$GetRepo" ]] && GetRepo="doa"
# [[ -z "$GetBranch" ]] && GetBranch="vayu-r-oss-a-a vayu-r-oss-a-b vayu-r-oss-a-c vayu-r-oss-a-d vayu-r-oss-a-e vayu-r-oss-a-f"
[[ -z "$GetBranch" ]] && GetBranch="vayu-r-oss-a-b vayu-r-oss-a-a vayu-r-oss-a-c vayu-r-oss-a-f"
SetBranch="vayu-r-oss-a"
. pushg/vayu.sh $GetRepo $GetBranch