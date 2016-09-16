require File.expand_path '../../test_helper', __dir__
# Test class for Storage Account Model
class TestStorageAccount < Minitest::Test
  def setup
    @service = Fog::Storage::AzureRM.new(credentials)
    @storage_mgmt_client = @service.instance_variable_get(:@storage_mgmt_client)
    @storage_account = storage_account(@service)
    @standard_lrs_storage_account = standard_lrs(@service)
    @standard_invalid_replication = standard_check_for_invalid_replications(@service)
    @premium_invalid_replication  = premium_check_for_invalid_replications(@service)
    @storage_account_response = ApiStub::Models::Storage::StorageAccount.create_storage_account(@storage_mgmt_client)
  end

  def test_model_methods
    methods = [
      :save,
      :destroy,
      :get_access_keys
    ]
    methods.each do |method|
      assert @storage_account.respond_to? method, true
    end
  end

  def test_model_attributes
    attributes = [
      :name,
      :location,
      :resource_group,
      :sku_name,
      :replication
    ]
    attributes.each do |attribute|
      assert_respond_to @storage_account, attribute
    end
  end

  def test_save_method_response
    @service.stub :create_storage_account, @storage_account_response do
      assert_instance_of Fog::Storage::AzureRM::StorageAccount, @storage_account.save
    end
    @service.stub :create_storage_account, @storage_account_response do
      assert_raises RuntimeError do
        @standard_lrs_storage_account.save
      end
    end
    @service.stub :create_storage_account, @storage_account_response do
      assert_raises RuntimeError do
        @standard_invalid_replication.save
      end
    end
    @service.stub :create_storage_account, @storage_account_response do
      assert_raises RuntimeError do
        @premium_invalid_replication.save
      end
    end
  end

  def test_get_access_keys_method_response
    key1 = Azure::ARM::Storage::Models::StorageAccountKey.new
    key1.key_name = 'key1'
    key1.value = 'sfhyuiafhhfids0943'
    key1.permissions = 'Full'
    response = [key1]
    @service.stub :get_storage_access_keys, response do
      assert_equal @storage_account.get_access_keys, response
    end
  end

  def test_destroy_method_true_response
    @service.stub :delete_storage_account, true do
      assert @storage_account.destroy
    end
  end

  def test_destroy_method_false_response
    @service.stub :delete_storage_account, false do
      assert !@storage_account.destroy
    end
  end
end
