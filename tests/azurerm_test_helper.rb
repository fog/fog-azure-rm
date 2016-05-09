# rubocop:disable LineLength
# rubocop:disable AbcSize
def azurerm_resources_service
  Fog::Resources::AzureRM.new
end

def azurerm_dns_service
  Fog::DNS::AzureRM.new
end

def azurerm_storage_service
  Fog::Storage::AzureRM.new
end

def azurerm_network_service
  Fog::Network::AzureRM.new
end

def azurerm_compute_service
  Fog::Compute::AzureRM.new
end

def storage_account_attributes
  {
      name: storage_account_name,
      location: location,
      resource_group: rg_name
  }
end

def availability_set_attributes
  {
      name: availability_set_name,
      location: location,
      resource_group: rg_name
  }
end

def server_attributes
  {
      name: server_name,
      location: location,
      resource_group: rg_name,
      vm_size: 'Basic_A0',
      storage_account_name: storage_account_name,
      username: 'shaffan',
      password: 'Confiz=123',
      disable_password_authentication: false,
      network_interface_card_id: "/subscriptions/########-####-####-####-############/resourceGroups/#{rg_name}/providers/Microsoft.Network/networkInterfaces/#{network_interface_name}",
      publisher: 'Canonical',
      offer: 'UbuntuServer',
      sku: '14.04.2-LTS',
      version: 'latest'
  }
end

def rg_attributes
  {
      name: rg_name,
      location: location
  }
end

def server_name
  'fog-test-server'
end

def availability_set_name
  'fog-test-availability-set'
end

def storage_account_name
  'fog-test-storage-account'
end

def rg_name
  'fog-test-resource-group'
end

def zone_name
  'fogtestzone.com'
end

def virtual_network_name
  'fogtestvnet'
end

def subnet_name
  'fogtestsubnet'
end

def rs_record_type
  'A'
end

def rs_name
  'fogtestrecordset'
end

def rs_test_records
  ['1.2.3.4', '1.2.3.3']
end

def rs_ttl
  60
end

def location
  'West US'
end

def fog_availability_set
  availability_set = azurerm_compute_service.availability_sets(resource_group: rg_name).find { |as| as.name == availability_set_name && as.resource_group == rg_name }
  unless availability_set
    availability_set = azurerm_compute_service.availability_sets.create(availability_set_attributes)
  end
  availability_set
end

def fog_storage_account
  storage_account = azurerm_storage_service.storage_accounts.find { |sa| sa.name == storage_account_name && sa.resource_group == rg_name }
  unless storage_account
    storage_account = azurerm_storage_service.storage_accounts.create(storage_account_attributes)
  end
  storage_account
end

def pubpic_ip_type
  'Static'
end

def public_ip_name
  'fogtestpublicip'
end

def network_interface_name
  'fogtestnetworkinterface'
end

def subnet_id_for_network_interface
  '/subscriptions/XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX/resourceGroups/XXXXXXXX/providers/Microsoft.Network/virtualNetworks/XXXXXXXX/subnets/XXXXXXX'
end

def ip_configurations_name_for_network_interface
  'fogtestipconfigs'
end

def private_ip_allocation_method_for_network_interface
  'Dynamic'
end

def fog_resource_group
  resource_group = azurerm_resources_service.resource_groups.find { |rg| rg.name == rg_name }
  unless resource_group
    resource_group = azurerm_resources_service.resource_groups.create(rg_attributes)
  end
  resource_group
end

def fog_zone
  zone = azurerm_dns_service.zones.find { |z| z.name == zone_name && z.resource_group == rg_name }
  unless zone
    zone = azurerm_dns_service.zones.create(name: zone_name, resource_group: rg_name)
  end
  zone
end

