require 'fog/azurerm'
require 'minitest/autorun'
# Integration smoke test class to test resource group
class TestResourceGroupSmoke < MiniTest::Test
  
  def setup
    if !ENV['TENANT_ID'].nil? && !ENV['CLIENT_ID'].nil? && !ENV['CLIENT_SECRET'].nil? && !ENV['SUBSCRIPTION_ID'].nil?
      @resource = Fog::Resources::AzureRM.new(
        tenant_id: ENV['TENANT_ID'],
        client_id: ENV['CLIENT_ID'],
        client_secret: ENV['CLIENT_SECRET'],
        subscription_id: ENV['SUBSCRIPTION_ID']
      )
    else
      azure_credentials = YAML.load_file('../../integration/credentials/azure.yml')
      @resource = Fog::Resources::AzureRM.new(
        tenant_id: azure_credentials['tenant_id'],
        client_id: azure_credentials['client_id'],
        client_secret: azure_credentials['client_secret'],
        subscription_id: azure_credentials['subscription_id']
      )
    end
    time = Time.now.to_f.to_s
    new_time = time.split(/\W+/).join
    @resource_group_name = "fog-smoke-test-rg-#{new_time}"
  end

  def test_resource_group
    puts 'In Smoke tests'
    resource_group = @resource.resource_groups.create(name: @resource_group_name, location: 'eastus')
    assert_instance_of Fog::Resources::AzureRM::ResourceGroup, resource_group

    resource_group = @resource.resource_groups.get(@resource_group_name)
    assert_instance_of Fog::Resources::AzureRM::ResourceGroup, resource_group

    resource_group.destroy
  end
end
