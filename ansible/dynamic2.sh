#!/bin/bash

GROUPS='app db'

gcloud compute instances list|grep RUNNING|awk 'BEGIN{apps="";dbs=""}{if($1 ~ /app/){ apps=($1   ansible_host\=$5)}} END{print apps}'
