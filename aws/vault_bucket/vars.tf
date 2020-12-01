variable "name" {
  description = "the bucket name"
}

variable "team" {
  description = "the team to which the bucket belongs"
}

variable "env" {
  description = "the environment the bucket exists in"
}


variable "versioning" {
  default     = false
  description = "should versioning be enabled"
}

variable "vault_role_id" {
  description = "ID of the vault role"
}
