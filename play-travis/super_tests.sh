#!/bin/bash

T_ENVS='prod stage'
PACKER_JSONS=`ls  packer/*\.json|grep -v 'variables'`

echo "PACKER TESTS:"

for FILE in $PACKER_JSONS
do
  echo $FILE
  packer validate  -var-file=packer/variables.json.example $FILE
done

echo "TERRAFORM TESTS:"
for T_ENV in $T_ENVS
do
echo -n "$T_ENV  -  "
cd ./terraform/${T_ENV} && terraform validate ; echo $?; cd ../../
done

echo "ANSIBLE LINT TESTS:"
PLAYBOOKS=`ls ansible/playbooks/*\.yml`
for PLAY in $PLAYBOOKS
do
 echo $PLAY
 ansible-lint $PLAY

done
