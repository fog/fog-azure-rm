require File.expand_path '../../test_helper', __dir__

# Storage Container Class
class TestCreateContainer < Minitest::Test
  # This class posesses the test cases for the requests of creating storage containers.
  def setup
    @service = Fog::Storage::AzureRM.new(storage_account_credentials)
    @blob_client = @service.instance_variable_get(:@blob_client)
    @storage_container_object = ApiStub::Requests::Storage::Directory.create_container
  end

  def test_create_container_with_service_success
    @blob_client.stub :create_container, @storage_container_object do
      assert @service.create_container('testcontainer1')
    end
  end

  def test_create_container_with_internal_client_success
    @blob_client.stub :create_container, @storage_container_object do
      assert @blob_client.create_container('testcontainer1')
    end
  end

  def test_create_container_with_service_exception
    assert_raises(URI::InvalidURIError) { @service.create_container('testcontainer1#@#@') }
  end

  def test_create_container_with_internal_client_exception
    assert_raises(URI::InvalidURIError) { @blob_client.create_container('testcontainer1#@#@') }
  end
end
