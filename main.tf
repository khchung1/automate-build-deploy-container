data "aws_vpc" "selected" {
  filter {
    name   = "tag:Name"
    values = ["Default VPC"]
  }
}

data "aws_subnets" "public" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.selected.id]
  }
}

module "ecs" {
  source = "terraform-aws-modules/ecs/aws"

  cluster_name = "kh-ecs"   #Change

  fargate_capacity_providers = {
    FARGATE = {
      default_capacity_provider_strategy = {
        weight = 100
      }
    }
  }

  services = {
    kh-service = { #task def and service name -> #Change
      cpu    = 512
      memory = 1024

      # Container definition(s)
      #task definition
      container_definitions = {

        ecs-sample = { #container name
          essential = true 
          image     = var.repo_uri_variable
          port_mappings = [
            {
              name          = "ecs-sample"  #container name
              containerPort = 8080
              protocol      = "tcp"
            }
          ]
          readonly_root_filesystem = false

        }
      }
      assign_public_ip = true
      deployment_minimum_healthy_percent = 100
      subnet_ids = flatten(data.aws_subnets.public.ids)
      security_group_ids  = [aws_security_group.allow_sg.id]
    }
  }
}

resource "aws_security_group" "allow_sg" {
  name        = "kh-allow_tls" #add your name to prefix
  description = "Allow traffic"
  vpc_id      = data.aws_vpc.selected.id

  ingress {
    description = "Allow all"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"] #allow internet access
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_sg"
  }
}

# resource "aws_ecrpublic_repository" "foo" {

#   repository_name = "kh-ecr-repo"

#   tags = {
#     env = "production"
#   }
# }