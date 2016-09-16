require File.expand_path '../../test_helper', __dir__

# Blob Class
class TestGetBlobMetadata < Minitest::Test
  # This class posesses the test cases for the requests of Blob service.
  def setup
    @service = Fog::Storage::AzureRM.new(storage_account_credentials)
    @blob_client = @service.instance_variable_get(:@blob_client)
    @blob_object = ApiStub::Requests::Storage::File.test_get_blob_metadata
  end

  def test_get_blob_metadata_success
    metadata_response = ApiStub::Requests::Storage::File.metadata_response
    @blob_client.stub :get_blob_metadata, @blob_object do
      assert_equal @service.get_blob_metadata('Test-container', 'Test-blob'), metadata_response
    end
  end
end
