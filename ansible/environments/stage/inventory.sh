#!/bin/bash

export GCE_INI_PATH=`dirname $0`/gce.ini
./ansible/gce.py  
