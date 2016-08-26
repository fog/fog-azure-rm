require File.expand_path '../../test_helper', __dir__

# Test class for Get Storage Access Keys
class TestGetStorageAccessKeys < Minitest::Test
  def setup
    @service = Fog::Storage::AzureRM.new(credentials)
    @storage_mgmt_client = @service.instance_variable_get(:@storage_mgmt_client)
    @storage_accounts = @storage_mgmt_client.storage_accounts
  end

  def test_get_storage_access_keys_success
    mocked_response = ApiStub::Requests::Storage::StorageAccount.list_keys_response
    @storage_accounts.stub :list_keys, mocked_response do
      assert_equal @service.get_storage_access_keys('fog-test-rg', 'fogstorageaccount'), mocked_response.keys
    end
  end

  def test_get_storage_access_keys_failure
    response = proc { raise MsRestAzure::AzureOperationError.new(nil, nil, 'error' => { 'message' => 'mocked exception' }) }
    @storage_accounts.stub :list_keys, response do
      assert_raises(RuntimeError) { @service.get_storage_access_keys('fog-test-rg', 'fogstorageaccount') }
    end
  end
end
