#using $GITHUB_ENV, Terraform will automatically recognize and use it as an input variable. 
variable "repo_uri_variable" {
  type = string
  default = "public.ecr.aws/u2q1a2y8/khchung/simple-node-app"
  description = "The repository URI from ECR" 
}