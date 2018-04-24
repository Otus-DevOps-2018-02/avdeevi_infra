#!/bin/bash

T_ENVS='prod stage'

mkdir ./tmp && cd ./tmp 
wget https://releases.hashicorp.com/packer/1.2.2/packer_1.2.2_linux_amd64.zip && unzip packer_1.2.2_linux_amd64.zip
wget https://releases.hashicorp.com/terraform/0.11.7/terraform_0.11.7_linux_amd64.zip && unzip terraform_0.11.7_linux_amd64.zip
sudo pip2 install ansible-lint
sudo pip install ansible
cd ../

PACKER_JSONS=`ls  packer/*\.json|grep -v 'variables'`

echo "PACKER TESTS:"

for FILE in $PACKER_JSONS
do
  echo $FILE
  ./tmp/packer validate  -var-file=packer/variables.json.example $FILE || exit 1
done

rm -f terraform/backend.tf  terraform/stage/backend.tf terraform/prod/backend.tf


echo "TERRAFORM TESTS:"
for T_ENV in $T_ENVS
do
echo -n "$T_ENV  -  "
cd ./terraform/${T_ENV} && ../../tmp/terraform init && ../../tmp/terraform validate || exit 1; cd ../../
done

echo "ANSIBLE LINT TESTS:"
PLAYBOOKS=`ls ansible/playbooks/*\.yml`
for PLAY in $PLAYBOOKS
do
 echo $PLAY
 ansible-lint $PLAY || exit 1

done
