output "instance_public_ip" {
  description = "Public IP of Strapi EC2 instance"
  value       = aws_instance.strapi.public_ip
}

output "instance_public_dns" {
  description = "Public DNS"
  value       = aws_instance.strapi.public_dns
}
