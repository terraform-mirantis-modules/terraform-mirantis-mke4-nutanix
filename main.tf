data "nutanix_clusters" "clusters" {}

data "nutanix_images_v2" "images" {
  for_each = var.nodegroups
  filter   = "name==${each.value.image}"
}

data "nutanix_subnets_v2" "subnets" {
  for_each = var.network_config
  filter   = "name==${each.value.subnet_name}"
}

module "nodegroups" {
  for_each         = var.nodegroups
  source           = "./modules/virtual_machine"
  node_count       = each.value.count
  hostname         = "${var.cluster_name}-${each.key}"
  cluster_uuid     = data.nutanix_clusters.clusters.entities[0].metadata.uuid
  subnet_uuid      = data.nutanix_subnets_v2.subnets[each.value.network_config_name].uuid
  image_uuid       = data.nutanix_images_v2.images[each.key].entities[0].uuid
  disk_size        = each.value.disk
  vcpu_per_socket  = each.value.cpu
  ram_mib          = each.value.ram
  network_config   = var.network_config[each.value.network_config_name]
  role             = each.value.role
  external_address = var.external_address
  vm_user          = each.value.user
  public_ssh_key   = file(each.value.ssh_public_key_file)
}
