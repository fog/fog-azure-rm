require File.expand_path '../../test_helper', __dir__

# Container Class
class TestSetContainerMetadata < Minitest::Test
  # This class posesses the test cases for the requests of container service.
  def setup
    @service = Fog::Storage::AzureRM.new(storage_account_credentials)
    @blob_client = @service.instance_variable_get(:@blob_client)
    @metadata = ApiStub::Requests::Storage::Directory.metadata_response
  end

  def test_set_container_metadata_success
    @blob_client.stub :set_container_metadata, true do
      assert @service.set_container_metadata('Test-container', @metadata)
    end
  end
end
