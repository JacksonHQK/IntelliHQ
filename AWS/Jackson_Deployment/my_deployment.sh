#!/bin/bash

set -e
set -u
set -x

# requires the profile to be added as parameters to this i.e. --profile myprofile

# deploy the cluster
aws emr create-cluster \
	--name 'defined configurations cluster' \
	--instance-groups file://./instance-groups.json \
	--release-label emr-5.13.0\
	--ec2-attributes file://./ec2-attributes.json \
	--service-role EMR_DefaultRole \
    --applications Name=Spark Name=Zeppelin Name=Hadoop Name=Hive\
	--configurations file://./configurations.json \
    --region ap-southeast-2 \
	--no-auto-terminate \
#	--scale-down-behavior TERMINATE_AT_TASK_COMPLETION \
    $@

