require File.expand_path '../../test_helper', __dir__

# Storage Account Class
class TestCheckStorageAccountNameAvailability < Minitest::Test
  # This class posesses the test cases for the requests of storage account service.
  def setup
    @azure_credentials = Fog::Storage::AzureRM.new(credentials)
    client = @azure_credentials.instance_variable_get(:@storage_mgmt_client)
    @storage_accounts = client.storage_accounts
  end

  def test_check_storage_account_name_availability_success
    params = Azure::ARM::Storage::Models::StorageAccountCheckNameAvailabilityParameters.new
    params.name = 'teststorageaccount'
    params.type = 'Microsoft.Storage/storageAccounts'
    mock_promise = Concurrent::Promise.execute do
    end
    true_case_response = ApiStub::Requests::Storage::StorageAccount.true_case_for_check_name_availability
    result = ApiStub::Requests::Storage::StorageAccount.azure_operation_response(true_case_response)
    mock_promise.stub :value!, result do
      @storage_accounts.stub :check_name_availability, mock_promise do
        assert_equal @azure_credentials.check_storage_account_name_availability(params), true
      end
    end
  end

  def test_check_storage_account_name_availability_failure
    params = Azure::ARM::Storage::Models::StorageAccountCheckNameAvailabilityParameters.new
    params.name = 'teststorageaccount'
    params.type = 'Microsoft.Storage/storageAccounts'
    mock_promise = Concurrent::Promise.execute do
    end
    false_case_response = ApiStub::Requests::Storage::StorageAccount.false_case_for_check_name_availability
    result = ApiStub::Requests::Storage::StorageAccount
             .azure_operation_response(false_case_response)
    mock_promise.stub :value!, result do
      @storage_accounts.stub :check_name_availability, mock_promise do
        assert_equal @azure_credentials.check_storage_account_name_availability(params), false
        assert_raises ArgumentError do
          @azure_credentials.check_storage_account_name_availability(params, 'wrong arg')
        end
      end
    end
  end

  def test_check_storage_account_name_availability_exception
    params = Azure::ARM::Storage::Models::StorageAccountCheckNameAvailabilityParameters.new
    params.name = 'teststorageaccount'
    params.type = 'Microsoft.Storage/storageAccounts'
    raise_exception = -> { raise MsRestAzure::AzureOperationError.new(nil, nil, 'error' => { 'message' => 'mocked exception', 'code' => 'ResourceGroupNotFound' }) }
    mock_promise = Concurrent::Promise.execute do
    end
    mock_promise.stub :value!, raise_exception do
      @storage_accounts.stub :check_name_availability, mock_promise do
        assert_raises(RuntimeError) { @azure_credentials.check_storage_account_name_availability(params) }
      end
    end
  end
end
