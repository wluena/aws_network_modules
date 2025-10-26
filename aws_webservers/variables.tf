variable "vpc_id" {
  type        = string
  description = "The ID of the VPC to deploy resources into."
}

variable "public_subnets" {
  type        = list(string)
  description = "A list of public subnet IDs to launch instances in."
}

variable "env" {
  type        = string
  description = "Deployment environment (e.g., dev, prod)."
}

variable "prefix" {
  type        = string
  description = "Prefix used for resource naming."
}

variable "default_tags" {
  type        = map(any)
  description = "A map of default tags to apply to all resources."
}

variable "public_key_path" {
  type        = string
  description = "Local path to the public SSH key file."
}

variable "instance_type" {
  type        = string
  description = "The size of the EC2 instance to deploy."
}

variable "instance_count" {
  type        = number
  description = "The number of EC2 instances to deploy."
}