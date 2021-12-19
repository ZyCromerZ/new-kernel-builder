#! /bin/bash

GetRepo="${1}"
shift
GetBranch="${@}"
[[ -z "$GetRepo" ]] && GetRepo="doa"
[[ -z "$GetBranch" ]] && GetBranch="begonia-q-oss-uv begonia-q-oss-uv-b begonia-q-oss-uv-c begonia-q-oss-uv-d begonia-q-oss-std begonia-q-oss-std-b begonia-q-oss-std-c begonia-q-oss-std-d begonia-q-oss-stock begonia-q-oss-stock-b begonia-q-oss-stock-c"
SetBranch="bego-q-builder"
. pushg/vayu.sh $GetRepo $GetBranch