require 'fog/azurerm'
require 'yaml'

########################################################################################################################
######################                   Services object required by all actions                  ######################
######################                              Keep it Uncommented!                          ######################
########################################################################################################################

azure_credentials = YAML.load_file('credentials/azure.yml')

resource = Fog::Resources::AzureRM.new(
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

resource.resource_groups.create(
  name: 'TestRG-VNG',
  location: 'eastus'
)

########################################################################################################################
######################                           Create Virtual Network Gateway                   ######################
########################################################################################################################

network.virtual_network_gateways.create(
  name: 'testnetworkgateway',
  location: 'eastus',
  tags: {
    key1: 'value1',
    key2: 'value2'
  },
  ip_configurations: [
    {
      name: 'default',
      private_ipallocation_method: 'Dynamic',
      public_ipaddress_id: '/subscriptions/{subscription_id}/resourceGroups/{resource_group_name}/providers/Microsoft.Network/publicIPAddresses/{public_ip_name}',
      subnet_id: '/subscriptions/{subscription_id}/resourceGroups/{resource_group_name}/providers/Microsoft.Network/virtualNetworks/{virtual_network_name}/subnets/{subnet_name}',
      private_ipaddress: nil
    }
  ],
  resource_group: 'learn_fog',
  sku_name: 'Standard',
  sku_tier: 'Standard',
  sku_capacity: 2,
  gateway_type: 'ExpressRoute',
  enable_bgp: true,
  gateway_size: nil,
  asn: 100,
  bgp_peering_address: nil,
  peer_weight: 3,
  vpn_type: 'RouteBased',
  vpn_client_address_pool: [],
  gateway_default_site: '/subscriptions/{subscription_id}/resourceGroups/{resource_group_name}/providers/Microsoft.Network/localNetworkGateways/{local_network_gateway_name}',
  default_sites: [],
  vpn_client_configuration: {
    address_pool: ['192.168.0.4', '192.168.0.5'],
    root_certificates: [
      {
        name: 'root',
        public_cert_data: 'certificate data'
      }
    ],
    revoked_certificates: [
      {
        name: 'revoked',
        thumbprint: 'thumb print detail'
      }
    ]
  }
)

########################################################################################################################
######################                      List Virtual Network Gateways                         ######################
########################################################################################################################

network_gateways = network.virtual_network_gateways(resource_group: 'TestRG-VNG')
network_gateways.each do |gateway|
  puts gateway.name.to_s
end

########################################################################################################################
######################                  Get Virtual Network Gateway and CleanUp                   ######################
########################################################################################################################

network_gateway = network.virtual_network_gateways.get('learn_fog', 'testVNG')
puts network_gateway.name.to_s

network_gateway.destroy
