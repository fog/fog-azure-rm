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
  # resource_group = rs.resource_groups.create(
  #   name: rg_name,
  #   location: LOCATION
  # )

  # storage_account_name = "sa#{current_time}"

  # storage.storage_accounts.create(
  #   name: storage_account_name,
  #   location: LOCATION,
  #   resource_group: rg_name,
  #   account_type: 'Standard',
  #   replication: 'LRS'
  # )

  # network.virtual_networks.create(
  #   name:             'testVnet',
  #   location:         LOCATION,
  #   resource_group:   rg_name,
  #   network_address_list:  '10.1.0.0/16,10.2.0.0/16'
  # )

  # network.subnets.create(
  #   name: 'mysubnet',
  #   resource_group: rg_name,
  #   virtual_network_name: 'testVnet',
  #   address_prefix: '10.2.0.0/24'
  # )

  # network.network_interfaces.create(
  #   name: 'NetInt',
  #   resource_group: rg_name,
  #   location: LOCATION,
  #   subnet_id: "/subscriptions/#{azure_credentials['subscription_id']}/resourceGroups/#{rg_name}/providers/Microsoft.Network/virtualNetworks/testVnet/subnets/mysubnet",
  #   ip_configuration_name: 'testIpConfiguration',
  #   private_ip_allocation_method: Fog::ARM::Network::Models::IPAllocationMethod::Dynamic
  # )

  # network.network_interfaces.create(
  #   name: 'NetInt2',
  #   resource_group: rg_name,
  #   location: LOCATION,
  #   subnet_id: "/subscriptions/#{azure_credentials['subscription_id']}/resourceGroups/#{rg_name}/providers/Microsoft.Network/virtualNetworks/testVnet/subnets/mysubnet",
  #   ip_configuration_name: 'testIpConfiguration',
  #   private_ip_allocation_method: Fog::ARM::Network::Models::IPAllocationMethod::Dynamic
  # )

  ########################################################################################################################
  ######################                                Create Server                               ######################
  ########################################################################################################################

  # custom_image_virtual_machine = compute.servers.create_async(
  #   name: 'TestVM',
  #   location: LOCATION,
  #   resource_group: rg_name,
  #   storage_account_name: 'sa15077256528000371',
  #   vm_size: 'Basic_A0',
  #   username: 'testuser',
  #   password: 'Confiz=123',
  #   disable_password_authentication: false,
  #   network_interface_card_ids: ["/subscriptions/#{azure_credentials['subscription_id']}/resourceGroups/#{rg_name}/providers/Microsoft.Network/networkInterfaces/NetInt"],
  #   platform: 'linux',
  #   vhd_path: 'https://sa15077256528000371.blob.core.windows.net/customvhd15077256924636393/vhd_image15077256924636393.vhd?sv=2017-04-17&ss=bfqt&srt=sco&sp=rwdlacup&se=2017-10-31T01:52:48Z&st=2017-10-01T17:52:48Z&spr=https&sig=WWS3PUa9n8WJ0Syq2%2Fa82jyGKClKAKjlYYVA7YD8xo8%3D'
  # )

  # loop do
  #   puts custom_image_virtual_machine.state

  #   sleep(2) if custom_image_virtual_machine.pending?

  #   if custom_image_virtual_machine.fulfilled?
  #     puts "Created custom image un-managed virtual machine: #{custom_image_virtual_machine.value.name}"
  #     break
  #   end

  #   if custom_image_virtual_machine.rejected?
  #     puts custom_image_virtual_machine.reason.inspect
  #     break
  #   end
  # end
  

  ########################################################################################################################
  #################                                Create Managed Server                               ###################
  ########################################################################################################################

  custom_image_virtual_machine_managed = compute.servers.create_async(
    name: 'TestVM-Managed',
    location: LOCATION,
    storage_account_name: 'sa15077256528000371',
    resource_group: rg_name,
    vm_size: 'Basic_A0',
    username: 'testuser',
    password: 'Confiz=123',
    disable_password_authentication: false,
    network_interface_card_ids: ["/subscriptions/#{azure_credentials['subscription_id']}/resourceGroups/#{rg_name}/providers/Microsoft.Network/networkInterfaces/NetInt2"],
    platform: 'linux',
    vhd_path: 'https://sa15077256528000371.blob.core.windows.net/customvhd15077256924636393/vhd_image15077256924636393.vhd',
    managed_disk_storage_type: Azure::ARM::Compute::Models::StorageAccountTypes::StandardLRS
  )

  loop do
    puts custom_image_virtual_machine_managed.state

    sleep(2) if custom_image_virtual_machine_managed.pending?

    if custom_image_virtual_machine_managed.fulfilled?
      puts "Created custom image un-managed virtual machine: #{custom_image_virtual_machine_managed.value.name}"
      break
    end

    if custom_image_virtual_machine_managed.rejected?
      puts custom_image_virtual_machine_managed.reason.inspect
      break
    end
  end

  ########################################################################################################################
  ######################                            Get and Delete Server                           ######################
  ########################################################################################################################

  # custom_image_virtual_machine = compute.servers.get(rg_name, 'TestVM')
  # puts "Get custom image un-managed virtual machine: #{custom_image_virtual_machine.value.name}"
  # puts "Deleted custom image un-managed virtual machine: #{custom_image_virtual_machine.value.destroy}"

  custom_image_virtual_machine_managed = compute.servers.get(rg_name, 'TestVM-Managed')
  puts "Get custom image managed virtual machine: #{custom_image_virtual_machine_managed.value.name}"
  puts "Deleted custom image managed virtual machine: #{custom_image_virtual_machine_managed.value.destroy}"

  ########################################################################################################################
  ######################                                   CleanUp                                  ######################
  ########################################################################################################################

  # nic = network.network_interfaces.get(rg_name, 'NetInt')
  # nic.destroy

  # nic = network.network_interfaces.get(rg_name, 'NetInt2')
  # nic.destroy

  # vnet = network.virtual_networks.get(rg_name, 'testVnet')
  # vnet.destroy

  # storage = storage.storage_accounts.get(rg_name, storage_account_name)
  # storage.destroy

  # resource_group = rs.resource_groups.get(rg_name)
  # resource_group.destroy
rescue Exception => e
  raise(e) 
  puts 'Integration Test for custom image virtual machine is failing'
  resource_group.destroy unless resource_group.nil?
end
