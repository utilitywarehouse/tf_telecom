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

variable cors_allowed_headers {
  default = []
  type = list(string)
  description = "a list of allowed headers for CORS"
}

variable cors_allowed_methods {
  default = []
  type = list(string)
  description = "a list of allowed methods, ie. PUT GET"
}

variable "cors_allowed_origins" {
  default = []
  type = list(string)
  description = "a list of allowed origins"
}

variable "cors_expose_headers" {
  default = ["ETag"]
  type = list(string)
  description = "a list of exposed headers from the object"
}

variable "cors_max_age" {
  default = 3000
  type = number
  description = "max age for cache instruction cors"
}
