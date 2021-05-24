export AWS_ACCESS_KEY_ID=xxxx
export AWS_SECRET_ACCESS_KEY=xxxx

export ENVIRON=uat
export AWS_DEFAULT_REGION=us-east-1
export TF_VAR_s3_bucket_name="hpy-tf-us-$ENVIRON-$AWS_DEFAULT_REGION"

./init.sh $ENVIRON init
./init.sh $ENVIRON plan
./init.sh $ENVIRON apply
