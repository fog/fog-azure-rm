if ENV['COVERAGE']
  require 'simplecov'
  SimpleCov.start do
    add_filter 'test'
    command_name 'Minitest'
  end
end

require 'minitest/autorun'
$LOAD_PATH.unshift(File.expand_path '../lib', __dir__)
require File.expand_path '../lib/fog/azurerm', __dir__
require File.expand_path './api_stub', __dir__
def credentials
  {
    tenant_id:        '<TENANT-ID>',
    client_id:        '<CLIENT-ID>',
    client_secret:    '<CLIENT-SECRET>',
    subscription_id:  '<SUBSCRIPTION-ID>'
  }
end

def server(service)
  Fog::Compute::AzureRM::Server.new(
    name: 'fog-test-server',
    location: 'West US',
    resource_group: 'fog-test-rg',
    vm_size: 'Basic_A0',
    storage_account_name: 'shaffanstrg',
    username: 'shaffan',
    password: 'Confiz=123',
    disable_password_authentication: false,
    network_interface_card_id: '/subscriptions/########-####-####-####-############/resourceGroups/shaffanRG/providers/Microsoft.Network/networkInterfaces/testNIC',
    publisher: 'Canonical',
    offer: 'UbuntuServer',
    sku: '14.04.2-LTS',
    version: 'latest',
    service: service
  )
end

def availability_set(service)
  Fog::Compute::AzureRM::AvailabilitySet.new(
    name: 'availability-set',
    location: 'West US',
    resource_group: 'fog-test-rg',
    service: service
  )
end

def resource_group(service)
  Fog::Resources::AzureRM::ResourceGroup.new(
    name: 'fog-test-rg',
    location: 'West US',
    service: service
  )
end

def storage_account(service)
  Fog::Storage::AzureRM::StorageAccount.new(
    name: 'storage-account',
    location: 'West US',
    resource_group: 'fog-test-rg',
    service: service
  )
end

def public_ip(service)
  Fog::Network::AzureRM::PublicIp.new(
    name: 'fog-test-public-ip',
    resource_group: 'fog-test-rg',
    location: 'West US',
    public_ip_allocation_method: 'Dynamic',
    service: service
  )
end

def subnet(service)
  Fog::Network::AzureRM::Subnet.new(
    name: 'fog-test-subnet',
    id: '/subscriptions/########-####-####-####-############/resourceGroups/fog-test-rg/providers/Microsoft.Network/virtualNetworks/fog-test-virtual-network/subnets/fog-test-subnet',
    resource_group: 'fog-test-rg',
    virtual_network_name: 'fog-test-virtual-network',
    properties: nil,
    addressPrefix: '10.1.0.0/24',
    networkSecurityGroupId: '/subscriptions/########-####-####-####-############/resourceGroups/fog-test-rg/providers/Microsoft.Network/networkSecurityGroups/fog-test-network-security-group',
    routeTableId: '/subscriptions/########-####-####-####-############/resourceGroups/fog-test-rg/providers/Microsoft.Network/routeTables/fog-test-route-table',
    service: service
  )
end

def virtual_network(service)
  Fog::Network::AzureRM::VirtualNetwork.new(
    name: 'fog-test-virtual-network',
    id: '/subscriptions/########-####-####-####-############/resourceGroups/fog-test-rg/providers/Microsoft.Network/virtualNetworks/fog-test-virtual-network',
    resource_group: 'fog-test-rg',
    location: 'West US',
    dns_list: '10.1.0.5,10.1.0.6',
    subnet_address_list: '10.1.0.0/24',
    network_address_list: '10.1.0.0/16,10.2.0.0/16',
    properties: nil,
    service: service
  )
end

def network_interface(service)
  Fog::Network::AzureRM::NetworkInterface.new(
    name: 'fog-test-network-interface',
    location: 'West US',
    resource_group: 'fog-test-rg',
    subnet_id: '/subscriptions/########-####-####-####-############/resourceGroups/fog-test-rg/providers/Microsoft.Network/virtualNetworks/fog-test-virtual-network/subnets/fog-test-subnet',
    ip_configuration_name: 'fog-test-ip-configuration',
    private_ip_allocation_method: 'fog-test-private-ip-allocation-method',
    properties: nil,
    service: service
  )
end

def zone(service)
  Fog::DNS::AzureRM::Zone.new(
    name: 'fog-test-zone.com',
    id: '/subscriptions/########-####-####-####-############/resourceGroups/fog-test-rg/providers/Microsoft.Network/dnszones/fog-test-zone.com',
    resource_group: 'fog-test-rg',
    service: service
  )
