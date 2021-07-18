variable "subscription_id" {
  default = $(TF_VAR_subscription_id)
}

variable "client_id" {
  default = $(TF_VAR_client_id)
}

variable "client_secret" {
  default = $(TF_VAR_client_secret)
}

variable "tenant_id" {
  default = $(TF_VAR_tenant_id)
}

variable "environment" {
  default = "production"
}