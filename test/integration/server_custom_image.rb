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
    private_ip_allocation_method: Fog::ARM::Network::Models::IPAllocationMethod::Dynamic
  )

  network.network_interfaces.create(
      name: 'NetInt2',
      resource_group: 'TestRG-CustomVM',
      location: LOCATION,
      subnet_id: "/subscriptions/#{azure_credentials['subscription_id']}/resourceGroups/TestRG-CustomVM/providers/Microsoft.Network/virtualNetworks/testVnet/subnets/mysubnet",
      ip_configuration_name: 'testIpConfiguration',
      private_ip_allocation_method: Fog::ARM::Network::Models::IPAllocationMethod::Dynamic
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
    network_interface_card_ids: ["/subscriptions/#{azure_credentials['subscription_id']}/resourceGroups/TestRG-CustomVM/providers/Microsoft.Network/networkInterfaces/NetInt"],
    platform: 'linux',
    vhd_path: 'https://imagergdisks695.blob.core.windows.net/vhds/test-vm20171004153054.vhd?sv=2017-04-17&ss=b&srt=sco&sp=rwdlac&se=2017-10-31T00:11:36Z&st=2017-10-01T16:11:36Z&sip=0.0.0.0-255.255.255.255&spr=https,http&sig=l%2Bxd%2FQmAm6a7rGLMgdcnVXmNXAczYdaB4LqBsPH3xHI%3D',
  )
  puts "Created custom image un-managed virtual machine: #{custom_image_virtual_machine.name}"

  ########################################################################################################################
  #################                                Create Managed Server                               ###################
  ########################################################################################################################

  custom_image_virtual_machine_managed = compute.servers.create(
      name: 'TestVM-Managed',
      location: LOCATION,
      resource_group: 'TestRG-CustomVM',
      vm_size: 'Basic_A0',
      storage_account_name: storage_account_name,
      username: 'testuser',
      password: 'Confiz=123',
      disable_password_authentication: false,
      network_interface_card_ids: ["/subscriptions/#{azure_credentials['subscription_id']}/resourceGroups/TestRG-CustomVM/providers/Microsoft.Network/networkInterfaces/NetInt2"],
      platform: 'linux',
      vhd_path: 'https://imagergdisks695.blob.core.windows.net/vhds/test-vm20171004153054.vhd?sv=2017-04-17&ss=b&srt=sco&sp=rwdlac&se=2017-10-31T00:11:36Z&st=2017-10-01T16:11:36Z&sip=0.0.0.0-255.255.255.255&spr=https,http&sig=l%2Bxd%2FQmAm6a7rGLMgdcnVXmNXAczYdaB4LqBsPH3xHI%3D',
      managed_disk_storage_type: Azure::ARM::Compute::Models::StorageAccountTypes::StandardLRS
  )
  puts "Created custom image managed virtual machine: #{custom_image_virtual_machine.name}"

  ########################################################################################################################
  ######################                            Get and Delete Server                           ######################
  ########################################################################################################################

  custom_image_virtual_machine = compute.servers.get('TestRG-CustomVM', 'TestVM')
  puts "Get custom image un-managed virtual machine: #{custom_image_virtual_machine.name}"
  puts "Deleted custom image un-managed virtual machine: #{custom_image_virtual_machine.destroy}"

  custom_image_virtual_machine_managed = compute.servers.get('TestRG-CustomVM', 'TestVM-Managed')
  puts "Get custom image managed virtual machine: #{custom_image_virtual_machine_managed.name}"
  puts "Deleted custom image managed virtual machine: #{custom_image_virtual_machine_managed.destroy}"

  ########################################################################################################################
  ######################                                   CleanUp                                  ######################
  ########################################################################################################################

  nic = network.network_interfaces.get('TestRG-CustomVM', 'NetInt')
  nic.destroy

  nic = network.network_interfaces.get('TestRG-CustomVM', 'NetInt2')
  nic.destroy

  vnet = network.virtual_networks.get('TestRG-CustomVM', 'testVnet')
  vnet.destroy

  storage = storage.storage_accounts.get('TestRG-CustomVM', storage_account_name)
  storage.destroy

  resource_group = rs.resource_groups.get('TestRG-CustomVM')
  resource_group.destroy
rescue  Exception => e
  raise(e)
  puts 'Integration Test for custom image virtual machine is failing'
  resource_group.destroy unless resource_group.nil?
end
