variable "writer_users" {
  description = "a csv list of valid bucket writers"
  default     = ""
}

variable "reader_users" {
  description = "a csv list of valid bucket writers"
  default     = ""
}

variable "project_id" {
  description = "the project ID"
}

variable "project_number" {
  description = "the project number"
}

variable "name" {
  description = "the bucket name to create"
}

variable "team" {
  description = "the team the bucket belongs to"
}

variable "env" {
  default = "the environment"
}
