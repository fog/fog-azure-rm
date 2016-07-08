require File.expand_path '../../test_helper', __dir__

# Test class for Storage Container Model
class TestContainer < Minitest::Test
  def setup
    @service = Fog::Storage::AzureRM.new(storage_account_credentials)
    @container = storage_container(@service)
    @create_result = ApiStub::Models::Storage::Container.create_container
    @get_properties_result = ApiStub::Models::Storage::Container.get_container_properties
    @get_access_control_list_result = ApiStub::Models::Storage::Container.get_container_access_control_list
  end

  def test_model_methods
    methods = [
      :save,
      :create,
      :delete
    ]
    methods.each do |method|
      assert @container.respond_to? method, true
    end
  end

  def test_model_attributes
    attributes = [
      :name,
      :etag,
      :last_modified,
      :lease_duration,
      :lease_state,
      :lease_status,
      :metadata
    ]
    @service.stub :create_container, @create_result do
      attributes.each do |attribute|
        assert_respond_to @container, attribute
      end
    end
  end

  def test_save_method_response
    @service.stub :create_container, @create_result do
      assert_instance_of Fog::Storage::AzureRM::Container, @container.save
    end
    @service.stub :create_container, @create_result do
      assert_instance_of Fog::Storage::AzureRM::Container, @container.create
    end
  end

  def test_get_properties_method_response
    @service.stub :get_container_properties, @get_properties_result do
      assert_instance_of Fog::Storage::AzureRM::Container, @container.get_properties
    end
  end

  def test_get_access_control_list_method_response
    @service.stub :get_container_access_control_list, @get_access_control_list_result do
      assert_instance_of Fog::Storage::AzureRM::Container, @container.get_access_control_list
    end
  end

  def test_delete_method_true_response
    @service.stub :delete_container, true do
      assert @container.delete
    end
  end
end
