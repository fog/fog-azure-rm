if ENV['COVERAGE']
  require 'simplecov'
  SimpleCov.start do
    add_filter 'test'
    command_name 'Minitest'
  end
end

if ENV['CODECLIMATE_REPO_TOKEN']
  require 'codeclimate-test-reporter'
  CodeClimate::TestReporter.start
end

require 'minitest/autorun'
$LOAD_PATH.unshift(File.expand_path '../lib', __dir__)
require File.expand_path '../lib/fog/azurerm', __dir__
require File.expand_path './api_stub', __dir__
def credentials
  {
    tenant_id: '<TENANT-ID>',
    client_id: '<CLIENT-ID>',
    client_secret: '<CLIENT-SECRET>',
    subscription_id: '<SUBSCRIPTION-ID>'
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

def load_balancer(service)
  Fog::Network::AzureRM::LoadBalancer.new(
    name: 'lb',
    resource_group: 'fogRM-rg',
    location: 'westus',
    frontend_ip_configurations:
      [
        {
          name: 'fic',
          private_ipallocation_method: 'Dynamic',
          public_ipaddress_id: '/subscriptions/67f2116d-4ea2-4c6c-b20a-f92183dbe3cb/resourcegroups/fogRM-rg/providers/Microsoft.Network/publicIPAddresses/pip',
          subnet_id: '/subscriptions/67f2116d-4ea2-4c6c-b20a-f92183dbe3cb/resourcegroups/fogRM-rg/providers/Microsoft.Network/virtualNetworks/vnet/subnets/sb1'
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
          frontend_ip_configuration_id: '/subscriptions/67f2116d-4ea2-4c6c-b20a-f92183dbe3cb/resourceGroups/fogRM-rg/providers/Microsoft.Network/loadBalancers/lb/frontendIPConfigurations/fic',
          backend_address_pool_id: '/subscriptions/67f2116d-4ea2-4c6c-b20a-f92183dbe3cb/resourceGroups/fogRM-rg/providers/Microsoft.Network/loadBalancers/lb/backendAddressPools/pool1',
          protocol: 'Tcp',
          frontend_port: '80',
          backend_port: '8080',
          enable_floating_ip: false,
          idle_timeout_in_minutes: 4,
          load_distribution: 'Default'
        }
      ],
    inbound_nat_rules:
      [
        {
          name: 'RDP-Traffic',
          frontend_ip_configuration_id: '/subscriptions/67f2116d-4ea2-4c6c-b20a-f92183dbe3cb/resourceGroups/fogRM-rg/providers/Microsoft.Network/loadBalancers/lb/frontendIPConfigurations/fic',
          protocol: 'Tcp',
          frontend_port: 3389,
          backend_port: 3389
        }
      ],
    probes:
      [
        {
          name: 'probe1',
          protocol: 'Tcp',
          port: 8080,
          request_path: 'myprobeapp1/myprobe1.svc',
          interval_in_seconds: 5,
          number_of_probes: 16
        }
      ],
    inbound_nat_pools:
      [
        {
          name: 'RDPForVMSS1',
          protocol: 'Tcp',
          frontend_port_range_start: 500,
          frontend_port_range_end: 505,
          backend_port: 3389
        }
      ],
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
    records: %w(1.2.3.4 1.2.3.3),
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

def traffic_manager_end_point(service)
  Fog::Network::AzureRM::TrafficManagerEndPoint.new(
    name: 'fog-test-end-point',
    traffic_manager_profile_name: 'fog-test-profile',
    resource_group: 'fog-test-rg',
    type: 'external',
    target: 'test.com',
    endpoint_location: 'West US',
    service: service
  )
end

def traffic_manager_profile(service)
  Fog::Network::AzureRM::TrafficManagerProfile.new(
    name: 'fog-test-profile',
    resource_group: 'fog-test-rg',
    traffic_routing_method: 'Performance',
    relative_name: 'fog-test-app',
    ttl: '30',
    protocol: 'http',
    port: '80',
    path: '/monitorpage.aspx',
    service: service
  )
end
