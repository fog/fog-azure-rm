require File.expand_path '../../test_helper', __dir__

# Test class for Storage Container Model
class TestDirectory < Minitest::Test
  def setup
    Fog.mock!
    @mock_service = Fog::Storage::AzureRM.new(storage_account_credentials)
    @mock_directory = storage_container(@mock_service)
    Fog.unmock!
    @service = Fog::Storage::AzureRM.new(storage_account_credentials)
    @directory = storage_container(@service)
    @create_result = ApiStub::Models::Storage::Directory.create_container
    @get_properties_result = ApiStub::Models::Storage::Directory.get_container_properties
    @get_access_control_list_result = ApiStub::Models::Storage::Directory.get_container_access_control_list
    @blob_client = @service.instance_variable_get(:@blob_client)
    @mocked_response = mocked_storage_http_error
  end

  def test_model_methods
    methods = [
      :save,
      :create,
      :destroy
    ]
    methods.each do |method|
      assert @directory.respond_to? method, true
    end
  end

  def test_model_attributes
    attributes = [
      :key,
      :etag,
      :last_modified,
      :lease_duration,
      :lease_state,
      :lease_status,
      :metadata
    ]
    @service.stub :create_container, @create_result do
      attributes.each do |attribute|
        assert_respond_to @directory, attribute
      end
    end
  end

  def test_save_method_response
    @service.stub :create_container, @create_result do
      assert_instance_of Fog::Storage::AzureRM::Directory, @directory.save
    end
    @service.stub :create_container, @create_result do
      assert_instance_of Fog::Storage::AzureRM::Directory, @directory.create
    end
  end

  def test_save_http_exception
    http_exception = -> (_container_name, _option) { raise Azure::Core::Http::HTTPError.new(@mocked_response) }
    @blob_client.stub :create_container, http_exception do
      assert_raises(RuntimeError) do
        @directory.save
      end
    end
  end

  def test_save_mock
    assert_instance_of Fog::Storage::AzureRM::Directory, @mock_directory.save
  end

  def test_get_container_properties_method_response
    @service.stub :get_container_properties, @get_properties_result do
      assert_instance_of Fog::Storage::AzureRM::Directory, @directory.get_properties
    end
  end

  def test_get_container_properties_http_exception
    http_exception = -> (_container_name, _option) { raise Azure::Core::Http::HTTPError.new(@mocked_response) }
    @blob_client.stub :get_container_properties, http_exception do
      assert_raises(RuntimeError) do
        @directory.get_properties
      end
    end
  end

  def test_get_container_properties_mock
    assert_instance_of Fog::Storage::AzureRM::Directory, @mock_directory.get_properties
  end

  def test_get_access_control_list_method_response
    @service.stub :get_container_access_control_list, @get_access_control_list_result do
      assert_instance_of Fog::Storage::AzureRM::Directory, @directory.access_control_list
    end
  end

  def test_get_access_control_list_http_exception
    http_exception = -> (_container_name, _option) { raise Azure::Core::Http::HTTPError.new(@mocked_response) }
    @blob_client.stub :get_container_acl, http_exception do
      assert_raises(RuntimeError) do
        @directory.access_control_list
      end
    end
  end

  def test_get_access_control_list_mock
    assert_instance_of Fog::Storage::AzureRM::Directory, @mock_directory.access_control_list
  end

  def test_delete_method_true_response
    @service.stub :delete_container, true do
      assert @directory.destroy
    end
  end

  def test_delete_method_exception
    exception = -> (_container_name, _option) { raise Azure::Core::Http::HTTPError.new(@mocked_response) }
    @blob_client.stub :delete_container, exception do
      assert_raises(RuntimeError) do
        assert @directory.destroy
      end
    end
  end

  def test_delete_method_response_mock
    assert @mock_directory.destroy
  end
end
