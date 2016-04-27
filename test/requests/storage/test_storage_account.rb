require File.expand_path '../../test_helper', __dir__

# Storage Account Class
class TestStorageAccount < Minitest::Test
  # This class posesses the test cases for the requests of storage account service.
  def setup
    @azure_credentials = Fog::Storage::AzureRM.new(credentials)
    client = @azure_credentials.instance_variable_get(:@storage_mgmt_client)
    @storage_accounts = client.storage_accounts
  end

  def test_list_storage_accounts_for_rg
    mock_promise = Concurrent::Promise.execute do
    end
    response_body = ApiStub::Requests::Storage::StorageAccount.list_storage_accounts_for_rg
    result = ApiStub::Requests::Storage::StorageAccount
                 .azure_operation_response(response_body)
    mock_promise.stub :value!, result do
      @storage_accounts.stub :list_by_resource_group, mock_promise do
        assert @azure_credentials.list_storage_account_for_rg('gateway-RG').size >= 1
        @azure_credentials.list_storage_account_for_rg('gateway-RG').each do |s|
          assert_instance_of Azure::ARM::Storage::Models::StorageAccount, s
        end
      end
    end
    raise_exception = -> { raise MsRestAzure::AzureOperationError.new }
    @storage_accounts.stub :list_by_resource_group, raise_exception do
      assert_raises(Exception) { @azure_credentials.list_storage_account_for_rg('gateway-RG') }
    end
  end

  def test_list_storage_accounts
    mock_promise = Concurrent::Promise.execute do
    end
    response_body = ApiStub::Requests::Storage::StorageAccount.list_storage_accounts
    result = ApiStub::Requests::Storage::StorageAccount
                 .azure_operation_response(response_body)
    mock_promise.stub :value!, result do
      @storage_accounts.stub :list, mock_promise do
        assert @azure_credentials.list_storage_accounts.size >= 1
        @azure_credentials.list_storage_accounts.each do |s|
          assert_instance_of Azure::ARM::Storage::Models::StorageAccount, s
        end
      end
    end
    raise_exception = -> { raise MsRestAzure::AzureOperationError.new }
    @storage_accounts.stub :list, raise_exception do
      assert_raises(Exception) { @azure_credentials.list_storage_accounts }
    end
  end

  def test_check_storage_account_name_availability
    params = Azure::ARM::Storage::Models::StorageAccountCheckNameAvailabilityParameters.new
    params.name = 'teststorageaccount'
    params.type = 'Microsoft.Storage/storageAccounts'
    mock_promise = Concurrent::Promise.execute do
    end
    true_case_response = ApiStub::Requests::Storage::StorageAccount
                             .true_case_for_check_name_availability
    result = ApiStub::Requests::Storage::StorageAccount
                 .azure_operation_response(true_case_response)
    mock_promise.stub :value!, result do
      @storage_accounts.stub :check_name_availability, mock_promise do
        assert_equal @azure_credentials
                         .check_storage_account_name_availability(params), true
      end
    end
    false_case_response = ApiStub::Requests::Storage::StorageAccount.false_case_for_check_name_availability
    result = ApiStub::Requests::Storage::StorageAccount
                 .azure_operation_response(false_case_response)
    mock_promise.stub :value!, result do
      @storage_accounts.stub :check_name_availability, mock_promise do
        assert_equal @azure_credentials
                         .check_storage_account_name_availability(params), false
      end
    end
    raise_exception = -> { raise MsRestAzure::AzureOperationError.new }
    @storage_accounts.stub :check_name_availability, raise_exception do
      assert_raises(Exception) do
        @azure_credentials.check_storage_account_name_availability(params)
      end
    end
  end
end
