require File.expand_path('../../../helper', __FILE__)

Shindo.tests('Fog::Network[:azurerm] | subnet request', %w(azurerm network)) do
  tests('#subnets') do
    subnets = azurerm_network_service.subnets(resource_group: fog_resource_group, virtual_network_name: fog_virtual_network)
    subnets = [fog_subnet] if subnets.empty?

    test 'returns a Array' do
      subnets.is_a? Array
    end

    test('should return valid subnet name') do
      subnets.first.name.is_a? String
    end

    test('should return records') do
      subnets.size >= 1
    end
  end
end
