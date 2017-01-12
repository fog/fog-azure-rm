require File.expand_path '../../test_helper', __dir__

# Test class for Create Sql Server
class TestCreateOrUpdateSqlServer < Minitest::Test
  def setup
    @service = Fog::Sql::AzureRM.new(credentials)
    @sql_manager_client = @service.instance_variable_get(:@sql_mgmt_client)
    @server = @sql_manager_client.servers
    @data_hash = ApiStub::Requests::Sql::SqlServer.sql_server_hash
  end

  def test_create_or_update_sql_server_success
    server_response = ApiStub::Requests::Sql::SqlServer.create_sql_server_response(@sql_manager_client)
    @server.stub :create_or_update, server_response do
      assert_equal @service.create_or_update_sql_server(@data_hash), server_response
    end
  end

  def test_create_or_update_sql_server_failure
    response = proc { raise MsRestAzure::AzureOperationError.new(nil, nil, 'error' => { 'message' => 'mocked exception' }) }
    @server.stub :create_or_update, response do
      assert_raises(RuntimeError) { @service.create_or_update_sql_server(@data_hash) }
    end
  end
end
