require File.expand_path '../../test_helper', __dir__

# Test class for List Databases Request
class TestListDatabases < Minitest::Test
  def setup
    @service = Fog::Sql::AzureRM.new(credentials)
    @sql_manager_client = @service.instance_variable_get(:@sql_mgmt_client)
    @database = @sql_manager_client.databases
  end

  def test_list_databases_success
    list_response = ApiStub::Requests::Sql::SqlDatabase.list_database_response(@sql_manager_client)
    @database.stub :list_by_server, list_response do
      assert_equal @service.list_databases('fog-test-rg', 'fog-test-server-name'), list_response
    end
  end

  def test_list_databases_failure
    response = proc { raise MsRestAzure::AzureOperationError.new(nil, nil, 'error' => { 'message' => 'mocked exception' }) }
    @database.stub :list_by_server, response do
      assert_raises(RuntimeError) { @service.list_databases('fog-test-rg', 'fog-test-server-name') }
    end
  end
end
