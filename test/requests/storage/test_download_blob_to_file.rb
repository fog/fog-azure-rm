require File.expand_path '../../test_helper', __dir__

# Storage Blob Class
class TestDownloadBlob < Minitest::Test
  # This class posesses the test cases for the requests of getting storage blob properties.
  def setup
    @service = Fog::Storage::AzureRM.new(storage_account_credentials)
    @blob_client = @service.instance_variable_get(:@blob_client)
    @storage_blob_object = ApiStub::Requests::Storage::Blob.download_blob_to_file
  end

  def test_download_blob_with_service_success
    @blob_client.stub :get_blob, @storage_blob_object do
      file_path = 'test.dat'
      assert @service.download_blob_to_file('testcontainer', 'testblob1', file_path)
      File.delete file_path
    end
  end

  def test_download_blob_with_internal_client_success
    @blob_client.stub :get_blob, @storage_blob_object do
      assert @blob_client.get_blob('testcontainer', 'testblob1')
    end
  end
end
