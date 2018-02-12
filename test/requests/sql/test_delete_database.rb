require File.expand_path '../../test_helper', __dir__

# Test class for Delete Database
class TestDeleteDatabase < Minitest::Test
  def setup
    @service = Fog::Sql::AzureRM.new(credentials)
    @sql_manager_client = @service.instance_variable_get(:@sql_mgmt_client)
    @databases = @sql_manager_client.databases
  end

  def test_delete_database_success
    @databases.stub :delete, true do
      assert @service.delete_database('fog-test-rg', 'fog-test-server-name', 'database-name')
    end
  end

  def test_delete_database_failure
    response = proc { raise MsRestAzure::AzureOperationError.new(nil, nil, 'error' => { 'message' => 'mocked exception' }) }
    @databases.stub :delete, response do
      assert_raises(MsRestAzure::AzureOperationError) { @service.delete_database('fog-test-rg', 'fog-test-server-name', 'database-name') }
    end
  end
end
