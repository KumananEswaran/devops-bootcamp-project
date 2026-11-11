variable "github_sub_prefix" {
  description = "OIDC subject prefix for the repo. Immutable form (owner/repo IDs) from: gh api repos/<owner>/<repo>/actions/oidc/customization/sub"
  type        = string
  default     = "repo:KumananEswaran@63443836/devops-bootcamp-project@1384938268"
}

variable "state_bucket" {
  description = "S3 bucket holding Terraform state (never destroyed)"
  type        = string
  default     = "devops-bootcamp-terraform-kumanan"
}
