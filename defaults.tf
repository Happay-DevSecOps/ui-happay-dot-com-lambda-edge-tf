/* DEFAULT VARIABLES */

locals {
  tags = {
  Project = local.workspace["project_name"]
  Environ = local.workspace["environ"]
  Product = "ui-lambda-edge-tf"                          
  Contact = "vivek.kumar@happay.in"                    
  Requester = "vivek.kumar@happay.in"                  
  Creator = "vivek.kumar@happay.in"
  ManagedBy = "tf"                              # tf, cf, man
  Encryption = "yes"                            # yes, no
  Department = "tech"                           # tech, marketing, accounts etc
  Compliance = "non-pci"                        # pci, non-pci, hipaa etc
  ProductVersion = "v1"                         # v1,v2
  ApplicationId = "ui-happay-dot-com-lambda-edge-tf"            # Must be same a bitbucket repo name
  Stack = "Infra"                               # frontend #backend, storage-db, storage-file, jobs-cron
  AlertGroupEmail = "vivek.kumar@happay.in"
   }
}

locals {
  meta = {
      name_prefix = "hpy-${local.workspace["environ"]}-${local.workspace["project_name"]}"
      ssm_ps_np = "/happay/${var.environ}/${var.project}"
      region_name = local.workspace["region_name"]
   }
}

################  DEFAULT LOCALS - DEFINE ENV VARIABLES FOR APP  #################
locals {
  env = {
    default = {
      project_name = var.project
      region_name = var.region
      environ = var.environ
      kms_key_arn = data.aws_ssm_parameter.kms_key_arn.value
    }
    default_list = {
    }

################  EXPORTING ENV/WORKSPACE VARIABLES FOR APP  #################
  }
  workspace = merge(local.env["default"])
  workspace_lists = merge(local.env["default_list"])
} 

data   "aws_ssm_parameter" "kms_key_arn" {
   name = "/happay/${var.environ}/regional-shared/kms_key_arn"
}
