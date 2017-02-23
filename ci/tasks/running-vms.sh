#!/bin/bash
echo 'Checking BOSH VMs'

#Needed to login
#$ export BOSH_CLIENT=ci
#$ export BOSH_CLIENT_SECRET=ci-password

bosh --ca-cert cacert/bosh.pem target $BOSH_URL
bosh vms >> output.txt
cat output.txt
#We need to ignore the web node from concourse because this will fail when we bring down CF
cat output.txt | grep -v "web/0" | grep -v "db/0" | grep -v "worker" | grep running | wc -l > result.txt
grep 0 result.txt
