variable "filename" {
  type        = string
  description = "Path to the zipped payload"
}

variable "function_name" {
  type        = string
  description = "Name of the lambda function"
}

variable "handler" {
  type        = string
  description = "Name of the lambda handler. (Entry point on lambda code)"
}

variable "desc" {
  type        = string
  description = "Lambda function explanation. Short description of what it does"
  default     = ""
}

variable "runtime" {
  type        = string
  description = "Lambda function runtime language. (e.g.: pythonx nodejsx, ...)"
  default     = "python3.9"
}

variable "iam_role_name" {
  type        = string
  description = "IAM role name"
}

variable "iam_role_arn" {
  type        = string
  description = "IAM role arn"
}

variable "iam_policy_name" {
  type        = string
  description = "IAM policy name"
}

variable "iam_policy_content" {
  type        = string
  description = "IAM policy. Should only give permissions to whatever lambda needs to communicate with / do"
}

variable "private_subnet_id" {
  type        = string
  description = "Private subnet id for the subnet where the lambda lives"
}

variable "lambda_sg_id" {
  type        = string
  description = "Security Group for the current lambda"
}

variable "lambda_tag_name" {
  type        = string
  description = "Lambda tag for resource identification"
}