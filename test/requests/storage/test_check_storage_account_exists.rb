require File.expand_path '../../test_helper', __dir__

# Test Class for Check Storage Account Exists Request
class TestCheckStorageAccountExists < Minitest::Test
  # This class posesses the test cases for the requests of storage account service.
  def setup
    @service = Fog::Storage::AzureRM.new(credentials)
    @storage_mgmt_client = @service.instance_variable_get(:@storage_mgmt_client)
    @storage_accounts = @storage_mgmt_client.storage_accounts
  end

  def test_check_storage_account_exists_success
    response_body = ApiStub::Requests::Storage::StorageAccount.storage_account_request(@storage_mgmt_client)
    response_body.provisioning_state = 'Succeeded'
    @storage_accounts.stub :get_properties, response_body do
      assert_equal @service.check_storage_account_exists('fog_test_rg', 'fog-test-storage-account'), true
    end
  end

  def test_check_storage_account_exists_failure
    response = ApiStub::Requests::Storage::StorageAccount.storage_account_request(@storage_mgmt_client)
    response.provisioning_state = 'Failed'
    @storage_accounts.stub :get_properties, response do
      assert !@service.check_storage_account_exists('fog_test_rg', 'fogtestsasecond')
    end
  end

  def test_check_storage_account_exists_exception
    response = proc { raise MsRestAzure::AzureOperationError.new(nil, mock_response, 'error' => { 'message' => 'mocked exception', 'code' => 'ResourceGroupNotFound' }) }
    @storage_accounts.stub :get_properties, response do
      assert !@service.check_storage_account_exists('fog_test_rg', 'fogtestsasecond')
    end
  end
end
