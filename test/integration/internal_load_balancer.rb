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
  name: 'NRP-RG-Fog',
  location: 'westus'
)

network.virtual_networks.create(
  name: 'NRPVNet',
  location: 'westus',
  resource_group: 'NRP-RG-Fog',
  dns_servers: %w(10.1.0.0 10.2.0.0),
  address_prefixes: %w(10.1.0.0/16 10.2.0.0/16)
)

subnet = network.subnets.create(
  name: 'LB-Subnet-BE',
  resource_group: 'NRP-RG-Fog',
  virtual_network_name: 'NRPVNet',
  address_prefix: '10.1.2.0/24'
)

########################################################################################################################
######################                             Create Load Balancer                           ######################
########################################################################################################################

network.load_balancers.create(
  name: 'lb',
  resource_group: 'NRP-RG-Fog',
  location: 'westus',
  frontend_ip_configurations:
    [
      {
        name: 'LB-Frontend',
        private_ipallocation_method: 'Static',
        private_ipaddress: '10.1.2.5',
        subnet_id: subnet.id
      }
    ],
  backend_address_pool_names:
    [
      'LB-backend'
    ],
  load_balancing_rules:
    [
      {
        name: 'HTTP',
        frontend_ip_configuration_id: "/subscriptions/#{azure_credentials['subscription_id']}/resourceGroups/NRP-RG-Fog/providers/Microsoft.Network/loadBalancers/lb/frontendIPConfigurations/LB-Frontend",
        backend_address_pool_id: "/subscriptions/#{azure_credentials['subscription_id']}/resourceGroups/NRP-RG-Fog/providers/Microsoft.Network/loadBalancers/lb/backendAddressPools/LB-backend",
        probe_id: "/subscriptions/#{azure_credentials['subscription_id']}/resourceGroups/NRP-RG-Fog/providers/Microsoft.Network/loadBalancers/lb/probes/HealthProbe",
        protocol: 'Tcp',
        frontend_port: '80',
        backend_port: '80'
      }
    ],
  inbound_nat_rules:
    [
      {
        name: 'RDP1',
        frontend_ip_configuration_id: "/subscriptions/#{azure_credentials['subscription_id']}/resourceGroups/NRP-RG-Fog/providers/Microsoft.Network/loadBalancers/lb/frontendIPConfigurations/LB-Frontend",
        protocol: 'Tcp',
        frontend_port: 3441,
        backend_port: 3389
      },
      {
        name: 'RDP2',
        frontend_ip_configuration_id: "/subscriptions/#{azure_credentials['subscription_id']}/resourceGroups/NRP-RG-Fog/providers/Microsoft.Network/loadBalancers/lb/frontendIPConfigurations/LB-Frontend",
        protocol: 'Tcp',
        frontend_port: 3442,
        backend_port: 3389
      }
    ],
  probes:
    [
      {
        name: 'HealthProbe',
        protocol: 'http',
        request_path: 'HealthProbe.aspx',
        port: '80',
        interval_in_seconds: 15,
        number_of_probes: 2
      }
    ]
)
########################################################################################################################
######################                      List External Load Balancers                          ######################
########################################################################################################################

load_balancers = network.load_balancers(resource_group: 'NRP-RG-Fog')
load_balancers.each do |load_balancer|
  Fog::Logger.debug load_balancer.name
end

########################################################################################################################
######################                        Get and Destroy Internal Load Balancer                       ######################
########################################################################################################################

load_balancer = network.load_balancers.get('NRP-RG-Fog', 'lb')
load_balancer.destroy

########################################################################################################################
######################                                   CleanUp                                  ######################
########################################################################################################################

vnet = network.virtual_networks.get('NRP-RG-Fog', 'NRPVNet')
vnet.destroy

resource_group = rs.resource_groups.get('NRP-RG-Fog')
resource_group.destroy
