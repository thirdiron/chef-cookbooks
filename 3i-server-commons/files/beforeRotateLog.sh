#!/bin/bash

# first argument - path to log file that's getting rotated
# second argument - name of s3 bucket where log file should be archived

datestamp=`date +%m_%d_%y_%H_%M`
archivalname=$(basename $1)_$datestamp
cp $1 /tmp/$archivalname
gzip /tmp/$archivalname

s3put $2 /tmp/${archivalname}.gz 

