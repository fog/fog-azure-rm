require File.expand_path '../../test_helper', __dir__

# Test class for Get Storage Access Keys
class TestGetStorageAccessKeys < Minitest::Test
  def setup
    @service = Fog::Storage::AzureRM.new(credentials)
    client = @service.instance_variable_get(:@storage_mgmt_client)
    @storage_accounts = client.storage_accounts
    @promise = Concurrent::Promise.execute do
    end
  end

  def test_get_storage_access_keys_success
    mocked_response = ApiStub::Requests::Storage::StorageAccount.list_keys_response
    expected_response = Azure::ARM::Storage::Models::StorageAccountKeys.serialize_object(mocked_response.body)
    @promise.stub :value!, mocked_response do
      @storage_accounts.stub :list_keys, @promise do
        assert_equal @service.get_storage_access_keys('fog-test-rg', 'fogstorageaccount'), expected_response
      end
    end
  end

  def test_get_storage_access_keys_failure
    response = -> { raise MsRestAzure::AzureOperationError.new(nil, nil, 'error' => { 'message' => 'mocked exception' }) }
    @promise.stub :value!, response do
      @storage_accounts.stub :list_keys, @promise do
        assert_raises(RuntimeError) { @service.get_storage_access_keys('fog-test-rg', 'fogstorageaccount') }
      end
    end
  end
end
