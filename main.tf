# main.tf

# 1. Define the required providers and their versions
terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0"
    }
  }
}

# 2. Configure the Docker Provider
# Since we are running this ON the EC2 instance, 
# Terraform can connect to the local Docker daemon.
provider "docker" {}

# 3. Pull a Docker Image (e.g., Nginx)
resource "docker_image" "nginx_image" {
  name = "nginx:latest"
  keep_locally = true
}

# 4. Create and run a Docker Container
resource "docker_container" "nginx_container" {
  name  = "terraform-nginx-container"
  image = docker_image.nginx_image.image_id
  # Maps port 80 on the EC2 host to port 80 on the container
  ports {
    internal = 80
    external = 80
  }
  # This ensures the image is pulled before the container is created (Resource Dependency)
  depends_on = [docker_image.nginx_image] 
}
