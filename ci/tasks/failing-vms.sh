#!/bin/bash
echo 'Checking BOSH VMs'

#Needed to login
#$ export BOSH_CLIENT=ci
#$ export BOSH_CLIENT_SECRET=ci-password

bosh --ca-cert cacert/bosh.pem target $BOSH_URL
bosh vms >> output.txt
cat output.txt
cat output.txt | grep failing | wc -l > result.txt
grep 0 result.txt
