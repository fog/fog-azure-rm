require File.expand_path '../../test_helper', __dir__

# Test class for Create Database
class TestCreateOrUpdateDatabase < Minitest::Test
  def setup
    @service = Fog::Sql::AzureRM.new(credentials)
    @sql_manager_client = @service.instance_variable_get(:@sql_mgmt_client)
    @databases = @sql_manager_client.databases
    @database_hash = ApiStub::Requests::Sql::SqlDatabase.database_hash
  end

  def test_create_or_update_database_success
    database_response = ApiStub::Requests::Sql::SqlDatabase.create_database_response(@sql_manager_client)
    @databases.stub :create_or_update, database_response do
      assert_equal @service.create_or_update_database(@database_hash), database_response
    end
  end

  def test_create_or_update_database_failure
    response = proc { raise MsRestAzure::AzureOperationError.new(nil, nil, 'error' => { 'message' => 'mocked exception' }) }
    @databases.stub :create_or_update, response do
      assert_raises(MsRestAzure::AzureOperationError) { @service.create_or_update_database(@database_hash) }
    end
  end
end
