#! /bin/bash

# . pushg2/run.sh doa begonia-q-oss-std-d-almk begonia-q-oss-std-d-slmk begonia-q-oss-uv-d-almk begonia-q-oss-uv-d-slmk begonia-q-oss-uv-slmk begonia-q-oss-uv-almk begonia-q-oss-uv-b-slmk begonia-q-oss-uv-b-almk && \
# . pushg2/run.sh dob begonia-q-oss-std-slmk begonia-q-oss-std-almk begonia-q-oss-std-b-slmk begonia-q-oss-std-b-almk begonia-r-oss-std-d-almk begonia-r-oss-std-d-slmk begonia-r-oss-uv-d-almk begonia-r-oss-uv-d-slmk && \
# . pushg2/run.sh doc begonia-r-oss-uv-slmk begonia-r-oss-uv-almk begonia-r-oss-uv-b-slmk begonia-r-oss-uv-b-almk begonia-r-oss-std-slmk begonia-r-oss-std-almk begonia-r-oss-std-b-slmk begonia-r-oss-std-b-almk


for asua in begonia-q-oss-std-d-almk begonia-q-oss-std-d-slmk begonia-q-oss-uv-d-almk begonia-q-oss-uv-d-slmk begonia-q-oss-uv-slmk begonia-q-oss-uv-almk begonia-q-oss-uv-b-slmk begonia-q-oss-uv-b-almk
do
    SetBranch="my-builder-$asua"
    . pushg2/run.sh doa $asua
done
for asua in begonia-q-oss-std-slmk begonia-q-oss-std-almk begonia-q-oss-std-b-slmk begonia-q-oss-std-b-almk begonia-r-oss-std-d-almk begonia-r-oss-std-d-slmk begonia-r-oss-uv-d-almk begonia-r-oss-uv-d-slmk
do
    SetBranch="my-builder-$asua"
    . pushg2/run.sh dob $asua
done
for asua in begonia-r-oss-uv-slmk begonia-r-oss-uv-almk begonia-r-oss-uv-b-slmk begonia-r-oss-uv-b-almk begonia-r-oss-std-slmk begonia-r-oss-std-almk begonia-r-oss-std-b-slmk begonia-r-oss-std-b-almk
do
    SetBranch="my-builder-$asua"
    . pushg2/run.sh doc $asua
done

