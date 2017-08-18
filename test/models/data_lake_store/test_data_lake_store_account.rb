require File.expand_path '../../test_helper', __dir__

# Test class for Data Lake Store Account Model
class TestDataLakeStoreAccount < Minitest::Test
  def setup
    @service = Fog::DataLakeStore::AzureRM.new(credentials)
    @account = data_lake_store_account(@service)
    @account_client1 = @service.instance_variable_get(:@account_client)
    @response = ApiStub::Models::DataLakeStore::DataLakeStoreAccount.create_data_lake_store_account_obj(@account_client1)
  end

  def test_model_methods
    methods = [
        :save,
        :update,
        :destroy
    ]
    methods.each do |method|
      assert_respond_to @account, method
    end
  end

  def test_model_attributes
    attributes = [
        :name,
        :id,
        :resource_group,
        :location,
        :type,
        :tags,
        :firewall_state,
        :firewall_allow_azure_ips,
        :firewall_rules,
        :encryption_state,
        :encryption_config,
        :new_tier,
        :current_tier
    ]
    attributes.each do |attribute|
      assert_respond_to @account, attribute
    end
  end

  def test_save_method_response
    @service.stub :create_data_lake_store_account, @response do
      assert_instance_of Fog::DataLakeStore::AzureRM::DataLakeStoreAccount, @account.save
    end
  end

  def test_update_method_response
    @service.stub :update_data_lake_store_account, @response do
      assert_instance_of Fog::DataLakeStore::AzureRM::DataLakeStoreAccountUpdateParameters, @account.update
    end
  end

  def test_destroy_method_true_response
    @service.stub :delete_data_lake_store_account, true do
      assert @account.destroy
    end
  end

  def test_destroy_method_false_response
    @service.stub :delete_data_lake_store_account, false do
      assert !@account.destroy
    end
  end
end
