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