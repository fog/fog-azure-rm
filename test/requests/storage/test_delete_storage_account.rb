require File.expand_path '../../../test_helper', __FILE__

# Test Class for Delete Storage Account Request
class TestDeleteStorageAccount < Minitest::Test
  # This class posesses the test cases for the requests of storage account service.
  def setup
    @azure_credentials = Fog::Storage::AzureRM.new(credentials)
    storage_mgmt_client = @azure_credentials.instance_variable_get(:@storage_mgmt_client)
    @storage_accounts = storage_mgmt_client.storage_accounts
  end

  def test_delete_storage_account_success
    @storage_accounts.stub :delete, nil do
      assert @azure_credentials.delete_storage_account('gateway-RG', 'fog_test_storage_account')
    end
  end

  def test_delete_storage_account_failure
    assert_raises(ArgumentError) { @azure_credentials.delete_storage_account('gateway-RG', 'fog_test_storage_account', 'Hi') }
  end

  def test_delete_storage_account_exception
    raise_exception = proc { fail MsRestAzure::AzureOperationError.new(nil, nil, 'error' => { 'message' => 'mocked exception' }) }
    @storage_accounts.stub :delete, raise_exception do
      assert_raises(RuntimeError) { @azure_credentials.delete_storage_account('gateway-RG', 'fog_test_storage_account') }
    end
  end
end
