require File.expand_path '../../test_helper', __dir__

# Storage Blob Class
class TestCopyBlobFromUri < Minitest::Test
  # This class posesses the test cases for the requests of copying blobs.
  def setup
    @service = Fog::Storage::AzureRM.new(storage_account_credentials)
    @blob_client = @service.instance_variable_get(:@blob_client)
    @copy_blob_reponse = ApiStub::Requests::Storage::File.copy_blob
  end

  def test_copy_blob_from_uri_success
    @blob_client.stub :copy_blob_from_uri, @copy_blob_reponse do
      assert @service.copy_blob_from_uri('destination_container', 'destination_blob', 'VHD uri'), @copy_blob_reponse
    end
  end
end