variable "aws_region" {
  description = "The AWS region in which the resources will be created."
  type        = string
}

variable "name" {
  type        = string
  description = "The name of the eks worker cluster."
}

variable "instance_type" {
  type        = string
  description = "Instance type to launch"
}

variable "key_name" {
  type        = string
  description = "SSH key name that should be used for the instance"
}