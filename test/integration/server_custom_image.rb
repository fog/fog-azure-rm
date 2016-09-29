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

rs.resource_groups.create(
  name: 'TestRG-VM',
  location: 'eastus'
)

storage.storage_accounts.create(
  name: 'fogstorageac',
  location: 'eastus',
  resource_group: 'TestRG-VM',
  account_type: 'Standard',
  replication: 'LRS'
)

network.virtual_networks.create(
  name:             'testVnet',
  location:         'eastus',
  resource_group:   'TestRG-VM',
  network_address_list:  '10.1.0.0/16,10.2.0.0/16'
)

network.subnets.create(
  name: 'mysubnet',
  resource_group: 'TestRG-VM',
  virtual_network_name: 'testVnet',
  address_prefix: '10.2.0.0/24'
)

network.network_interfaces.create(
  name: 'NetInt',
  resource_group: 'TestRG-VM',
  location: 'eastus',
  subnet_id: "/subscriptions/#{azure_credentials['subscription_id']}/resourceGroups/TestRG-VM/providers/Microsoft.Network/virtualNetworks/testVnet/subnets/mysubnet",
  ip_configuration_name: 'testIpConfiguration',
  private_ip_allocation_method: 'Dynamic'
)

########################################################################################################################
######################                                Create Server                               ######################
########################################################################################################################

compute.servers.create(
  name: 'TestVM',
  location: 'eastus',
  resource_group: 'TestRG-VM',
  vm_size: 'Basic_A0',
  storage_account_name: 'fogstorageac',
  username: 'testuser',
  password: 'Confiz=123',
  disable_password_authentication: false,
  network_interface_card_id: "/subscriptions/#{azure_credentials['subscription_id']}/resourceGroups/TestRG-VM/providers/Microsoft.Network/networkInterfaces/NetInt",
  platform: 'linux',
  is_from_custom_image: true,
  vhd_path: 'https://custimagestorage.blob.core.windows.net/newcustomvhd/trusty-server-cloudimg-amd64-disk1-zeeshan.vhd'
)

########################################################################################################################
######################                            Get and Delete Server                           ######################
########################################################################################################################

server = compute.servers.get('TestRG-VM', 'TestVM')
server.destroy

########################################################################################################################
######################                                   CleanUp                                  ######################
########################################################################################################################

nic = network.network_interfaces.get('TestRG-VM', 'NetInt')
nic.destroy

vnet = network.virtual_networks.get('TestRG-VM', 'testVnet')
vnet.destroy

storage = storage.storage_accounts.get('TestRG-VM', 'fogstorageac')
storage.destroy

resource_group = rs.resource_groups.get('TestRG-VM')
resource_group.destroy
