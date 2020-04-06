#!/bin/bash

set -e -u -o pipefail
declare -r SCRIPT_DIR=$(cd -P $(dirname $0) && pwd)
declare cicd_prj=post-app-cicd 
declare dev_prj=post-app-sun

oc new-project $cicd_prj 
oc policy add-role-to-user edit system:serviceaccount:$cicd_prj:pipeline -n $dev_prj

oc apply -f cd -n $cicd_prj
oc apply -f tasks -n $cicd_prj
oc apply -f pipelines -n $cicd_prj
oc apply -f config/maven-configmap.yaml -n $cicd_prj

oc apply -f triggers/github-triggerbinding.yaml -n $cicd_prj
oc apply -f triggers/triggertemplate.yaml -n $cicd_prj
oc apply -f triggers -n $cicd_prj