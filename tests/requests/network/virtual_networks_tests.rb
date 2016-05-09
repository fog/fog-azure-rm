require File.expand_path('../../../helper', __FILE__)

Shindo.tests('Fog::Network[:azurerm] | virtual_network request', %w(azurerm network)) do
  tests('#virtual_networks') do
    virtual_networks = azurerm_network_service.virtual_networks(resource_group: fog_resource_group)
    virtual_networks = [fog_virtual_network] if virtual_networks.empty?

    test 'returns a Array' do
      virtual_networks.is_a? Array
    end

    test('should return valid Virtual Network name') do
      virtual_networks.first.name.is_a? String
    end

    test('should return records') do
      virtual_networks.size >= 1
    end
  end
end
