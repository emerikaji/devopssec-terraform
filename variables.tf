variable "ami" {
  description = "AMI of the desired instance"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
}

variable "access_key" {
  description = "Access key for the EC2 IAM user"
  type        = string
  sensitive   = true
  ephemeral   = true
}

variable "secret_key" {
  description = "Secret key for the EC2 IAM user"
  type        = string
  sensitive   = true
  ephemeral   = true
}
