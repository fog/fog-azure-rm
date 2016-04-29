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
    network_interface_card_id: '/subscriptions/67f2116d-4ea2-4c6c-b20a-f92183dbe3cb/resourceGroups/shaffanRG/providers/Microsoft.Network/networkInterfaces/testNIC',
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
