# Zero-Downtime-Blue-Green-Deployment-Platform
This project demonstrates an industry-grade Blue-Green Deployment strategy implemented entirely using Infrastructure as Code (Terraform), Dockerized applications, and Nginx reverse proxy on AWS EC2.
The primary goal is to achieve zero-downtime application releases by routing traffic between two identical application environments (Blue and Green) without impacting end users.

The setup provisions three EC2 instances:

Blue Environment – Running application version v1

Green Environment – Running application version v2

Nginx Reverse Proxy – Acts as a traffic switch between Blue and Green

All infrastructure provisioning, application deployment, and traffic routing are fully automated using Terraform and EC2 user_data scripts.
