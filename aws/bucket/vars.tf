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

variable "hot_retention" {
  default = 7
  description = "days to retain objects on s3 before being moved to cold storage"
}

variable "cold_storage_enabled" {
  default = true
  description = "flag to indicate if bucket will use cold storage for older objects"
}

