variable "network_name" {
  type        = string
  description = "Name of the VPC network"
}

variable "subnets_config" {
  type        = map(string)
  description = "Map of subnets configuration (zone = CIDR)"
}