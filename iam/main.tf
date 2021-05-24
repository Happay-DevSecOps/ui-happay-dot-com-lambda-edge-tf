data "aws_region" "current" {}

resource "aws_iam_policy" "policy" {
  name        = "${local.name_prefix}-policy-${data.aws_region.current.name}"
  path        = "/"
  description = "${local.name_prefix}-policy-${data.aws_region.current.name}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "lambda:InvokeFunction"
            ],
            "Resource": [
                "arn:aws:lambda:*:*:function:Automation*"
            ]
        },
        {
            "Effect": "Allow",
            "Action": [
                "ec2:CreateImage",
                "ec2:CopyImage",
                "ec2:DeregisterImage",
                "ec2:DescribeImages",
                "ec2:DeleteSnapshot",
                "ec2:StartInstances",
                "ec2:RunInstances",
                "ec2:StopInstances",
                "ec2:TerminateInstances",
                "ec2:DescribeInstanceStatus",
                "ec2:CreateTags",
                "ec2:DeleteTags",
                "ec2:DescribeTags",
                "cloudformation:CreateStack",
                "cloudformation:DescribeStackEvents",
                "cloudformation:DescribeStacks",
                "cloudformation:UpdateStack"
            ],
            "Resource": [
                "*"
            ]
        },
        {
            "Effect": "Allow",
            "Action": [
                "s3:*",
                "codedeploy:*",
                "codebuild:*",
                "codepipeline:*",
                "codecommit:*",
                "ec2:*",
                "ecs:*",
                "ecr:*",
                "sqs:*",
                "lambda:*",
                "autoscaling:*",
                "elasticloadbalancing:*",
                "application-autoscaling:*",
                "cloudwatch:*",
                "logs:*",
                "kms:Decrypt",
                "ec2messages:*",
                "ds:*"
            ],
            "Resource": [
                "*"
            ]
        },
        {
      "NotAction": "s3:Delete*",
      "Effect": "Allow",
      "Resource": [
        "${var.s3_log_bucket_arn}",
        "${var.s3_log_bucket_arn}/*"
        ]
        },
        {
            "Effect": "Allow",
            "Action": [
                "ssm:*"
            ],
            "Resource": [
                "*"
            ]
        },
        {
            "Effect": "Allow",
            "Action": [
                "ssmmessages:*"
            ],
            "Resource": [
                "*"
            ]
        },
        {
            "Effect": "Allow",
            "Action": [
                "ec2messages:*"
            ],
            "Resource": [
                "*"
            ]
        },
        {
            "Effect": "Allow",
            "Action": [
                "sns:Publish"
            ],
            "Resource": [
                "arn:aws:sns:*:*:Automation*"
            ]
        },
        {
            "Effect": "Allow",
            "Action": [
                "lambda:InvokeFunction"
            ],
            "Resource": [
                "arn:aws:lambda:*:*:function:SSM*",
                "arn:aws:lambda:*:*:function:*:SSM*"
            ]
        },
        {
            "Effect": "Allow",
            "Action": [
                "states:DescribeExecution",
                "states:StartExecution"
            ],
            "Resource": [
                "arn:aws:states:*:*:stateMachine:SSM*",
                "arn:aws:states:*:*:execution:SSM*"
            ]
        },
        {
            "Effect": "Allow",
            "Action": [
                "resource-groups:ListGroups",
                "resource-groups:ListGroupResources"
            ],
            "Resource": [
                "*"
            ]
        },
        {
            "Effect": "Allow",
            "Action": [
                "tag:GetResources"
            ],
            "Resource": [
                "*"
            ]
        }
   ]
 }
EOF
}

resource "aws_iam_role" "role" {
  name = "${local.name_prefix}-role-${data.aws_region.current.name}"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "SSMAssumeRole",
      "Action": "sts:AssumeRole",
      "Effect": "Allow",
      "Principal": { 
        "Service": [
          "ec2.amazonaws.com", 
          "s3.amazonaws.com", 
          "ssm.amazonaws.com",
          "codedeploy.amazonaws.com",
          "codebuild.amazonaws.com",
          "codecommit.amazonaws.com",
          "codepipeline.amazonaws.com",
          "ecs.amazonaws.com",
          "ecs-tasks.amazonaws.com",
          "batch.amazonaws.com",
          "sqs.amazonaws.com",
          "vpc-flow-logs.amazonaws.com",
          "lambda.amazonaws.com",
          "edgelambda.amazonaws.com"
           ]
        }    
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "attach" {
    role       = aws_iam_role.role.name
    policy_arn = aws_iam_policy.policy.arn
}

resource "aws_iam_instance_profile" "profile" {
  name = "${local.name_prefix}-profile-${data.aws_region.current.name}"
  role = aws_iam_role.role.name
}

resource "aws_iam_role_policy" "inline_policy" {
  name = "${local.name_prefix}-ssm-iam-policy-${data.aws_region.current.name}"
  role = aws_iam_role.role.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
      {
              "Sid": "GrantsAccessToIAMRoles",
              "Effect": "Allow",
              "Action": [
                 "iam:*"
               ],
               "Resource": [
                   "${aws_iam_role.role.arn}",
                   "${aws_iam_role.role.arn}/*"
               ]
    } 
  ]
}
EOF
}
