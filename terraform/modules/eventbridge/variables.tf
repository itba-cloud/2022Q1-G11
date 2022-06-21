variable "rule_name" {
  type        = string
  description = "Event rule name"
}

variable "rule_description" {
  type        = string
  description = "Event rule description"
  default     = ""
}

variable "schedule_expression" {
  type        = string
  description = "Schedule in which the rule will be triggered. Cron format"
}

variable "target_arn" {
  type        = string
  description = "Target arn for the rule"
}