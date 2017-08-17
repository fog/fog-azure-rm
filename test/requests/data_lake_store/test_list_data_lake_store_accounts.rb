require File.expand_path '../../test_helper', __dir__

# Test class for List Data Lake Store Accounts Request
class TestListDataLakeStoreAccounts < Minitest::Test
  def setup
    @service = Fog::DataLakeStore::AzureRM.new(credentials)
    @account_client = @service.instance_variable_get(:@data_lake_store_account_client)
    @accounts = @account_client.account
  end

  def test_list_data_lake_store_accounts_success
    mocked_response = ApiStub::Requests::DataLakeStore::DataLakeStoreAccount.data_lake_store_account_response(@account_client)
    @accounts.stub :list, mocked_response do
      assert_equal @service.list_data_lake_store_accounts, mocked_response
    end
  end

  def test_list_data_lake_store_accounts_exception
    response = proc { raise MsRestAzure::AzureOperationError.new(nil, nil, 'error' => { 'message' => 'mocked exception' }) }
    @accounts.stub :list, response do
      assert_raises MsRestAzure::AzureOperationError do
        @service.list_data_lake_store_accounts
      end
    end
  end
end
