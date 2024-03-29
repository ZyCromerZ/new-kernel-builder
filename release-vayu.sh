#! /bin/bash

# . pushg2/run.sh doa vayu-r-oss-g-c-3 vayu-r-oss-g-d-3 vayu-r-oss-g-c-2 && \
# . pushg2/run.sh dob vayu-r-oss-h-c-2 vayu-r-oss-h-d-2 vayu-r-oss-g-d-2 && \
# . pushg2/run.sh doc vayu-r-oss-i-c-4 vayu-r-oss-i-d-4

for asua in vayu-r-oss-g-c-3 vayu-r-oss-g-d-3 vayu-r-oss-g-c-2
do
    SetBranch="my-builder-$asua"
    . pushg2/run.sh doa $asua
done

for asua in vayu-r-oss-h-c-2 vayu-r-oss-h-d-2 vayu-r-oss-g-d-2
do
    SetBranch="my-builder-$asua"
    . pushg2/run.sh dob $asua
done

for asua in vayu-r-oss-i-c-4 vayu-r-oss-i-d-4
do
    SetBranch="my-builder-$asua"
    . pushg2/run.sh doc $asua
done

# vayu-r-oss-f-e vayu-r-oss-f-f
# vayu-r-oss-g-e vayu-r-oss-g-f
# vayu-r-oss-h-e vayu-r-oss-h-f
