require 'fog/azurerm'
require 'minitest/autorun'

class TestResourceGroupSmoke < MiniTest::Test
  
  def setup
    @resource = Fog::Resources::AzureRM.new(
      tenant_id: ENV['TENANT_ID'],
      client_id: ENV['CLIENT_ID'],
      client_secret: ENV['CLIENT_SECRET'],
      subscription_id: ENV['SUBSCRIPTION_ID']
    )
    time = Time.now.to_f.to_s
    new_time = time.split(/\W+/).join
    @resource_group_name = "fog-smoke-test-rg-#{new_time}"
  end

  def test_resource_group
    resource_group = @resource.resource_groups.create(name: @resource_group_name, location: 'eastus')
    assert_instance_of Fog::Resources::AzureRM::ResourceGroup, resource_group

    resource_group = @resource.resource_groups.get(@resource_group_name)
    assert_instance_of Fog::Resources::AzureRM::ResourceGroup, resource_group

    resource_group.destroy
  end
end
