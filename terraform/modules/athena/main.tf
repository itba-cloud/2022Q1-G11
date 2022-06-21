resource "aws_glue_catalog_database" "this" {
  name = var.glue_db_name
  create_table_default_permission {
    permissions = ["SELECT"]
  }
}

resource "aws_glue_catalog_table" "this" {
  database_name = aws_glue_catalog_database.this.name
  name          = var.glue_table_name
  description   = var.glue_table_description

  table_type = var.table_type

  parameters = {
    EXTERNAL = var.is_table_external
  }

  storage_descriptor {
    location      = var.data_location
    input_format  = var.input_format
    output_format = var.output_format

    ser_de_info {
      name                  = var.ser_name
      serialization_library = var.ser_lib

      parameters = {
        "serialization.format" = var.ser_format
      }
    }

    dynamic "columns" {
      for_each = var.columns

      content {
        name = columns.key
        type = columns.value
      }
    }
  }
}