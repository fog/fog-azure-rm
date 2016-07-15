require File.expand_path '../../test_helper', __dir__

# Blob Class
class TestSetBlobMetadata < Minitest::Test
  # This class posesses the test cases for the requests of blob service.
  def setup
    @service = Fog::Storage::AzureRM.new(storage_account_credentials)
    @blob_client = @service.instance_variable_get(:@blob_client)
    @metadata = ApiStub::Requests::Storage::Blob.metadata_response
  end

  def test_set_blob_metadata_success
    @blob_client.stub :set_blob_metadata, true do
      assert @service.set_blob_metadata('Test-container', 'Test-blob', @metadata)
    end
  end
end
