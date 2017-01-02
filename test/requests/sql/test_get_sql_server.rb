require File.expand_path '../../test_helper', __dir__

# Test class for Get Sql Server
class TestGetSqlServer < Minitest::Test
  def setup
    @service = Fog::Sql::AzureRM.new(credentials)
    @sql_manager_client = @service.instance_variable_get(:@sql_mgmt_client)
    @servers = @sql_manager_client.servers
  end

  def test_get_sql_server_success
    create_response = ApiStub::Requests::Sql::SqlServer.create_sql_server_response(@sql_manager_client)
    @servers.stub :get_by_resource_group, create_response do
      assert_equal @service.get_sql_server('fog-test-rg', 'fog-test-server-name'), create_response
    end
  end

  def test_get_sql_server_failure
    response = proc { raise MsRestAzure::AzureOperationError.new(nil, nil, 'error' => { 'message' => 'mocked exception' }) }
    @servers.stub :get_by_resource_group, response do
      assert_raises(RuntimeError) { @service.get_sql_server('fog-test-rg', 'fog-test-server-name') }
    end
  end
end
