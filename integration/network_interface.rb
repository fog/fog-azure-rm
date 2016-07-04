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
    :name => 'TestRG-NI',
    :location => 'eastus'
)

vnet = network.virtual_networks.create(
    name:             'testVnet',
    location:         'eastus',
    resource_group:   'TestRG-NI',
    network_address_list:  '10.1.0.0/16,10.2.0.0/16'
)

subnet = network.subnets.create(
    name: 'mysubnet',
    resource_group: 'TestRG-NI',
    virtual_network_name: 'testVnet',
    address_prefix: '10.1.0.0/24'
)

pubip = network.public_ips.create(
    name: 'mypubip',
    resource_group: 'TestRG-NI',
    location: 'eastus',
    public_ip_allocation_method: 'Dynamic'
)

########################################################################################################################
######################                           Create Network Interface                         ######################
########################################################################################################################

nic = network.network_interfaces.create(
    name: 'NetInt',
    resource_group: 'TestRG-NI',
    location: 'eastus',
    subnet_id: "/subscriptions/#{azureCredentials['subscription_id']}/resourceGroups/TestRG-NI/providers/Microsoft.Network/virtualNetworks/testVnet/subnets/mysubnet",
    public_ip_address_id: "/subscriptions/#{azureCredentials['subscription_id']}/resourceGroups/TestRG-NI/providers/Microsoft.Network/publicIPAddresses/mypubip",
    ip_configuration_name: 'testIpConfiguration',
    private_ip_allocation_method: 'Dynamic'
)

########################################################################################################################
######################                       Get and Delete Network Interface                     ######################
########################################################################################################################

nic = network.network_interfaces(:resource_group => 'TestRG-NI').get('NetInt')
nic.destroy

########################################################################################################################
######################                                   CleanUp                                  ######################
########################################################################################################################

pubip = network.public_ips(resource_group: 'TestRG-NI').get('mypubip')
pubip.destroy

vnet = network.virtual_networks(resource_group: 'TestRG-NI').get('testVnet')
vnet.destroy

rg = rs.resource_groups.get('TestRG-NI')
rg.destroy
