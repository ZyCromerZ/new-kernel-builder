#! /bin/bash

GetRepo="${1}"
shift
GetBranch="${@}"
[[ -z "$GetRepo" ]] && GetRepo="doa"
[[ -z "$GetBranch" ]] && GetBranch="begonia-q-oss-uv begonia-q-oss-std begonia-q-oss-stock"
SetBranch="bego-q-builder"
. pushg/vayu.sh $GetRepo $GetBranch