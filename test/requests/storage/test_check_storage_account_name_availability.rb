require File.expand_path '../../test_helper', __dir__

# Storage Account Class
class TestCheckStorageAccountNameAvailability < Minitest::Test
  # This class posesses the test cases for the requests of storage account service.
  def setup
    @azure_credentials = Fog::Storage::AzureRM.new(credentials)
    @client = @azure_credentials.instance_variable_get(:@storage_mgmt_client)
    @storage_accounts = @client.storage_accounts
  end

  def test_check_storage_account_name_availability_success
    params = Azure::ARM::Storage::Models::StorageAccountCheckNameAvailabilityParameters.new
    params.name = 'teststorageaccount'
    params.type = 'Microsoft.Storage/storageAccounts'
    true_case_response = ApiStub::Requests::Storage::StorageAccount.true_case_for_check_name_availability(@client)
    @storage_accounts.stub :check_name_availability, true_case_response do
      assert_equal @azure_credentials.check_storage_account_name_availability(params), true
    end
  end

  def test_check_storage_account_name_availability_failure
    params = Azure::ARM::Storage::Models::StorageAccountCheckNameAvailabilityParameters.new
    params.name = 'teststorageaccount'
    params.type = 'Microsoft.Storage/storageAccounts'
    false_case_response = ApiStub::Requests::Storage::StorageAccount.false_case_for_check_name_availability(@client)
    @storage_accounts.stub :check_name_availability, false_case_response do
      assert_equal @azure_credentials.check_storage_account_name_availability(params), false
      assert_raises ArgumentError do
        @azure_credentials.check_storage_account_name_availability(params, 'wrong arg')
      end
    end
  end

  def test_check_storage_account_name_availability_exception
    params = Azure::ARM::Storage::Models::StorageAccountCheckNameAvailabilityParameters.new
    params.name = 'teststorageaccount'
    params.type = 'Microsoft.Storage/storageAccounts'
    raise_exception = proc { raise MsRestAzure::AzureOperationError.new(nil, nil, 'error' => { 'message' => 'mocked exception', 'code' => 'ResourceGroupNotFound' }) }
    @storage_accounts.stub :check_name_availability, raise_exception do
      assert_raises(RuntimeError) { @azure_credentials.check_storage_account_name_availability(params) }
    end
  end
end
