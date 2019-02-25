variable "project_id" {
  description = "the Google project ID"
}

variable "write_members" {
  type = "list"
  default = []
  description = "list of members with write access"
}