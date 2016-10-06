require 'fog/azurerm'
require 'minitest/autorun'
require 'yaml'

class TestResourceGroupSmoke < MiniTest::Test
  begin
    @@resource = Fog::Resources::AzureRM.new(
        tenant_id: "5ad58990-1a8e-439a-9de6-804ed6e5f511",
        client_id: "40f33832-e9f8-4524-97c4-9e66f059a087",
        client_secret: "Hwc69ON3/FW6xo8zeoDPhjlg9Xg0kI0ZpiNUYjgGbcY=",
        subscription_id: "67f2116d-4ea2-4c6c-b20a-f92183dbe3cb"
    )
    time = Time.now.to_f.to_s
    puts "Time: #{time}"
    new_time = time.split(/\W+/).join
    @@resource_group_name = "fog-smoke-test-rg-#{new_time}"
  rescue StandardError => e
    puts e
  end

  # Minitest.after_run do
  #   begin
  #     resource_group = @resource.resource_groups.get(@resource_group_name)
  #     resource_group.destroy
  #   rescue StandardError => e
  #     puts e
  #   end
  # end

  def setup
    @resource = @@resource
    @resource_group_name = @@resource_group_name
  end

  def test_create_resource_group
    resource_group = @resource.resource_groups.create(name: @resource_group_name, location: 'eastus')
    resource_group1 = @resource.resource_groups.get(@resource_group_name)
    puts resource_group1
    assert_instance_of Fog::Resources::AzureRM::ResourceGroup, resource_group
  end

  def test_all_resource_groups
  skip
  end

  def test_get_resource_group
    resource_group = @resource.resource_groups.get(@resource_group_name)
    assert_instance_of Fog::Resources::AzureRM::ResourceGroup, resource_group
  end
end
