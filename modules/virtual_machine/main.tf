data "external" "ip_addresses" {
  count   = var.network_config.type == "IPAM" ? 1 : 0
  program = ["python3", "${path.module}/helpers/ipaddr.py"]

  query = {
    ip_range = var.network_config.ip_range
  }
}

resource "nutanix_virtual_machine" "vm" {
  count                = var.node_count
  name                 = "${var.hostname}-${count.index}"
  cluster_uuid         = var.cluster_uuid
  num_vcpus_per_socket = var.vcpu_per_socket
  num_sockets          = var.sockets
  memory_size_mib      = var.ram_mib

  # Define the disk to use a pre-existing image
  disk_list {
    data_source_reference = {
      kind = "image"
      uuid = var.image_uuid
    }
    disk_size_mib = var.disk_size
  }

  # Attach the VM to the specified subnet
  nic_list {
    subnet_uuid = var.subnet_uuid
  }


  guest_customization_cloud_init_user_data = var.role == "worker" ? base64encode(
    templatefile(
      "${path.module}/helpers/cloudinit/userdata-wrk.yaml",
      {
        hostname = "${var.hostname}-${count.index}"
        user     = var.vm_user
        ssh_key  = var.public_ssh_key
      }
    )
    ) : base64encode(
    templatefile(
      "${path.module}/helpers/cloudinit/userdata-ctr.yaml",
      {
        hostname         = "${var.hostname}-${count.index}"
        user             = var.vm_user
        ssh_key          = var.public_ssh_key
        external_address = var.external_address
      }
    )
  )
  guest_customization_cloud_init_meta_data = var.network_config.type == "IPAM" ? base64encode(
    templatefile(
      "${path.module}/helpers/cloudinit/metadata-ipam.yaml",
      {
        ip_addr      = data.external.ip_addresses[0].result[count.index]
        gateway_addr = var.network_config.gateway
        hostname     = "${var.hostname}-${count.index}"
        nameserver   = var.network_config.nameserver
      }
    )
    ) : base64encode(
    templatefile(
      "${path.module}/helpers/cloudinit/metadata-dhcp.yaml",
      {
        hostname = "${var.hostname}-${count.index}"
      }
    )
  )
}
