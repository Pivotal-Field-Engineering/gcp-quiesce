#!/bin/bash
echo "Starting BOSH Deployment $DEPLOYMENT_NAME"

#Needed to login
#$ export BOSH_CLIENT=ci
#$ export BOSH_CLIENT_SECRET=ci-password

bosh --ca-cert cacert/bosh.pem target $BOSH_URL

#Loops through specified deployments
for deployment in ${DEPLOYMENTS//,/ }
do
    # call your procedure/other scripts here below
    echo "Deployment $deployment"
    bosh vms $deployment
    bosh download manifest $deployment $deployment.yml
    bosh deployment $deployment.yml
    bosh -n start --force
    bosh vms $deployment >> $deployment.txt
    cat $deployment.txt
done
