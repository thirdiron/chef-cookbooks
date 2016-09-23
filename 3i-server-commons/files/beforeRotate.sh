#!/bin/bash

datestamp=`date +%m_%d_%y_%H_%M`
archivalname=$(basename $1)_$datestamp
cp $1 /tmp/$archivalname
gzip /tmp/$archivalname

test -z $3 && echo "No third argument!"

/vagrant/s3put.sh thirdiron-test-bucket /tmp/${archivalname}.gz /tmp/app.env

