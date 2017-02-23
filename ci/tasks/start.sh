#!/bin/bash
echo "Starting BOSH Deployment $DEPLOYMENT_NAME"

#Needed to login
#$ export BOSH_CLIENT=ci
#$ export BOSH_CLIENT_SECRET=ci-password

bosh --ca-cert cacert/bosh.pem target $BOSH_URL
bosh deployment $DEPLOYMENT_FILE
bosh vms $DEPLOYMENT_NAME
bosh -n start --force
bosh vms $DEPLOYMENT_NAME >> output.txt
cat output.txt
cat output.txt | grep failing | wc -l > result.txt
grep 0 result.txt
