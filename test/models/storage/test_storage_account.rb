require File.expand_path '../../test_helper', __dir__

# Test class for Storage Account Model
class TestStorageAccount < Minitest::Test
  def setup
    @service = Fog::Storage::AzureRM.new(credentials)
    @storage_account = storage_account(@service)
    @response = ApiStub::Models::Storage::StorageAccount.create_storage_account
  end

  def test_model_methods
    methods = [
      :save,
      :destroy
    ]
    methods.each do |method|
      assert @storage_account.respond_to? method, true
    end
  end

  def test_model_attributes
    attributes = [
      :id,
      :name,
      :type,
      :location,
      :tags,
      :resource_group,
      :properties
    ]
    @service.stub :create_storage_account, @response do
      attributes.each do |attribute|
        assert @storage_account.respond_to? attribute
      end
    end
  end

  def test_save_method_response
    @service.stub :create_storage_account, @response do
      assert_instance_of Azure::ARM::Storage::Models::StorageAccount, @storage_account.save
    end
  end

  def test_destroy_method_response
    @service.stub :delete_storage_account, @response do
      assert_instance_of Azure::ARM::Storage::Models::StorageAccount, @storage_account.destroy
    end
  end
end
