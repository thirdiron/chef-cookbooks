#!/bin/bash

# first argument - name of s3 bucket where log file should be archived
# remaining arguments - paths to log file that are getting rotated

bucket=$1
shift
for filePath in "$@"
do
  datestamp=`date +%m_%d_%y_%H_%M`
  archivalname=$(basename $filePath)_$datestamp
  echo "First param: $1"
  echo "Second param: $2"
  echo "Third param: $3"
  cp $filePath /tmp/$archivalname
  gzip /tmp/$archivalname

  s3put $bucket /tmp/${archivalname}.gz
done
