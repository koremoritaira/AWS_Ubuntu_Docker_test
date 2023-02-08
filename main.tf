# This small project creates an Ubuntu 22.04 server on AWS and runs there Docker container with Terraform.

# Define the AWS provider with the desired region
provider "aws" {
  region = "eu-central-1"
}

# Create an EC2 instance
resource "aws_instance" "example" {
  # Use the latest Ubuntu 22.04 LTS AMI
  ami           = "ami-03e08697c325f02ab"
  instance_type = "t2.micro"

  # Pass a shell script as the user data to install Docker, Git, clone the Terraform repository, build the Docker image, and run Terraform
  user_data = <<-EOF
    #!/bin/bash
    # Update the package index and install Docker and Git
    apt update
    apt install -y docker.io git

    # Clone the Terraform repository
    git clone https://github.com/koremoritaira/-epam_test_devops_spring_22_linux_bash

    # Change to the repository directory and build the Docker image
    cd repo
    docker build -t terraform-image .

    # Run Terraform inside a Docker container and mount the repository directory as a volume
    docker run -it -v $(pwd):/app terraform-image terraform init
    docker run -it -v $(pwd):/app terraform-image terraform apply
  EOF
}


