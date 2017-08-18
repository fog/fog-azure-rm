require File.expand_path '../../test_helper', __dir__

# Test class for Get Data Lake Store Account
class TestGetDataLakeStoreAccount < Minitest::Test
  def setup
    @service = Fog::DataLakeStore::AzureRM.new(credentials)
    @account_client = @service.instance_variable_get(:@data_lake_store_account_client)
    @accounts = @account_client.account
  end

  def test_get_data_lake_store_account_success
    mocked_response = ApiStub::Requests::DataLakeStore::DataLakeStoreAccount.data_lake_store_account_response(@account_client)
    @accounts.stub :get, mocked_response do
      assert_equal @service.get_data_lake_store_account('fog-test-rg', 'data_lake_store_account_name'), mocked_response
    end
  end

  def test_get_data_lake_store_account_failure
    response = ApiStub::Requests::DataLakeStore::DataLakeStoreAccount.list_data_lake_store_accounts_response(@account_client)
    @accounts.stub :get, response do
      assert_raises ArgumentError do
        @service.get_data_lake_store_account('fog-test-rg')
      end
    end
  end

  def test_get_data_lake_store_account_exception
    response = proc { raise MsRestAzure::AzureOperationError.new(nil, nil, 'error' => { 'message' => 'mocked exception' }) }
    @accounts.stub :get, response do
      assert_raises MsRestAzure::AzureOperationError do
        @service.get_data_lake_store_account('fog-test-rg', 'data_lake_store_account_name')
      end
    end
  end
end
