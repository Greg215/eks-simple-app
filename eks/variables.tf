# ---------------------------------------------------------------------------------------------------------------------
# REQUIRED MODULE PARAMETERS
# These variables must be passed in by the operator.
# ---------------------------------------------------------------------------------------------------------------------

variable "aws_region" {
  description = "The AWS region in which the resources will be created."
  type        = string
}

variable "cidr_block" {
  type        = string
  description = "CIDR for the VPC"
}

variable "name" {
  type        = string
  description = "The name of the eks worker cluster."
}

variable "instance_type" {
  type        = string
  description = "Instance type to launch"
}

variable "health_check_type" {
  type        = string
  description = "Controls how health checking is done. Valid values are `EC2` or `ELB`"
  default     = "EC2"
}

variable "min_size" {
  type        = number
  description = "The minimum size of the autoscale group"
}

variable "max_size" {
  type        = number
  description = "The maximum size of the autoscale group"
}

variable "wait_for_capacity_timeout" {
  type        = string
  description = "A maximum duration that Terraform should wait for ASG instances to be healthy before timing out. Setting this to '0' causes Terraform to skip all Capacity Waiting behavior"
  default     = "5m"
}

variable "autoscaling_policies_enabled" {
  type        = bool
  default     = true
  description = "Whether to create `aws_autoscaling_policy` and `aws_cloudwatch_metric_alarm` resources to control Auto Scaling"
}

variable "cpu_utilization_high_threshold_percent" {
  type        = number
  default     = 70
  description = "The value against which the specified statistic is compared"
}

variable "cpu_utilization_low_threshold_percent" {
  type        = number
  default     = 30
  description = "The value against which the specified statistic is compared"
}

variable "cluster_security_group_id" {
  type        = string
  description = "Security Group ID of the EKS cluster"
  default     = ""
}

variable "key_name" {
  type        = string
  description = "SSH key name that should be used for the instance"
}

variable "image_id" {
  type        = string
  description = "EC2 image ID to launch. If not provided, the module will lookup the most recent EKS AMI. See https://docs.aws.amazon.com/eks/latest/userguide/eks-optimized-ami.html for more details on EKS-optimized images"
}

variable "additional_security_group_ids" {
  type        = list(string)
  default     = []
  description = "Additional list of security groups that will be attached to the autoscaling group"
}

variable "associate_public_ip_address" {
  type        = bool
  description = "Associate a public IP address with an instance in a VPC"
  default     = true
}

variable "cluster_security_group_ingress_enabled" {
  type        = bool
  description = "Whether to enable the EKS cluster Security Group as ingress to workers Security Group"
  default     = false
}

variable "kubernetes_version" {
  type        = string
  description = "Desired Kubernetes master version. If you do not specify a value, the latest available version is used"
}

variable "subdomian" {
  type    = string
}

variable "nat_gateway_enabled" {
  type    = bool
  default = true
}

variable "instance_market_options" {
  description = "The market (purchasing) option for the instances"

  type = object({
    market_type = string
    spot_options = object({
      block_duration_minutes         = number
      instance_interruption_behavior = string
      max_price                      = number
      spot_instance_type             = string
      valid_until                    = string
    })
  })

  default = null
}

variable "zone_id" {
  type = string
  description = "Route53 zone id"
}

variable "aws-load-balancer-ssl-cert-arn" {
  type = string
}