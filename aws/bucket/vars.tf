variable "name" {
  description = "the bucket name"
}

variable "team" {
  description = "the team to which the bucket belongs"
}

variable "env" {
  description = "the environment the bucket exists in"
}

variable "write_access" {
  description = "arns with write access"
  default     = ""
}

variable "read_access" {
  default     = ""
  description = "arns with read access"
}

variable "list_access" {
  default     = ""
  description = "arns with list content access"
}

variable "versioning" {
  default     = false
  description = "should versioning be enabled"
}
