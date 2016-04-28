require File.expand_path '../../test_helper', __dir__

# Storage Account Class
class TestDeleteStorageAccount < Minitest::Test
  # This class posesses the test cases for the requests of storage account service.
  def setup
    @azure_credentials = Fog::Storage::AzureRM.new(credentials)
    client = @azure_credentials.instance_variable_get(:@storage_mgmt_client)
    @storage_accounts = client.storage_accounts
  end

  def test_delete_storage_account_success
    @storage_accounts.stub :delete, nil do
      assert_equal @azure_credentials.delete_storage_account('gateway-RG', 'awain'), nil
    end
  end

  def test_delete_storage_account_failure

    assert_raises(ArgumentError) { @azure_credentials.delete_storage_account('gateway-RG', 'awain', 'Hi') }

    raise_exception = -> { raise MsRestAzure::AzureOperationError.new }
    @storage_accounts.stub :delete, raise_exception do
      assert_raises(Exception) { @azure_credentials.delete_availability_set('gateway-RG', 'awain') }
    end
  end
end
