require File.expand_path '../../test_helper', __dir__

# Storage Blob Class
class TestDeleteBlob < Minitest::Test
  # This class posesses the test cases for the requests of deleting storage blobs.
  def setup
    @service = Fog::Storage::AzureRM.new(storage_account_credentials)
    @blob_client = @service.instance_variable_get(:@blob_client)
  end

  def test_delete_blob_with_service_success
    @blob_client.stub :delete_blob, true do
      assert @service.delete_blob('testcontainer1', 'testblob1')
    end
  end

  def test_delete_blob_with_internal_client_success
    @blob_client.stub :delete_blob, true do
      assert @blob_client.delete_blob('testcontainer1', 'testblob1')
    end
  end
end
