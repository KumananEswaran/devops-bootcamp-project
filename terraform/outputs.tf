output "web_public_ip" {
  description = "Elastic IP of the web server"
  value       = aws_eip.web.public_ip
}

output "web_instance_id" {
  value = aws_instance.web.id
}

output "controller_instance_id" {
  value = aws_instance.controller.id
}

output "monitoring_instance_id" {
  value = aws_instance.monitoring.id
}

output "controller_private_ip" {
  value = aws_instance.controller.private_ip
}

output "web_private_ip" {
  value = aws_instance.web.private_ip
}

output "monitoring_private_ip" {
  value = aws_instance.monitoring.private_ip
}
