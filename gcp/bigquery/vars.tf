variable "project_id" {
  description = "the Google project ID"
}

variable "write_members" {
  default     = ""
  description = "list of members with write access"
}

variable "job_members" {
  default = ""
  description = "list of members with ability to run jobs"
}

variable "job_get_create_members" {
  default = ""
  description = "list of members with ability to create & get jobs"
}

variable "view_members" {
  default = ""
  description = "list of members with ability to view datasets and all of their contents"
}
