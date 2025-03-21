virtual_machine_id = {
  eu1pcd1-010 = "eu1pcd1-010"
  eu1pcd1-011 = "eu1pcd1-011"
  eu1pcd2-012 = "eu1pcd2-012"
  eu1pcd2-013 = "eu1pcd2-013"
}

zone_list = ["1", "1", "2", "2"]

linux_vm_default_nic = {
  nic_name      = "vm-%{vm_name}-primary-nic" # Make base name dynamic
  nic_subnet_id = "/subscriptions/59bab8f2-1319-472b-bb69-314d1b034ec0/resourceGroups/demorg1/providers/Microsoft.Network/virtualNetworks/demovnet1/subnets/demosubnet1"
  nic_ip_config = [{
    nic_ip_config_name = "primary"
    nic_ip_config_primary = true
  }]
}

linux_vm_additional_nic = [{
  nic_name      = "vm-%{vm_name}-secondary-nic" # Make base name dynamic
  nic_subnet_id = "/subscriptions/59bab8f2-1319-472b-bb69-314d1b034ec0/resourceGroups/demorg1/providers/Microsoft.Network/virtualNetworks/demovnet1/subnets/demosubnet1"
  nic_ip_config = [{
    nic_ip_config_name = "primary"
    nic_ip_config_primary = true
  }]
}]
