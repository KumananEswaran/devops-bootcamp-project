variable "github_repo" {
  description = "GitHub repository allowed to assume the CI roles, as owner/name"
  type        = string
  default     = "KumananEswaran/devops-bootcamp-project"
}

variable "state_bucket" {
  description = "S3 bucket holding Terraform state (never destroyed)"
  type        = string
  default     = "devops-bootcamp-terraform-kumanan"
}
