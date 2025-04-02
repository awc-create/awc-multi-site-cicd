variable "project_name" {
  description = "The GitHub repo name used to generate unique resource names"
  type        = string
}

variable "domain_name" {
  description = "The custom domain name (optional)"
  type        = string
  default     = ""
}

variable "zone_id" {
  description = "Route53 Hosted Zone ID (optional)"
  type        = string
  default     = ""
}
