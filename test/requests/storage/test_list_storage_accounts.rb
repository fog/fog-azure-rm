require File.expand_path '../../test_helper', __dir__

# Storage Account Class
class TestListStorageAccounts < Minitest::Test
  # This class posesses the test cases for the requests of storage account service.
  def setup
    @azure_credentials = Fog::Storage::AzureRM.new(credentials)
    client = @azure_credentials.instance_variable_get(:@storage_mgmt_client)
    @storage_accounts = client.storage_accounts
  end

  def test_list_storage_accounts_success
    mock_promise = Concurrent::Promise.execute do
    end
    response_body = ApiStub::Requests::Storage::StorageAccount.list_storage_accounts
    result = ApiStub::Requests::Storage::StorageAccount.response_storage_account_list(response_body)
    mock_promise.stub :value!, result do
      @storage_accounts.stub :list, mock_promise do
        assert @azure_credentials.list_storage_accounts.size >= 1
        @azure_credentials.list_storage_accounts.each do |s|
          assert_instance_of Azure::ARM::Storage::Models::StorageAccount, s
        end
      end
    end
  end

  def test_list_storage_accounts_failure
    mock_promise = Concurrent::Promise.execute do
    end
    response_body = ApiStub::Requests::Storage::StorageAccount.list_storage_accounts
    result = ApiStub::Requests::Storage::StorageAccount.response_storage_account_list(response_body)
    mock_promise.stub :value!, result do
      @storage_accounts.stub :list, mock_promise do
        assert_raises ArgumentError do
          assert @azure_credentials.list_storage_accounts('wrong arg', 'second wrong arg')
        end
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
