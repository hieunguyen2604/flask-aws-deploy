variable "public_key_path" {
  description = "Path to your SSH public key"
  type        = string
  default     = "/Users/hieunguyen/.ssh/id_rsa.pub"
}

variable "private_key_path" {
  description = "Path to your SSH private key"
  type        = string
  default     = "/Users/hieunguyen/.ssh/id_rsa"
}
