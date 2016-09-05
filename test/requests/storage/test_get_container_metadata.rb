require File.expand_path '../../../test_helper', __FILE__

# Container Class
class TestGetContainerMetadata < Minitest::Test
  # This class posesses the test cases for the requests of container service.
  def setup
    @service = Fog::Storage::AzureRM.new(storage_account_credentials)
    @blob_client = @service.instance_variable_get(:@blob_client)
    @container_object = ApiStub::Requests::Storage::Container.test_get_container_metadata
  end

  def test_get_container_metadata_success
    metadata_response = ApiStub::Requests::Storage::Container.metadata_response
    @blob_client.stub :get_container_metadata, @container_object do
      assert_equal @service.get_container_metadata('Test-container'), metadata_response
    end
  end
end
