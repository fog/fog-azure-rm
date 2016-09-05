require File.expand_path '../../test_helper', __dir__

# Storage Container Class
class TestGetContaienrProperties < Minitest::Test
  # This class posesses the test cases for the requests of getting storage container properties.
  def setup
    @service = Fog::Storage::AzureRM.new(storage_account_credentials)
    @blob_client = @service.instance_variable_get(:@blob_client)
    @storage_container_object = ApiStub::Requests::Storage::Container.get_container_properties
  end

  def test_get_container_properties_with_service_success
    @blob_client.stub :get_container_properties, @storage_container_object do
      assert @service.get_container_properties('testcontainer1')
    end
  end

  def test_get_container_properties_with_internal_client_success
    @blob_client.stub :get_container_properties, @storage_container_object do
      assert @blob_client.get_container_properties('testcontainer1')
    end
  end

  def test_get_container_properties_with_service_exception
    assert_raises(URI::InvalidURIError) { @service.get_container_properties('testcontainer1#@#@') }
  end

  def test_get_container_properties_with_internal_client_exception
    assert_raises(URI::InvalidURIError) { @blob_client.get_container_properties('testcontainer1#@#@') }
  end
end
