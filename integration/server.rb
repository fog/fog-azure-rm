require 'fog/azurerm'
require 'yaml'

########################################################################################################################
######################                   Services object required by all actions                  ######################
######################                              Keep it Uncommented!                          ######################
########################################################################################################################

azureCredentials = YAML.load_file('credentials/azure.yml')

rs = Fog::Resources::AzureRM.new(
    tenant_id: azureCredentials['tenant_id'],
    client_id: azureCredentials['client_id'],
    client_secret: azureCredentials['client_secret'],
    subscription_id: azureCredentials['subscription_id']
)

compute = Fog::Compute::AzureRM.new(
    tenant_id: azureCredentials['tenant_id'],
    client_id: azureCredentials['client_id'],
    client_secret: azureCredentials['client_secret'],
    subscription_id: azureCredentials['subscription_id']
)

storage = Fog::Storage::AzureRM.new(
    tenant_id: azureCredentials['tenant_id'],
    client_id: azureCredentials['client_id'],
    client_secret: azureCredentials['client_secret'],
    subscription_id: azureCredentials['subscription_id']
)

network = Fog::Network::AzureRM.new(
    tenant_id: azureCredentials['tenant_id'],
    client_id: azureCredentials['client_id'],
    client_secret: azureCredentials['client_secret'],
    subscription_id: azureCredentials['subscription_id']
)

########################################################################################################################
######################                                 Prerequisites                              ######################
########################################################################################################################

rg = rs.resource_groups.create(
    :name => 'TestRG-VM',
    :location => 'eastus'
)

storage_account = storage.storage_accounts.create(
    :name => 'test-storage',
    :location => 'eastus',
    :resource_group => 'TestRG-VM'
)

vnet = network.virtual_networks.create(
    name:             'testVnet',
    location:         'eastus',
    resource_group:   'TestRG-VM',
    network_address_list:  '10.1.0.0/16,10.2.0.0/16'
)

subnet = network.subnets.create(
    name: 'mysubnet',
    resource_group: 'TestRG-VM',
    virtual_network_name: 'testVnet',
    address_prefix: '10.1.0.0/24'
)

nic = network.network_interfaces.create(
    name: 'NetInt',
    resource_group: 'TestRG-VM',
    location: 'eastus',
    subnet_id: "/subscriptions/#{azureCredentials['subscription_id']}/resourceGroups/TestRG-VM/providers/Microsoft.Network/virtualNetworks/testVnet/subnets/mysubnet",
    ip_configuration_name: 'testIpConfiguration',
    private_ip_allocation_method: 'Dynamic'
)

########################################################################################################################
######################                                Create Server                               ######################
########################################################################################################################

server = compute.servers.create(
    name: 'TestVM',
    location: 'test-storage',
    resource_group: 'TestRG-VM',
    vm_size: 'Basic_A0',
    storage_account_name: 'test-storage',
    username: 'testuser',
    password: 'Confiz=123',
    disable_password_authentication: false,
    network_interface_card_id: "/subscriptions/#{azureCredentials['subscription_id']}/resourceGroups/TestRG-VM/providers/Microsoft.Network/networkInterfaces/testNIC",
    publisher: 'Canonical',
    offer: 'UbuntuServer',
    sku: '14.04.2-LTS',
    version: 'latest'
)

########################################################################################################################
######################                          Attach Data Disk to Server                        ######################
########################################################################################################################

server = compute.servers(resource_group: 'TestRG-VM').get('TestVM')
server.attach_data_disk('datadisk1', 10, 'test-storage')

########################################################################################################################
######################                          Detach Data Disk to Server                        ######################
########################################################################################################################

server = compute.servers(resource_group: 'TestRG-VM').get('TestVM')
server.detach_data_disk('datadisk1')

########################################################################################################################
######################                                Delete Data Disk                            ######################
########################################################################################################################

storage.delete_data_disk('TestRG-VM', 'test-storage', 'datadisk1')

########################################################################################################################
######################                            Get and Delete Server                           ######################
########################################################################################################################

server = compute.servers(:resource_group => 'TestRG-VM').get('TestVM')
server.destroy

########################################################################################################################
######################                                   CleanUp                                  ######################
########################################################################################################################

nic = network.network_interfaces(resource_group: 'TestRG-VM').get('NetInt')
nic.destroy

vnet = network.virtual_networks(resource_group: 'TestRG-VM').get('testVnet')
vnet.destroy

pubip = network.public_ips(resource_group: 'TestRG-VM').get('mypubip')
pubip.destroy

storage = storage.storage_accounts(resource_group: 'TestRG-VM').get('test-storage')
storage.destroy

rg = rs.resource_groups.get('TestRG-VM')
rg.destroy