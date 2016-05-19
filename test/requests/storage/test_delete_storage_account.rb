require File.expand_path '../../test_helper', __dir__

# Storage Account Class
class TestDeleteStorageAccount < Minitest::Test
  # This class posesses the test cases for the requests of storage account service.
  def setup
    @azure_credentials = Fog::Storage::AzureRM.new(credentials)
    client = @azure_credentials.instance_variable_get(:@storage_mgmt_client)
    @storage_accounts = client.storage_accounts
    @promise = Concurrent::Promise.execute do
    end
  end

  def test_delete_storage_account_success
    @promise.stub :value!, true do
      @storage_accounts.stub :delete, @promise do
        assert @azure_credentials.delete_storage_account('gateway-RG', 'fog_test_storage_account')
      end
    end
  end

  def test_delete_storage_account_failure
    assert_raises(ArgumentError) { @azure_credentials.delete_storage_account('gateway-RG', 'fog_test_storage_account', 'Hi') }
  end

  def test_delete_storage_account_exception
    raise_exception = -> { fail MsRestAzure::AzureOperationError.new(nil, nil, 'error' => { 'message' => 'mocked exception' }) }
    @promise.stub :value!, raise_exception do
      @storage_accounts.stub :delete, @promise do
        assert_raises(RuntimeError) { @azure_credentials.delete_storage_account('gateway-RG', 'fog_test_storage_account') }
      end
    end
  end
end
