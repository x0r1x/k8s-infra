variable "yc_cloud_id" {
  type        = string
  description = "Cloud Id"
}

variable "yc_folder_id" {
  type        = string
  description = "Folder Id"
}

variable "yc_default_zone" {
  type        = string
  default     = "ru-central1-a"
  description = "Default availability zone"
}

variable "yc_sa_id" {
  type = string
  sensitive = true
}

variable "yc_sa_key" {
  type = string
  sensitive = true
  description = "Service Account key"
}

variable "ssh_public_key" {
  type = string
  sensitive = true
  description = "SSH public key"
}

variable "ssh_username" {
  type = string
  description = "SSH username"
}

variable "network" {
  type = object({
    network_name = string
    subnets = map(string)
  })
}

variable "registry" {
  type = object({
    registry_name = string
    repository_name = string
  })
}

variable "source_image" {
  type = string
  description = "Image family Id"
}