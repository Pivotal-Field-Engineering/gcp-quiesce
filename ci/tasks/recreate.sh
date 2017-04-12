#!/bin/bash
echo "Recreating BOSH Deployment $DEPLOYMENT_NAME"

#Needed to login
#$ export BOSH_CLIENT=ci
#$ export BOSH_CLIENT_SECRET=ci-password

bosh --ca-cert cacert/bosh.pem target $BOSH_URL

#Loops through ODB instances
bosh deployments | grep service-instance | cut -d \| -f 2
for deployment in `bosh deployments | grep service-instance | cut -d \| -f 2` ; do
  echo "Deployment $deployment"
  bosh vms $deployment
  bosh download manifest $deployment $deployment.yml
  #set UID
  #bosh status | grep UUID | tr -s ' ' | cut -d ' ' -f 3 > UID.txt
  #uid=`cat UID.txt`
  #echo "Director UID: $uid"
  #echo "director_uuid: $uid" >> $deployment.yml
  bosh deployment $deployment.yml
  bosh -n recreate --force
  bosh vms $deployment >> $deployment.txt
  cat $deployment.txt
done

#Loops through specified deployments
for deployment in ${DEPLOYMENTS//,/ }
do
    # call your procedure/other scripts here below
    echo "Deployment $deployment"
    bosh vms $deployment
    bosh download manifest $deployment $deployment.yml
    bosh deployment $deployment.yml
    bosh -n recreate --force
    bosh vms $deployment >> $deployment.txt
    cat $deployment.txt
done
