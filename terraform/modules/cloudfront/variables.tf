variable "origin" {
  description = "Origin for distribution"
  type        = any
  default     = null
}

variable "origin_path" {
  description = "Origin path for distribution"
  type        = string
  default     = ""
}

variable "logging_config" {
  description = "The logging configuration"
  type        = any
  default     = {}
}

variable "viewer_certificate" {
  description = "The SSL configuration for this distribution"
  type        = any
  default = {
    cloudfront_default_certificate = true
    minimum_protocol_version       = "TLSv1.2_2018"
  }
}

variable "default_cache_behavior" {
  description = "The default cache behavior for this distribution"
  type        = any
  default     = null
}

variable "geo_restriction" {
  description = "The restriction configuration for this distribution (geo_restrictions)"
  type        = any
  default     = {}
}

variable "cdn_tag_name" {
  type        = string
  description = "Cloudfront tag for resource identification"
}