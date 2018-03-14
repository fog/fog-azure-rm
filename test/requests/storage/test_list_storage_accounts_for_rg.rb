require File.expand_path '../../test_helper', __dir__

# Test Class for List Storage Accounts For Resource Group Request
class TestListStorageAccountsForRG < Minitest::Test
  # This class posesses the test cases for the requests of storage account service.
  def setup
    @azure_credentials = Fog::Storage::AzureRM.new(credentials)
    @storage_mgmt_client = @azure_credentials.instance_variable_get(:@storage_mgmt_client)
    @storage_accounts = @storage_mgmt_client.storage_accounts
  end

  def test_list_storage_accounts_for_rg_success
    response_body = ApiStub::Requests::Storage::StorageAccount.list_storage_accounts_for_rg(@storage_mgmt_client)
    @storage_accounts.stub :list_by_resource_group, response_body do
      assert @azure_credentials.list_storage_account_for_rg('gateway-RG').size >= 1
      @azure_credentials.list_storage_account_for_rg('gateway-RG').each do |s|
        assert_equal s.name, response_body.value[0].name
      end
    end
  end

  def test_list_storage_accounts_for_rg_failure
    response_body = ApiStub::Requests::Storage::StorageAccount.list_storage_accounts_for_rg(@storage_mgmt_client)
    @storage_accounts.stub :list_by_resource_group, response_body do
      assert_raises ArgumentError do
        @azure_credentials.list_storage_account_for_rg('gateway-RG', 'wrong argument')
      end
    end
  end

  def test_list_storage_accounts_for_rg_exception
    raise_exception = proc { fail MsRestAzure::AzureOperationError.new(nil, nil, 'error' => { 'message' => 'mocked exception' }) }
    @storage_accounts.stub :list_by_resource_group, raise_exception do
      assert_raises(MsRestAzure::AzureOperationError) { @azure_credentials.list_storage_account_for_rg('gateway-RG') }
    end
  end
end