def fog_record_set
  rset = azurerm_dns_service.record_sets(resource_group: rg_name, zone_name: zone_name).find { |rs| rs.name == rs_name && rs.type == rs_record_type }
  unless rset
    rset = azurerm_dns_service.record_sets.create(
        name: rs_name, resource_group: rg_name, zone_name: zone_name, records: rs_test_records, type: rs_record_type, ttl: rs_ttl
    )
  end
  rset
end

def fog_virtual_network
  vnet = azurerm_network_service.virtual_networks(resource_group: rg_name).find { |v| v.name == virtual_network_name && v.resource_group == rg_name }
  unless vnet
    vnet = azurerm_network_service.virtual_networks.create(name: virtual_network_name, location: location, resource_group: rg_name)
  end
  vnet
end

def fog_server
  server = azurerm_compute_service.servers(resource_group: rg_name).find { |s| s.name == server_name && s.resource_group == rg_name }
  unless server
    server = azurerm_compute_service.servers.create(server_attributes)
  end
  server
end

def availability_set_destroy
  availability_set = azurerm_compute_service.availability_sets(resource_group: rg_name).find { |as| as.name == availability_set_name }
  availability_set.destroy if availability_set
end

def fog_public_ip
  pubip = azurerm_network_service.public_ips(resource_group: rg_name).find { |pip| pip.name == public_ip_name }
  unless pubip
    pubip = azurerm_network_service.public_ips.create(
        name: public_ip_name, resource_group: rg_name, location: location, type: pubpic_ip_type
    )
  end
  pubip
end

def fog_subnet
  subnet = azurerm_network_service.subnets({ resource_group: rg_name, virtual_network_name: virtual_network_name }).find{ |sn| sn.name == subnet_name }
  unless subnet
    subnet = azurerm_network_service.subnets.create(
        name: subnet_name, resource_group: rg_name, virtual_network_name: virtual_network_name
    )
  end
  subnet
end

def fog_network_interface
  nic = azurerm_network_service.network_interfaces(resource_group: rg_name).find { |ni| ni.name == network_interface_name }
  unless nic
    nic = azurerm_network_service.network_interfaces.create(
        name: network_interface_name, resource_group: rg_name, location: location, subnet_id: subnet_id_for_network_interface, ip_configuration_name: ip_configurations_name_for_network_interface, private_ip_allocation_method: private_ip_allocation_method_for_network_interface
    )
  end
  nic
end

def rg_destroy
  resource_group = azurerm_resources_service.resource_groups.find { |rg| rg.name == rg_name }
  resource_group.destroy if resource_group
end

def zone_destroy
  zone = azurerm_dns_service.zones.find { |z| z.name == zone_name }
  zone.destroy if zone
end

def record_set_destroy
  rset = azurerm_dns_service.record_sets(resource_group: rg_name, zone_name: zone_name).find { |rs| rs.name == rs_name }
  rset.destroy if rset
end

def virtual_network_destroy
  vnet = azurerm_network_service.virtual_networks.find { |vn| vn.name == rs_name && vn.resource_group == rg_name }
  vnet.destroy if vnet
end

def public_ip_destroy
  pubip = azurerm_network_service.public_ips(resource_group: rg_name).find { |pip| pip.name == public_ip_name }
  pubip.destroy if pubip
end

def subnet_destroy
  subnet = azurerm_network_service.subnets( { resource_group: rg_name, virtual_network_name: virtual_network_name }).find{ |sn| sn.name == subnet_name }
  subnet.destroy if subnet
end

def network_interface_destroy
  nic = azurerm_network_service.network_interfaces(resource_group: rg_name).find { |ni| ni.name == network_interface_name }
  nic.destroy if nic
end

def storage_account_destroy
  storage_account = azurerm_storage_service.storage_accounts.find { |sa| sa.name == storage_account_name }
  storage_account.destroy if storage_account
end

at_exit do
  unless Fog.mocking?
    record_set_destroy
    storage_account_destroy
    zone_destroy
    subnet_destroy
    virtual_network_destroy
    public_ip_destroy
    rg_destroy
    availability_set_destroy
  end
end
