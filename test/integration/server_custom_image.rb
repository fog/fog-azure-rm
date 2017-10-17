require 'fog/azurerm'
require 'yaml'

########################################################################################################################
######################                   Services object required by all actions                  ######################
######################                              Keep it Uncommented!                          ######################
########################################################################################################################

azure_credentials = YAML.load_file(File.expand_path('credentials/azure.yml', __dir__))

rs = Fog::Resources::AzureRM.new(
  tenant_id: azure_credentials['tenant_id'],
  client_id: azure_credentials['client_id'],
  client_secret: azure_credentials['client_secret'],
  subscription_id: azure_credentials['subscription_id']
)

compute = Fog::Compute::AzureRM.new(
  tenant_id: azure_credentials['tenant_id'],
  client_id: azure_credentials['client_id'],
  client_secret: azure_credentials['client_secret'],
  subscription_id: azure_credentials['subscription_id']
)

storage = Fog::Storage::AzureRM.new(
  tenant_id: azure_credentials['tenant_id'],
  client_id: azure_credentials['client_id'],
  client_secret: azure_credentials['client_secret'],
  subscription_id: azure_credentials['subscription_id']
)

network = Fog::Network::AzureRM.new(
  tenant_id: azure_credentials['tenant_id'],
  client_id: azure_credentials['client_id'],
  client_secret: azure_credentials['client_secret'],
  subscription_id: azure_credentials['subscription_id']
)

########################################################################################################################
######################                                 Prerequisites                              ######################
########################################################################################################################

rg_name = 'TestRG-CustomVM'

