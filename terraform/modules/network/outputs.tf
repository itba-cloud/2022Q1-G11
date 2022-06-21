output "subnet_id" {
  description = "Subnet's id"
  value       = aws_subnet.this.id
}

output "sg_id" {
  description = "Security group's id"
  value       = aws_security_group.this.id
}