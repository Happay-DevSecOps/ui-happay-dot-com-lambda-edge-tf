#!/bin/bash

set -e
set +x

export TF_VAR_srcvars="init.vars"

source $TF_VAR_srcvars

echo "Validating project - $PROJECT ...."

clean () {
	echo "cleaning pre-existing state files..."
	find .terraform ! -name modules  ! -name plugins -maxdepth 1 -type f -delete 2>/dev/null || true
}

validation () {
	if [[ -z "${PROJECT}" ]]; then
 		echo "PROJECT variable not set !!"
        	echo "Exiting... "
                echo "Usage - ./init.sh \$ENVIRON(dev|uat|prep|prd) (plan|apply)"
		exit 1
	fi
        if [[ -z "${ENVIRON}" ]]; then
                echo "ENVIRON variable not set !!"
                echo "Exiting... "
                echo "Usage - ./init.sh \$ENVIRON(dev|uat|prep|prd) (plan|apply)"
                exit 1
        fi
	if [ $# -eq 0 ]; then
                echo "No parameters provided !!"
                echo "Exiting... "
                echo "Usage - ./init.sh \$ENVIRON(dev|uat|prep|prd) (plan|apply)"
                exit 1
	fi
}

init () {
	echo "Initalizing backend...."
	$TF_VAR_tfbin init -backend-config="bucket=$TF_VAR_s3_bucket_name" -backend-config="key=$TF_VAR_key" -backend-config="region=$TF_VAR_region" -backend=true
        $TF_VAR_tfbin workspace new $ENVIRON || $TF_VAR_tfbin workspace select $ENVIRON
}

plan () {
	if [[ "$2" == "plan" ]] ; then
		echo "Showing planned changes...."
		 $TF_VAR_tfbin plan
	else
		echo "No plans requested..."
	fi
}

apply () {
        if [[ "$2" == "apply" ]] ; then
                 echo "Applying changes...."
                  $TF_VAR_tfbin apply --auto-approve
        else
                echo "not applying changes, apply manually..."
        fi
}

show () {
        if [[ "$2" == "show" ]] ; then
                 echo "Showing state...."
                  $TF_VAR_tfbin show
        else
                echo "..."
        fi
}

destroy-plan () {
        if [[ "$2" == "destroy-plan" ]] ; then
                 echo "Showing destruction plan...."
                 echo no |  $TF_VAR_tfbin destroy
        else
                echo "..."
        fi
}

destroy-apply () {
        if [[ "$2" == "destroy-apply" ]] ; then
                 echo "Destroying resources...."
                  $TF_VAR_tfbin destroy --auto-approve
        else
                echo "..."
        fi
}

clean
validation $1
init
plan $1 $2
apply $1 $2
show $1 $2
destroy-plan $1 $2
destroy-apply $1 $2
