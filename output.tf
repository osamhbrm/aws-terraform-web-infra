output "alb_dns_name" {
  description = "The DNS name of the Load Balancer"
  value       = "http://${aws_lb.main_alb.dns_name}"
}