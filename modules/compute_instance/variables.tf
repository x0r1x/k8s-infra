variable "service_account_id" {
  type = string
  sensitive = true
}

variable "ssh_username" {
    type = string
    sensitive = true
}

variable "ssh_public_key" {
    type = string
    sensitive = true
}

# Compute Instance
variable "master_count" {
  type        = number
  description = "Number of master nodes"
  default     = 1
}

variable "node_count" {
  type        = number
  description = "Number of worker nodes"
  default     = 2
}

variable "source_image" {
  type = string
}

variable "master_resources" {
  type = object({
    cores  = number
    memory = number
  })
  default = {
    cores  = 2
    memory = 4
  }
}

variable "node_resources" {
  type = object({
    cores  = number
    memory = number
  })
  default = {
    cores  = 2
    memory = 4
  }
}

# NET
variable "zones" {
  type        = list(string)
  description = "Map of subnet IDs per availability zone"
}

variable "network_id" {
  type        = string
  description = "Network ID for Kubernetes cluster"
}

variable "subnet_ids" {
  type        = list(string)
  description = "Map of subnet IDs per availability zone"
}

variable "security_group_id" {
  type        = string
  description = "Security group ID"
}

variable "nat" {
  type        = bool
  description = "Enable NAT for public IP"
  default     = true
}

