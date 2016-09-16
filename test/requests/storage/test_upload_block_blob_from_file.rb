require File.expand_path '../../test_helper', __dir__

# Storage Blob Class
class TestUploadBlockBlob < Minitest::Test
  # This class posesses the test cases for the requests of getting storage blob properties.
  def setup
    @service = Fog::Storage::AzureRM.new(storage_account_credentials)
    @blob_client = @service.instance_variable_get(:@blob_client)
    @storage_blob_object = ApiStub::Requests::Storage::File.upload_block_blob_from_file
  end

  def test_upload_blob_with_service_success
    @blob_client.stub :create_block_blob, @storage_blob_object do
      assert @service.upload_block_blob_from_file('testcontainer', 'testblob1', nil)
    end
  end

  def test_upload_blob_with_internal_client_success
    @blob_client.stub :create_block_blob, @storage_blob_object do
      assert @blob_client.create_block_blob('testcontainer', 'testblob1')
    end
  end
end
