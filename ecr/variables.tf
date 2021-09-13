variable "aws_region" {
  description = "The AWS region in which the resources will be created."
  type        = string
}

variable "name" {
  type        = string
  description = "The name of the ecr repo to be created."
}

variable "image_tag_mutability" {
  type        = string
  description = "The tag mutability setting for the repository."
}

variable "scan_on_push" {
  type    = bool
  description = "Indicates whether images are scanned after being pushed to the repository (true) or not scanned (false)."
}