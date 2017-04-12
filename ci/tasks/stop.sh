#!/bin/bash

#Needed to login
#$ export BOSH_CLIENT=ci
#$ export BOSH_CLIENT_SECRET=ci-password

bosh --ca-cert cacert/bosh.pem target $BOSH_URL

#Loops through ODB instances
bosh deployments | grep service-instance | cut -d \| -f 2
for deployment in `bosh deployments | grep service-instance | cut -d \| -f 2` ; do
    echo "Stopping Deployment: $deployment"
    bosh vms $deployment
    bosh download manifest $deployment $deployment.yml
    #set UID
    #bosh status | grep UUID | tr -s ' ' | cut -d ' ' -f 3 > UID.txt
    #uid=`cat UID.txt`
    #echo "Director UID: $uid"
    #echo "director_uuid: $uid" >> $deployment.yml
    bosh deployment $deployment.yml
    bosh -n stop --hard --force
    bosh vms $deployment >> $deployment.txt
    cat $deployment.txt
done

#Loops through specified deployments and stop in reverse order
deployment=(${DEPLOYMENTS//,/ })
for ((i = ${#deployment[@]} - 1;i >= 0;i--))
do
    curr_deploy=${deployment[i]}
    echo "Stopping Deployment $i: $curr_deploy"
    bosh vms $curr_deploy
    bosh download manifest $curr_deploy $curr_deploy.yml
    bosh deployment $curr_deploy.yml
    bosh -n stop --hard --force
    bosh vms $curr_deploy >> $curr_deploy.txt
    cat $curr_deploy.txt
done
