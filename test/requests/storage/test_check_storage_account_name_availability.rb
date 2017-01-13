require File.expand_path '../../test_helper', __dir__

# Test Class for Check Storage Account Request
class TestCheckStorageAccountNameAvailability < Minitest::Test
  # This class posesses the test cases for the requests of storage account service.
  def setup
    @azure_credentials = Fog::Storage::AzureRM.new(credentials)
    @storage_mgmt_client = @azure_credentials.instance_variable_get(:@storage_mgmt_client)
    @storage_accounts = @storage_mgmt_client.storage_accounts
  end

  def test_check_storage_account_name_availability_success
    true_case_response = ApiStub::Requests::Storage::StorageAccount.true_case_for_check_name_availability(@storage_mgmt_client)
    @storage_accounts.stub :check_name_availability, true_case_response do
      assert_equal @azure_credentials.check_storage_account_name_availability('teststorageaccount', 'Microsoft.Storage/storageAccounts'), true
    end
  end

  def test_check_storage_account_name_availability_failure
    false_case_response = ApiStub::Requests::Storage::StorageAccount.false_case_for_check_name_availability(@storage_mgmt_client)
    @storage_accounts.stub :check_name_availability, false_case_response do
      assert_equal @azure_credentials.check_storage_account_name_availability('testname', 'Microsoft.Storage/storageAccounts'), false
      assert_raises ArgumentError do
        @azure_credentials.check_storage_account_name_availability
      end
    end
  end

  def test_check_storage_account_name_availability_exception
    raise_exception = proc { raise MsRestAzure::AzureOperationError.new(nil, nil, 'error' => { 'message' => 'mocked exception', 'code' => 'ResourceGroupNotFound' }) }
    @storage_accounts.stub :check_name_availability, raise_exception do
      assert_raises(RuntimeError) { @azure_credentials.check_storage_account_name_availability('teststorageaccount', 'Microsoft.Storage/storageAccounts') }
    end
  end
end
