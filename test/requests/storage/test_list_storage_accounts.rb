require File.expand_path '../../test_helper', __dir__

# Test Class for List Storage Accounts Request
class TestListStorageAccounts < Minitest::Test
  # This class posesses the test cases for the requests of storage account service.
  def setup
    @azure_credentials = Fog::Storage::AzureRM.new(credentials)
    @storage_mgmt_client = @azure_credentials.instance_variable_get(:@storage_mgmt_client)
    @storage_accounts = @client.storage_accounts
  end

  def test_list_storage_accounts_success
    response_body = ApiStub::Requests::Storage::StorageAccount.list_storage_accounts(@storage_mgmt_client)
    @storage_accounts.stub :list, response_body do
      assert @azure_credentials.list_storage_accounts.size >= 1
      @azure_credentials.list_storage_accounts.each do |s|
        assert_equal s.name, response_body.value[0].name
      end
    end
  end

  def test_list_storage_accounts_failure
    response_body = ApiStub::Requests::Storage::StorageAccount.list_storage_accounts(@storage_mgmt_client)
    @storage_accounts.stub :list, response_body do
      assert_raises ArgumentError do
        assert @azure_credentials.list_storage_accounts('wrong arg', 'second wrong arg')
      end
    end
  end

  def test_list_storage_accounts_exeception
    raise_exception = -> { fail MsRestAzure::AzureOperationError.new(nil, nil, 'error' => { 'message' => 'mocked exception' }) }
    @storage_accounts.stub :list, raise_exception do
      assert_raises(RuntimeError) { @azure_credentials.list_storage_accounts }
    end
  end
end
