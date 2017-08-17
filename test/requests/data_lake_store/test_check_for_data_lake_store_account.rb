require File.expand_path '../../test_helper', __dir__

# Test class for Check for Data Lake Store Account Request
class TestCheckForDataLakeStoreAccount < Minitest::Test
  def setup
    @service = Fog::DataLakeStore::AzureRM.new(credentials)
    @account_client = @service.instance_variable_get(:@data_lake_store_account_client)
    @accounts = @account_client.account
  end

  def test_check_for_data_lake_store_account_success
    mocked_response = ApiStub::Requests::DataLakeStore::DataLakeStoreAccount.data_lake_store_account_response(@account_client)
    @accounts.stub :get, mocked_response do
      assert_equal @service.check_for_data_lake_store_account('fog-test-rg', 'fogtestdls'), true
    end
  end

  def test_check_for_data_lake_store_account_failure
    response = proc { raise MsRestAzure::AzureOperationError.new(nil, nil, 'error' => { 'message' => 'mocked exception' }) }
    @accounts.stub :get, response do
      assert_raises(MsRestAzure::AzureOperationError) { @service.check_for_data_lake_store_account('fog-test-rg', 'fogtestdls') }
    end
  end
end