begin
  resource_group = rs.resource_groups.create(
    name: rg_name,
    location: LOCATION
  )

  storage_account_name = "sa#{current_time}"

  storage.storage_accounts.create(
    name: storage_account_name,
    location: LOCATION,
    resource_group: rg_name,
    account_type: 'Standard',
    replication: 'LRS'
  )

  network.virtual_networks.create(
    name:             'testVnet',
    location:         LOCATION,
    resource_group:   rg_name,
    network_address_list:  '10.1.0.0/16,10.2.0.0/16'
  )

  network.subnets.create(
    name: 'mysubnet',
    resource_group: rg_name,
    virtual_network_name: 'testVnet',
    address_prefix: '10.2.0.0/24'
  )

  network.network_interfaces.create(
    name: 'NetInt',
    resource_group: rg_name,
    location: LOCATION,
    subnet_id: "/subscriptions/#{azure_credentials['subscription_id']}/resourceGroups/#{rg_name}/providers/Microsoft.Network/virtualNetworks/testVnet/subnets/mysubnet",
    ip_configuration_name: 'testIpConfiguration',
    private_ip_allocation_method: Fog::ARM::Network::Models::IPAllocationMethod::Dynamic
  )

  network.network_interfaces.create(
    name: 'NetInt2',
    resource_group: rg_name,
    location: LOCATION,
    subnet_id: "/subscriptions/#{azure_credentials['subscription_id']}/resourceGroups/#{rg_name}/providers/Microsoft.Network/virtualNetworks/testVnet/subnets/mysubnet",
    ip_configuration_name: 'testIpConfiguration',
    private_ip_allocation_method: Fog::ARM::Network::Models::IPAllocationMethod::Dynamic
  )

  network.network_interfaces.create(
    name: 'NetInt3',
    resource_group: rg_name,
    location: LOCATION,
    subnet_id: "/subscriptions/#{azure_credentials['subscription_id']}/resourceGroups/#{rg_name}/providers/Microsoft.Network/virtualNetworks/testVnet/subnets/mysubnet",
    ip_configuration_name: 'testIpConfiguration',
    private_ip_allocation_method: Fog::ARM::Network::Models::IPAllocationMethod::Dynamic
  )

  ########################################################################################################################
  ######################                                Create Server                               ######################
  ########################################################################################################################

  custom_image_virtual_machine = compute.servers.create(
    name: 'TestVM',
    location: LOCATION,
    resource_group: rg_name,
    storage_account_name: storage_account_name,
    vm_size: 'Basic_A0',
    username: 'testuser',
    password: 'Confiz=123',
    disable_password_authentication: false,
    network_interface_card_ids: ["/subscriptions/#{azure_credentials['subscription_id']}/resourceGroups/#{rg_name}/providers/Microsoft.Network/networkInterfaces/NetInt"],
    platform: 'linux',
    vhd_path: 'https://myblob.blob.core.windows.net/vhds/myvhd.vhd',
  )

  puts "Created custom image un-managed virtual machine: #{custom_image_virtual_machine.name}"

  ########################################################################################################################
  #################                                Create Managed Server                               ###################
  ########################################################################################################################

  custom_image_virtual_machine_managed = compute.servers.create(
    name: 'TestVM-Managed',
    location: LOCATION,
    resource_group: rg_name,
    storage_account_name: storage_account_name,
    vm_size: 'Basic_A0',
    username: 'testuser',
    password: 'Confiz=123',
    disable_password_authentication: false,
    network_interface_card_ids: ["/subscriptions/#{azure_credentials['subscription_id']}/resourceGroups/#{rg_name}/providers/Microsoft.Network/networkInterfaces/NetInt2"],
    platform: 'linux',
    vhd_path: 'https://myblob.blob.core.windows.net/vhds/myvhd.vhd',
    managed_disk_storage_type: Azure::ARM::Compute::Models::StorageAccountTypes::StandardLRS
  )

  puts "Created custom image managed virtual machine: #{custom_image_virtual_machine_managed.name}"

  ########################################################################################################################
  ##############                                Create Managed Server Async                               ################
  ########################################################################################################################

  async_response = compute.servers.create_async(
    name: 'TestVM-ManagedAsync',
    location: LOCATION,
    resource_group: rg_name,
    storage_account_name: storage_account_name,
    vm_size: 'Basic_A0',
    username: 'testuser',
    password: 'Confiz=123',
    disable_password_authentication: false,
    network_interface_card_ids: ["/subscriptions/#{azure_credentials['subscription_id']}/resourceGroups/#{rg_name}/providers/Microsoft.Network/networkInterfaces/NetInt3"],
    platform: 'linux',
    vhd_path: 'https://myblob.blob.core.windows.net/vhds/myvhd.vhd',
    managed_disk_storage_type: Azure::ARM::Compute::Models::StorageAccountTypes::StandardLRS
  )

  loop do
    puts async_response.state

    sleep(2) if async_response.pending?

    if async_response.fulfilled?
      puts "Created custom image managed virtual machine: #{async_response.value.name}"
      break
    end

    if async_response.rejected?
      puts async_response.reason.inspect
      break
    end
  end

  ########################################################################################################################
  ######################                            Get and Delete Server                           ######################
  ########################################################################################################################

  custom_image_virtual_machine = compute.servers.get(rg_name, 'TestVM')
  puts "Get custom image un-managed virtual machine: #{custom_image_virtual_machine.name}"
  puts "Deleted custom image un-managed virtual machine: #{custom_image_virtual_machine.destroy}"

  custom_image_virtual_machine_managed = compute.servers.get(rg_name, 'TestVM-Managed')
  puts "Get custom image managed virtual machine: #{custom_image_virtual_machine_managed.name}"
  puts "Deleted custom image managed virtual machine: #{custom_image_virtual_machine_managed.destroy}"

  custom_image_virtual_machine_managed_async = compute.servers.get(rg_name, 'TestVM-ManagedAsync')
  puts "Get custom image managed virtual machine async: #{custom_image_virtual_machine_managed_async.name}"
  puts "Deleted custom image managed virtual machine async: #{custom_image_virtual_machine_managed_async.destroy}"

  ########################################################################################################################
  ######################                                   CleanUp                                  ######################
  ########################################################################################################################

  nic = network.network_interfaces.get(rg_name, 'NetInt')
  nic.destroy

  nic = network.network_interfaces.get(rg_name, 'NetInt2')
  nic.destroy

  nic = network.network_interfaces.get(rg_name, 'NetInt3')
  nic.destroy

  vnet = network.virtual_networks.get(rg_name, 'testVnet')
  vnet.destroy

  storage = storage.storage_accounts.get(rg_name, storage_account_name)
  storage.destroy

  resource_group = rs.resource_groups.get(rg_name)
  resource_group.destroy
rescue
  puts 'Integration Test for custom image virtual machine is failing'
  resource_group.destroy unless resource_group.nil?
end
