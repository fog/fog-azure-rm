require File.expand_path('../../../helper', __FILE__)

Shindo.tests('Fog::Network[:azurerm] | public_ips request', %w(azurerm network)) do
  tests('#public_ips') do
    pubips = azurerm_network_service.public_ips({:resource_group => rg_name})
    pubips = [fog_public_ip] if pubips.empty?

    test 'returns a Array' do
      pubips.is_a? Array
    end

    test('should return valid public_ip name') do
      pubips.first.name.is_a? String
    end

    test('should return public_ips') do
      pubips.size >= 1
    end
  end
end
