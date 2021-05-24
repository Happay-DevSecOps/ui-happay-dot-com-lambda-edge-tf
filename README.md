## Deploy lambda edge function to redirect your Cloudfront on country wide URLs

Such as -     
APAC_REGION / Suffix = ["SG", "TH", "MY", "VN", "RI", "KH", "MM"] / sg 

*Note* -  For a request from APAC_REGION country code, requests will get redirected from "happay.com" to "happay.com/sg"



#### 1. Create a SSM parameter store key to store KMS KEY value - 
Like - /happay/prd/regional-shared/kms_key_arn     

*Note* - Chage your ORG_ID in code(default.tf) as desired.



#### 2. Deploy it -

```
export AWS_ACCESS_KEY_ID=xxxx
export AWS_SECRET_ACCESS_KEY=xxxx

export ENVIRON=uat
export AWS_DEFAULT_REGION=us-east-1
export TF_VAR_s3_bucket_name="hpy-tf-us-$ENVIRON-$AWS_DEFAULT_REGION"

./init.sh $ENVIRON init
./init.sh $ENVIRON plan
./init.sh $ENVIRON apply
```