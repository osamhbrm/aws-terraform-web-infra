AWS High-Availability Web Infrastructure with Terraform 🚀
This repository contains a production-grade, highly available web infrastructure on AWS, provisioned entirely through Infrastructure as Code (IaC) using Terraform.

🏗️ Architecture Features
Networking: Custom VPC with Public and Private Subnets distributed across multiple Availability Zones (Multi-AZ) for maximum resilience.

Security: * Security Group Chaining: Implemented strict multi-tier traffic control between the Load Balancer, Web servers, and Database.

Database Isolation: The RDS instance resides in private subnets with no direct internet exposure.

IAM Roles & Instance Profiles: Used for secure, keyless access to AWS services (Secrets Manager) without static credentials.

Automation & Scalability: * Auto Scaling Group (ASG): Configured with Instance Refresh policies for seamless updates.

Application Load Balancer (ALB): Efficiently distributes incoming traffic across healthy instances.

Secrets Management: Dynamic retrieval of RDS credentials via AWS Secrets Manager, eliminating hardcoded passwords in the codebase.

Secure Outbound Access: NAT Gateways allow instances in private subnets to fetch system updates securely.

🛠️ Technology Stack
Cloud Provider: AWS

IaC Tool: Terraform

Web Server: Apache (HTTPD)

Database: Amazon RDS (MariaDB)

Secrets Management: AWS Secrets Manager

CI/CD: GitHub Actions (In Progress 🚧)

📖 How it Works
Infrastructure Provisioning: Terraform orchestrates the networking layer (VPC, IGW, NAT Gateways).

Database Deployment: A private RDS instance is launched within dedicated data subnets.

Compute & Scaling: An Auto Scaling Group launches EC2 instances based on a versioned Launch Template.

Bootstrapping (User Data): Upon launch, instances execute a shell script to:

Install and configure the Apache web server.

Securely authenticate with Secrets Manager using the assigned IAM Role.

Fetch database credentials dynamically for internal configuration.

Maintained by OsamhBrm
