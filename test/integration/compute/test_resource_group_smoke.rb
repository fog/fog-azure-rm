require 'fog/azurerm'
require 'minitest/autorun'
require 'yaml'

class TestResourceGroupSmoke < MiniTest::Test
  begin
    #azure_credentials = YAML.load_file(Dir.pwd + '\test\integration\credentials\azure.yml')
    puts "Client ID: #{ENV['CLIENT_ID']}"
    @@resource = Fog::Resources::AzureRM.new(
        tenant_id: ENV['TENANT_ID'],
        client_id: ENV['CLIENT_ID'],
        client_secret: ENV['CLIENT_SECRET'],
        subscription_id: ENV['SUBSCRIPTION_ID']
    )
  rescue StandardError => e
    puts e
  end

  Minitest.after_run do
    begin
      resource_group = @@resource.resource_groups.get('fog-smoke-test-rg')
      resource_group.destroy
    rescue StandardError => e
      puts e
    end
  end

  def setup
    @resource = @@resource
  end

  def test_create_resource_group
    resource_group = @resource.resource_groups.create(name: 'fog-smoke-test-rg', location: 'eastus')
    assert_instance_of Fog::Resources::AzureRM::ResourceGroup, resource_group
  end

  def test_all_resource_groups
  skip
  end

  def test_get_resource_group
    resource_group = @resource.resource_groups.get('fog-smoke-test-rg')
    assert_instance_of Fog::Resources::AzureRM::ResourceGroup, resource_group
  end
end
