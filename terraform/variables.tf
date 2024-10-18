variable "public_subnet_cidr" {
  type        = string
  description = "Public Subnet CIDR"
  default     = "10.0.1.0/24"
}

variable "private_subnet_cidr" {
  type        = string
  description = "Private Subnet CIDR"
  default     = "10.0.2.0/24"
}

variable "az" {
  type        = string
  description = "Availability Zone"
  default     = "us-east-1a"
}

variable "ami" {
  default = "ami-066784287e358dad1"
}

variable "instance_type" {
  default = "t2.micro"
}

variable "key_name" {
  default = "MERN"                  # Replace it with your AWS Key Pair name
}