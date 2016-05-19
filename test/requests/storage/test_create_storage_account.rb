require File.expand_path '../../test_helper', __dir__

# Create Storage Account Class
class TestCreateStorageAccount < Minitest::Test
  # This class posesses the test cases for the requests of storage account service.
  def setup
    @azure_credentials = Fog::Storage::AzureRM.new(credentials)
    client = @azure_credentials.instance_variable_get(:@storage_mgmt_client)
    @storage_accounts = client.storage_accounts
  end

  def test_create_storage_account_success
    mock_promise = Concurrent::Promise.execute do
    end
    storage_acc_obj = ApiStub::Requests::Storage::StorageAccount.storage_account_request
    properties = Azure::ARM::Storage::Models::StorageAccountPropertiesCreateParameters.new
    properties.account_type = 'Standard_LRS' # This might change in the near future!

    params = Azure::ARM::Storage::Models::StorageAccountCreateParameters.new
    params.properties = properties
    params.location = location
    mock_promise.stub :value!, storage_acc_obj do
      @storage_accounts.stub :create, mock_promise do
        assert_equal @azure_credentials.create_storage_account('gateway-RG', 'fog_test_storage_account', params),Azure::ARM::Storage::Models::StorageAccount.serialize_object(storage_acc_obj.body)
      end
    end
  end

  def test_create_storage_account_failure
    mock_promise = Concurrent::Promise.execute do
    end
    storage_acc_obj = ApiStub::Requests::Storage::StorageAccount.create_storage_account
    mock_promise.stub :value!, storage_acc_obj do
      @storage_accounts.stub :create, mock_promise do
        assert_raises ArgumentError do
          @azure_credentials.create_storage_account('gateway-RG', 'fog_test_storage_account')
        end
      end
    end
  end

  def test_create_storage_account_exception
    properties = Azure::ARM::Storage::Models::StorageAccountPropertiesCreateParameters.new
    properties.account_type = 'Standard_LRS' # This might change in the near future!
    params = Azure::ARM::Storage::Models::StorageAccountCreateParameters.new
    params.properties = properties
    params.location = location
    mock_promise = Concurrent::Promise.execute do
    end
    raise_exception = -> { fail MsRestAzure::AzureOperationError.new(nil, nil, 'error' => { 'message' => 'mocked exception' }) }
    mock_promise.stub :value!, raise_exception do
      @storage_accounts.stub :create, mock_promise do
        assert_raises(RuntimeError) { @azure_credentials.create_storage_account('gateway-RG', 'fog_test_storage_account', params) }
      end
    end
  end
end
