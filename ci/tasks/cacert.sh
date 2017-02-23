#!/bin/bash
echo 'Generating BOSH Cert'

#Needed to login
#$ export BOSH_CLIENT=ci
#$ export BOSH_CLIENT_SECRET=ci-password

echo $BOSH_CACERT | tr " " "\n" > ca-no-linebreaks.pem
cat ca-no-linebreaks.pem | tr " " "\n" > temp.pem
sed -i '/---/d' temp.pem
echo '-----BEGIN CERTIFICATE-----' > bosh-cacert.pem
cat temp.pem >> bosh-cacert.pem
echo '-----END CERTIFICATE-----' >> bosh-cacert.pem

bosh --ca-cert bosh-cacert.pem target $BOSH_URL
bosh status >> output.txt
cat output.txt
cp bosh-cacert.pem cacert/bosh.pem
