########################################################################################################################
######################                            Driver Code From Haider                         ######################
########################################################################################################################

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
    :name => 'TestRG-LB',
    :location => 'westus'
)

vnet = network.virtual_networks.create(
    name:             'testVnet',
    location:         'westus',
    resource_group:   'TestRG-LB',
    network_address_list:  '10.1.0.0/16,10.2.0.0/16'
)

subnet = network.subnets.create(
    name: 'mysubnet',
    resource_group: 'TestRG-LB',
    virtual_network_name: 'testVnet',
    address_prefix: '10.1.0.0/24'
)

pubip = network.public_ips.create(
    name: 'mypubip',
    resource_group: 'TestRG-LB',
    location: 'westus',
    public_ip_allocation_method: 'Dynamic'
)

########################################################################################################################
######################                             Create Load Balancer                           ######################
########################################################################################################################

lb = network.load_balancers.create(
    name: 'lb',
    resource_group: 'TestRG-LB',
    location: 'westus',

    frontend_ip_configurations:
    [
        {
            name: 'fic',
            private_ipallocation_method: 'Dynamic',
            public_ipaddress_id: "/subscriptions/#{azureCredentials['subscription_id']}/resourcegroups/TestRG-LB/providers/Microsoft.Network/publicIPAddresses/mypubip",
        }
    ],
    backend_address_pool_names:
    [
        'pool1'
    ],
    load_balancing_rules:
    [
        {
            name: 'lb_rule_1',
            frontend_ip_configuration_id: "/subscriptions/#{azureCredentials['subscription_id']}/resourceGroups/TestRG-LB/providers/Microsoft.Network/loadBalancers/lb/frontendIPConfigurations/fic",
            backend_address_pool_id: "/subscriptions/#{azureCredentials['subscription_id']}/resourceGroups/TestRG-LB/providers/Microsoft.Network/loadBalancers/lb/backendAddressPools/pool1",
            protocol: 'Tcp',
            frontend_port: '80',
            backend_port: '8080',
            enable_floating_ip: false,
            idle_timeout_in_minutes: 4,
            load_distribution: "Default"
        }
    ],
    inbound_nat_rules:
    [
        {
            name: 'RDP-Traffic',
            frontend_ip_configuration_id: "/subscriptions/#{azureCredentials['subscription_id']}/resourceGroups/TestRG-LB/providers/Microsoft.Network/loadBalancers/lb/frontendIPConfigurations/fic",
            protocol: 'Tcp',
            frontend_port: 3389,
            backend_port: 3389
        }
    ]
)

########################################################################################################################
######################                        Get and Destroy Load Balancer                       ######################
########################################################################################################################

lb = network.load_balancers(resource_group: 'TestRG-LB').get('lb')
lb.destroy

########################################################################################################################
######################                                   CleanUp                                  ######################
########################################################################################################################

pubip = network.public_ips(resource_group: 'TestRG-LB').get('mypubip')
pubip.destroy

vnet = network.virtual_networks(resource_group: 'TestRG-LB').get('testVnet')
vnet.destroy

rg = rs.resource_groups.get('TestRG-LB')
rg.destroy
