#using $GITHUB_ENV, Terraform will automatically recognize and use it as an input variable. 
variable "repo_uri_variable" {
  type = string
  description = "The repository URI from ECR" 
}