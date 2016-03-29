require File.expand_path('../../../helper', __FILE__)

Shindo.tests('Fog::Resources[:azurerm] | resource_groups request', %w(azurerm resources)) do
  tests('#resource_groups') do
    resource_groups = azurerm_resources_service.resource_groups
    resource_groups = [fog_resource_group] if resource_groups.empty?

    test 'returns a Array' do
      resource_groups.is_a? Array
    end

    test('should return valid resource group name') do
      resource_groups.first.name.is_a? String
    end

    test('should return records') do
      resource_groups.size >= 1
    end
  end
end
