#!/bin/bash
set -e

# $1 - path to folder to compress
# $2 - name to call archive
# $3 - path to move archive to

module load tar zstd

# make archive
srun --time 7-00:00 -c 16 tar -I "zstd -T10 -16" -cvf  $2 $1
#tar -I "zstd -T10 -1" -cvf  $2 $1

copy_md5.sh $2 $3
