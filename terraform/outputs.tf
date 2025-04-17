output "ec2_public_ip" {
  value       = aws_instance.flask_server.public_ip
  description = "EC2 public IP"
}

output "ssh_command" {
  value       = "ssh -i ~/.ssh/id_rsa ubuntu@${aws_instance.flask_server.public_ip}"
  description = "SSH into your EC2"
}

output "web_url" {
  value       = "http://${aws_instance.flask_server.public_ip}"
  description = "Access Flask web app"
}
