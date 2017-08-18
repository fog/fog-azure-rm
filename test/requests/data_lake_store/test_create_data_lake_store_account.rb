require File.expand_path '../../test_helper', __dir__

# Test class for Create Data Lake Store Account Request
class TestCreateDataLakeStoreAccount < Minitest::Test
  def setup
    @service = Fog::DataLakeStore::AzureRM.new(credentials)
    @account_client = @service.instance_variable_get(:@data_lake_store_account_client)
    @accounts = @account_client.account
  end

  def test_create_data_lake_store_account_success
    mocked_response = ApiStub::Requests::DataLakeStore::DataLakeStoreAccount.data_lake_store_account_response(@account_client)
    account_params = {}
    @accounts.stub :create, mocked_response do
      assert_equal @service.create_data_lake_store_account(account_params), mocked_response
    end
  end

  def test_create_data_lake_store_account_failure
    response = ApiStub::Requests::DataLakeStore::DataLakeStoreAccount.list_data_lake_store_accounts_response(@account_client)
    @accounts.stub :create, response do
      assert_raises ArgumentError do
        @service.create_data_lake_store_account
      end
    end
  end

  def test_create_data_lake_store_account_exception
    response = proc { raise MsRestAzure::AzureOperationError.new(nil, nil, 'error' => { 'message' => 'mocked exception' }) }
    account_params = {}
    @accounts.stub :create, response do
      assert_raises MsRestAzure::AzureOperationError do
        @service.create_data_lake_store_account(account_params)
      end
    end
  end
end
