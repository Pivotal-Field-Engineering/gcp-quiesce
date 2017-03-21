#!/bin/bash

#Needed to login
#$ export BOSH_CLIENT=ci
#$ export BOSH_CLIENT_SECRET=ci-password

bosh --ca-cert cacert/bosh.pem target $BOSH_URL

#Loops through specified deployments and stop in reverse order
deployment=(${DEPLOYMENTS//,/ })
for ((i = ${#deployment[@]} - 1;i >= 0;i--))
do
    echo "Stopping Deployment ${deployment[i]}"
    bosh vms $deployment
    bosh download manifest $deployment $deployment.yml
    bosh deployment $deployment.yml
    bosh -n stop --hard --force
    bosh vms $deployment >> $deployment.txt
    cat $deployment.txt
done
