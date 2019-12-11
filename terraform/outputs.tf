output "wp-db--hostname" {
  value = aws_db_instance.rds.address
}

output "wp_alb_public_dns" {
  value =  module.alb.this_lb_dns_name
}

output "wp_server_domain" {
  value = aws_route53_record.wp_server_domain.*.fqdn
}

output "wp_server_ip" {
  value = aws_instance.wp_server.*.private_ip
}
