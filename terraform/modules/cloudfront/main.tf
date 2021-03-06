# Cloudfront distribution for S3 origin (https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront_distribution)

resource "aws_cloudfront_distribution" "this" {

  #TODO: setear los defaults que nosotros queremos
  # aliases             = var.aliases
  # comment             = var.comment
  default_root_object = "index.html"
  enabled             = true
  # http_version        = var.http_version
  # is_ipv6_enabled     = false
  # price_class         = var.price_class
  # retain_on_delete    = var.retain_on_delete
  # wait_for_deployment = var.wait_for_deployment
  # web_acl_id          = var.web_acl_id
  tags = {
    Name = var.cdn_tag_name
  }

  dynamic "origin" {
    for_each = var.origin
    content {
      domain_name         = origin.value.domain_name
      origin_id           = lookup(origin.value, "origin_id", origin.key)
      origin_path         = lookup(origin.value, "origin_path", "")
      connection_attempts = lookup(origin.value, "connection_attempts", null)
      connection_timeout  = lookup(origin.value, "connection_timeout", null)

      dynamic "s3_origin_config" {
        for_each = length(keys(lookup(origin.value, "s3_origin_config", {}))) == 0 ? [] : [lookup(origin.value, "s3_origin_config", {})]

        content {
          origin_access_identity = lookup(s3_origin_config.value, "cloudfront_access_identity_path", lookup(lookup(aws_cloudfront_origin_access_identity.this, lookup(s3_origin_config.value, "origin_access_identity", ""), {}), "cloudfront_access_identity_path", null))
        }
      }

      dynamic "custom_origin_config" {
        for_each = length(lookup(origin.value, "custom_origin_config", "")) == 0 ? [] : [lookup(origin.value, "custom_origin_config", "")]

        content {
          http_port                = custom_origin_config.value.http_port
          https_port               = custom_origin_config.value.https_port
          origin_protocol_policy   = custom_origin_config.value.origin_protocol_policy
          origin_ssl_protocols     = custom_origin_config.value.origin_ssl_protocols
          origin_keepalive_timeout = lookup(custom_origin_config.value, "origin_keepalive_timeout", null)
          origin_read_timeout      = lookup(custom_origin_config.value, "origin_read_timeout", null)
        }
      }

    }
  }

  # dynamic "logging_config" {
  #     for_each = length(keys(var.logging_config)) == 0 ? [] : [var.logging_config]

  #     content {
  #         bucket          = logging_config.value["bucket"]
  #         prefix          = lookup(logging_config.value, "prefix", null)
  #         include_cookies = lookup(logging_config.value, "include_cookies", null)
  #     }
  # }

  dynamic "default_cache_behavior" {
    for_each = [var.default_cache_behavior]
    iterator = i

    content {
      allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
      cached_methods   = ["GET", "HEAD"]
      target_origin_id = i.value["target_origin_id"]

      forwarded_values {
        query_string = false

        cookies {
          forward = "none"
        }
      }

      viewer_protocol_policy = "allow-all"
      min_ttl                = 0
      default_ttl            = 3600
      max_ttl                = 86400
    }
  }

  restrictions {
    dynamic "geo_restriction" {
      for_each = [var.geo_restriction]

      content {
        restriction_type = lookup(geo_restriction.value, "restriction_type", "none")
        locations        = lookup(geo_restriction.value, "locations", [])
      }
    }
  }

  viewer_certificate {
    acm_certificate_arn            = lookup(var.viewer_certificate, "acm_certificate_arn", null)
    cloudfront_default_certificate = lookup(var.viewer_certificate, "cloudfront_default_certificate", null)
    iam_certificate_id             = lookup(var.viewer_certificate, "iam_certificate_id", null)

    minimum_protocol_version = lookup(var.viewer_certificate, "minimum_protocol_version", "TLSv1.2_2018")
    ssl_support_method       = lookup(var.viewer_certificate, "ssl_support_method", null)
  }

}