require File.expand_path '../../test_helper', __dir__

# Test class for Get Database
class TestGetDatabase < Minitest::Test
  def setup
    @service = Fog::Sql::AzureRM.new(credentials)
    @sql_manager_client = @service.instance_variable_get(:@sql_mgmt_client)
    @databases = @sql_manager_client.databases
  end

  def test_get_database_success
    create_response = ApiStub::Requests::Sql::SqlDatabase.create_database_response(@sql_manager_client)
    @databases.stub :get, create_response do
      assert_equal @service.get_database('fog-test-rg', 'fog-test-server-name', 'fog-test-database-name'), create_response
    end
  end

  def test_get_database_failure
    response = proc { raise MsRestAzure::AzureOperationError.new(nil, nil, 'error' => { 'message' => 'mocked exception' }) }
    @databases.stub :get, response do
      assert_raises(RuntimeError) { @service.get_database('fog-test-rg', 'fog-test-server-name', 'fog-test-database-name') }
    end
  end
end
