output "alb_dns_name" {
  description = "The DNS name of the Load Balancer"
  value       = "http://${module.compute.lb}"
}