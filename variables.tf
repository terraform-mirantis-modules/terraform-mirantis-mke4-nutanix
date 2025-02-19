variable "nutanix" {
  description = "Nutanix environment variables"
  type = object({
    endpoint = string
    username = string
    password = string
    insecure = optional(bool)
  })
  default = null
}

variable "nodegroups" {
  description = "A map of machine group definitions"
  type = map(object({
    count                = number
    ssh_private_key_file = string
    ssh_public_key_file  = string
    cpu                  = number
    ram                  = number
    disk                 = number
    role                 = string # currently "worker" or "controller+worker" only
    user                 = string
    image                = string
    network_config_name  = string
  }))
  default = {}
}

variable "network_config" {
  description = "Network configuration"
  type = map(object({
    subnet_name = string
    type        = string
    ip_range    = optional(string)
    gateway     = optional(string)
    nameserver  = optional(string)
  }))

  default = null

  # this validation make sure that all network parameters are set if type of network is "IPAM"
  validation {
    condition = alltrue([for k, v in var.network_config : v.type == "IPAM" ? alltrue(v.ip_range != null &&
      v.gateway != null
    && v.nameserver != null) : true])
    error_message = "Network type is IPAM, but necessary variables are not specified (ip_range, gateway, and/or nameserver) for one or many networks"
  }
}

variable "cluster_name" {
  description = "Name of the cluster (will be used as prefix for cluster nodes)"
  default     = "mkex-cluster"
}

variable "external_address" {
  description = "IP address or DNS name that will be used to access the cluster"
}
