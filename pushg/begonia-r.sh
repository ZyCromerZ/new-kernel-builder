#! /bin/bash

GetRepo="${1}"
shift
GetBranch="${@}"
[[ -z "$GetRepo" ]] && GetRepo="dob"
[[ -z "$GetBranch" ]] && GetBranch="begonia-r-oss-uv begonia-r-oss-uv-d begonia-r-oss-std begonia-r-oss-std-d begonia-r-oss-stock begonia-r-oss-stock-b begonia-r-oss-stock-c"
SetBranch="bego-r-builder"
. pushg/vayu.sh $GetRepo $GetBranch

. pushd/vayu.sh zero "begonia-r-oss-uv-b begonia-r-oss-uv-c begonia-r-oss-std-b begonia-r-oss-std-c"