end

def record_set(service)
  Fog::DNS::AzureRM::RecordSet.new(
    name: 'fog-test-record_set',
    resource_group: 'fog-test-rg',
    zone_name: 'fog-test-zone.com',
    records: ['1.2.3.4', '1.2.3.3'],
    type: 'A',
    ttl: 60,
    service: service
  )
end

def network_security_group(service)
  Fog::Network::AzureRM::NetworkSecurityGroup.new(
    name: 'fog-test-nsg',
    resource_group: 'fog-test-rg',
    location: 'West US',
    security_rules: [{
      name: 'fog-test-rule',
      protocol: 'tcp',
      source_port_range: '22',
      destination_port_range: '22',
      source_address_prefix: '0.0.0.0/0',
      destination_address_prefix: '0.0.0.0/0',
      access: 'Allow',
      priority: '100',
      direction: 'Inbound'
    }],
    service: service
  )
end

def network_security_rule(service)
  Fog::Network::AzureRM::NetworkSecurityRule.new(
    name: 'fog-test-nsr',
    resource_group: 'fog-test-rg',
    network_security_group_name: 'fog-test-nsr',
    protocol: 'tcp',
    source_port_range: '22',
    destination_port_range: '22',
    source_address_prefix: '0.0.0.0/0',
    destination_address_prefix: '0.0.0.0/0',
    access: 'Allow',
    priority: '100',
    direction: 'Inbound',
    service: service
  )
end

def application_gateway(service)
  Fog::Network::AzureRM::ApplicationGateway.new(
    name: 'gateway',
    location: 'eastus',
    resource_group: 'fogRM-rg',
    skuName: 'Standard_Medium',
    skuTier: 'Standard',
    skuCapacity: '2',
    gatewayIpConfigurations:
      [
        {
          name: 'gatewayIpConfigName',
          subnet: '/subscriptions/########-####-####-####-############/resourcegroups/fogRM-rg/providers/Microsoft.Network/virtualNetworks/vnet/subnets/subnetName'
        }
      ],
    frontendIpConfigurations:
      [
        {
          name: 'frontendIpConfig',
          privateIPAllocationMethod: 'Dynamic',
          publicIpAddressId: '/subscriptions/########-####-####-####-############/resourcegroups/fogRM-rg/providers/Microsoft.Network/publicIPAddresses/publicIp',
          privateIPAddress: '10.0.1.5'
        }
      ],
    frontendPorts:
      [
        {
          name: 'frontendPort',
          port: 443
        }
      ],
    backendAddressPools:
      [
        {
          name: 'backendAddressPool',
          ipaddresses: [
            {
              ipAddress: '10.0.1.6'
            }
          ]
        }
      ],
    backendHttpSettingsList:
      [
        {
          name: 'gateway_settings',
          port: 80,
          protocol: 'Http',
          cookieBasedAffinity: 'Enabled',
          requestTimeout: '30',
          probe: ''
        }
      ],
    httpListeners:
      [
        {
          name: 'gateway_listener',
          frontendIp: '/subscriptions/########-####-####-####-############/resourceGroups/fogRM-rg/providers/Microsoft.Network/applicationGateways/gateway/frontendIPConfigurations/frontend_ip_config',
          frontendPort: '/subscriptions/########-####-####-####-############/resourceGroups/fogRM-rg/providers/Microsoft.Network/applicationGateways/gateway/frontendPorts/gateway_front_port',
          protocol: 'Https',
          hostName: '',
          sslCert: '/subscriptions/########-####-####-####-############/resourceGroups/fogRM-rg/providers/Microsoft.Network/applicationGateways/gateway/sslCertificates/ssl_certificate',
          requireServerNameIndication: 'false'
        }
      ],
    requestRoutingRules:
      [
        {
          name: 'gateway_request_route_rule',
          type: 'Basic',
          httpListener: '/subscriptions/########-####-####-####-############/resourceGroups/fogRM-rg/providers/Microsoft.Network/applicationGateways/gateway/httpListeners/gateway_listener',
          backendAddressPool: '/subscriptions/########-####-####-####-############/resourceGroups/fogRM-rg/providers/Microsoft.Network/applicationGateways/gateway/backendAddressPools/AG-BackEndAddressPool',
          backendHttpSettings: '/subscriptions/########-####-####-####-############/resourceGroups/fogRM-rg/providers/Microsoft.Network/applicationGateways/gateway/backendHttpSettingsCollection/gateway_settings',
          urlPathMap: ''
        }
      ],
    service: service
  )
end
