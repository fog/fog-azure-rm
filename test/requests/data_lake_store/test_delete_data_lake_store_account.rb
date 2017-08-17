require File.expand_path '../../test_helper', __dir__

# Test class for Delete Data Lake Store Account Request
class TestDeleteDataLakeStoreAccount < Minitest::Test
  def setup
    @service = Fog::DataLakeStore::AzureRM.new(credentials)
    @account_client = @service.instance_variable_get(:@data_lake_store_account_client)
    @accounts = @account_client.account
  end

  def test_delete_data_lake_store_account_success
    response = true
    @accounts.stub :delete, response do
      assert @service.delete_data_lake_store_account('fog-test-rg', 'fogtestdls'), response
    end
  end

  def test_delete_data_lake_store_account_failure
    response = proc { raise MsRestAzure::AzureOperationError.new(nil, nil, 'error' => { 'message' => 'mocked exception' }) }
    @accounts.stub :delete, response do
      assert_raises(MsRestAzure::AzureOperationError) { @service.delete_data_lake_store_account('fog-test-rg', 'fogtestdls') }
    end
  end
end
