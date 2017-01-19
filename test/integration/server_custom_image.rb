require 'fog/azurerm'
require 'yaml'

########################################################################################################################
######################                   Services object required by all actions                  ######################
######################                              Keep it Uncommented!                          ######################
########################################################################################################################

azure_credentials = YAML.load_file('credentials/azure.yml')

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

begin
  resource_group = rs.resource_groups.create(
    name: 'TestRG-CustomVM',
    location: LOCATION
  )

  storage_account_name = "sa#{current_time}"

  storage.storage_accounts.create(
    name: storage_account_name,
    location: LOCATION,
    resource_group: 'TestRG-CustomVM',
    account_type: 'Standard',
    replication: 'LRS'
  )

  network.virtual_networks.create(
    name:             'testVnet',
    location:         LOCATION,
    resource_group:   'TestRG-CustomVM',
    network_address_list:  '10.1.0.0/16,10.2.0.0/16'
  )

  network.subnets.create(
    name: 'mysubnet',
    resource_group: 'TestRG-CustomVM',
    virtual_network_name: 'testVnet',
    address_prefix: '10.2.0.0/24'
  )

  network.network_interfaces.create(
    name: 'NetInt',
    resource_group: 'TestRG-CustomVM',
    location: LOCATION,
    subnet_id: "/subscriptions/#{azure_credentials['subscription_id']}/resourceGroups/TestRG-CustomVM/providers/Microsoft.Network/virtualNetworks/testVnet/subnets/mysubnet",
    ip_configuration_name: 'testIpConfiguration',
    private_ip_allocation_method: Fog::Network::AzureRM::IPAllocationMethod::Dynamic
  )

  ########################################################################################################################
  ######################                                Create Server                               ######################
  ########################################################################################################################

  custom_image_virtual_machine = compute.servers.create(
    name: 'TestVM',
    location: LOCATION,
    resource_group: 'TestRG-CustomVM',
    vm_size: 'Basic_A0',
    storage_account_name: storage_account_name,
    username: 'testuser',
    password: 'Confiz=123',
    disable_password_authentication: false,
    network_interface_card_id: "/subscriptions/#{azure_credentials['subscription_id']}/resourceGroups/TestRG-CustomVM/providers/Microsoft.Network/networkInterfaces/NetInt",
    platform: 'linux',
    vhd_path: 'https://custimagestorage.blob.core.windows.net/newcustomvhd/trusty-server-cloudimg-amd64-disk1-zeeshan.vhd'
  )
  puts "Created custom image virtual machine: #{custom_image_virtual_machine.name}"

  ########################################################################################################################
  ######################                            Get and Delete Server                           ######################
  ########################################################################################################################

  custom_image_virtual_machine = compute.servers.get('TestRG-CustomVM', 'TestVM')
  puts "Get custom image virtual machine: #{custom_image_virtual_machine.name}"
  puts "Deleted custom image virtual machine: #{custom_image_virtual_machine.destroy}"

  ########################################################################################################################
  ######################                                   CleanUp                                  ######################
  ########################################################################################################################

  nic = network.network_interfaces.get('TestRG-CustomVM', 'NetInt')
  nic.destroy

  vnet = network.virtual_networks.get('TestRG-CustomVM', 'testVnet')
  vnet.destroy

  storage = storage.storage_accounts.get('TestRG-CustomVM', storage_account_name)
  storage.destroy

  resource_group = rs.resource_groups.get('TestRG-CustomVM')
  resource_group.destroy
rescue
  puts 'Integration Test for custom image virtual machine is failing'
  resource_group.destroy unless resource_group.nil?
end
