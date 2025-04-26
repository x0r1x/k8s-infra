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

variable "yc_sa_key" {
  type = string
  sensitive = true
  description = "Service Account key"
}

variable "network" {
  type = object({
    network_name = string
    subnets = map(string)
  })
}