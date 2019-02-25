variable "writer_users" {
  type = "list"
  description = "a list of valid bucket writers"
  default = []
}

variable "reader_users" {
  type = "list"
  description = "a list of valid bucket writers"
  default = []
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