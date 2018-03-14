require File.expand_path '../../test_helper', __dir__

# Test class for Delete Sql Server
class TestDeleteSqlServer < Minitest::Test
  def setup
    @service = Fog::Sql::AzureRM.new(credentials)
    @sql_manager_client = @service.instance_variable_get(:@sql_mgmt_client)
    @servers = @sql_manager_client.servers
  end

  def test_delete_sql_server_success
    @servers.stub :delete, true do
      assert @service.delete_sql_server('fog-test-rg', 'fog-test-server-name')
    end
  end

  def test_delete_sql_server_failure
    response = proc { raise MsRestAzure::AzureOperationError.new(nil, nil, 'error' => { 'message' => 'mocked exception' }) }
    @servers.stub :delete, response do
      assert_raises(MsRestAzure::AzureOperationError) { @service.delete_sql_server('fog-test-rg', 'fog-test-server-name') }
    end
  end
end
