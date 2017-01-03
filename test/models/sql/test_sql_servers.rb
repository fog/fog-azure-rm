require File.expand_path '../../test_helper', __dir__

# Test class for Sql Server Collection
class TestSqlServers < Minitest::Test
  def setup
    @service = Fog::Sql::AzureRM.new(credentials)
    @sql_servers = sql_servers(@service)
    @sql_server_client = @service.instance_variable_get(:@sql_mgmt_client)
    @sql_server_response = ApiStub::Models::Sql::SqlServer.create_sql_server(@sql_server_client)
  end

  def test_collection_methods
    methods = [
      :all,
      :get
    ]
    methods.each do |method|
      assert_respond_to @sql_servers, method
    end
  end

  def test_collection_attributes
    assert_respond_to @sql_servers, :resource_group
  end

  def test_all_method_response
    @service.stub :list_sql_servers, [@sql_server_response] do
      assert_instance_of Fog::Sql::AzureRM::SqlServers, @sql_servers.all
      assert @sql_servers.all.size >= 1
      @sql_servers.all.each do |s|
        assert_instance_of Fog::Sql::AzureRM::SqlServer, s
      end
    end
  end

  def test_get_method_response
    @service.stub :get_sql_server, @sql_server_response do
      assert_instance_of Fog::Sql::AzureRM::SqlServer, @sql_servers.get('fog-test-rg', 'fog-test-server-name')
    end
  end
end
