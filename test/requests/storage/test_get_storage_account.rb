require File.expand_path '../../test_helper', __dir__

# Test Class for Get Storage Account Request
class TestGetStorageAccount < Minitest::Test
  # This class posesses the test cases for the requests of storage account service.
  def setup
    @service = Fog::Storage::AzureRM.new(credentials)
    @storage_mgmt_client = @service.instance_variable_get(:@storage_mgmt_client)
    @storage_accounts = @storage_mgmt_client.storage_accounts
  end

  def test_get_storage_account_success
    response_body = ApiStub::Requests::Storage::StorageAccount.storage_account_request(@storage_mgmt_client)
    @storage_accounts.stub :get_properties, response_body do
      assert_equal @service.get_storage_account('fog_test_rg', 'fogtestsasecond'), response_body
    end
  end

  def test_list_storage_accounts_exeception
    raise_exception = proc { fail MsRestAzure::AzureOperationError.new(nil, nil, 'error' => { 'message' => 'mocked exception' }) }
    @storage_accounts.stub :get_properties, raise_exception do
      assert_raises(RuntimeError) { @service.get_storage_account('fog_test_rg', 'fogtestsasecond') }
    end
  end
end
