locals {
  bucket_name  = "g11-20221q-itba-cloud-computing"
  path         = "./../resources"
  modules_path = "./../modules"
  region       = "us-east-1"
  az1          = "${local.region}a"

  s3_front = {

    # 1 - Website
    website = {
      bucket_name        = local.bucket_name
      path               = local.path
      bucket_acl         = "public-read"
      index_file         = "index.html"
      public_read_policy = true
      bucket_tag         = "Front Website Bucket"
      objects = {
        index = {
          filename     = "html/index.html"
          content_type = "text/html"
        }
      }
    }

    # 2 - WWW Website
    www-website = {
      bucket_name       = "www.${local.bucket_name}"
      redirect_hostname = "${local.bucket_name}.s3-website-${local.region}.amazonaws.com"
      bucket_acl        = "public-read"
      bucket_tag        = "Front www Bucket"
    }

    # 3 - Logs
    website-logs = {
      bucket_name = "${local.bucket_name}-logs"
      bucket_acl  = "private"
      bucket_tag  = "Front Logs Bucket"
    }
  }

  s3_data = {
    data-curated = {
      bucket_name = "data-curated-g11-20221q-itba-cloud-computing"
      path        = local.path
      bucket_acl  = "private"
      bucket_tag  = "Data Curated Bucket"
      objects = {
        // Should index not go here at all? Not here in example...
        index = {
          filename     = "data-curated/example-data.txt"
          content_type = "text/plain"
        }
      }
    }
    raw-data = {
      bucket_name = "raw-data-g11-20221q-itba-cloud-computing"
      bucket_acl  = "private"
      bucket_tag  = "Raw Data Bucket"
    }
  }

  vpc = {
    tenancy = "default"
  }

  vpc_sg = {
    name = "G11-VPC-SG"
  }

  lambdas = {
    queries = {
      function_name      = "lambda_execute_query"
      handler            = "lambda.handler"
      runtime            = "python3.9"
      desc               = "Lambda function to execute user queries"
      filename           = "${local.path}/lambda/lambda_query_payload.zip"
      iam_role_name      = "LabRole" //"g11-tcbj-role-lambda-queries"
      iam_role_arn       = "arn:aws:iam::693999936336:role/LabRole"
      tag_name           = "Lambda-query"
      iam_policy_name    = "g11-policy-lambda-queries"
      iam_policy_content = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "s3:ListBucket",
        "s3:GetObject"
      ],
      "Resource": [
        "*"
      ]
    }
  ]
}
EOF
    },
    ingestion = {
      function_name      = "lambda_ingest_data"
      handler            = "lambda.handler"
      runtime            = "python3.9"
      desc               = "Lambda function to load github data into S3"
      filename           = "${local.path}/lambda/lambda_ingestion_payload.zip"
      iam_role_name      = "LabRole" //"g11-tcbj-role-lambda-ingestion"
      iam_role_arn       = "arn:aws:iam::693999936336:role/LabRole"
      tag_name           = "Lambda-ingestion"
      iam_policy_name    = "g11-policy-lambda-ingestion"
      iam_policy_content = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "s3:PutObject"
      ],
      "Resource": [
        "*"
      ]
    }
  ]
}
EOF
    }
  }
}