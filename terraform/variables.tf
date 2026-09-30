variable "cloudflare_api_token" {
  description = "Cloudflare API token with Zone:DNS:Edit and Account:Cloudflare Tunnel:Edit"
  type        = string
  sensitive   = true
}

variable "domain" {
  description = "Root domain managed in Cloudflare"
  type        = string
  default     = "kumananz.com"
}

variable "cloudflare_account_id" {
  description = "Cloudflare account ID"
  type        = string
}
