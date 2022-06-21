module "s3-front" {
  for_each = local.s3_front
  source   = "./../modules/s3_4.0"

  providers = {
    aws = aws.aws
  }

  bucket_name        = each.value.bucket_name
  objects            = try(each.value.objects, {})
  bucket_acl         = try(each.value.bucket_acl, "private")
  public_read_policy = try(each.value.public_read_policy, false)
  index_file         = try(each.value.index_file, null)
  redirect_hostname  = try(each.value.redirect_hostname, null)
  bucket_tag         = each.value.bucket_tag
}

module "s3-data" {
  for_each = local.s3_data
  source   = "./../modules/s3_4.0"

  providers = {
    aws = aws.aws
  }

  bucket_name        = each.value.bucket_name
  objects            = try(each.value.objects, {})
  bucket_acl         = try(each.value.bucket_acl, "private")
  public_read_policy = try(each.value.public_read_policy, false)
  bucket_tag         = each.value.bucket_tag
}

module "cloudfront" {
  source     = "./../modules/cloudfront"
  depends_on = [module.s3-front, module.api-gw]
  providers = {
    aws = aws.aws
  }

  cdn_tag_name = "Cloudfront Github Data"

  origin = {
    api-gateway = {
      domain_name = replace(replace(module.api-gw.rest_api_domain_name, "https://", ""), "/", "")
      origin_path = module.api-gw.rest_api_path
      custom_origin_config = {
        http_port              = 80
        https_port             = 443
        origin_protocol_policy = "match-viewer"
        origin_ssl_protocols   = ["TLSv1.2"]
      }
    }
    presentation_s3_bucket = {
      domain_name = module.s3-front["website"].website_endpoint

      custom_origin_config = {
        http_port              = 80
        https_port             = 443
        origin_protocol_policy = "match-viewer"
        origin_ssl_protocols   = ["TLSv1.2"]
      }
    }
  }

  default_cache_behavior = {
    target_origin_id = "presentation_s3_bucket"
  }
}

module "network" {
  source = "./../modules/network"

  providers = {
    aws = aws.aws
  }

  vpc_cidr          = "10.0.0.0/16"
  vpc_tenancy       = local.vpc.tenancy
  vpc_tag_name      = "G11-VPC"
  subnet_cidr       = "10.0.0.0/24"
  subnet_az         = local.az1
  subnet_tag_name   = "Private Subnet 1"
  sg_tag_name       = local.vpc_sg.name
  ingress_protocol  = -1
  ingress_self      = true
  ingress_from_port = 0
  ingress_to_port   = 0
  egress_from_port  = 0
  egress_to_port    = 0
  egress_protocol   = -1
  egress_cidr       = ["0.0.0.0/0"]

}

module "lambda" {
  for_each = local.lambdas
  source   = "./../modules/lambda"

  providers = {
    aws = aws.aws
  }

  depends_on = [
    module.network
  ]

  function_name      = each.value.function_name
  handler            = each.value.handler
  runtime            = each.value.runtime
  desc               = each.value.desc
  filename           = each.value.filename
  iam_role_name      = each.value.iam_role_name
  iam_role_arn       = each.value.iam_role_arn
  iam_policy_name    = each.value.iam_policy_name
  iam_policy_content = each.value.iam_policy_content
  private_subnet_id  = module.network.subnet_id
  lambda_sg_id       = module.network.sg_id
  lambda_tag_name    = each.value.tag_name
}

module "eventbridge" {
  source = "./../modules/eventbridge"

  providers = {
    aws = aws.aws
  }

  rule_name           = "lamda-ingestion-caller"
  rule_description    = "Calls lambda that loads data into S3"
  schedule_expression = "rate(1 day)"
  target_arn          = module.lambda["ingestion"].lambda_function_arn

}

module "api-gw" {
  source = "./../modules/api-gw"

  providers = {
    aws = aws.aws
  }

  depends_on = [
    module.lambda
  ]

  rest_api_name     = "AWSAPIGateway-g11"
  rest_api_desc     = "Catch all user queries for lambda"
  rest_api_tag_name = "Api Gateway Github Data"
  lambda_func_name  = module.lambda["queries"].lambda_function_name
  lambda_func_arn   = module.lambda["queries"].lambda_invoke_function_arn
}


# module "athena" {
#   source = "./../modules/athena"

#   providers = {
#     aws = aws.aws
#   }

#   depends_on = [
#     module.s3-data
#   ]

#   glue_db_name           = "g11-athena"
#   glue_table_name        = "user-data"
#   glue_table_description = "Contains curated github data to answer user queries"
#   table_type             = "EXTERNAL_TABLE"
#   is_table_external      = "TRUE"
#   //Example: data_location = "s3://${aws_s3_bucket.myservice.bucket}/myservice/mydata"
#   // Should it be arn + path to object?
#   data_location = module.s3-data["data-curated"].arn
#   input_format  = "org.apache.hadoop.mapred.TextInputFormat"
#   output_format = "org.apache.hadoop.hive.ql.io.IgnoreKeyTextOutputFormat"
#   ser_name      = "user-data-ser-s3-stream"
#   ser_lib       = "org.openx.data.jsonserde.JsonSerDe"
#   ser_format    = 1

#   columns = {
#     id                 = "int"
#     username           = "string"
#     rating             = "double"
#     account_created_at = "date"
#     best_lang          = "string"
#   }
# }
