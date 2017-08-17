require File.expand_path '../../test_helper', __dir__

# Test class for Data Lake Store Accounts Collection
class TestDataLakeStoreAccounts < Minitest::Test
  def setup
    @service = Fog::DataLakeStore::AzureRM.new(credentials)
    @accounts = Fog::DataLakeStore::AzureRM::DataLakeStoreAccounts.new(service: @service)
    @account_client1 = @service.instance_variable_get(:@dns_client)
    @response = [ApiStub::Models::DataLakeStore::DataLakeStoreAccount.create_data_lake_store_account_obj(@account_client1)]
  end

  def test_collection_methods
    methods = [
        :all,
        :get,
        :check_for_data_lake_store_account
    ]
    methods.each do |method|
      assert_respond_to @accounts, method
    end
  end

  def test_all_method_response
    @service.stub :list_data_lake_store_accounts, @response do
      assert_instance_of Fog::DataLakeStore::AzureRM::DataLakeStoreAccounts, @accounts.all
      assert @accounts.all.size >= 1
      @accounts.all.each do |s|
        assert_instance_of Fog::DataLakeStore::AzureRM::DataLakeStoreAccount, s
      end
    end
  end

  def test_get_method_response
    response = ApiStub::Models::DataLakeStore::DataLakeStoreAccount.create_data_lake_store_account_obj(@account_client1)
    @service.stub :get_data_lake_store_account, response do
      assert_instance_of Fog::DataLakeStore::AzureRM::DataLakeStoreAccount, @accounts.get('fog-test-rg', 'fogtestdls')
    end
  end

  def test_check_for_data_lake_store_account_true_response
    @service.stub :check_for_data_lake_store_account, true do
      assert @accounts.check_for_data_lake_store_account('fog-test-rg', 'fogtestdls')
    end
  end

  def test_check_for_data_lake_store_account_false_response
    @service.stub :check_for_data_lake_store_account, false do
      assert !@accounts.check_for_data_lake_store_account('fog-test-rg', 'fogtestdls')
    end
  end
end
