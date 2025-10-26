variable "namespace" {
  type        = string
  description = "A short company abbreviation for unique global IDs."
}

variable "stage" {
  type        = string
  description = "The deployment stage (e.g., dev, prod)."
}

variable "name" {
  type        = string
  description = "The component name for the resource (e.g., vpc)."
}

variable "cidr_block" {
  type        = string
  description = "The CIDR block for the VPC."
}

variable "public_subnet_count" {
  type        = number
  description = "The number of public subnets to create."
}

// Add this if it's used to pass tags from the caller
variable "default_tags" {
  type        = map(string)
  default     = {}
  description = "Default tags to apply to all resources."
}