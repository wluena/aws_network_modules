// New Variable for Naming Convention
variable "namespace" {
  type        = string
  description = "A short (3-4 letters) abbreviation of the company name for globally unique IDs."
}

// Ensure 'stage' (which is passed as 'env' in your current setup) is defined
variable "stage" {
  type        = string
  description = "The name or role of the account the resource is for (e.g., prod or dev)."
}

// Ensure 'name' (which is passed as 'prefix' in your current setup) is defined
variable "name" {
  type        = string
  description = "The name of the component that owns the resources (e.g., vpc)."
}

# Default tags
variable "default_tags" {
  default = {
    "Owner" = "Irina"
    "App"   = "Web"
  }
  type        = map(any)
  description = "Default tags to be appliad to all AWS resources"
}

# Name prefix
variable "prefix" {
  default     = "week4"
  type        = string
  description = "Name prefix"
}

# Provision public subnets in custom VPC
variable "private_cidr_blocks" {
  default     = ["10.20.0.0/24", "10.20.1.0/24"]
  type        = list(string)
  description = "Public Subnet CIDRs"
}

# VPC CIDR range
variable "vpc_cidr" {
  default     = "10.20.0.0/16"
  type        = string
  description = "VPC to host static web site"
}

# Variable to signal the current environment 
variable "env" {
  default     = "test"
  type        = string
  description = "Deployment Environment"
}

