variable "glue_db_name" {
  type        = string
  description = "Database name"
}

variable "glue_table_name" {
  type        = string
  description = "Table name"
}

variable "glue_table_description" {
  type        = string
  description = "Table description"
}

variable "table_type" {
  type        = string
  description = "Table type. (e.g.: EXTERNAL_TABLE)"
}

variable "is_table_external" {
  type        = string
  description = "TRUE or FALSE"
}

variable "data_location" {
  type        = string
  description = "Path towards data location (e.g.: s3://aws_s3_bucket.myservice.bucket/myservice/mydata)"
}

variable "input_format" {
  type        = string
  description = "Storage input format. (e.g.: org.apache.hadoop.hive.ql.io.parquet.MapredParquetInputFormat)"
}

variable "output_format" {
  type        = string
  description = "Storage input format. (e.g.: org.apache.hadoop.hive.ql.io.parquet.MapredParquetOutputFormat)"
}

variable "ser_name" {
  type        = string
  description = "serialization info name"
}

variable "ser_lib" {
  type        = string
  description = "Chosen serialization library"
}

variable "ser_format" {
  type        = string
  description = "Serialization format (e.g.: 1)"
}

variable "columns" {
  type        = map(any)
  description = "Columns that data structure has"
}