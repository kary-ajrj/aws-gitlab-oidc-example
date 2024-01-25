variable "gitlab_tls_url" {
  type    = string
  # Avoid using https scheme because the Hashicorp TLS provider has started following redirects starting v4.
  # See https://github.com/hashicorp/terraform-provider-tls/issues/249
  default = "tls://<VALUE>:443"
}

variable "gitlab_url" {
  type    = string
  default = "<VALUE>"
}

variable "audience_value" {
  type    = string
  default = "<VALUE>"
}
