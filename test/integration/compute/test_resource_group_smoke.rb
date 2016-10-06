require 'fog/azurerm'
require 'minitest/autorun'
require 'yaml'

class TestResourceGroupSmoke < MiniTest::Test
  begin
    @@resource = Fog::Resources::AzureRM.new(
        tenant_id: ENV['TENANT_ID'],
        client_id: ENV['CLIENT_ID'],
        client_secret: ENV['CLIENT_SECRET'],
        subscription_id: ENV['SUBSCRIPTION_ID']
    )
    time = Time.now.to_s
    new_time = time.split(/\W+/).join
    @@resource_group_name = "fog-smoke-test-rg-#{new_time}"
  rescue StandardError => e
    puts e
  end

  Minitest.after_run do
    begin
      resource_group = @@resource.resource_groups.get(@@resource_group_name)
      resource_group.destroy
    rescue StandardError => e
      puts e
    end
  end

  def setup
    @resource = @@resource
  end

  def test_create_resource_group
    resource_group = @resource.resource_groups.create(name: @@resource_group_name, location: 'eastus')
    assert_instance_of Fog::Resources::AzureRM::ResourceGroup, resource_group
  end

  def test_all_resource_groups
  skip
  end

  def test_get_resource_group
    resource_group = @resource.resource_groups.get(@@resource_group_name)
    assert_instance_of Fog::Resources::AzureRM::ResourceGroup, resource_group
  end
end
