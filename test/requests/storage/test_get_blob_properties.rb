require File.expand_path '../../test_helper', __dir__

# Storage Blob Class
class TestGetBlobProperties < Minitest::Test
  # This class posesses the test cases for the requests of getting storage blob properties.
  def setup
    @service = Fog::Storage::AzureRM.new(storage_account_credentials)
    @blob_client = @service.instance_variable_get(:@blob_client)
    @storage_blob_object = ApiStub::Requests::Storage::Blob.get_blob_properties
  end

  def test_get_blob_properties_with_service_success
    @blob_client.stub :get_blob_properties, @storage_blob_object do
      assert @service.get_blob_properties('testcontainer', 'testblob1')
    end
  end

  def test_get_blob_properties_with_internal_client_success
    @blob_client.stub :get_blob_properties, @storage_blob_object do
      assert @blob_client.get_blob_properties('testcontainer', 'testblob1')
    end
  end
end
