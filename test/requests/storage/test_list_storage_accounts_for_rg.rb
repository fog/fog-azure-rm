require File.expand_path '../../test_helper', __dir__

# Storage Account Class
class TestListStorageAccountsForRG < Minitest::Test
  # This class posesses the test cases for the requests of storage account service.
  def setup
    @azure_credentials = Fog::Storage::AzureRM.new(credentials)
    client = @azure_credentials.instance_variable_get(:@storage_mgmt_client)
    @storage_accounts = client.storage_accounts
  end

  def test_list_storage_accounts_for_rg_success
    mock_promise = Concurrent::Promise.execute do
    end
    response_body = ApiStub::Requests::Storage::StorageAccount.list_storage_accounts_for_rg
    result = ApiStub::Requests::Storage::StorageAccount.response_storage_account_list(response_body)
    mock_promise.stub :value!, result do
      @storage_accounts.stub :list_by_resource_group, mock_promise do
        assert @azure_credentials.list_storage_account_for_rg('gateway-RG').size >= 1
        @azure_credentials.list_storage_account_for_rg('gateway-RG').each do |s|
          assert_equal s, response_body['value'][0]
        end
      end
    end
  end

  def test_list_storage_accounts_for_rg_failure
    mock_promise = Concurrent::Promise.execute do
    end
    response_body = ApiStub::Requests::Storage::StorageAccount.list_storage_accounts_for_rg
    result = ApiStub::Requests::Storage::StorageAccount.response_storage_account_list(response_body)
    mock_promise.stub :value!, result do
      @storage_accounts.stub :list_by_resource_group, mock_promise do
        assert_raises ArgumentError do
          @azure_credentials.list_storage_account_for_rg('gateway-RG', 'wrong argument')
        end
      end
    end
  end

  def test_list_storage_accounts_for_rg_exception
    raise_exception = -> { fail MsRestAzure::AzureOperationError.new(nil, nil, 'error' => { 'message' => 'mocked exception' }) }
    mock_promise = Concurrent::Promise.execute do
    end
    mock_promise.stub :value!, raise_exception do
      @storage_accounts.stub :list_by_resource_group, mock_promise do
        assert_raises(RuntimeError) { @azure_credentials.list_storage_account_for_rg('gateway-RG') }
      end
    end
  end
end
