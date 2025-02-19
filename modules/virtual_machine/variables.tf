variable "role" {
  description = "Node role"
}

variable "network_config" {
  description = "VM network configuration"
}

variable "hostname" {
  description = "The name of the VM"
}

variable "subnet_uuid" {
  description = "UUID of the subnet to attach the VMs to"
}

variable "disk_size" {
  description = "Size of the disk drive (in MiB) for the VMs"
}

variable "sockets" {
  description = "Number of vCPU sockets"
  default     = 1
}

variable "vcpu_per_socket" {
  description = "Number of vCPUs per sockets"
  default     = 4
}

variable "ram_mib" {
  description = "Amount of RAM (in MiB)"
  default     = 4096
}

variable "ip_prefix" {
  description = "IP prefix to be used for IP addresses"
  default     = 24
}

variable "vm_user" {
  description = "Username that will be used to login to the VM"
}

variable "node_count" {
  description = "Number of nodes"
}

variable "external_address" {
  description = "Address that will be used to connect to MKE4 cluster"
}

variable "public_ssh_key" {
  description = "Public SSH key that will be added to authorized_keys"
}

variable "image_uuid" {
  description = "UUID of the image that will be used for VMs"
}

variable "cluster_uuid" {
  description = "UUID of the Nutanix cluster"
}
