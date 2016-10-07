require File.expand_path '../../test_helper', __dir__

# Test class for Sql Server Collection
class TestSqlServers < Minitest::Test
  def setup
    @service = Fog::Sql::AzureRM.new(credentials)
    @sql_servers = Fog::Sql::AzureRM::SqlServers.new(resource_group: 'fog-test-rg', name: 'database-name', location: 'eastus', version: '2.0', administrator_login: 'test-admin', administrator_login_password: 'test-apase2', service: @service)
    @list_sql_server_response = [ApiStub::Models::Sql::SqlServer.create_sql_server]
  end

  def test_collection_methods
    methods = [
      :all,
      :get
    ]
    methods.each do |method|
      assert @sql_servers.respond_to? method, true
    end
  end

  def test_collection_attributes
    assert @sql_servers.respond_to? :resource_group, true
  end

  def test_all_method_response
    @service.stub :list_sql_servers, @list_sql_server_response do
      assert_instance_of Fog::Sql::AzureRM::SqlServers, @sql_servers.all
      assert @sql_servers.all.size >= 1
      @sql_servers.all.each do |s|
        assert_instance_of Fog::Sql::AzureRM::SqlServer, s
      end
    end
  end

  def test_get_method_response
    response = ApiStub::Models::Sql::SqlServer.create_sql_server
    @service.stub :get_sql_server, response do
      assert_instance_of Fog::Sql::AzureRM::SqlServer, @sql_servers.get('fog-test-rg', 'fog-test-server-name')
    end
  end
end
