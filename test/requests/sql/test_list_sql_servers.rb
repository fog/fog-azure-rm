require File.expand_path '../../test_helper', __dir__

# Test class for List Sql Server Request
class TestListSqlServers < Minitest::Test
  def setup
    @service = Fog::Sql::AzureRM.new(credentials)
    @sql_manager_client = @service.instance_variable_get(:@sql_mgmt_client)
    @server = @sql_manager_client.servers
  end

  def test_list_sql_servers_success
    list_response = ApiStub::Requests::Sql::SqlServer.list_sql_server_response(@sql_manager_client)
    @server.stub :list_by_resource_group, list_response do
      assert_equal @service.list_sql_servers('fog-test-rg'), list_response
    end
  end

  def test_list_sql_servers_failure
    response = proc { raise MsRestAzure::AzureOperationError.new(nil, nil, 'error' => { 'message' => 'mocked exception' }) }
    @server.stub :list_by_resource_group, response do
      assert_raises(MsRestAzure::AzureOperationError) { @service.list_sql_servers('fog-test-rg') }
    end
  end
end
