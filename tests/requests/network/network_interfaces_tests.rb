require File.expand_path('../../../helper', __FILE__)

Shindo.tests('Fog::Network[:azurerm] | network_interfaces request', %w(azurerm network)) do
  tests('#network_interfaces') do
    nics = azurerm_network_service.network_interfaces(resource_group: rg_name)
    nics = [fog_network_interface] if nics.empty?

    test 'returns a Array' do
      nics.is_a? Array
    end

    test('should return valid network_interface name') do
      nics.first.name.is_a? String
    end

    test('should return public_ips') do
      nics.size >= 1
    end
  end
end
